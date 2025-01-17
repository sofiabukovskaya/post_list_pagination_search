import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_bloc.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_event.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_state.dart';

import 'package:post_list_pagination_search/presentation/widgets/bottom_loader_widget.dart';
import 'package:post_list_pagination_search/presentation/widgets/loading_indicator_widget.dart';
import 'package:post_list_pagination_search/presentation/widgets/post_list_item_widget.dart';
import 'package:post_list_pagination_search/presentation/widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SearchBarWidget(),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return Expanded(
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case PostStatus.initial:
                          return const LoadingIndicator();

                        case PostStatus.success:
                          final posts = state.query.isEmpty
                              ? state.allPosts
                              : state.filteredPosts;

                          if (posts.isEmpty) {
                            return const Center(
                              child: Text('No posts found.'),
                            );
                          }
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return index >= posts.length
                                  ? const BottomLoaderWidget()
                                  : PostListItemWidget(
                                      post: posts[index],
                                    );
                            },
                            itemCount: state.hasReachedMax
                                ? posts.length
                                : posts.length + 1,
                            controller: _scrollController,
                          );
                        case PostStatus.failure:
                          return Center(
                            child: Text('Failed to load posts'),
                          );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom)
      context.read<PostBloc>().add(
            PostFetched(),
          );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
