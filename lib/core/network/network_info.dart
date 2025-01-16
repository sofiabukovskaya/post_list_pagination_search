import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

final class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(
    this._connectivity,
  );

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return !connectivityResult.contains(
      ConnectivityResult.none,
    );
  }
}
