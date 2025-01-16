import 'package:get_it/get_it.dart';
import 'package:post_list_pagination_search/core/network/network_info.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Utils
  sl.registerLazySingleton(() => NetworkInfoImpl(sl()));
}
