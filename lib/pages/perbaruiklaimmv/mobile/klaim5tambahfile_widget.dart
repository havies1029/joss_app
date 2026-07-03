import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

class Klaim5TambahDokumenForm extends StatefulWidget {
  final Future<bool> Function(String judul)? onPickFileDokLain;
  final Future<bool> Function(String judul)? onPickPhoto;

  const Klaim5TambahDokumenForm({
    super.key,
    this.onPickFileDokLain,
    this.onPickPhoto,
  });

  @override
  State<Klaim5TambahDokumenForm> createState() =>
      _Klaim5TambahDokumenFormState();
}

class _Klaim5TambahDokumenFormState extends State<Klaim5TambahDokumenForm> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String? _errorText;
  bool _isLoading = false;

  bool get _isValid => !_isLoading;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_errorText != null) {
        setState(() {
          _errorText = null;
        });
      }
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
      setState(() {
        _errorText = 'Judul dokumen wajib diisi';
      });
      _focusNode.requestFocus();
      return;
    }

    if (action == null) return;

    setState(() => _isLoading = true);

    try {
      final success = await action(judul);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        _controller.clear();
        setState(() {
          _errorText = null;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
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
          Text(
            'Tambah Dokumen',
            style: TextStyle(
              color: primaryLightColor,
              fontSize: getResponsiveFont(context, 18),
            ),
          ),
          Text(
            'Judul Dokumen :',
            style: TextStyle(
              color: cardGrey,
              fontSize: getResponsiveFont(context, 13),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Masukan Judul Dokumen',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.45),
              ),
              errorText: _errorText,
              filled: true,
              fillColor: const Color(0xFF3A3A3A),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cardBorderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              errorStyle: bodyTextStyle(context).copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FormButton(
                  label: 'Ambil File',
                  icon: SvgPicture.asset(
                    "assets/icons/gallery_img.svg",
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
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
                  icon: SvgPicture.asset(
                    "assets/icons/photo_img.svg",
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  bg: const Color(0xFFF28C28),
                  fg: Colors.white,
                  isEnabled: _isValid,
                  isLoading: _isLoading,
                  onTap: () => _handlePick(widget.onPickPhoto),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _FormButton extends StatelessWidget {
  final String label;
  final Widget icon;
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

  bool _isOverflow(
    String text,
    double maxWidth,
    TextStyle style,
    BuildContext context,
  ) {
    if (maxWidth <= 0) return true;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: fg,
      fontSize: 13,
      fontWeight: FontWeight.w800,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        const iconWidth = 18.0;
        const iconSpacing = 6.0;
        const horizontalPadding = 24.0;

        final textMaxWidthWhenIconShown =
            maxWidth - (horizontalPadding + iconWidth + iconSpacing);

        final overflowWithIcon = _isOverflow(
          label,
          textMaxWidthWhenIconShown,
          textStyle,
          context,
        );

        final showIcon = !overflowWithIcon;

        return SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: isEnabled ? onTap : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              disabledBackgroundColor: bg.withOpacity(0.5),
              disabledForegroundColor: fg.withOpacity(0.7),
              foregroundColor: fg,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showIcon) ...[
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: icon,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
