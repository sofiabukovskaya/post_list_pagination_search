sealed class PostEvent {}

class FetchPosts extends PostEvent {
  final int page;
  final int limit;

  FetchPosts({
    required this.page,
    required this.limit,
  });
}

class SearchPost extends PostEvent {
  final String query;

  SearchPost({
    required this.query,
  });
}
