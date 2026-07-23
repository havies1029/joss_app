import 'dart:io';

import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../../common/app_data.dart';
import '../../../common/loading_indicator.dart';
import 'klaim5cari_tile_widget.dart';
import 'klaim5tambahfile_widget.dart';

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
        // context.read<Klaim5cariBloc>().add(Klaim5ValidateDocumentsEvent());

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
                  key: ValueKey(
                    '${state.items[index].mjenisdocId}'
                        '-${state.items[index].klaim5Id}'
                        '-${state.items[index].fileUrl ?? ''}'
                        '-${state.items[index].localPath ?? ''}'
                        '-${state.items[index].fileName ?? ''}',
                  ),
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
                  await pickNewPhotoDokLain(widget.klaim1Id, judul);
                  return true;
                },
              ),
            ),
          ],
        )
        : const Center(
          child: LoadingIndicator(),
        );
      } else {
			return const Center(
					child: LoadingIndicator(),
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

  Future<void> pickNewPhotoDokLain(String klaim1Id, String jenisDocLain) async {
    final bloc = context.read<Klaim5cariBloc>();
    final picker = ImagePicker();

    try {
      final photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;

      final path = photo.path;
      final mime = lookupMimeType(path);

      bloc.add(
        Klaim5LocalFileSetEvent(
          klaim1Id: klaim1Id,
          mjenisdocId: '',
          klaim5Id: '',
          localPath: path,
          fileName: path.split('/').last,
          mimeType: mime,
          fileSizeBytes: await photo.length(),
          jenisDocLain: jenisDocLain,
        ),
      );

      bloc.add(
        Klaim5UploadRequestedEvent(
          mjenisdocId: '',
          klaim5Id: '',
          jenisDocLain: jenisDocLain,
        ),
      );

      // bloc.add(Klaim5ValidateDocumentsEvent());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil foto: $e')),
      );
    }
  }

  Future<void> _pickFile(Klaim5cariModel it) async {
    final bloc = context.read<Klaim5cariBloc>();

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
        'doc',
        'docx',
      ],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final path = file.path;
    if (path == null) return;

    final ext = path.split('.').last.toLowerCase();

    const allowed = [
      'jpg',
      'jpeg',
      'png',
      'pdf',
      'doc',
      'docx',
    ];

    if (!allowed.contains(ext)) return;

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
        jenisDocLain: it.jenisDocLain,
      ),
    );

    bloc.add(
      Klaim5UploadRequestedEvent(
        mjenisdocId: it.mjenisdocId,
        klaim5Id: it.klaim5Id,
        jenisDocLain: it.jenisDocLain,
      ),
    );

    bloc.add(Klaim5ValidateDocumentsEvent());
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

    bloc.add(
      Klaim5ValidateDocumentsEvent(),
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

    debugPrint('=== _pickPhoto START ===');
    debugPrint('it.klaim1Id      : ${it.klaim1Id}');
    debugPrint('it.klaim5Id      : ${it.klaim5Id}');
    debugPrint('it.mjenisdocId   : ${it.mjenisdocId}');
    debugPrint('it.jenisDocLain  : ${it.jenisDocLain}');
    debugPrint('it.jenisNama     : ${it.jenisNama}');
    debugPrint('picked path      : $path');
    debugPrint('picked file.size : ${await photo.length()}');

    bloc.add(
      Klaim5LocalFileSetEvent(
        klaim1Id: it.klaim1Id,
        mjenisdocId: it.mjenisdocId,
        klaim5Id: it.klaim5Id,
        localPath: path,
        fileName: path.split('/').last,
        mimeType: mime,
        fileSizeBytes: await photo.length(),
        jenisDocLain: it.jenisDocLain,
      ),
    );

    bloc.add(
      Klaim5UploadRequestedEvent(mjenisdocId: it.mjenisdocId, klaim5Id: it.klaim5Id,  jenisDocLain: it.jenisDocLain,),
    );

    bloc.add(
      Klaim5ValidateDocumentsEvent(),
    );
  }

  Future<bool?> showLogoutConfirmDialog(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutup",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              decoration: BoxDecoration(
                color: formGrey,
                borderRadius: BorderRadius.circular(cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hapus Dokumen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: getResponsiveFont(context, 18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Apakah Anda yakin ingin menghapus file ini?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryLightColor.withOpacity(0.7),
                      fontSize: getResponsiveFont(context, 16),
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sGrey,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(dialogContext, false),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pSlowRed,
                              foregroundColor: primaryLightColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(
                              "Iya",
                              style: TextStyle(
                                fontSize: getResponsiveFont(context, 16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _deleteFile(Klaim5cariModel it) async {
    final bloc = context.read<Klaim5cariBloc>();

    final confirm = await showLogoutConfirmDialog(context);

    if (!context.mounted) return;
    if (confirm != true) return;

    bloc.add(
      Klaim5DeleteRequestedEvent(
        mjenisdocId: it.mjenisdocId,
        klaim5Id: it.klaim5Id,
        jenisDocLain: it.jenisDocLain,
      ),
    );
    //
    // bloc.add(
    //   Klaim5ValidateDocumentsEvent(),
    // );
  }

  String? _detectMime(Klaim5cariModel it, String path) {
    final fromModel = it.mimeType?.trim();
    if (fromModel != null &&
        fromModel.isNotEmpty &&
        fromModel.toLowerCase() != 'application/octet-stream') {
      return fromModel;
    }

    final fromFileName = it.fileName?.trim();
    if (fromFileName != null && fromFileName.isNotEmpty) {
      final fileNameMime = lookupMimeType(fromFileName);
      if (fileNameMime != null && fileNameMime.isNotEmpty) {
        return fileNameMime;
      }
    }

    return lookupMimeType(path) ?? fromModel;
  }

  Map<String, String> get _authHeaders => {
    'Authorization': 'Bearer ${AppData.userToken}',
  };

  String _safePreviewFileName(Klaim5cariModel it, String source) {
    final uri = Uri.tryParse(source);
    final sourceName = (uri != null && uri.pathSegments.isNotEmpty)
        ? uri.pathSegments.last
        : 'preview_file';
    final rawName = (it.fileName?.trim().isNotEmpty ?? false)
        ? it.fileName!.trim()
        : sourceName;

    final sanitized = rawName
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return sanitized.isEmpty ? 'preview_file' : sanitized;
  }

  String _extensionFromMime(String mime) {
    final cleanMime = mime.split(';').first.trim().toLowerCase();
    if (cleanMime.contains('pdf')) return '.pdf';
    if (cleanMime.contains('jpeg')) return '.jpg';
    if (cleanMime.contains('png')) return '.png';
    if (cleanMime.contains('webp')) return '.webp';

    return '';
  }

  String _previewExtension(Klaim5cariModel it, String source, [String? contentType]) {
    final fileName = it.fileName?.trim();
    if (fileName != null && fileName.contains('.')) {
      final ext = fileName.split('.').last.trim().toLowerCase();
      if (ext.isNotEmpty && ext.length <= 6) return '.$ext';
    }

    final path = Uri.tryParse(source)?.path.toLowerCase() ?? source.toLowerCase();
    if (path.contains('.') && !path.endsWith('.')) {
      final ext = path.split('.').last.trim().toLowerCase();
      if (ext.isNotEmpty && ext.length <= 6) return '.$ext';
    }

    final responseExt = _extensionFromMime(contentType ?? '');
    if (responseExt.isNotEmpty) return responseExt;

    final mime = _detectMime(it, source)?.toLowerCase() ?? '';
    final mimeExt = _extensionFromMime(mime);
    if (mimeExt.isNotEmpty) return mimeExt;

    return '';
  }

  Future<String> _downloadRemotePreviewFile(Klaim5cariModel it, String source) async {
    final response = await http.get(Uri.parse(source), headers: _authHeaders);
    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception('File tidak bisa diakses (${response.statusCode})');
    }

    final tempDir = await getTemporaryDirectory();
    final previewDir = await Directory(
      '${tempDir.path}${Platform.pathSeparator}klaim5_preview',
    ).create(recursive: true);

    final ext = _previewExtension(it, source, response.headers['content-type']);
    final safeName = _safePreviewFileName(it, source);
    final hasExt = safeName.toLowerCase().endsWith(ext.toLowerCase());
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = hasExt
        ? '${timestamp}_$safeName'
        : '${timestamp}_$safeName$ext';
    final file = File('${previewDir.path}${Platform.pathSeparator}$fileName');

    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }

  Future<void> _preview(Klaim5cariModel it) async {
    final localPath = it.localPath?.trim();
    final fileUrl = it.fileUrl?.trim();

    if ((localPath == null || localPath.isEmpty) &&
        (fileUrl == null || fileUrl.isEmpty)) {
      return;
    }

    bool isLocal = localPath != null && localPath.isNotEmpty;
    String source = isLocal ? localPath : fileUrl!;

    if (!isLocal) {
      try {
        source = await _downloadRemotePreviewFile(it, source);
        isLocal = true;
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar('File tidak bisa dibuka dari server. $e'),
        );
        return;
      }

      if (!mounted) return;
    }

    final mime = _detectMime(it, source)?.toLowerCase() ?? '';
    final lowerSource = source.toLowerCase();

    final isImage = mime.startsWith('image/') ||
        lowerSource.endsWith('.jpg') ||
        lowerSource.endsWith('.jpeg') ||
        lowerSource.endsWith('.png') ||
        lowerSource.endsWith('.webp');

    final isPdf = mime.contains('pdf') || lowerSource.endsWith('.pdf');

    if (isImage) {
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: isLocal
                      ? Image.file(
                    File(source),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Gambar lokal tidak bisa dibuka',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
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

    if (isPdf) {
      final controller = PdfController(
        document: PdfDocument.openFile(source),
      );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Preview PDF')),
            body: PdfView(controller: controller),
          ),
        ),
      );
      return;
    }

    final result = await OpenFilex.open(source);
    if (result.type != ResultType.done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(result.message),
      );
    }
  }
}
