import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class StnkPickItem extends Equatable {
  final String localId;
  final Uint8List bytes;
  final String fileName;

  const StnkPickItem({
    required this.localId,
    required this.bytes,
    required this.fileName,
  });

  factory StnkPickItem.create(Uint8List bytes, String name) {
    return StnkPickItem(
      localId: const Uuid().v4(),
      bytes: bytes,
      fileName: name,
    );
  }

  @override
  List<Object?> get props => [localId, bytes, fileName];
}