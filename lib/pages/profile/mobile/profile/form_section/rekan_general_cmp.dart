import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/blocs/gen_profile/mrekangeneralcmpcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralcmpcrud_model.dart';
import 'package:joss_app/models/combobox/combombentukcst_model.dart';
import 'package:joss_app/models/combobox/combombidang_model.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/profile/profile_download_foto_bloc.dart';
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
  bool _isFirstLoad = true;
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
            height: constraints.maxHeight,
            color: secondaryBlackColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: BlocConsumer<MRekanGeneralCmpCrudBloc, MRekanGeneralCmpCrudState>(
                    listener: (context, state) {
                      if (state.isLoaded && _isFirstLoad) {
                        final formName = (state.record?.rekanNama ?? '').trim();
                        final fallbackName =
                        (context.read<MRekan1CrudBloc>().state.record?.rekanNama ?? '').trim();

                        if (fieldRekanNamaController.text.trim().isEmpty) {
                          if (formName.isNotEmpty) {
                            fieldRekanNamaController.text = formName;
                          } else if (fallbackName.isNotEmpty) {
                            fieldRekanNamaController.text = fallbackName;
                          }
                        }

                        fieldComboMBentukCst = state.comboMBentukCst;
                        fieldComboMBidang = state.comboMBidang;

                        _isFirstLoad = false;
                      }

                      if (state.isSaved && !state.hasFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          successSnackBar("Data berhasil disimpan!"),
                        );

                        _isFirstLoad = true;
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // --- Avatar ---
                            BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
                              buildWhen: (prev, curr) {
                                if (prev is ProfileDownloadFotoLoaded &&
                                    curr is ProfileDownloadFotoLoaded) {
                                  return prev.imageBytes.lengthInBytes !=
                                      curr.imageBytes.lengthInBytes;
                                }
                                return prev.runtimeType != curr.runtimeType;
                              },
                              builder: (context, state) {
                                final Uint8List? imageBytes =
                                state is ProfileDownloadFotoLoaded ? state.imageBytes : null;
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

                            const SizedBox(height: vPadding),

                            // --- Heading ---
                            Text(
                              "Informasi Perusahaan",
                              style: headingStyle(context, fontSize: getResponsiveFont(context, 22))
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "Lengkapi identitas dasar Anda dengan benar.",
                              style: bodyTextStyle(context, fontSize: getResponsiveFont(context, 16))
                                  .copyWith(color: hintGrey),
                            ),
                            const SizedBox(height: vPadding),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: pGrey,
                                border: Border.all(color: sGrey),
                                borderRadius: BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  buildFieldJenisKlien(),
                                  const SizedBox(height: vPadding),
                                  buildFieldNamaPerusahaan(),
                                  const SizedBox(height: vPadding),
                                  buildFieldBentukPerusahaan(),
                                  const SizedBox(height: vPadding),
                                  buildFieldBidangUsaha(),
                                ],
                              ),
                            ),

                            const SizedBox(height: vPadding),
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

    // final name =
    //     context.read<MRekan1CrudBloc>().state.record?.rekanNama;
    //
    //
    // if (fieldRekanNamaController.text.isEmpty && (name?.isNotEmpty ?? false)) {
    //   fieldRekanNamaController.text = name!;
    // }

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
