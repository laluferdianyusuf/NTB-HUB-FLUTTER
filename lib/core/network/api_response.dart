class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    this.message,
    this.statusCode = 200,
  });

  final T data;
  final String? message;
  final int statusCode;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
