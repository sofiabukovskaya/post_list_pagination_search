import 'package:post_list_pagination_search/data/datasources/remote/post_remote_data_source.dart';
import 'package:post_list_pagination_search/domain/entities/post.dart';
import 'package:post_list_pagination_search/domain/repositories/post_repository.dart';

final class PostRepositoryImpl implements PostRepository {
  const PostRepositoryImpl({
    required this.remoteDataSource,
  });

  final PostRemoteDataSource remoteDataSource;

  @override
  Future<List<Post>> getPosts(int page, int limit) async {
    return await remoteDataSource.getPosts(
      page: page,
      limit: limit,
    );
  }
}
