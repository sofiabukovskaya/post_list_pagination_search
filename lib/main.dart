import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';
import 'package:post_list_pagination_search/core/theming/app_theme.dart';
import 'package:post_list_pagination_search/di/service_locator.dart';
import 'package:post_list_pagination_search/domain/usecases/fetch_posts_use_case.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_bloc.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_event.dart';
import 'package:post_list_pagination_search/presentation/screens/home_screen.dart';

void main() {
  setupDependencies();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [
          lightSimpleTheme,
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [
          darkSimpleTheme,
        ],
      ),
      home: BlocProvider<PostBloc>(
        create: (_) => PostBloc(
          fetchPostsUseCase: sl.get<FetchPostsUseCase>(),
          networkInfo: sl.get<NetworkInfo>(),
        )..add(
            PostFetched(),
          ),
        child: HomeScreen(),
      ),
    );
  }
}
