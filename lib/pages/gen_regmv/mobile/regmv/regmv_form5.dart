import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../blocs/gen_regmv/regmv4form_bloc.dart';
import '../../../../blocs/gen_regmv/regmv5form_bloc.dart';

class RegmvForm5Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1id;

  const RegmvForm5Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1id
  });

  @override
  State<RegmvForm5Section> createState() => RegmvForm5SectionState();
}

class RegmvForm5SectionState extends State<RegmvForm5Section> {
  final _regmvform5key = GlobalKey<FormState>();
  late final Regmv5FormBloc regmv5Bloc;
  Uint8List? _localImageBytes;
  bool _showError = false;


  void initState() {
    super.initState();
    regmv5Bloc = context.read<Regmv5FormBloc>();
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
      title: Text("Foto Mobil", style: bodyTextStyle(context)),
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
    return BlocBuilder<Regmv5FormBloc, Regmv5FormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: hPadding, right: hPadding, bottom: hPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ------------------- 📸 Preview Foto -------------------
              // ------------------- 📸 Preview Foto -------------------
              if (_localImageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  child: Image.memory(
                    _localImageBytes!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                )
              else
                _uploadInstructionBox(),
            ],
          ),
        );
      },
    );
  }

  Future<bool> validateAndReturn() async {
    if (_localImageBytes == null) {
      // Tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap unggah foto Mobil terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true; // Foto sudah ada → valid
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
          Icon(
            Icons.upload,
            size: 40,
            color: _showError ? Colors.red : primaryLightColor,
          ),
          const SizedBox(height: 14),

          Text(
            "Unggah Foto Mobil",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryLightColor,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Pastikan foto Mobil jelas, terang, dan tidak buram untuk memudahkan verifikasi.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: cardGrey),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  text: 'Ambil dari Galeri',
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton.primary(
                  text: 'Ambil Foto',
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);

    if (file == null) return;

    final bytes = await file.readAsBytes();

    setState(() {
      _localImageBytes = bytes;
    });

    context.read<Regmv5FormBloc>().add(
      UploadBinaryFotoEvent(
        regmv1Id: widget.regmv1id ?? "",
        fileName: file.name,
        bytes: bytes,
        imageSource: source == ImageSource.camera ? "camera" : "gallery",
      ),
    );
  }

  Future<void> saveForm5() async {
    if (_localImageBytes == null) return;

    context.read<Regmv5FormBloc>().add(
      UploadBinaryFotoEvent(
        regmv1Id: widget.regmv1id ?? "",
        fileName: "foto-Mobil.jpg",
        bytes: _localImageBytes!,
        imageSource: "uploaded",
      ),
    );
  }
}