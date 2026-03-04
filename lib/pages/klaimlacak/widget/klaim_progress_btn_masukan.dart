import 'package:flutter/material.dart';

class KlaimProgressBtnMasukan extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool enabled;

  const KlaimProgressBtnMasukan({
    super.key,
    required this.onPressed,
    this.text = 'Masukan',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    const bgEnabled = Color(0xFFF5B33B);

    const bgDisabled = Color(0xFFF2D9A1);      // krem, masih “kuning” tapi tida›k pudar banget
    const fgDisabled = Color(0xFF6B4B10);      // coklat gelap (kontras tinggi)
    const borderDisabled = Color(0xFFB98A2A);  // border kuning tua

    final bg = enabled ? bgEnabled : bgDisabled;
    final fg = enabled ? Colors.white : fgDisabled;
    final borderColor = enabled ? Colors.transparent : borderDisabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: enabled ? onPressed : null,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: enabled ? 0 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 22,
                height: 18,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Icon(
                        Icons.thumb_up_alt_rounded,
                        size: 18,
                        color: fg,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 4,
                      child: Icon(
                        Icons.thumb_down_alt_rounded,
                        size: 18,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: fg,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700, // lebih “nyata”
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}