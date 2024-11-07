import 'package:get_it/get_it.dart';
import 'package:infiniteagent/feature_auth/data/data_sources/local/authentication_local_data_source.dart';
import 'package:infiniteagent/feature_auth/data/data_sources/remote/authentication_remote_data_source.dart';
import 'package:infiniteagent/feature_auth/data/repositories/authentication_repository_impl.dart';
import 'package:infiniteagent/feature_auth/domain/use_cases/login_use_case.dart';
import 'package:infiniteagent/feature_home/data/repositories/census_repository_impl.dart';
import 'package:infiniteagent/feature_home/domain/use_cases/create_census_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/use_cases/logout_use_case.dart';
import 'feature_auth/domain/use_cases/check_if_logged_use_case.dart';
import 'feature_home/data/data_sources/remote/census_remote_data_source.dart';
import 'feature_home/domain/use_cases/get_census_list_use_case.dart';
import 'feature_home/domain/use_cases/update_census_use_case.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Features

  //Data sources
  //auth
  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton(() => AuthLocalDataSource(sharedPreferences));
  //census
  sl.registerLazySingleton(() => CensusRemoteDataSource());

  //Repositories
  //auth
  sl.registerLazySingleton(() => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(), sl<AuthLocalDataSource>()));
  //census
  sl.registerLazySingleton(() => CensusRepositoryImpl(sl()));

  //UseCases
  //auth
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepositoryImpl>()));
  sl.registerLazySingleton(
      () => CheckIfLoggedUseCase(sl<AuthRepositoryImpl>()));
  //census
  sl.registerLazySingleton(
      () => GetCensusListUseCase(sl<CensusRepositoryImpl>()));
  sl.registerLazySingleton(
      () => CreateCensusUseCase(sl<CensusRepositoryImpl>()));
  sl.registerLazySingleton(
      () => UpdateCensusUseCase(sl<CensusRepositoryImpl>()));
}
