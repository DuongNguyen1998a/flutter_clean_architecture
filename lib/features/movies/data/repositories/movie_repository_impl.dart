import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/errors/exception.dart';
import 'package:flutter_clean_architecture/core/errors/failure.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/movies/data/data_sources/movie_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/movies/domain/entities/movie_entity.dart';
import 'package:flutter_clean_architecture/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource movieRemoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.movieRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MovieEntity>>> fetchMovies(String page) async {
    debugPrint('2. call in MovieRepositoryImpl implements MovieRepository');
    if (await networkInfo.isConnected) {
      try {
        final movies = await movieRemoteDataSource.fetchMovies(page);
        return Right(movies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
