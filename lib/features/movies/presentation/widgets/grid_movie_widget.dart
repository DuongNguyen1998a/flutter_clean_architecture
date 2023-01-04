import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/movies/domain/entities/movie_entity.dart';

import 'grid_movie_item_widget.dart';

class GridMovieWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  const GridMovieWidget({Key? key, required this.movies,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('GridMovieWidget build');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return GridMovieItemWidget(
            movie: movies[index],
          );
        },
      ),
    );
  }
}
