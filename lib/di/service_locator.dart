import 'package:get_it/get_it.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:post_list_pagination_search/data/datasources/remote/post_remote_data_source.dart';
import 'package:post_list_pagination_search/data/repositories/post_repository_impl.dart';
import 'package:post_list_pagination_search/domain/repositories/post_repository.dart';
import 'package:post_list_pagination_search/domain/usecases/fetch_posts_use_case.dart';
import 'package:post_list_pagination_search/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // External
  sl.registerLazySingleton(() => http.Client());

  // Utils
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(remoteDataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => FetchPostsUseCase(postRepository: sl()));

  // Blocs
  sl.registerFactory(() => PostBloc(fetchPosts: sl(), networkInfo: sl()));
}
