import 'package:flutter/material.dart';

class Klaim5TambahDokumenForm extends StatefulWidget {
  final Future<bool> Function(String judul)? onPickFileDokLain;
  final Future<bool> Function(String judul)? onPickPhoto;

  const Klaim5TambahDokumenForm({
    super.key,
    this.onPickFileDokLain,
    this.onPickPhoto,
  });

  @override
  State<Klaim5TambahDokumenForm> createState() => _Klaim5TambahDokumenFormState();
}

class _Klaim5TambahDokumenFormState extends State<Klaim5TambahDokumenForm> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String? _errorText;
  bool _isLoading = false;

  bool get _isValid => _controller.text.trim().isNotEmpty && !_isLoading;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _errorText = null;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePick(Future<bool> Function(String)? action) async {
    final judul = _controller.text.trim();

    if (judul.isEmpty) {
      setState(() => _errorText = 'Judul dokumen wajib diisi');
      _focusNode.requestFocus();
      return;
    }

    if (action == null) return;

    setState(() => _isLoading = true);

    final success = await action(judul);

    setState(() => _isLoading = false);

    if (success) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF2F2F2F);
    final border = Colors.white.withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Dokumen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'Judul Dokumen :',
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Masukan Judul Dokumen',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
              errorText: _errorText,
              filled: true,
              fillColor: const Color(0xFF3A3A3A),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _FormButton(
                  label: 'Ambil File',
                  icon: Icons.insert_drive_file_outlined,
                  bg: const Color(0xFF4A4A4A),
                  fg: Colors.white,
                  isEnabled: _isValid,
                  isLoading: _isLoading,
                  onTap: () => _handlePick(widget.onPickFileDokLain),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormButton(
                  label: 'Ambil Foto',
                  icon: Icons.photo_camera_outlined,
                  bg: const Color(0xFFF28C28),
                  fg: Colors.white,
                  isEnabled: _isValid,
                  isLoading: _isLoading,
                  onTap: () => _handlePick(widget.onPickPhoto),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _FormButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.isEnabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: isEnabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
