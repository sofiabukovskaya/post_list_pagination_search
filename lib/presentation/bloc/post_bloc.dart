import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';
import 'package:post_list_pagination_search/domain/usecases/fetch_posts_use_case.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_event.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_state.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final FetchPostsUseCase fetchPostsUseCase;
  final NetworkInfo networkInfo;

  PostBloc({required this.fetchPostsUseCase, required this.networkInfo})
      : super(const PostState()) {
    on<PostFetched>(_onFetched,
        transformer: throttleDroppable(throttleDuration));
    on<SearchPosts>(_onSearchPosts);
  }

  // Fetch Posts Logic (Pagination)
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

  // Search Posts Logic
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
