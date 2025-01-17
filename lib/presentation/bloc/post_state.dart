import 'package:post_list_pagination_search/domain/entities/post.dart';

sealed class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {
  PostLoading({
    required this.posts,
    required this.isFirstFetch,
  });

  final List<Post> posts;
  final bool isFirstFetch;
}

class PostLoaded extends PostState {
  PostLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  final List<Post> posts;
  final bool hasReachedMax;
}

class PostSearchResult extends PostState {
  final List<Post> posts;

  PostSearchResult({
    required this.posts,
  });
}

class PostError extends PostState {
  PostError({
    required this.errorMessage,
  });

  final String errorMessage;
}
