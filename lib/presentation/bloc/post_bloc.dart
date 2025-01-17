import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';
import 'package:post_list_pagination_search/domain/usecases/fetch_posts_use_case.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_event.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_state.dart';
import 'package:stream_transform/stream_transform.dart';

/// Duration for throttling events
const throttleDuration = Duration(milliseconds: 300);

/// Custom event transformer to throttle and drop events
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

/// Bloc for handling post-related events and states
class PostBloc extends Bloc<PostEvent, PostState> {
  final FetchPostsUseCase fetchPostsUseCase;
  final NetworkInfo networkInfo;

  /// Constructor for PostBloc
  ///
  /// Takes [fetchPostsUseCase] and [networkInfo] as required parameters.
  PostBloc({required this.fetchPostsUseCase, required this.networkInfo})
      : super(const PostState()) {
    on<PostFetched>(_onFetched,
        transformer: throttleDroppable(throttleDuration));
    on<SearchPosts>(_onSearchPosts);
  }

  /// Event handler for fetching posts with pagination
  ///
  /// This method fetches posts and updates the state with the new posts.
  /// If there are no more posts to fetch, it sets [hasReachedMax] to true.
  Future<void> _onFetched(
      PostFetched event,
      Emitter<PostState> emit,
      ) async {
    if (state.hasReachedMax) return;

    try {
      final posts = await fetchPostsUseCase(state.allPosts.length, 20);

      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      final allPosts = [...state.allPosts, ...posts];
      final filteredPosts = state.query.isEmpty
          ? allPosts
          : allPosts
          .where((post) =>
          post.title.toLowerCase().contains(state.query.toLowerCase()))
          .toList();

      emit(state.copyWith(
        status: PostStatus.success,
        allPosts: allPosts,
        filteredPosts: filteredPosts,
      ));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  /// Event handler for searching posts
  ///
  /// This method filters the posts based on the search query and updates the state.
  Future<void> _onSearchPosts(
      SearchPosts event,
      Emitter<PostState> emit,
      ) async {
    final filteredPosts = state.allPosts
        .where((post) =>
        post.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(state.copyWith(query: event.query, filteredPosts: filteredPosts));
  }
}