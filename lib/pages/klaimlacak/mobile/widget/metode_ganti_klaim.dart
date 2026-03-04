import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class MetodeGantiKlaimWidget extends StatelessWidget {
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SegBtnReadonly(
          label: 'Indemnity',
          selected: selectedIndemnity,
          isLeft: true,
        ),
        SizedBox(width: 5),
        _SegBtnReadonly(
          label: 'Reinstatement',
          selected: selectedReinstatement,
          isLeft: false,
        ),
      ],
    );
  }
}

class _SegBtnReadonly extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isLeft;

  const _SegBtnReadonly({
    required this.label,
    required this.selected,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.horizontal(
      left: isLeft ? const Radius.circular(10) : Radius.zero,
      right: isLeft ? Radius.zero : const Radius.circular(10),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF61A1A) : pGrey,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: selected ? const Color(0xFFF61A1A) : sGrey,
        ),
      ),
      child: Text(
          label,
          style: bodyTextStyle(context, fontSize: 14)
      ),
    );
  }
}