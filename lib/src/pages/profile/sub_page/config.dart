import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/aplication/image/upload_image_use_case.dart';
import 'package:lexxi/aplication/student/student_service.dart';
import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/models/auth/userViewModel.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/global/widgets/custom_popup.dart';
import 'package:lexxi/src/global/widgets/custom_switch.dart';
import 'package:lexxi/src/global/widgets/flat_color_button.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/global/widgets/rounded_text_field.dart';
import 'package:lexxi/src/pages/profile/widgets/avatar_profile.dart';
import 'package:lexxi/src/pages/profile/widgets/selected_number_question.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/routes/routes_import.gr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;

@RoutePage() // Add this annotation to your routable pages

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AuthService _authService = getIt.get<AuthService>();
  final _studentService = getIt.get<StudentService>();
  final UploadImageUseCase _uploadImageUseCase =
      getIt.get<UploadImageUseCase>();
  final ValueNotifier<Student?> _studentNotifier = ValueNotifier(null);
  String password = '', newPassword = '';
  String time = "";
  Student? student;

  @override
  void initState() {
    // _cancelAllNotifications();
    showPendingNotifications();

    loadData();

    super.initState();
  }

  void loadData() async {
    student = await _studentService.getInfo();
    final rec = RecordatorioPersonalizado();
    final not = NotificationConfig(recordatorioPersonalizado: rec);
    Config config = Config(idStudent: student!.idStudent!, notification: not);
    if (student!.config == null) {
      student!.config = config;
      _studentService.update(student!);
    }
    _studentNotifier.value = student;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
            gradient: context.darkmode
                ? AppColors.linealGradientBlueDark
                : AppColors.linealGGrey),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                       
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),
                          )),
                      Container()
                    ],
                  ),
                ),
                ValueListenableBuilder<UserViewModel>(
                    valueListenable:
                        context.read<DataUserProvider>().userViewModel,
                    builder: (context, user, child) {
                      return AvatarProfile(
                        icon: Icons.camera_alt_outlined,
                        photo: user.profile??student?.photo,
                        onClick: () async {
                          await _pickAndUploadImage();
                        },
                        name: Text(
                          "${user.name!} ${user.lastName!}",
                          style: context.textTheme.titleMedium!
                              .copyWith(color: blackToWhite(context)),
                        ),
                        carrera: user.grado!.first.shortName!,
                      );
                    }),
                // Container(
                //   height: 100,
                // ),
                ValueListenableBuilder(
                    valueListenable: _studentNotifier,
                    builder: (context, student, _) {
                      if (student == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final n = student.config!.notification;

                      return SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 3.h),
                            Text(
                              'Datos personales',
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: blackToWhite(context)),
                            ),
                            SizedBox(height: 2.h),
                            GradientButton(
                              text: 'Cambiar contraseña',
                              w: 80.w,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomPopup(
                                      title: 'Mi Popup Personalizado',
                                      message:
                                          'Este es un mensaje personalizado en el Popup.',
                                      actions: [
                                        GradientButton(
                                          w: 120,
                                          text: 'Continuar',
                                          m: 5,
                                          onPressed: () async {
                                            // Acciones a realizar al presionar el botón
                                            final r = await _authService
                                                .changePassword(
                                                    password, newPassword);

                                            // Asegúrate de que el widget todavía está montado antes de interactuar con el context
                                            _updateUIBasedOnResponse(r);
                                          },
                                        ),
                                        GradientButton(
                                            w: 120,
                                            text: 'Cancelar',
                                            m: 5,
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Cambiar contraseña ',
                                                style: context
                                                    .textTheme.titleLarge!
                                                    .copyWith(
                                                        color: blackToWhite(
                                                            context))),
                                          ),
                                          RoundedTextField(
                                            hintText: 'Contraseña vieja',
                                            width: 70.w,
                                            center: false,
                                            onChanged: (value) {
                                              password = value;
                                            },
                                          ),
                                          RoundedTextField(
                                            hintText: 'Nueva contraseña',
                                            width: 70.w,
                                            center: false,
                                            onChanged: (value) {
                                              newPassword = value;
                                            },
                                          ),
                                          // RoundedTextField(
                                          //   hintText: 'Confirma la contraseña ',
                                          //   width: 70.w,
                                          //   center: false,
                                          // ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'General',
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: blackToWhite(context)),
                            ),
                            SizedBox(height: 1.h),
                            Column(
                              children: [
                                // SliderRowText(
                                //     init: n!.sonido,
                                //     onChanged: (v) {
                                //       n.sonido = v;
                                //       updateStudent(n);
                                //     },
                                //     title: Text(
                                //       'Efectos de sonido',
                                //       style: context.textTheme.titleMedium!
                                //           .copyWith(
                                //               color: blackToWhite(context)),
                                //     )),
                                SliderRowText(
                                    init: n!.recordatorio,
                                    onChanged: (v) {
                                      n.recordatorio = v;

                                      if (!v) {
                                        _cancelAllNotifications();
                                        return;
                                      }
                                      _scheduleDailyNotification(n
                                          .recordatorioPersonalizado!
                                          .parseTimeOfDay());
                                      updateStudent(n);

                                      setState(() {});
                                    },
                                    title: Text(
                                      'Recordatorio',
                                      style: context.textTheme.titleMedium!
                                          .copyWith(
                                              color: blackToWhite(context)),
                                    )),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            if (n.recordatorio)
                              SliderRowText(
                                init: n.recordatorioPersonalizado!.status,
                                onChanged: (v) {
                                  n.recordatorioPersonalizado!.status = v;

                                  updateStudent(n);
                                  setState(() {});
                                },
                                title: Text(
                                  'Personalizar recordatorio',
                                  style: context.textTheme.titleLarge!
                                      .copyWith(color: blackToWhite(context)),
                                ),
                              ),
                            if (n.recordatorioPersonalizado!.status)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('¿A qué hora puedes practicar?',
                                      style: context.textTheme.titleMedium!
                                          .copyWith(
                                              color: blackToWhite(context))),
                                  Container(
                                    width: 100.w,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FlatColorButton(
                                          onPressed: () async {
                                            final timeOfDay =
                                                await _selectTime();

                                            if (timeOfDay != null) {
                                              n.recordatorioPersonalizado!
                                                      .time =
                                                  n.recordatorioPersonalizado!
                                                      .formatTimeOfDay(
                                                          timeOfDay);

                                              updateStudent(n);
                                              setState(() {});
                                            }
                                          },
                                          color: AppColors.white,
                                          text: Text(
                                              n.recordatorioPersonalizado!.time,
                                              style: context
                                                  .textTheme.titleLarge!
                                                  .copyWith(
                                                      color: blackToWhite(
                                                          context))),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 3.h),
                            Text(
                              'Personalizar número de preguntas',
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: blackToWhite(context)),
                            ),
                            SizedBox(height: 1.h),
                            Text('¿Cuántas preguntas quieres que aparezcan?',
                                style: context.textTheme.titleMedium!
                                    .copyWith(color: blackToWhite(context))),
                            const SelectedNumberQuestion(),
                            SizedBox(height: 4.h),
                            FlatColorButton(
                              onPressed: () async {
                                await _authService.logout();
                                context.router
                                    .replaceAll([const SplashRoute()]);
                              },
                              color: AppColors.blueDark,
                              text: Text('Cerrar sesión',
                                  style: context.textTheme.titleLarge!
                                      .copyWith(
                                          color: whiteToBlack(context))),
                            ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateUIBasedOnResponse(bool response) {
    if (response) {
      Navigator.of(context).pop();

      MotionToast.success(
              toastDuration: const Duration(seconds: 3),
              description: const Text("Se cambio la contraseña con exito"))
          .show(context);
    } else {
      Navigator.of(context).pop();
      MotionToast.error(
              toastDuration: const Duration(seconds: 3),
              description: const Text("Los datos ingresados son incorrectos"))
          .show(context);
    }
  }

  void updateStudent(NotificationConfig not) {
    Config config = Config(idStudent: student!.idStudent!, notification: not);

    student!.config = config;

    _studentService.update(student!);
  }

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (pickedTime != null && pickedTime != TimeOfDay.now()) {
      await _cancelAllNotifications();
      _scheduleDailyNotification(pickedTime);
      return pickedTime;
    }
    return null;
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = timeOfDay.format(context);
    return '${format[0]}${format[1]}:${format[3]}${format[4]} ${dateTime.hour >= 12 ? 'pm' : 'am'}';
  }

  Future<void> _scheduleDailyNotification(TimeOfDay time) async {
    try {
      print('[_scheduleDailyNotification] Iniciando programación de notificación para ${time.hour}:${time.minute}');

      // Solicitar permisos de notificaciones si es necesario
      final permissionGranted = await _requestNotificationPermissions();
      if (!permissionGranted) {
        print('[_scheduleDailyNotification] Permisos de notificación denegados');
        if (mounted) {
          MotionToast.warning(
            description: const Text('Necesitas habilitar los permisos de notificaciones en la configuración'),
            toastDuration: const Duration(seconds: 3),
          ).show(context);
        }
        return;
      }

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, time.hour, time.minute);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
        print('[_scheduleDailyNotification] Fecha ajustada al siguiente día: $scheduledDate');
      }

      var androidDetails = const AndroidNotificationDetails(
          'daily_notif_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
      );

      var iOSDetails = const DarwinNotificationDetails();

      var platformDetails = NotificationDetails(
          android: androidDetails,
          iOS: iOSDetails,
          macOS: iOSDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Recordatorio Diario',
        '¡Es hora de tu recordatorio diario!',
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      print('[_scheduleDailyNotification] Notificación programada exitosamente para: $scheduledDate');

      if (mounted) {
        MotionToast.success(
          description: Text('Recordatorio programado para ${formatTimeOfDay(time)}'),
          toastDuration: const Duration(seconds: 2),
        ).show(context);
      }
    } catch (e) {
      print('[_scheduleDailyNotification] ERROR: $e');
      if (mounted) {
        MotionToast.error(
          description: Text('Error al programar recordatorio: $e'),
          toastDuration: const Duration(seconds: 3),
        ).show(context);
      }
    }
  }

  Future<bool> _requestNotificationPermissions() async {
    try {
      print('[_requestNotificationPermissions] Iniciando solicitud de permisos');

      // Solicitar permisos para Android 13+
      final androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        print('[_requestNotificationPermissions] Android implementation encontrada');

        // Primero verificar si ya tenemos permiso de notificaciones
        final hasNotificationPermission = await androidImplementation.areNotificationsEnabled();
        print('[_requestNotificationPermissions] Permisos de notificaciones ya habilitados: $hasNotificationPermission');

        // Si no tiene permiso, solicitarlo
        if (hasNotificationPermission != true) {
          print('[_requestNotificationPermissions] Solicitando permiso de notificaciones...');
          final notificationPermission = await androidImplementation.requestNotificationsPermission();
          print('[_requestNotificationPermissions] Resultado permiso de notificaciones: $notificationPermission');

          if (notificationPermission != true) {
            print('[_requestNotificationPermissions] Permiso de notificaciones denegado');
            return false;
          }
        }

        // Ahora solicitar permiso de alarmas exactas (este siempre debe solicitarse cuando se necesita)
        print('[_requestNotificationPermissions] Solicitando permiso de alarmas exactas...');
        final exactAlarmPermission = await androidImplementation.requestExactAlarmsPermission();
        print('[_requestNotificationPermissions] Resultado permiso de alarmas exactas: $exactAlarmPermission');

        return true; // Si llegamos aquí, al menos tenemos permisos de notificación
      }

      print('[_requestNotificationPermissions] No es Android, retornando true');
      return true; // Para iOS o si no es necesario
    } catch (e, stackTrace) {
      print('[_requestNotificationPermissions] ERROR: $e');
      print('[_requestNotificationPermissions] StackTrace: $stackTrace');
      return false;
    }
  }

  Future<void> showPendingNotifications() async {
    List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await showDialog<XFile?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Seleccionar imagen'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Cámara'),
                  onTap: () async {
                    final image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (context.mounted) {
                      Navigator.of(context).pop(image);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galería'),
                  onTap: () async {
                    final image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (context.mounted) {
                      Navigator.of(context).pop(image);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );

      if (pickedFile != null) {    final dataUserProvider = context.read<DataUserProvider>();
          final currentUser = dataUserProvider.userViewModel.value;

        final Uint8List imageBytes = await pickedFile.readAsBytes();
        final String fileName =
            '${student?.idStudent}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final String imageUrl =
            await _uploadImageUseCase.execute(imageBytes, fileName
);
        if (mounted) {
      
          final updatedUser = UserViewModel(
            id: currentUser.id,
            name: currentUser.name,
            secondName: currentUser.secondName,
            lastName: currentUser.lastName,
            secondLast: currentUser.secondLast,
            typeId: currentUser.typeId,
            email: currentUser.email,
            gender: currentUser.gender,
            phone: currentUser.phone,
            cellphone: currentUser.cellphone,
            address: currentUser.address,
            locateDistrict: currentUser.locateDistrict,
            neighborhood: currentUser.neighborhood,
            birthday: currentUser.birthday,
            company: currentUser.company,
            companyPhone: currentUser.companyPhone,
            profile: imageUrl,
            token: currentUser.token,
            grado: currentUser.grado,
          );

          dataUserProvider.userViewModel.value = updatedUser;
          if (student != null) {
            student!.photo = imageUrl;

            await _studentService.update(student!);
          }

          MotionToast.success(
            toastDuration: const Duration(seconds: 3),
            description:
                const Text("Imagen de perfil actualizada exitosamente"),
          ).show(context);
        }
      }
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          toastDuration: const Duration(seconds: 3),
          description: Text("Error al actualizar la imagen: ${e.toString()}"),
        ).show(context);
      }
    }
  }
}
