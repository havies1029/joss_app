import 'dart:io';

import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5tambahfile_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5cari_tile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfx/pdfx.dart';

class Klaim5cariListWidget extends StatefulWidget {
  final String klaim1Id;
	const Klaim5cariListWidget({super.key, required this.klaim1Id});

	@override
	Klaim5cariListWidgetState createState() => Klaim5cariListWidgetState();
}

class Klaim5cariListWidgetState extends State<Klaim5cariListWidget> {
	late Klaim5cariBloc klaim5cariBloc;
	final ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();
		_scrollController.addListener(_onScroll);
	}

	@override
	void dispose() {
		_scrollController
			..removeListener(_onScroll)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		klaim5cariBloc = BlocProvider.of<Klaim5cariBloc>(context);
		return BlocConsumer<Klaim5cariBloc, Klaim5cariState>(
			builder: (context, state) {

		  if (state.status == ListStatus.success) {

      return state.items.isNotEmpty
        ? Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemCount: state.items.length,
              itemBuilder: (_, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                padding: const EdgeInsets.all(0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0)),
                child: Klaim5cariTileWidget(
                  jenisDocLain: state.items[index].jenisDocLain,
                  klaim5Id: state.items[index].klaim5Id,
                  mjenisdocId: state.items[index].mjenisdocId,
                  jenisNama: state.items[index].jenisNama,
                  fileUrl: state.items[index].fileUrl,
                  fileName: state.items[index].fileName,
                  localPath: state.items[index].localPath,
                  mime: state.items[index].mimeType,
                  fileSizeBytes: state.items[index].fileSizeBytes,
                  onPickFile: () => _pickFile(state.items[index]),
                  onPickPhoto: () => _pickPhoto(state.items[index]),
                  onDelete: () => _deleteFile(state.items[index]),
                  onPreview: () => _preview(state.items[index]),
                ),
              )),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 12),
              child: Klaim5TambahDokumenForm(
                onPickFileDokLain: (judul) async {
                  await pickNewFileDokLain(widget.klaim1Id, judul);
                  return true;
                },
                onPickPhoto: (judul) async {
                  // TODO: panggil camera
                  // final judul = _judulCtrl.text.trim();
                  return true;
                },
              ),
            ),
          ],
        )
        : const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.0),
            child: Text(
              'No Data Available!!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
			return const Center(
					child: Text(
						'No Data Available!!',
						style: TextStyle(
							color: Colors.red,
							fontSize: 12.0,
							fontWeight: FontWeight.bold),
					),
				);
			}
			}, buildWhen: (previous, current) {
				return previous.status != current.status || previous.items != current.items;
			}, listener: (context, state) {}
		);
	}
	void _onScroll() {
		if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			klaim5cariBloc.add(FetchKlaim5cariEvent());
		}
	}
  
// helper: detect mime sederhana dari ekstensi
String? guessMime(String path) {
  final p = path.toLowerCase();
  if (p.endsWith('.jpg') || p.endsWith('.jpeg')) return 'image/jpeg';
  if (p.endsWith('.png')) return 'image/png';
  if (p.endsWith('.webp')) return 'image/webp';
  if (p.endsWith('.pdf')) return 'application/pdf';
  if (p.endsWith('.doc') || p.endsWith('.docx')) return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  if (p.endsWith('.xls') || p.endsWith('.xlsx')) return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  if (p.endsWith('.txt')) return 'text/plain';
  return null;
}

bool isImagePath(String? path) {
  if (path == null) return false;
  final p = path.toLowerCase();
  return p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.png') || p.endsWith('.webp');
}
bool isPdfPath(String? path) => (path ?? '').toLowerCase().endsWith('.pdf');

Future<void> showPreviewDialog({
  required BuildContext context,
  required String title,
  required String pathOrUrl,
  required bool isLocal,
}) async {
  final isImg = isImagePath(pathOrUrl);
  final isPdf = isPdfPath(pathOrUrl);

  if (isImg) {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF101010),
        child: Stack(
          children: [
            InteractiveViewer(
              child: isLocal
                  ? Image.file(File(pathOrUrl), fit: BoxFit.contain)
                  : Image.network(pathOrUrl, fit: BoxFit.contain),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    return;
  }

  if (isPdf && isLocal) {
    final controller = PdfControllerPinch(document: PdfDocument.openFile(pathOrUrl));
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: const Color(0xFF101010),
        child: Stack(
          children: [
            PdfViewPinch(controller: controller),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  controller.dispose();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    return;
  }

  // selain image/pdf lokal: buka pakai aplikasi eksternal
  if (isLocal) {
    await OpenFilex.open(pathOrUrl);
  } else {
    // kalau hanya URL dan bukan image: idealnya download dulu atau buka di webview/browser
    // untuk simpel: tampilkan info saja
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preview file ini belum didukung dari URL.')),
    );
  }
}


Future<void> _pickFile(Klaim5cariModel it) async {
  final bloc = context.read<Klaim5cariBloc>();
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: [
      'jpg', 'jpeg', 'png',
      'pdf',
      'doc', 'docx',
      'xls', 'xlsx',
      'txt'
    ],
  );

  if (result == null || result.files.isEmpty) return;

  final file = result.files.first;
  final path = file.path;
  if (path == null) return;

  final mime = lookupMimeType(path);
  bloc.add(
    Klaim5LocalFileSetEvent(
      klaim1Id: it.klaim1Id,
      mjenisdocId: it.mjenisdocId,
      klaim5Id: it.klaim5Id,
      localPath: path,
      fileName: file.name,
      mimeType: mime,
      fileSizeBytes: file.size,
    ),
  );

  bloc.add(
    Klaim5UploadRequestedEvent(mjenisdocId: it.mjenisdocId, klaim5Id: it.klaim5Id, jenisDocLain: ''),
  );
}

Future<void> pickNewFileDokLain(String klaim1Id, String jenisDocLain) async {
  final bloc = context.read<Klaim5cariBloc>();
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: [
      'jpg', 'jpeg', 'png',
      'pdf',
      'doc', 'docx',
      'xls', 'xlsx',
      'txt'
    ],
  );

  if (result == null || result.files.isEmpty) return;

  final file = result.files.first;
  final path = file.path;
  if (path == null) return;

  final mime = lookupMimeType(path);
  bloc.add(
    Klaim5LocalFileSetEvent(
      klaim1Id: klaim1Id,
      mjenisdocId: '',
      klaim5Id: '',
      localPath: path,
      fileName: file.name,
      mimeType: mime,
      fileSizeBytes: file.size,
      jenisDocLain: jenisDocLain,
    ),
  );

  bloc.add(
    Klaim5UploadRequestedEvent(mjenisdocId: '', klaim5Id: '', jenisDocLain: jenisDocLain),
  );
}


Future<void> _pickPhoto(Klaim5cariModel it) async {
  final picker = ImagePicker();

  final bloc = context.read<Klaim5cariBloc>();
  final photo = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 85,
  );

  if (photo == null) return;

  final path = photo.path;
  final mime = lookupMimeType(path);

  bloc.add(
    Klaim5LocalFileSetEvent(
      klaim1Id: it.klaim1Id,
      mjenisdocId: it.mjenisdocId,
      klaim5Id: it.klaim5Id,
      localPath: path,
      fileName: path.split('/').last,
      mimeType: mime,
      fileSizeBytes: await photo.length(),
    ),
  );

  bloc.add(
    Klaim5UploadRequestedEvent(mjenisdocId: it.mjenisdocId, klaim5Id: it.klaim5Id, jenisDocLain: ''),
  );
}

Future<void> _deleteFile(Klaim5cariModel it) async {
  
  final bloc = context.read<Klaim5cariBloc>();
  final confirm = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // optional: biar harus pilih tombol
    builder: (dialogContext) => AlertDialog(
      title: const Text("Hapus Dokumen"),
      content: const Text("Apakah Anda yakin ingin menghapus file ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Hapus"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  bloc.add(
    Klaim5DeleteRequestedEvent(mjenisdocId: it.mjenisdocId, klaim1Id: it.klaim1Id, jenisDocLain: it.jenisDocLain),
  );
}


Future<void> _preview(Klaim5cariModel it) async {
  // ignore: unnecessary_null_comparison
  if (it.fileUrl == null && it.localPath == null) return;

  final path = it.localPath ?? it.fileUrl ?? '';

  final mime = lookupMimeType(path);

  // IMAGE
  if (mime != null && mime.startsWith('image/')) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: InteractiveViewer(
          child: Image.file(File(path)),
        ),
      ),
    );
    return;
  }

  // PDF
  if (mime != null && mime.contains('pdf')) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Preview PDF")),
          body: PdfView(
            controller: PdfController(
              document: PdfDocument.openFile(path),
            ),
          ),
        ),
      ),
    );
    return;
  }

  // OTHER FILE (DOC/XLS/TXT)
  await OpenFilex.open(path);
}



}
