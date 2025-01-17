import 'package:equatable/equatable.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent {}

final class SearchPosts extends PostEvent {
  final String query;

  SearchPosts(this.query);

  @override
  List<Object> get props => [query];
}
