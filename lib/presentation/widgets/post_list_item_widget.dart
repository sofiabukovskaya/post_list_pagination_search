import 'package:flutter/material.dart';
import 'package:post_list_pagination_search/domain/entities/post.dart';

class PostListItemWidget extends StatelessWidget {
  final Post post;

  const PostListItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(post.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
