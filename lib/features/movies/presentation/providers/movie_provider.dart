import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/errors/failure.dart';
import 'package:flutter_clean_architecture/features/movies/domain/entities/movie_entity.dart';
import 'package:flutter_clean_architecture/features/movies/domain/use_cases/fetch_movies_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieProvider extends StateNotifier<AsyncValue<List<MovieEntity>>> {
  final FetchMoviesUseCase fetchMoviesUseCase;

  MovieProvider({
    required this.fetchMoviesUseCase,
  }) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  int page = 1;
  final List<MovieEntity> _movies = [];

  void fetchMovies() async {
    if (_movies.isEmpty) {
      state = const AsyncValue.loading();
      final moviesResponse = await fetchMoviesUseCase(page.toString());
      moviesResponse.fold(
        (error) {
          state = AsyncError(
            _mapFailureToMessage(error),
            StackTrace.fromString('StackTrace Error'),
          );
        },
        (movies) {
          _movies.addAll(movies);
          state = AsyncData(_movies);
        },
      );
    } else {
      page = page + 1;
      final moviesResponse = await fetchMoviesUseCase(page.toString());
      moviesResponse.fold(
        (error) {
          state = AsyncError(
            _mapFailureToMessage(error),
            StackTrace.fromString('StackTrace Error'),
          );
        },
        (movies) {
          _movies.addAll(movies);
          state = AsyncData(_movies);
        },
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'SERVER FAILURE';
      case NoInternetFailure:
        return 'NO INTERNET FAILURE';
      default:
        return 'Unexpected error';
    }
  }
}
