import 'package:flutter/material.dart';

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
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("initialValue : ${widget.initialValue.toString()}");
    debugPrint("_checkbox : ${_checkbox.toString()}");

    _checkbox = widget.initialValue;

    return Row(
      children: [
        SizedBox(width: widget.leftLabel.isEmpty ? 1 : 3),
        Text(
          widget.leftLabel,
          style: const TextStyle(fontSize: 15.0),
        ),
        Checkbox(
          value: _checkbox,
          onChanged: (value) {
            widget.callback(value!);
            setState(() => _checkbox = !_checkbox);
          },
        ),
        SizedBox(width: widget.leftLabel.isEmpty ? 1 : 3),
        Text(
          widget.rightLabel,
          style: const TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }
}
