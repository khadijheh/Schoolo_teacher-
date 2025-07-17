class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  @override
  // ignore: overridden_fields
  final String message;
  ServerFailure(this.message) : super(message);
}

class CacheFailure extends Failure {
  @override
  // ignore: overridden_fields
  final String message;
  CacheFailure(this.message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}
