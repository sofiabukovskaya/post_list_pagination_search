sealed class PostEvent {}

class FetchPosts extends PostEvent {
  final int page;
  final int limit;
  final bool isRefresh;

  FetchPosts({
    required this.page,
    required this.limit,
    this.isRefresh = false,
  });
}

class SearchPost extends PostEvent {
  final String query;

  SearchPost({
    required this.query,
  });
}
