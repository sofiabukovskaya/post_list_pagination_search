sealed class Failure {
  Failure({
    required this.message,
  });

  final String message;
}

final class ServerFailure extends Failure {
  ServerFailure({
    required super.message,
  });
}

final class NoInternetConnectionFailure extends Failure {
  NoInternetConnectionFailure()
      : super(
          message: 'No internet connection',
        );
}
