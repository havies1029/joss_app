import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmpcrud_model.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';

import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combombentukcst_repository.dart';
import '../../../../../repositories/combobox/combombidang_repository.dart';
import '../../../../../widgets/form_error.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanGeneralCmpCrudFormPage extends StatefulWidget {
  const MRekanGeneralCmpCrudFormPage({super.key});

  @override
  MRekanGeneralCmpCrudFormPageFormState createState() =>
      MRekanGeneralCmpCrudFormPageFormState();
}

class MRekanGeneralCmpCrudFormPageFormState
    extends State<MRekanGeneralCmpCrudFormPage> {
  late MRekanGeneralCmpCrudBloc mRekanGeneralCmpCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  ComboMBentukCstModel? fieldComboMBentukCst;
  final comboMBentukCstKey =
      GlobalKey<DropdownSearchState<ComboMBentukCstModel>>();
  ComboMBidangModel? fieldComboMBidang;
  final comboMBidangKey = GlobalKey<DropdownSearchState<ComboMBidangModel>>();
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
    mRekanGeneralCmpCrudBloc = BlocProvider.of<MRekanGeneralCmpCrudBloc>(
      context,
    );

    SizeConfig().init(context);

    return BaseBackgroundSidePage(
      title: 'Informasi Klien',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight, // ✅ full tinggi layar
            color: secondaryBlackColor, // ✅ background utama hitam elegan
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // ✅ tetap isi penuh walau konten sedikit
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: BlocConsumer<MRekanGeneralCmpCrudBloc, MRekanGeneralCmpCrudState>(
                    listener: (context, state) {
                      if (state.isLoaded) {
                        if (state.record != null) {
                          fieldRekanNamaController.text = state.record?.rekanNama ?? "";

                          if (state.record!.rekanNama!.isNotEmpty) {
                            fieldRekanNamaController.text = state.record!.rekanNama!;
                          } else {
                            final profile = context.read<UserProfileCubit>().state;
                            if (fieldRekanNamaController.text.isEmpty &&
                                (profile.nama?.isNotEmpty ?? false)) {
                              fieldRekanNamaController.text = profile.nama!;
                            }
                          }
                        }
                        fieldComboMBentukCst = state.comboMBentukCst;
                        fieldComboMBidang = state.comboMBidang;
                      }

                      if (state.isSaved && !state.hasFailure) {
                        context.read<MRekanGeneralCmpCrudBloc>().add(
                          MRekanGeneralCmpCrudLihatEvent(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          successSnackBar("Data berhasil disimpan."),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // --- Avatar ---
                            BlocBuilder<UserProfileCubit, UserProfileState>(
                              buildWhen: (prev, curr) =>
                              (prev.fotoBytes?.lengthInBytes ?? -1) !=
                                  (curr.fotoBytes?.lengthInBytes ?? -1),
                              builder: (context, state) {
                                final imageBytes = state.fotoBytes;
                                return Center(
                                  child: InkResponse(
                                    onTap: () => ImageUploader.pickAndUpload(context),
                                    containedInkWell: true,
                                    customBorder: const CircleBorder(),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: secondaryBlackColor,
                                          backgroundImage: (imageBytes != null &&
                                              imageBytes.isNotEmpty)
                                              ? MemoryImage(imageBytes)
                                              : null,
                                          child: (imageBytes == null ||
                                              imageBytes.isEmpty)
                                              ? const Icon(
                                            Icons.business,
                                            color: Colors.white,
                                            size: 48,
                                          )
                                              : null,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: sGrey),
                                              color: secondaryBlackColor,
                                            ),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: secondaryBlackColor,
                                              child: SvgPicture.asset(
                                                "assets/icons/camera.svg",
                                                width: 22,
                                                colorFilter: const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
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

                            const SizedBox(height: 24),

                            // --- Heading ---
                            Text(
                              "Informasi Perusahaan",
                              style: headingStyle(context, fontSize: 22)
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "Lengkapi identitas dasar Anda dengan benar.",
                              style: bodyTextStyle(context, fontSize: 16)
                                  .copyWith(color: hintGrey),
                            ),
                            const SizedBox(height: 20),

                            // --- Form Section ---
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: secondaryBlackColor.withOpacity(0.25), // ✅ layer lembut
                                border: Border.all(color: sGrey.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  buildFieldJenisKlien(),
                                  const SizedBox(height: 16),
                                  buildFieldNamaPerusahaan(),
                                  const SizedBox(height: 16),
                                  buildFieldBentukPerusahaan(),
                                  const SizedBox(height: 16),
                                  buildFieldBidangUsaha(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),
                            AppButton.primary(text: "Submit", onPressed: onSaveForm),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void loadData() {
    mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());

    final profile = context.read<UserProfileCubit>().state;

    if (fieldRekanNamaController.text.isEmpty && (profile.nama?.isNotEmpty ?? false)) {
      fieldRekanNamaController.text = profile.nama!;
    }

  }

  Widget buildFieldBentukPerusahaan() {
    return ReusableComboBox<ComboMBentukCstModel>(
      hintText: "Bentuk Badan Usaha",
      enableSearch: false,
      comboKey: comboMBentukCstKey,
      initItem: fieldComboMBentukCst,
      maxHeight: 150,
      dataLoader: () => ComboMBentukCstRepository().getComboMBentukCst(),
      displayText: (item) => item.bentukNama,
      compareItems: (a, b) => a.mbentukcstId == b.mbentukcstId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          mRekanGeneralCmpCrudBloc.add(
            ComboMBentukCstChangedEvent(comboMBentukCst: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMBentukCst = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldBidangUsaha() {
    return ReusableComboBox<ComboMBidangModel>(
      hintText: "Pilih Bidang Usaha",
      comboKey: comboMBidangKey,
      initItem: fieldComboMBidang,
      dataLoader: () => ComboMBidangRepository().getComboMBidang(),
      displayText: (item) => item.bidangNama,
      compareItems: (a, b) => a.mbidangId == b.mbidangId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          mRekanGeneralCmpCrudBloc.add(
            ComboMBidangChangedEvent(comboMBidang: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMBidang = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldNamaPerusahaan() {
    return appTextField(
      label: "Nama Perusahaan",
      controller: fieldRekanNamaController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return kStringNullError;
        } else if (value.trim().length < 3) {
          return "Nama Perusahaan terlalu pendek, Minimal 3 karakter";
        }
        return null;
      },
    );
  }

  Widget buildFieldJenisKlien() {
    return appTextField(
      label: "Badan Usaha",
      controller: TextEditingController(),
      enabled: false,
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MRekanGeneralCmpCrudModel record = MRekanGeneralCmpCrudModel(
        mbentukcstId: fieldComboMBentukCst?.mbentukcstId,
        mbidangId: fieldComboMBidang?.mbidangId,
        rekanNama: fieldRekanNamaController.text,
      );

      mRekanGeneralCmpCrudBloc.add(
        MRekanGeneralCmpCrudUbahEvent(record: record),
      );
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
