class ErrorI implements Exception {
  String message;
  int code;

  ErrorI({
    required this.message,
    required this.code,
  });

  ErrorI.fromJson(Map<String, dynamic> json)
      : this(
          code: int.parse((json['code'] ?? 404).toString()),
          message: json['_message'] ?? json['message'],
        );

  @override
  String toString() {
    return 'ErrorI(message: $message code: $code)';
  }
}
