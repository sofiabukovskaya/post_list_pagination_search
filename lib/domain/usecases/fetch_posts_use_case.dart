import 'package:post_list_pagination_search/domain/entities/post.dart';
import 'package:post_list_pagination_search/domain/repositories/post_repository.dart';

final class FetchPosts {
  const FetchPosts({
    required this.postRepository,
  });

  final PostRepository postRepository;

  Future<List<Post>> call(int page, int limit) async {
    return await postRepository.getPosts(
      page,
      limit,
    );
  }
}
