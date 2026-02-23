import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KlaimLacakAuthedImageThumb extends StatelessWidget {
  final String? url;
  final Map<String, String> headers;
  final double width;
  final double height;

  const KlaimLacakAuthedImageThumb({
    super.key,
    required this.url,
    required this.headers,
    this.width = 108,
    this.height = 78,
  });

  Future<Uint8List> _fetchBytes(String url) async {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode != 200) throw Exception("Image HTTP ${res.statusCode}");
    return res.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    final u = (url ?? '').trim();
    if (u.isEmpty) return _placeholder();

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width,
        height: height,
        color: Colors.white.withOpacity(0.06),
        child: FutureBuilder<Uint8List>(
          future: _fetchBytes(u),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            if (snap.hasError || !snap.hasData) return _placeholder();
            return Image.memory(snap.data!, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  Widget _placeholder() => Center(
    child: Icon(Icons.image_outlined, color: Colors.white.withOpacity(0.35), size: 22),
  );
}