import 'package:flutter/material.dart';

class MetodeGantiKlaimWidget extends StatelessWidget {
  /// Value dari backend: 10001 (Indemnity) atau 10002 (Reinstatement)
  /// Boleh kirim int atau String (mis "10001")
  final String metodeGantiKlaimId;

  const MetodeGantiKlaimWidget({
    super.key,
    required this.metodeGantiKlaimId,
  });

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  @override
  Widget build(BuildContext context) {
    final id = _toInt(metodeGantiKlaimId);
    final selectedIndemnity = id == 10001;
    final selectedReinstatement = id == 10002;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegBtnReadonly(label: 'Indemnity', selected: selectedIndemnity),
          const SizedBox(width: 6),
          _SegBtnReadonly(label: 'Reinstatement', selected: selectedReinstatement),
        ],
      ),
    );
  }
}

class _SegBtnReadonly extends StatelessWidget {
  final String label;
  final bool selected;

  const _SegBtnReadonly({
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFE53935) : const Color(0xFF2A2A2A);
    final border = selected ? Colors.transparent : Colors.white.withOpacity(0.10);
    final textColor = selected ? Colors.white : Colors.white.withOpacity(0.35);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
