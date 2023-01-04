import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class FetchMoviesUseCase {
  final MovieRepository movieRepository;

  FetchMoviesUseCase(this.movieRepository);

  Future<Either<Failure, List<MovieEntity>>> call(String page) async {
    debugPrint('1. call use case');
    return await movieRepository.fetchMovies(page);
  }
}
