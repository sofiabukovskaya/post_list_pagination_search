import 'package:equatable/equatable.dart';
import 'package:post_list_pagination_search/domain/entities/post.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  const PostState({
    this.status = PostStatus.initial,
    this.allPosts = const <Post>[],
    this.filteredPosts = const <Post>[],
    this.query = '',
    this.hasReachedMax = false,
  });

  final PostStatus status;
  final List<Post> allPosts;
  final List<Post> filteredPosts;
  final String query;
  final bool hasReachedMax;

  PostState copyWith({
    PostStatus? status,
    List<Post>? allPosts,
    List<Post>? filteredPosts,
    String? query,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      allPosts: allPosts ?? this.allPosts,
      filteredPosts: filteredPosts ?? this.filteredPosts,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props =>
      [status, allPosts, filteredPosts, query, hasReachedMax];
}
