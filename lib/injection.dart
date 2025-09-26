// injection.dart

import 'package:lexxi/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.I;



@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => initGetIt(getIt);
// @injectableInit
// void configureDependencies() {
//   // AUTH
//   getIt.registerSingleton<RemoteDataSource>(RemoteDataSource());
//   getIt.registerSingleton<LocalstorageShared>(LocalstorageShared());

//   getIt.registerSingleton<UserImplement>(UserImplement(
//       getIt.get<RemoteDataSource>(), getIt.get<LocalstorageShared>()));

//   getIt.registerSingleton<AuthService>(AuthService(getIt.get<UserImplement>()));

//   // PREGUNTAS
//   getIt.registerSingleton<RemoteDataSourceApiFormarte>(
//       RemoteDataSourceApiFormarte());

//   getIt.registerSingleton<PreguntaImlement>(
//       PreguntaImlement(getIt.get<RemoteDataSourceApiFormarte>()));

//   getIt.registerSingleton<PreguntaService>(
//       PreguntaService(getIt.get<PreguntaImlement>()));

//   // Asignatura
//   getIt.registerSingleton<AsignaturaImplement>(
//       AsignaturaImplement(getIt.get<RemoteDataSourceApiFormarte>()));

//   getIt.registerSingleton<AsignaturaService>(
//       AsignaturaService(getIt.get<AsignaturaImplement>()));



//   _registerSingleton<StudentImplement, StudentService>(
//     () => StudentImplement(getIt.get<RemoteDataSourceApiFormarte>()),
//     () => StudentService(getIt.get<StudentImplement>()),
//   );
// }
// // void registerSingleton<T extends Object, S extends Object>(
// //   T Function() factoryFuncT,
// //   S Function() factoryFuncS,
// // ) {
// //   getIt.registerSingleton<T>(factoryFuncT());
// //   getIt.registerSingleton<S>(factoryFuncS());
// // }

// // registerSingleton<MyClass, MyOtherClass>(
// //   () => MyClass(getIt.get<RemoteDataSourceApiFormarte>()),
// //   () => MyOtherClass(getIt.get<MyClass>()),
// // );

// void _registerSingleton<T extends Object, S extends Object>(
//   T Function() factoryFuncT,
//   S Function() factoryFuncS,
// ) {
//   getIt.registerSingleton<T>(factoryFuncT());

//   getIt.registerSingleton<S>(factoryFuncS());
// }
