import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:post_list_pagination_search/core/error/exceptions.dart';
import 'package:post_list_pagination_search/data/models/post_model.dart';

abstract interface class PostRemoteDataSource {
  Future<List<PostModel>> getPosts({required int page, required int limit});
}

final class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl({required this.client});

  final http.Client client;

  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<List<PostModel>> getPosts(
      {required int page, required int limit}) async {
    try {
      final response = await client.get(
        Uri.parse('$_baseUrl?_page=$page&_limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load posts');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to load posts');
    }
  }
}
