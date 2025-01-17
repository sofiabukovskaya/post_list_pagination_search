import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';
import 'package:post_list_pagination_search/domain/entities/post.dart';
import 'package:post_list_pagination_search/domain/usecases/fetch_posts_use_case.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_event.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FetchPostsUseCase fetchPosts;
  final NetworkInfo networkInfo;

  PostBloc({
    required this.fetchPosts,
    required this.networkInfo,
  }) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SearchPost>(_onSearchPost);
  }

  void _onFetchPosts(
    FetchPosts event,
    Emitter<PostState> emit,
  ) async {
    if (state is PostLoading) return;

    final currentState = state;

    List<Post> oldPosts = [];

    if (currentState is PostLoaded && !event.isRefresh) {
      oldPosts = currentState.posts;
    }

    emit(
      PostLoading(
        posts: oldPosts,
        isFirstFetch: oldPosts.isEmpty,
      ),
    );

    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      emit(
        PostError(
            errorMessage: 'No Internet connection. Please try again later.'),
      );
      return;
    }

    try {
      final posts = await fetchPosts(event.page, event.limit);
      final allPosts = [...oldPosts, ...posts];
      emit(
        PostLoaded(posts: allPosts, hasReachedMax: posts.isEmpty),
      );
    } catch (e) {
      emit(
        PostError(
          errorMessage: 'Fail to load posts: ${e.toString()}',
        ),
      );
    }
  }

  void _onSearchPost(
    SearchPost event,
    Emitter<PostState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(
        PostLoaded(
          posts: [],
        ),
      );
      return;
    }

    final filteredPosts = (state as PostLoaded)
        .posts
        .where(
          (post) => post.title.toLowerCase().contains(
                event.query.toLowerCase(),
              ),
        )
        .toList();

    emit(
      PostSearchResult(posts: filteredPosts),
    );
  }
}
