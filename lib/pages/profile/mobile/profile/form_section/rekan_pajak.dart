import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_profile/mrekanpajakcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanpajakcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/widgets/combobox/combomkota_widget.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/widgets/combobox/combompropinsi_widget.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanPajakCrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const MRekanPajakCrudFormPage({super.key, required this.viewMode, required this.recordId});

  @override
  MRekanPajakCrudFormPageFormState createState() => MRekanPajakCrudFormPageFormState();
}

class MRekanPajakCrudFormPageFormState extends State<MRekanPajakCrudFormPage> {
  late MRekanPajakCrudBloc mRekanPajakCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldAlamat1Controller = TextEditingController();
  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey = GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  var fieldNpwpNoController = TextEditingController();
  ComboRKodeposModel? fieldComboRKodepos;
  final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // init bloc contact
    mRekanPajakCrudBloc = BlocProvider.of<MRekanPajakCrudBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    // Avatar sizing (biar gampang tuning)
    const double avatarRadius = 50;
    const double avatarRingPadding = 3;
    const double avatarBorderWidth = 2;

    // Ruang di atas konten untuk avatar (radius + margin)
    const double contentTopPadding = 120;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Informasi Klien',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      SizedBox(height: headerSpacing * 4),
                      // di parent Column pastikan dibungkus Expanded ya:
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(                // ⬅️ hanya atas
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: secondaryBlackColor, // panel hitamnya di sini
                              borderRadius: BorderRadius.only(                // ⬅️ hanya atas
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              border: const Border(
                                top: BorderSide(color: primaryColor, width: 4.0),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                // --- FORM stretch sampai bawah + tetap bisa scroll ---
                                CustomScrollView(
                                  physics: const NeverScrollableScrollPhysics(), // ⬅️ matiin scroll gesture
                                  slivers: [
                                    SliverPadding(
                                      padding: EdgeInsets.fromLTRB(
                                        16,
                                        contentTopPadding, // ruang buat avatar
                                        16,
                                        24 + MediaQuery.of(context).viewInsets.bottom, // aman dari keyboard
                                      ),
                                      sliver: SliverFillRemaining(
                                        hasScrollBody: false, // ⬅️ ini yang bikin "stretch"
                                        child: BlocConsumer<MRekanPajakCrudBloc, MRekanPajakCrudState>(
                                          listener: (context, state) {
                                            if (state.isLoaded) {
                                              if (state.record != null){
                                                fieldAlamat1Controller.text = state.record!.alamat1;
                                                fieldNpwpNoController.text = state.record!.npwpNo;
                                              }
                                              fieldComboMKota = state.comboMKota;
                                              fieldComboMPropinsi = state.comboMPropinsi;
                                              fieldComboRKodepos = state.comboRKodepos;
                                            }
                                          },
                                          builder: (context, state) {
                                            return Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 10),

                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 20), // 20.0 dari constants
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start, // mulai dari start
                                                      children: [
                                                        Text(
                                                          "Informasi Klien",
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: getResponsiveFont(context, 22),
                                                            fontWeight: FontWeight.w600,
                                                            color: primaryLightColor,     // warna brand dari constants
                                                          ),
                                                        ),
                                                        Text(
                                                          "Lengkapi identitas dasar Anda dengan benar.",
                                                          style: TextStyle(
                                                            fontSize: getResponsiveFont(context, 16),          // lebih kecil dari judul
                                                            fontWeight: FontWeight.w400,
                                                            color: sGrey,         // teks sekunder dari constants
                                                            height: 1.3,             // biar terbaca nyaman
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // ===== Field-field milik Bos =====
                                                  buildFieldAlamat1(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldMkotaId(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldMpropinsiId(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldMrekan1Id(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldNpwpNo(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldRkodeposId(),

                                                  const SizedBox(height: 25),
                                                  FormError(errors: errors, key: null),

                                                  const SizedBox(height: 16),
                                                  AppButton.primary(
                                                    text: "Submit",
                                                    onPressed: onSaveForm,
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                  ),

                                                  const Spacer(), // ⬅️ dorong konten biar panel tetap nempel bawah saat konten pendek
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // --- Avatar tetap di atas tengah ---
                                Positioned(
                                  top: 16,
                                  child: BlocBuilder<UserProfileCubit, UserProfileState>(
                                    buildWhen: (prev, curr) =>
                                    (prev.fotoBytes?.lengthInBytes ?? -1) != (curr.fotoBytes?.lengthInBytes ?? -1),
                                    builder: (context, state) {
                                      final imageBytes = state.fotoBytes;
                                      return InkResponse(
                                        onTap: () => ImageUploader.pickAndUpload(context),
                                        containedInkWell: true,
                                        customBorder: const CircleBorder(),
                                        radius: avatarRadius + 14,
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(avatarRingPadding),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryBlackColor,
                                                border: Border.all(color: sGrey, width: avatarBorderWidth),
                                              ),
                                              child: CircleAvatar(
                                                radius: avatarRadius,
                                                backgroundColor: secondaryBlackColor,
                                                backgroundImage: (imageBytes != null && imageBytes.isNotEmpty)
                                                    ? MemoryImage(imageBytes)
                                                    : null,
                                                child: (imageBytes == null || imageBytes.isEmpty)
                                                    ? const Icon(Icons.person, color: Colors.white, size: 48)
                                                    : null,
                                              ),
                                            ),
                                            const Positioned(
                                              bottom: 4,
                                              right: 4,
                                              child: IgnorePointer(
                                                ignoring: true,
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor: Colors.black87,
                                                  child: Icon(Icons.camera_alt, color: Color(0xffff6101), size: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ===== END CARD =====
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      mRekanPajakCrudBloc.add(
          MRekanPajakCrudLihatEvent(recordId: widget.recordId));
    }
  }

  Widget buildFieldMkotaId(){
    return buildFieldComboMKota(
      comboKey: comboMKotaKey,
      labelText: 'mkotaId',
      initItem: fieldComboMKota,
      propinsiId: "",
      onChangedCallback: (value) {
        if (value != null) {
          removeError(
              error: "Field ComboMKota tidak boleh kosong.");
          mRekanPajakCrudBloc.add(ComboMKotaChangedEvent(comboMKota: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMKota = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(
              error: "Field ComboMKota tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldMpropinsiId(){
    return buildFieldComboMPropinsi(
      comboKey: comboMPropinsiKey,
      labelText: 'mpropinsiId',
      initItem: fieldComboMPropinsi,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(
              error: "Field ComboMPropinsi tidak boleh kosong.");
          mRekanPajakCrudBloc.add(ComboMPropinsiChangedEvent(comboMPropinsi: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMPropinsi = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(
              error: "Field ComboMPropinsi tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldMrekan1Id(){
    return TextFormField(
    );
  }

  // Alamat
  Widget buildFieldAlamat1() {
    return appTextField(
      label: "Alamat",
      controller: fieldAlamat1Controller,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
    );
  }

// No NPWP
  Widget buildFieldNpwpNo() {
    return appTextField(
      label: "No NPWP",
      controller: fieldNpwpNoController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
    );
  }

  Widget buildFieldRkodeposId(){
    return buildFieldComboRKodepos(
      comboKey: comboRKodeposKey,
      labelText: 'rkodeposId',
      initItem: fieldComboRKodepos,
      kotaId: "",
      onChangedCallback: (value) {
        if (value != null) {
          removeError(
              error: "Field ComboRKodepos tidak boleh kosong.");
          mRekanPajakCrudBloc.add(ComboRKodeposChangedEvent(comboRKodepos: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRKodepos = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(
              error: "Field ComboRKodepos tidak boleh kosong.");
        }
      },
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MRekanPajakCrudModel record = MRekanPajakCrudModel(
        alamat1: fieldAlamat1Controller.text,
        mkotaId: fieldComboMKota?.mkotaId,
        mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
        mrekanpajakId: '',
        npwpNo: fieldNpwpNoController.text,
        rkodeposId: fieldComboRKodepos?.rkodeposId,
      );
      if (widget.viewMode == "tambah") {
        mRekanPajakCrudBloc.add(MRekanPajakCrudTambahEvent(record: record));
      } else if (widget.viewMode == "ubah") {
        record.mrekanpajakId = mRekanPajakCrudBloc.state.record!.mrekanpajakId;
        mRekanPajakCrudBloc.add(MRekanPajakCrudUbahEvent(record: record));
      }
      _dismissDialog();
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)){
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)){
      setState(() {
        errors.remove(error);
      });
    }
  }

}
