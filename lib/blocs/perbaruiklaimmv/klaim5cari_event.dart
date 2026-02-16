part of 'klaim5cari_bloc.dart';

abstract class Klaim5cariEvents extends Equatable {
	const Klaim5cariEvents();

	@override
	List<Object> get props => [];
}

class FetchKlaim5cariEvent extends Klaim5cariEvents {}

class RefreshKlaim5cariEvent extends Klaim5cariEvents {
  final String klaim1Id;
  const RefreshKlaim5cariEvent({required this.klaim1Id});

  @override
  List<Object> get props => [klaim1Id];
}

class Klaim5LocalFileSetEvent extends Klaim5cariEvents {
  final String klaim1Id;
  final String mjenisdocId;
  final String klaim5Id; // id klaim5 (dokumen) yang bersangkutan, bisa kosong kalau belum pernah disimpan ke server
  final String localPath;
  final String fileName;
  final String? mimeType;
  final int? fileSizeBytes;
  final String jenisDocLain;

  const Klaim5LocalFileSetEvent({
    required this.klaim1Id,
    required this.mjenisdocId,
    required this.klaim5Id,
    required this.localPath,
    required this.fileName,
    this.mimeType,
    this.fileSizeBytes,
    this.jenisDocLain = "",
  });

  @override
  List<Object> get props => [klaim1Id, mjenisdocId, klaim5Id, localPath, fileName, mimeType ?? '', fileSizeBytes ?? 0, jenisDocLain];
}

class Klaim5DeleteRequestedEvent extends Klaim5cariEvents {
  final String mjenisdocId;
  final String klaim1Id;
  final String jenisDocLain;

  const Klaim5DeleteRequestedEvent({
    required this.mjenisdocId,
    required this.klaim1Id,
    required this.jenisDocLain,
  });

  @override
  List<Object> get props => [mjenisdocId, klaim1Id, jenisDocLain];
}

class Klaim5UploadRequestedEvent extends Klaim5cariEvents {
  final String mjenisdocId;      // id row dokumen (bisa kosong kalau belum created)
  final String klaim5Id;
  final String jenisDocLain;     // jenis dokumen lain, bisa kosong kalau belum pernah disimpan ke server

  const Klaim5UploadRequestedEvent({
    required this.mjenisdocId,
    required this.klaim5Id,
    required this.jenisDocLain,
  });

  @override
  List<Object> get props => [mjenisdocId, klaim5Id, jenisDocLain];
}