import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/student/student_service.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/models/auth/userViewModel.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';
import 'package:lexxi/src/global/widgets/body_custom.dart';
import 'package:lexxi/src/global/widgets/logo.dart';
import 'package:lexxi/src/pages/profile/widgets/target_history.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/avatar_profile.dart';

@RoutePage() // Add this annotation to your routable pages

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ValueNotifier<List<Asignatura>> _valueNotifierHistory =
      ValueNotifier([]);
  final StudentService _studentService = getIt.get<StudentService>();
  List<Grado> grados = [];
  Student? student;

  bool initData = false;
  @override
  void initState() {
    _loaddata();
    super.initState();
  }

  void _loaddata() async {
     student = await _studentService.getInfo();

    grados = student!.grados ?? [];
    setState(() {
      
    });
  }

  _asignatures(String grado, String nameLarge) async {
    await Future.delayed(Duration(seconds: !initData ? 1 : 0));
    for (var e in grados) {
  
      if (e.grado == grado) {
        
        initData = true;
        _valueNotifierHistory.value = e.asignaturas!;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      needShortName: true,
      appBar: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(),
          Logo(),
        ],
      ),
      title: 'Detalle de pruebas',
      header: ValueListenableBuilder<UserViewModel>(
          valueListenable: context.read<DataUserProvider>().userViewModel,
          builder: (context, user, child) {
            return AvatarProfile(
                   photo: user.profile??student?.photo,
              icon: Icons.settings,
              onClick: () {
                context.router.pushNamed('/config');
              },
              name: Text(
                "${user.name!} ${user.lastName!}",
                style: context.textTheme.titleMedium!
                    .copyWith(color: blackToWhite(context)),
              ),
              carrera: user.grado!.first.shortName!,
            );
          }),
      changeGrade: _asignatures,
      needGrados: true,
      body: ValueListenableBuilder(
          valueListenable: _valueNotifierHistory,
          builder: (context, value, child) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  int i = index;
                  final e = value[index];

                  return TargetHistory(
                      asignatura: e.asignatura!,
                      puntaje: e.score.toDouble(),
                      score: e.score.toString(),
                      isRight: (i % 2 == 0));

                  // return const SizedBox();
                },
                childCount: value.length, // El número de ítems
              ),
            );
          }),
    );
  }

  // List<Widget> _allTargets(List<ResultadoAsignatura> value) {
  //   int i = 0;
  //   return value.map((e) {
  //     i = i + 1;
  //     return TargetHistory(
  //         asignatura: e.asignaturaValue!,
  //         puntaje: e.puntaje!,
  //         isRight: (i % 2 == 0));
  //   }).toList();
  // }
}
