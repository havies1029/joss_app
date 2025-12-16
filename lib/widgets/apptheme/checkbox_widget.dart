part of '../../common/constants.dart';

class CheckboxWidget extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final Function(bool) callback;

  // 🔥 BARU
  final bool forceActive;

  const CheckboxWidget({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.initialValue,
    required this.callback,
    this.forceActive = false, 
  });

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State<CheckboxWidget> {
  late bool _checkbox;

  @override
  void initState() {
    super.initState();
    _checkbox = widget.forceActive ? true : widget.initialValue;
  }

  @override
  void didUpdateWidget(CheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.forceActive) {
      _checkbox = true;
    } else if (oldWidget.initialValue != widget.initialValue) {
      _checkbox = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4), // biar stabil tinggi
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ❗ sejajarkan vertikal
        children: [
          // Kotak checkbox
          GestureDetector(
            onTap: _toggleCheck,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: _checkbox
                    ? (widget.forceActive ? pGrey : primaryColor)
                    : Colors.transparent,
                border: Border.all(
                  color: _checkbox
                      ? (widget.forceActive ? pGrey : primaryColor)
                      : sGrey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _checkbox
                  ? const Icon(Icons.check, size: 14)
                  : null,
            ),
          ),

          const SizedBox(width: 10),

          // Label — tidak lagi Expanded (biar tidak stretchy!)
          Flexible(
            child: GestureDetector(
              onTap: _toggleCheck,
              child: Text(
                widget.rightLabel,
                style: bodyTextStyle(context, fontSize: 15.5),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }

// biar gak ulang2 kode
  void _toggleCheck() {
    if (widget.forceActive) return; // 🔒 KUNCI
    setState(() => _checkbox = !_checkbox);
    widget.callback(_checkbox);
  }
}