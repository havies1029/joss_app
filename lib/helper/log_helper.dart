import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

String prettyJson(String raw) {
  final obj = jsonDecode(raw);
  return const JsonEncoder.withIndent('  ').convert(obj);
}

/// Paling aman: pakai developer.log (lebih stabil daripada debugPrint)
void logFull(String text, {String name = 'HTTP', int chunkSize = 900}) {
  for (int i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    dev.log(text.substring(i, end), name: name);
  }
}

/// Fallback: print() (biasanya selalu keluar juga)
void printFull(String text, {int chunkSize = 900}) {
  for (int i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    print(text.substring(i, end));
  }
}

/// Kalau tetap mau debugPrint, pakai ini (tapi bisa throttle)
void debugPrintFull(String text, {int chunkSize = 900}) {
  for (int i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    debugPrint(text.substring(i, end));
  }
}
