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
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combombentukcst_repository.dart';
import '../../../../../repositories/combobox/combombidang_repository.dart';
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
  bool isSaving = false;

  ComboMBentukCstModel? fieldComboMBentukCst;
  final comboMBentukCstKey =
  GlobalKey<DropdownSearchState<ComboMBentukCstModel>>();

  ComboMBidangModel? fieldComboMBidang;
  final comboMBidangKey =
  GlobalKey<DropdownSearchState<ComboMBidangModel>>();

  final fieldRekanNamaController = TextEditingController();
  final fieldNamaBadanUsahaController = TextEditingController();
  final fieldIdKlienController = TextEditingController();

  bool _isFirstLoad = true;
  bool _isTapLocked = false;
  @override
  void initState() {
    super.initState();
    mRekanGeneralCmpCrudBloc = context.read<MRekanGeneralCmpCrudBloc>();

    // mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudResetStatusEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    fieldRekanNamaController.dispose();
    fieldNamaBadanUsahaController.dispose();
    fieldIdKlienController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: BlocConsumer<MRekanGeneralCmpCrudBloc,
                      MRekanGeneralCmpCrudState>(
                    listenWhen: (prev, curr) =>
                    prev.isLoaded != curr.isLoaded ||
                        prev.isSaved != curr.isSaved,
                    listener: (context, state) {
                      if (state.isLoaded && _isFirstLoad) {
                        final rec = state.record;

                        final formName = (rec?.rekanNama ?? '').trim();
                        final fallbackName = (context
                            .read<MRekan1CrudBloc>()
                            .state
                            .record
                            ?.rekanNama ??
                            '')
                            .trim();

                        final mjenisClient = context
                            .read<MRekan1CrudBloc>()
                            .state
                            .record
                            ?.mjnsclientId;

                        final idKlien = context
                            .read<MRekan1CrudBloc>()
                            .state
                            .record
                            ?.mrekan1Id;

                        if (fieldRekanNamaController.text.trim().isEmpty) {
                          if (formName.isNotEmpty) {
                            fieldRekanNamaController.text = formName;
                          }
                          // else if (fallbackName.isNotEmpty) {
                          //   fieldRekanNamaController.text = fallbackName;
                          // }
                        }

                        // if (fieldNamaBadanUsahaController.text.trim().isEmpty) {
                        //   if (mjenisClient == '10') {
                        //     fieldNamaBadanUsahaController.text = "Individu";
                        //   } else if (mjenisClient == '20') {
                        //     fieldNamaBadanUsahaController.text = "Perusahaan";
                        //   }
                        // }
                        fieldNamaBadanUsahaController.text = "Perusahaan";

                        if (fieldIdKlienController.text.trim().isEmpty) {
                          fieldIdKlienController.text = idKlien ?? "";
                        }

                        fieldComboMBentukCst ??= rec?.comboMBentukCst ?? state.comboMBentukCst;
                        fieldComboMBidang ??= rec?.comboMBidang ?? state.comboMBidang;

                        setState(() {});
                        _isFirstLoad = false;
                      }

                      if (state.isSaved) {
                        if (mounted) {
                          setState(() {
                            isSaving = false;
                          });
                        }

                        if (!state.hasFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            successSnackBar("Data berhasil disimpan!"),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar("Data gagal disimpan!"),
                          );
                        }

                        context
                            .read<MRekanGeneralCmpCrudBloc>()
                            .add(MRekanGeneralCmpCrudResetStatusEvent());
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            BlocBuilder<ProfileDownloadFotoBloc,
                                ProfileDownloadFotoState>(
                              buildWhen: (prev, curr) =>
                              prev.runtimeType != curr.runtimeType ||
                                  curr is ProfileDownloadFotoLoaded,
                              builder: (context, state) {
                                final Uint8List? imageBytes =
                                state is ProfileDownloadFotoLoaded
                                    ? state.imageBytes
                                    : null;
                                return Center(
                                  child: InkResponse(
                                    onTap: _isTapLocked
                                        ? null
                                        : () async {
                                      setState(() => _isTapLocked = true);

                                      try {
                                        await ImageUploader.pickAndUpload(context);
                                      } finally {
                                        await Future.delayed(const Duration(seconds: 2));
                                        if (mounted) {
                                          setState(() => _isTapLocked = false);
                                        }
                                      }
                                    },
                                    containedInkWell: true,
                                    customBorder: const CircleBorder(),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: secondaryBlackColor,
                                          backgroundImage:
                                          (imageBytes != null && imageBytes.isNotEmpty)
                                              ? MemoryImage(imageBytes)
                                              : null,
                                          child: (imageBytes == null || imageBytes.isEmpty)
                                              ? _avatarFallback()
                                              : null,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: sGrey, width: 1),
                                              color: pGrey,
                                            ),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.transparent,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child: ShaderMask(
                                                    shaderCallback: (Rect bounds) {
                                                      return const LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [
                                                          Color(0xFFFCCF6F),
                                                          Color(0xFFEF7A28),
                                                        ],
                                                      ).createShader(bounds);
                                                    },
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
                            Text(
                              "Informasi Perusahaan",
                              style: headingStyle(
                                context,
                                fontSize: getResponsiveFont(context, 22),
                              ).copyWith(color: Colors.white),
                            ),
                            Text(
                              "Lengkapi identitas dasar Anda dengan benar.",
                              style: bodyTextStyle(
                                context,
                                fontSize: getResponsiveFont(context, 16),
                              ).copyWith(color: hintGrey),
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
                                borderRadius:
                                BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  buildFieldIdKlien(),
                                  const SizedBox(height: vPadding),
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
                            AppButton.primary(
                              text: "Simpan Perubahan",
                              isLoading: isSaving,
                              backgroundColor: isSaving ? secondaryBlackColor : primaryColor,
                              onPressed: isSaving
                                  ? null
                                  : () async {
                                await onSaveForm();
                              },
                            )
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

  Widget _avatarFallback() => SvgPicture.asset(
    'assets/icons/place_holder_2.svg',
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  );

  void loadData() {
    mRekanGeneralCmpCrudBloc.add(MRekanGeneralCmpCrudLihatEvent());

    // context.read<ProfileDownloadFotoBloc>()
    //     .add(LoadSecureImage());
  }

  Widget buildFieldBentukPerusahaan() {
    final mjenisClient = context
        .read<MRekan1CrudBloc>()
        .state
        .record
        ?.mjnsclientId;

    String hint = "Bentuk";

    if (mjenisClient == '10') {
      hint = "Bentuk Badan Individu";
    } else if (mjenisClient == '20') {
      hint = "Bentuk Badan Perusahaan";
    }

    return ReusableComboBox<ComboMBentukCstModel>(
      hintText: "Bentuk Badan",
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
          fieldComboMBentukCst = value;
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
      hintText: "Bisnis Utama",
      comboKey: comboMBidangKey,
      initItem: fieldComboMBidang,
      dataLoader: () => ComboMBidangRepository().getComboMBidang(),
      displayText: (item) => item.bidangNama,
      compareItems: (a, b) => a.mbidangId == b.mbidangId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
          fieldComboMBidang = value;
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
      label: "Tipe",
      controller: fieldNamaBadanUsahaController,
      enabled: false,
    );
  }

  Widget buildFieldIdKlien() {
    return appTextField(
      label: "ID KLIEN",
      controller: fieldIdKlienController,
      enabled: false,
    );
  }

  Future<void> onSaveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }

    final record = MRekanGeneralCmpCrudModel(
      mbentukcstId: fieldComboMBentukCst?.mbentukcstId,
      mbidangId: fieldComboMBidang?.mbidangId,
      rekanNama: fieldRekanNamaController.text.trim(),
      comboMBentukCst: fieldComboMBentukCst,
      comboMBidang: fieldComboMBidang,
    );

    mRekanGeneralCmpCrudBloc.add(
      MRekanGeneralCmpCrudUbahEvent(record: record),
    );
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}