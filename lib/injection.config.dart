// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'aplication/academic_level/academic_level_use_case.dart' as _i998;
import 'aplication/asignatura/service/asignatura_service.dart' as _i515;
import 'aplication/auth/service/auth_service.dart' as _i678;
import 'aplication/auth/use_case/login_use_case.dart' as _i1027;
import 'aplication/componente_educativo/componente_educativo_use_case.dart'
    as _i220;
import 'aplication/conexion_online/conexion_online_use_case.dart' as _i233;
import 'aplication/detail_preguntas/detail_pregunta_use_case.dart' as _i417;
import 'aplication/image/upload_image_use_case.dart' as _i728;
import 'aplication/item_dynamic/item_dynamic_use_case.dart' as _i483;
import 'aplication/level/level_use_case.dart' as _i775;
import 'aplication/pregunta/service/pregunta_service.dart' as _i150;
import 'aplication/promotion/promotion_use_cause.dart' as _i167;
import 'aplication/student/student_service.dart' as _i300;
import 'domain/academic_level/repository/academic_level_repository.dart'
    as _i365;
import 'domain/asignaturas/repositories/asignatura_repository.dart' as _i213;
import 'domain/auth/repositories/login_repository.dart' as _i316;
import 'domain/componente_educativo/repository/componente_educativo_repo.dart'
    as _i839;
import 'domain/conexion_online/repository/conexion_online_repository.dart'
    as _i341;
import 'domain/detalle_pregunta/repository/detalle_pregunta_repository.dart'
    as _i823;
import 'domain/image/repository/image_repository.dart' as _i142;
import 'domain/item_dynamic/repository/item_repository.dart' as _i345;
import 'domain/level/repository/level_repository.dart' as _i850;
import 'domain/pregunta/repositories/pregunta_repository.dart' as _i236;
import 'domain/promotion/repositories/promotion_repositorie.dart' as _i506;
import 'domain/student/repositorie/student_repositorie.dart' as _i311;
import 'infrastructure/academic_level/academic_level_implement.dart' as _i927;
import 'infrastructure/api_service/api_service.dart' as _i752;
import 'infrastructure/auth/data_sources/local_data_source/localstorage_shared.dart'
    as _i905;
import 'infrastructure/auth/data_sources/remote_data_source.dart' as _i326;
import 'infrastructure/auth/repositories/user_implement.dart' as _i679;
import 'infrastructure/componente_educativo/componente_educativo_implement.dart'
    as _i782;
import 'infrastructure/conexion_online/conexion_online_implent.dart' as _i318;
import 'infrastructure/detalle_preguntas/preguntas_implement.dart' as _i969;
import 'infrastructure/image/image_implement.dart' as _i896;
import 'infrastructure/item/item_implement.dart' as _i23;
import 'infrastructure/level/level_implement.dart' as _i506;
import 'infrastructure/promotion/promotion_implement.dart' as _i106;
import 'infrastructure/student/repositories/student_implement.dart' as _i691;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i905.LocalstorageShared>(() => _i905.LocalstorageShared());
  gh.factory<_i326.RemoteDataSource>(() => _i326.RemoteDataSource());
  gh.factory<_i752.ApiService>(() => _i752.ApiService());
  gh.lazySingleton<_i142.ImageRepository>(() => _i896.ImageImplement());
  gh.lazySingleton<_i365.AcademicLevelRepository>(
    () => _i927.AcademicLevelRepositoryImpl(gh<_i752.ApiService>()),
  );
  gh.factory<_i515.AsignaturaService>(
    () => _i515.AsignaturaService(gh<_i213.AsignaturaRepository>()),
  );
  gh.lazySingleton<_i311.StudentsRepositorie>(
    () => _i691.StudentImplement(gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i839.ComponenteEducativoRepository>(
    () => _i782.ComponenteEducativoImplement(gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i823.IPreguntaRepository>(
    () => _i969.DetallePreguntaImplement(gh<_i752.ApiService>()),
  );
  gh.factory<_i998.AcademicLevelUseCase>(
    () => _i998.AcademicLevelUseCase(gh<_i365.AcademicLevelRepository>()),
  );
  gh.factory<_i150.PreguntaService>(
    () => _i150.PreguntaService(gh<_i236.PreguntaRepository>()),
  );
  gh.factory<_i728.UploadImageUseCase>(
    () => _i728.UploadImageUseCase(gh<_i142.ImageRepository>()),
  );
  gh.lazySingleton<_i341.ConexionOnlineRepository>(
    () => _i318.ConexionOnlineImplent(dbCrud: gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i506.PromotionRepositorie>(
    () => _i106.PromotionImplement(gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i850.LevelRepository>(
    () => _i506.LevelImplement(gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i345.IItemRepository>(
    () => _i23.ItemImplement(gh<_i752.ApiService>()),
  );
  gh.lazySingleton<_i316.LoginRepository>(
    () => _i679.UserImplement(
      gh<_i326.RemoteDataSource>(),
      gh<_i905.LocalstorageShared>(),
    ),
  );
  gh.factory<_i1027.LoginUseCase>(
    () => _i1027.LoginUseCase(gh<_i316.LoginRepository>()),
  );
  gh.factory<_i678.AuthService>(
    () => _i678.AuthService(gh<_i316.LoginRepository>()),
  );
  gh.factory<_i775.LevelUseCase>(
    () => _i775.LevelUseCase(gh<_i850.LevelRepository>()),
  );
  gh.factory<_i417.DetailPreguntasUseCase>(
    () => _i417.DetailPreguntasUseCase(gh<_i823.IPreguntaRepository>()),
  );
  gh.factory<_i167.PromotionUseCause>(
    () => _i167.PromotionUseCause(gh<_i506.PromotionRepositorie>()),
  );
  gh.factory<_i233.ConexionOnlineUseCase>(
    () => _i233.ConexionOnlineUseCase(
      repository: gh<_i341.ConexionOnlineRepository>(),
    ),
  );
  gh.factory<_i300.StudentService>(
    () => _i300.StudentService(gh<_i311.StudentsRepositorie>()),
  );
  gh.factory<_i220.ComponenteEducativoUseCase>(
    () => _i220.ComponenteEducativoUseCase(
      gh<_i839.ComponenteEducativoRepository>(),
    ),
  );
  gh.factory<_i483.ItemDynamicUseCase>(
    () => _i483.ItemDynamicUseCase(gh<_i345.IItemRepository>()),
  );
  return getIt;
}
