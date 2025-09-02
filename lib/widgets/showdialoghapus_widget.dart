import 'package:flutter/material.dart';

class ShowDialogHapusWidget extends StatefulWidget {
  final String recordId;
  final Function(String) onHapusFunction;

  const ShowDialogHapusWidget({super.key, 
    required this.recordId,
    required this.onHapusFunction});

  @override
  ShowDialogHapusWidgetState createState() => ShowDialogHapusWidgetState();
}

class ShowDialogHapusWidgetState extends State<ShowDialogHapusWidget> {

  @override
  Widget build(BuildContext context) {
    
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        widget.onHapusFunction(widget.recordId);
        Navigator.pop(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation !"),
      content: const Text("Apakah Anda yakin untuk menghapus data ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return alert;
  }
}
