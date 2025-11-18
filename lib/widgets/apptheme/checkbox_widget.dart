part of '../../common/constants.dart';

class CheckboxWidget extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final Function(bool) callback;

  const CheckboxWidget(
      {super.key,
        required this.leftLabel,
        required this.rightLabel,
        required this.initialValue,
        required this.callback});

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State<CheckboxWidget> {
  late bool _checkbox;

  @override
  void initState() {
    super.initState();
    _checkbox = widget.initialValue;
  }

  @override
  void didUpdateWidget(CheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _checkbox = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // penting!
      children: [
        // LEFT LABEL (opsional)
        if (widget.leftLabel.isNotEmpty) ...[
          GestureDetector(
            onTap: _toggleCheck,
            child: Text(
              widget.leftLabel,
              style: bodyTextStyle(context, fontSize: 16),
            ),
          ),
          const SizedBox(width: 14),
        ],

        // CHECKBOX
        GestureDetector(
          onTap: _toggleCheck,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 3),
            // biar sejajar dengan text wrap
            decoration: BoxDecoration(
              color: _checkbox ? primaryColor : Colors.transparent,
              border: Border.all(
                color: _checkbox ? primaryColor : sGrey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _checkbox
                ? const Icon(Icons.check, size: 12.8)
                : null,
          ),
        ),

        const SizedBox(width: 14),

        // RIGHT LABEL — FIX : expanded biar WRAP 🔥
        Expanded(
          child: GestureDetector(
            onTap: _toggleCheck,
            child: Text(
              widget.rightLabel,
              style: bodyTextStyle(context, fontSize: 16),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }

// biar gak ulang2 kode
  void _toggleCheck() {
    setState(() => _checkbox = !_checkbox);
    widget.callback(_checkbox);
  }
}