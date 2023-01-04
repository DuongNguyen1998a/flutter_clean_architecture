import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/movies/domain/entities/movie_entity.dart';
import 'package:flutter_clean_architecture/features/movies/domain/use_cases/fetch_movies_use_case.dart';
import 'package:flutter_clean_architecture/features/movies/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection_container.dart' as di;
import '../widgets/grid_movie_widget.dart';

final movieController =
    StateNotifierProvider<MovieProvider, AsyncValue<List<MovieEntity>>>(
  (ref) => MovieProvider(fetchMoviesUseCase: di.sl<FetchMoviesUseCase>()),
);

class MoviePage extends ConsumerWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MoviePage build');
    return Scaffold(
      body: SafeArea(
        child: Consumer(builder: (context, ref, child) {
          final movies = ref.watch(movieController);
          return movies.when(
            data: (data) {
              return GridMovieWidget(
                movies: data,
              );
            },
            error: (e, s) => Center(
              child: Text(e.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(movieController.notifier).fetchMovies();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
