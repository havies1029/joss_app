import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';



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



    // set up the AlertDialog

    AlertDialog alert = AlertDialog(

      backgroundColor: formGrey,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),

      ),

      title: Text(

        "Konfirmasi!",

        style: bodyTextStyle(context, fontSize: 18)

            .copyWith(fontWeight: FontWeight.bold, color: primaryLightColor),

      ),

      content: Text(

        "Apakah Anda yakin ingin menghapus data ini?",

        style: bodyTextStyle(context, fontSize: 14)

            .copyWith(color: hintGrey),

      ),

      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      actions: [

        Row(

          children: [

            Expanded(

              child: TextButton(

                style: TextButton.styleFrom(

                  backgroundColor: Colors.grey[700],

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 10),

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(8),

                  ),

                ),

                child: Text(

                  "Batal",

                  style: TextStyle(fontSize: getResponsiveFont(context, 16)),

                ),

                onPressed: () => Navigator.pop(context, false),

              ),

            ),

            const SizedBox(width: 10), // Jarak antar tombol

            Expanded(

              child: TextButton(

                style: TextButton.styleFrom(

                  backgroundColor: primaryColor,

                  foregroundColor: primaryLightColor,

                  padding: const EdgeInsets.symmetric(vertical: 10),

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(8),

                  ),

                ),

                child: Text(

                  "Ya",

                  style: TextStyle(fontSize: getResponsiveFont(context, 16)),

                ),

                onPressed: () {

                  widget.onHapusFunction(widget.recordId);

                  Navigator.pop(context, true);

                },

              ),

            ),

          ],

        ),

      ],

    );



    return alert;

  }

}