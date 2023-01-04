import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/movies/data/data_sources/movie_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:flutter_clean_architecture/features/movies/domain/repositories/movie_repository.dart';
import 'package:flutter_clean_architecture/features/movies/domain/use_cases/fetch_movies_use_case.dart';
import 'package:flutter_clean_architecture/features/movies/presentation/providers/movie_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// feature movies

  /// 1. Providers
  sl.registerFactory(() => MovieProvider(fetchMoviesUseCase: sl()));

  /// 2. Use cases
  sl.registerLazySingleton<FetchMoviesUseCase>(() => FetchMoviesUseCase(sl()));

  /// 3. repository
  sl.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(movieRemoteDataSource: sl(), networkInfo: sl()));

  /// 4. data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(client: sl()));

  /// core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// external
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
