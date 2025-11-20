import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../blocs/gen_regmv/regmv4form_bloc.dart';

class RegmvForm4Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1id;

  const RegmvForm4Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1id
  });

  @override
  State<RegmvForm4Section> createState() => RegmvForm4SectionState();
}

class RegmvForm4SectionState extends State<RegmvForm4Section> {
  final _regmvform4key = GlobalKey<FormState>();
  late final Regmv4FormBloc regmv4Bloc;
  // Uint8List? _localImageBytes;
  bool _showError = false;
  List<Uint8List> _images = [];


  void initState() {
    super.initState();
    regmv4Bloc = context.read<Regmv4FormBloc>();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: pGrey,
      child: Column(
        children: [
          _buildHeader(),
          if (widget.isExpanded) _buildForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Foto STNK", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () {
        widget.onToggle(!widget.isExpanded);
      },
    );
  }

  Widget _buildForm() {
    return BlocBuilder<Regmv4FormBloc, Regmv4FormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: hPadding, right: hPadding, bottom: hPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _uploadInstructionBox(),
            ],
          ),
        );
      },
    );
  }

  Future<bool> validateAndReturn() async {
    if (_images.isEmpty) {
      setState(() => _showError = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap unggah minimal 1 foto STNK."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    setState(() => _showError = false);
    return true;
  }

  Widget _uploadInstructionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: _showError ? Colors.red : sGrey),
        color: formGrey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_images.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: MemoryImage(_images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 18,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _images.removeAt(index);
                            });
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black54,
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text("${_images.length} foto terunggah"),
          // ]
          ] else ...[
            Icon(
              Icons.upload,
              size: 40,
              color: _showError ? Colors.red : primaryLightColor,
            ),
            const SizedBox(height: 14),
            Text(
              "Unggah Foto STNK",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryLightColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pastikan foto STNK jelas, terang, dan tidak buram untuk memudahkan verifikasi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: cardGrey),
            ),
          ],

          const SizedBox(height: hPadding),

          Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  text: 'Ambil dari Galeri',
                  onPressed: _pickMultipleImages,

                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton.primary(
                  text: 'Ambil Foto',
                  onPressed: _pickMultipleImages,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickMultipleImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      for (var file in result.files) {
        if (file.bytes != null) {
          _images.add(file.bytes!);
        }
      }
    });

    // Kirim ke Bloc satu-satu
    for (var file in result.files) {
      if (file.bytes == null) continue;

      context.read<Regmv4FormBloc>().add(
        UploadBinaryStnkEvent(
          regmv1Id: widget.regmv1id ?? "251100001",
          fileName: file.name,
          bytes: file.bytes!,
          imageSource: "multiple",
        ),
      );
    }
  }


  Future<void> saveForm4() async {
    if (_images.isEmpty) return; // minimal 1 foto

    for (int i = 0; i < _images.length; i++) {
      context.read<Regmv4FormBloc>().add(
        UploadBinaryStnkEvent(
          regmv1Id: widget.regmv1id ?? "251100001",
          fileName: "foto-stnk-${i + 1}.jpg",
          bytes: _images[i],
          imageSource: "uploaded",
        ),
      );
    }
  }
}