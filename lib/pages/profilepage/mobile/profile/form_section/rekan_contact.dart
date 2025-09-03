import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';
import 'package:joss_app/widgets/combobox/combomkota_widget.dart';
import 'package:joss_app/widgets/combobox/combompropinsi_widget.dart';
import 'package:joss_app/widgets/combobox/comborkodepos_widget.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../widgets/form_error.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanContactCrudFormPage extends StatefulWidget {
  const MRekanContactCrudFormPage({super.key});

  @override
  MRekanContactCrudFormPageFormState createState() =>
      MRekanContactCrudFormPageFormState();
}

class MRekanContactCrudFormPageFormState
    extends State<MRekanContactCrudFormPage> {
  late MRekanContactCrudBloc mRekanContactCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var fieldAlamat1Controller = TextEditingController();
  var fieldEmailController = TextEditingController();
  ComboMKotaModel? fieldComboMKota;
  final comboMKotaKey = GlobalKey<DropdownSearchState<ComboMKotaModel>>();
  ComboMPropinsiModel? fieldComboMPropinsi;
  final comboMPropinsiKey =
  GlobalKey<DropdownSearchState<ComboMPropinsiModel>>();
  ComboRKodeposModel? fieldComboRKodepos;
  final comboRKodeposKey = GlobalKey<DropdownSearchState<ComboRKodeposModel>>();
  var fieldTelpController = TextEditingController();

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
    mRekanContactCrudBloc = BlocProvider.of<MRekanContactCrudBloc>(context);

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
          title: 'Kontak & Alamat',
          child: Column(
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
                                child: BlocConsumer<MRekanContactCrudBloc, MRekanContactCrudState>(
                                  listener: (context, state) {
                                    if (state.isLoaded) {
                                      if (state.record != null) {
                                        fieldAlamat1Controller.text = state.record!.alamat1;
                                        fieldEmailController.text  = state.record!.email;
                                        fieldTelpController.text   = state.record!.telp;
                                      }
                                      fieldComboMKota     = state.comboMKota;
                                      fieldComboMPropinsi = state.comboMPropinsi;
                                      fieldComboRKodepos  = state.comboRKodepos;
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
                                                  "Kontak & Alamat",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: getResponsiveFont(context, 22),
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryLightColor,     // warna brand dari constants
                                                  ),
                                                ),
                                                Text(
                                                  "Gunakan email yang aktif dan alamat yang jelas.",
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

                                          // Fields
                                          buildFieldEmail(),
                                          const SizedBox(height: vPadding),
                                          buildFieldTelp(),
                                          const SizedBox(height: vPadding),
                                          buildFieldAlamat1(),
                                          const SizedBox(height: vPadding),
                                          buildFieldMpropinsiId(),
                                          const SizedBox(height: vPadding),
                                          buildFieldMkotaId(),
                                          const SizedBox(height: vPadding),
                                          buildFieldRkodeposId(),

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
            ],
          ),
        ),
      ),
    );
  }

  void loadData() {
    mRekanContactCrudBloc.add(MRekanContactCrudLihatEvent());
  }

  Widget buildFieldAlamat1() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: fieldAlamat1Controller,
      style: const TextStyle(color: primaryLightColor), // isi teks putih
      decoration: customInputDecoration("Alamat"), // 👈 pakai helper
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

  Widget buildFieldEmail() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: fieldEmailController,
      style: const TextStyle(color: primaryLightColor),
      decoration: customInputDecoration("Email"), // 👈 pakai helper
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

  Widget buildFieldMkotaId() {
    return buildFieldComboMKota(
      comboKey: comboMKotaKey,
      labelText: 'Kota',
      initItem: fieldComboMKota,
      propinsiId: fieldComboMPropinsi?.mpropinsiId ?? "",
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMKota tidak boleh kosong.");
          mRekanContactCrudBloc.add(ComboMKotaChangedEvent(comboMKota: value));
          comboRKodeposKey.currentState?.clear();
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMKota = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field ComboMKota tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldMpropinsiId() {
    return buildFieldComboMPropinsi(
      comboKey: comboMPropinsiKey,
      labelText: 'Propinsi',
      initItem: fieldComboMPropinsi,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMPropinsi tidak boleh kosong.");
          mRekanContactCrudBloc
              .add(ComboMPropinsiChangedEvent(comboMPropinsi: value));
          comboMKotaKey.currentState?.clear();
          comboRKodeposKey.currentState?.clear();
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMPropinsi = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field ComboMPropinsi tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldRkodeposId() {
    return buildFieldComboRKodepos(
      comboKey: comboRKodeposKey,
      labelText: 'Kodepos',
      initItem: fieldComboRKodepos,
      kotaId: fieldComboMKota?.mkotaId ?? "",
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboRKodepos tidak boleh kosong.");
          mRekanContactCrudBloc
              .add(ComboRKodeposChangedEvent(comboRKodepos: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRKodepos = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field ComboRKodepos tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldTelp() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: fieldTelpController,
      style: const TextStyle(color: primaryLightColor),
      decoration: customInputDecoration("No. Telp Perusahaan"),
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
      MRekanContactCrudModel record = MRekanContactCrudModel(
        alamat1: fieldAlamat1Controller.text,
        email: fieldEmailController.text,
        mkotaId: fieldComboMKota?.mkotaId,
        mpropinsiId: fieldComboMPropinsi?.mpropinsiId,
        mrekancontact1Id: '',
        rkodeposId: fieldComboRKodepos?.rkodeposId,
        telp: fieldTelpController.text,
      );

      record.mrekancontact1Id =
          mRekanContactCrudBloc.state.record!.mrekancontact1Id;
      mRekanContactCrudBloc.add(MRekanContactCrudUbahEvent(record: record));

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
