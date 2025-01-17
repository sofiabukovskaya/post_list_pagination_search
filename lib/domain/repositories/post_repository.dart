import 'package:post_list_pagination_search/domain/entities/post.dart';

abstract interface class PostRepository {
  Future<List<Post>> getPosts(int page, int limit);
}
