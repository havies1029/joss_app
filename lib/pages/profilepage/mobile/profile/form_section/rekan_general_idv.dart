import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/combobox/combompekerjaan_widget.dart';
import 'package:joss_app/widgets/combobox/combomjnskel_widget.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../widgets/form_error.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanGeneralIdvCrudFormPage extends StatefulWidget {
  const MRekanGeneralIdvCrudFormPage({super.key});

  @override
  MRekanGeneralIdvCrudFormPageFormState createState() =>
      MRekanGeneralIdvCrudFormPageFormState();
}

class MRekanGeneralIdvCrudFormPageFormState
    extends State<MRekanGeneralIdvCrudFormPage> {
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  ComboMPekerjaanModel? fieldComboMPekerjaan;
  ComboMJnskelModel? fieldComboMJnskel;
  final comboMPekerjaanKey =
  GlobalKey<DropdownSearchState<ComboMPekerjaanModel>>();
  var fieldRekanNamaController = TextEditingController();

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
    mRekanGeneralIdvCrudBloc = BlocProvider.of<MRekanGeneralIdvCrudBloc>(context);

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
                                        child: BlocConsumer<MRekanGeneralIdvCrudBloc, MRekanGeneralIdvCrudState>(
                                          listener: (context, state) {
                                            if (state.isLoaded) {
                                              if (state.record != null) {
                                                fieldRekanNamaController.text = state.record!.rekanNama;
                                              }
                                              fieldComboMPekerjaan = state.comboMPekerjaan;
                                              fieldComboMJnskel = state.comboMJnskel;
                                            }
                                            if (state.isSaved && !state.hasFailure){
                                              context.read<MRekan1CrudBloc>().add(
                                                MRekan1CrudLihatEvent(),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Data berhasil disimpan."),
                                                ),
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            return Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  // Heading + subheading
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: fieldSpacing), // 20.0 dari constants
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
                                                  buildFieldRekanNama(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldMJnsKel(),
                                                  const SizedBox(height: vPadding),
                                                  buildFieldMpekerjaanId(),
                                                  const SizedBox(height: vPadding),

                                                  const SizedBox(height: 25),
                                                  FormError(errors: errors, key: null),

                                                  const SizedBox(height: 16),
                                                  appButton(
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
    mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
  }

  Widget buildFieldMpekerjaanId() {
    return buildFieldComboMPekerjaan(
      comboKey: comboMPekerjaanKey,
      labelText: 'mpekerjaanId',
      initItem: fieldComboMPekerjaan,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMPekerjaan tidak boleh kosong.");
          mRekanGeneralIdvCrudBloc
              .add(ComboMPekerjaanChangedEvent(comboMPekerjaan: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMPekerjaan = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field ComboMPekerjaan tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldMJnsKel() {
    return buildFieldComboMJnskel(
      labelText: 'Jenis Kelamin',
      initItem: fieldComboMJnskel,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field fieldComboMJnskel tidak boleh kosong.");
          mRekanGeneralIdvCrudBloc
              .add(ComboMJnskelChangedEvent(comboMJnskel: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMJnskel = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field fieldComboMJnskel tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldRekanNama() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: fieldRekanNamaController,
      style: const TextStyle(color: primaryLightColor), // isi teks putih
      decoration: customInputDecoration("rekanNama"),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kStringNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MRekanGeneralIdvCrudModel record = MRekanGeneralIdvCrudModel(
        mjnskelId: fieldComboMJnskel?.mjnskelId,
        mpekerjaanId: fieldComboMPekerjaan?.mpekerjaanId,
        mrekan1Id: '',
        rekanNama: fieldRekanNamaController.text,
      );
      record.mrekan1Id = mRekanGeneralIdvCrudBloc.state.record!.mrekan1Id;
      mRekanGeneralIdvCrudBloc
          .add(MRekanGeneralIdvCrudUbahEvent(record: record));
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
