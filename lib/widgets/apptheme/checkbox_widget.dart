part of '../../common/constants.dart';

class CheckboxWidget extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final bool initialValue;
  final Function(bool) callback;

  // 🔥 BARU
  final bool enabled;
  final bool forceActive;

  const CheckboxWidget({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.initialValue,
    required this.callback,
    this.forceActive = false,
    this.enabled = true,
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

    final next = widget.forceActive ? true : widget.initialValue;
    if (next != _checkbox) {
      setState(() => _checkbox = next);
    }
  }

  void _toggleCheck() {
    if (!widget.enabled) return;     // ✅ disable klik
    if (widget.forceActive) return;  // 🔒 tetap kunci forceActive
    setState(() => _checkbox = !_checkbox);
    widget.callback(_checkbox);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: disabled ? null : _toggleCheck,
            child: Opacity(
              opacity: disabled ? 0.5 : 1,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _checkbox ? primaryColor : Colors.transparent,
                  border: Border.all(
                    color: _checkbox ? primaryColor : sGrey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _checkbox ? Icon(Icons.check, size: 14, color: primaryLightColor) : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: GestureDetector(
              onTap: _toggleCheck,
              child: Opacity(
                opacity: disabled ? 0.6 : 1,
                child: Text(
                  widget.rightLabel,
                  style: bodyTextStyle(context, fontSize: 15.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}