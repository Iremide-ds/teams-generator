/// A wrapper class to handle success and error states
class Result<T, E> {
  const Result._({this.data, this.error, required this.isSuccess});

  /// Creates a success result with data
  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  /// Creates an error result with an error message
  factory Result.error(E error) {
    return Result._(error: error, isSuccess: false);
  }

  final T? data;
  final E? error;
  final bool isSuccess;
}
