import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lexxi/src/global/controllers/theme_controller.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/src/providers/grado_provider.dart';
import 'package:lexxi/src/providers/resumen_quiz_provider.dart';
import 'package:lexxi/src/providers/state_app_bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// import 'firebase_options.dart';
import 'injection.dart';
// import 'src/global/messaging/firebase_messaging_service.dart';
import 'src/global/design_system/theme_system.dart';
import 'src/routes/routes_import.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    ignoreBadCertificates();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  configureDependencies();
  tz.initializeTimeZones();
  var bogota = tz.getLocation('America/Bogota');
  tz.setLocalLocation(bogota);
  // Configuración inicial para Android e iOS
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  // Configuración inicial para iOS
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,

    // notificationCategories: darwinNotificationCategories,
  ); // Puedes añadir configuraciones específicas de iOS aquí

  var initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
//  FirebaseMessagingService.requestPermission();
//   FirebaseMessagingService.getToken();

//   FirebaseMessagingService.onMessage = (RemoteMessage message) {
//     // Manejar la notificación cuando la app está en primer plano
//     print('Foreground message received: ${message.notification?.title} - ${message.notification?.body}');
//     // Aquí puedes mostrar un diálogo, notificación local, etc.
//   };

//   FirebaseMessagingService.onMessageOpenedApp = (RemoteMessage message) {
//     // Manejar la notificación cuando la app está en segundo plano y se abre por una notificación
//     print('Notification clicked: ${message.notification?.title} - ${message.notification?.body}');
//     // Aquí puedes navegar a una pantalla específica, mostrar un diálogo, etc.
//   };
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeController(true)),
    ChangeNotifierProvider(
      create: (_) => GradoProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ResumenQuizProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => StateAppBarProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => DataUserProvider(),
    ),
  ], child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _rootRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = context.watch();
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Formarte',
        theme: ThemeSystem.lightTheme,
        darkTheme: ThemeSystem.darkTheme,
        themeMode: themeController.darkCode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: _rootRouter.config(),
      );
    });
  }
}


void ignoreBadCertificates() {
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}