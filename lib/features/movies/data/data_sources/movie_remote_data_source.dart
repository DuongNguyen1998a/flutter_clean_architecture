import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/errors/exception.dart';
import 'package:flutter_clean_architecture/features/movies/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> fetchMovies(String page);
}

const baseUrl = 'https://api.themoviedb.org/3';
const apiKey = '9661964cdfdd361d13eb33e230c989a3';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> fetchMovies(String page) async {
    debugPrint('3. call MovieRemoteDataSourceImpl implements MovieRemoteDataSource');
    try {
      final response = await client.get(
        Uri.parse(
            '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=$page'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['results'] as List;
        return jsonData.map((e) => MovieModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    }
    on SocketException {
      throw NoInternetException();
    }
  }
}
