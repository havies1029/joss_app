import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  const FormError({
    super.key,
    required this.errors,
  });

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    return Column(
      children: List.generate(
        errors.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _errorRow(errors[index]),
        ),
      ),
    );
  }

  Widget _errorRow(String error) {
    const iconColor = Color(0xFFFF5A5F); // merah terang
    const textColor = Color(0xFFFFC1C3); // pink terang (lebih jelas di background gelap)
    const bgColor   = Color(0x33FF5A5F); // merah transparan (20%)

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x55FF5A5F), width: 1),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/Error.svg",
            height: 14,
            width: 14,
            colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: textColor,
                fontSize: 12.5,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}