import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekancontactcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekancontactcrud_model.dart';
import 'package:joss_app/models/combobox/combomkota_model.dart';
import 'package:joss_app/models/combobox/combompropinsi_model.dart';
import 'package:joss_app/models/combobox/comborkodepos_model.dart';

import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combomkota_repository.dart';
import '../../../../../repositories/combobox/combompropinsi_repository.dart';
import '../../../../../repositories/combobox/comborkodepos_repository.dart';
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

    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: "Kontak & Alamat",
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(100)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: secondaryBlackColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border(top: BorderSide(color: primaryColor)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: BlocConsumer<
                        MRekanContactCrudBloc,
                        MRekanContactCrudState
                      >(
                        listener: (context, state) {
                          if (state.isLoaded) {
                            if (state.record != null) {
                              fieldAlamat1Controller.text =
                                  state.record!.alamat1;
                              fieldEmailController.text = state.record!.email;
                              fieldTelpController.text = state.record!.telp;
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
                                BlocBuilder<UserProfileCubit, UserProfileState>(
                                  buildWhen:
                                      (prev, curr) =>
                                          (prev.fotoBytes?.lengthInBytes ??
                                              -1) !=
                                          (curr.fotoBytes?.lengthInBytes ?? -1),
                                  builder: (context, state) {
                                    final imageBytes = state.fotoBytes;
                                    return Center(
                                      child: InkResponse(
                                        onTap:
                                            () => ImageUploader.pickAndUpload(
                                              context,
                                            ),
                                        containedInkWell: true,
                                        customBorder: const CircleBorder(),
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundColor:
                                                  secondaryBlackColor,
                                              backgroundImage:
                                                  (imageBytes != null &&
                                                          imageBytes.isNotEmpty)
                                                      ? MemoryImage(imageBytes)
                                                      : null,
                                              child:
                                                  (imageBytes == null ||
                                                          imageBytes.isEmpty)
                                                      ? const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 48,
                                                      )
                                                      : null,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: sGrey,
                                                  ),
                                                  color: pGrey,
                                                ),
                                                child: CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: pGrey,
                                                  child: SvgPicture.asset(
                                                    "assets/icons/camera.svg",
                                                    width: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  "Kontak & Alamat",
                                  textAlign: TextAlign.start,
                                  style: headingStyle(context, fontSize: 22),
                                ),
                                Text(
                                  "Gunakan email yang aktif dan alamat yang jelas.",
                                  style: bodyTextStyle(
                                    context,
                                    fontSize: 16,
                                  ).copyWith(color: hintGrey),
                                ),
                                const SizedBox(height: 10),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pGrey,
                                    border: Border.all(color: sGrey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(cardBorderRadius),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      buildFieldEmail(),
                                      const SizedBox(height: 16),
                                      buildFieldTelp(),
                                      const SizedBox(height: 16),
                                      buildFieldAlamat1(),
                                      const SizedBox(height: 16),
                                      buildFieldMpropinsiId(),
                                      const SizedBox(height: 16),
                                      buildFieldMkotaId(),
                                      const SizedBox(height: 16),
                                      buildFieldRkodeposId(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                AppButton.primary(
                                  text: "Submit",
                                  onPressed: onSaveForm,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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

  Widget buildFieldEmail() {
    return appTextField(
      label: "Email",
      controller: fieldEmailController,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
    );
  }

  Widget buildFieldTelp() {
    return appTextField(
      label: "No. Telp Perusahaan",
      controller: fieldTelpController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kPhoneNumberNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldAlamat1() {
    return appTextField(
      label: "Alamat",
      controller: fieldAlamat1Controller,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldMpropinsiId() {
    return ReusableComboBox<ComboMPropinsiModel>(
      hintText: "Provinsi",
      searchHintText: "Cari provinsi...",
      comboKey: comboMPropinsiKey,
      initItem: fieldComboMPropinsi,
      dataLoader: () => ComboMPropinsiRepository().getComboMPropinsi(""),
      displayText: (item) => item.propinsiNama,
      compareItems: (a, b) => a.mpropinsiId == b.mpropinsiId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringProvinsiError);
          mRekanContactCrudBloc.add(
            ComboMPropinsiChangedEvent(comboMPropinsi: value),
          );
          // Clear dependent dropdowns
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
          return kStringProvinsiError;
        }
        return null;
      },
    );
  }

  Widget buildFieldMkotaId() {
    return ReusableComboBox<ComboMKotaModel>(
      hintText: "Kota",
      searchHintText: "Cari Kota...",
      comboKey: comboMKotaKey,
      initItem: fieldComboMKota,
      dataLoader:
          () => ComboMKotaRepository().getComboMKota(
            fieldComboMPropinsi?.mpropinsiId ?? "",
          ),
      displayText: (item) => item.kotaDesc,
      compareItems: (a, b) => a.mkotaId == b.mkotaId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringKotaError);
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
          return kStringKotaError;
        }
        return null;
      },
    );
  }

  Widget buildFieldRkodeposId() {
    return ReusableComboBox<ComboRKodeposModel>(
      hintText: "Kodepos",
      searchHintText: "Cari kodepos...",
      comboKey: comboRKodeposKey,
      initItem: fieldComboRKodepos,
      dataLoader:
          () => ComboRKodeposRepository().getComboRKodepos(
            fieldComboMKota?.mkotaId ?? "",
            "",
          ),
      displayText: (item) => item.kodeposNo,
      compareItems: (a, b) => a.rkodeposId == b.rkodeposId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringKodeposError);
          mRekanContactCrudBloc.add(
            ComboRKodeposChangedEvent(comboRKodepos: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboRKodepos = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          return kStringKodeposError;
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

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
