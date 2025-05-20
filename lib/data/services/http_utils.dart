import 'dart:async';
import 'package:http/http.dart' as http;

/// Выполняет HTTP-запрос с возможностью повторных попыток
///
/// [requestFn] - функция, выполняющая HTTP-запрос
/// [maxAttempts] - максимальное количество попыток (по умолчанию 3)
/// [delay] - задержка между попытками в миллисекундах (по умолчанию 1000)
/// [shouldRetry] - функция, определяющая, нужно ли повторять запрос при ошибке
Future<T> retry<T>({
  required Future<T> Function() requestFn,
  int maxAttempts = 3,
  int delay = 1000,
  bool Function(Exception)? shouldRetry,
}) async {
  int attempts = 0;
  while (true) {
    try {
      attempts++;
      return await requestFn();
    } catch (e) {
      if (e is Exception && (shouldRetry?.call(e) ?? true)) {
        if (attempts < maxAttempts) {
          await Future.delayed(Duration(milliseconds: delay * attempts));
          continue;
        }
      }
      rethrow;
    }
  }
}

/// Выполняет HTTP GET запрос с возможностью повторных попыток
Future<http.Response> retryGet(
  Uri url, {
  Map<String, String>? headers,
  int maxAttempts = 3,
  int delay = 1000,
  bool Function(Exception)? shouldRetry,
}) {
  return retry(
    requestFn: () => http.get(url, headers: headers),
    maxAttempts: maxAttempts,
    delay: delay,
    shouldRetry: shouldRetry,
  );
}
