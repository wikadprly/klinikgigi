class ValidationException implements Exception {
  final Map<String, List<String>> errors;
  final String message;

  ValidationException(this.errors, {this.message = 'Validation failed'});

  @override
  String toString() => '$message: ${errors.toString()}';
}
