import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../../../common/app_data.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combomjnskel_repository.dart';
import '../../../../../repositories/combobox/combompekerjaan_repository.dart';
import '../../../../../widgets/apptheme/dropdown2.dart';
import '../../../../base/base_background_sidepage.dart';

final List<TextInputFormatter> _xenditDisplayNameInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 .,']")),
  TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.startsWith(' ')) return oldValue;
    return newValue;
  }),
];

class MRekanGeneralIdvCrudFormPage extends StatefulWidget {
  const MRekanGeneralIdvCrudFormPage({super.key});

  @override
  MRekanGeneralIdvCrudFormPageFormState createState() =>
      MRekanGeneralIdvCrudFormPageFormState();
}

class MRekanGeneralIdvCrudFormPageFormState
    extends State<MRekanGeneralIdvCrudFormPage> {
  late final MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;
  final Map<String, String?> fieldErrors = {};

  late Future<List<ComboMJnskelModel>> _futureJenisKelamin =
      ComboMJnskelRepository().getComboMJnskel();

  final fieldRekanNamaController = TextEditingController();
  final fieldNamaBadanUsahaController = TextEditingController();

  final List<String> errors = [];

  ComboMPekerjaanModel? fieldComboMPekerjaan;
  final comboMPekerjaanKey =
      GlobalKey<DropdownSearchState<ComboMPekerjaanModel>>();

  ComboMJnskelModel? fieldComboMJnskel;
  final comboMJnsKelKey = GlobalKey<DropdownSearchState<ComboMJnskelModel>>();

  bool _isFirstLoad = true;
  bool _isLoadingInitialData = true;
  bool _isTapLocked = false;
  @override
  void initState() {
    super.initState();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();

    mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudResetStatusEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      loadData();
    });
  }

  @override
  void dispose() {
    fieldRekanNamaController.dispose();
    fieldNamaBadanUsahaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Informasi Klien',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight,
            color: secondaryBlackColor,
            child: BlocConsumer<MRekanGeneralIdvCrudBloc,
                MRekanGeneralIdvCrudState>(
              listenWhen: (prev, curr) =>
                  prev.isLoaded != curr.isLoaded ||
                  prev.isSaved != curr.isSaved,
              listener: (context, state) {
                if (state.isLoaded && _isFirstLoad) {
                  if (state.record != null) {
                    final rec = state.record!;

                    if (fieldRekanNamaController.text.trim().isEmpty) {
                      final formName = rec.rekanNama.trim();
                      final fallbackName = (context
                                  .read<MRekan1CrudBloc>()
                                  .state
                                  .record
                                  ?.rekanNama ??
                              '')
                          .trim();
                      final userName = (AppData.user.nama ?? '').trim();

                      if (formName.isNotEmpty) {
                        fieldRekanNamaController.text = formName;
                      } else if (fallbackName.isNotEmpty) {
                        fieldRekanNamaController.text = fallbackName;
                      } else if (userName.isNotEmpty) {
                        fieldRekanNamaController.text = userName;
                      }
                    }

                    final mjenisClient = context
                        .read<MRekan1CrudBloc>()
                        .state
                        .record
                        ?.mjnsclientId;

                    // if (fieldNamaBadanUsahaController.text.trim().isEmpty) {
                    //   if (mjenisClient == '10') {
                    //     fieldNamaBadanUsahaController.text = "Individu";
                    //   } else if (mjenisClient == '20') {
                    //     fieldNamaBadanUsahaController.text = "Perusahaan";
                    //   }
                    // }

                    fieldNamaBadanUsahaController.text = "Individu";

                    fieldComboMPekerjaan ??= rec.comboMPekerjaan;
                    fieldComboMJnskel ??= rec.comboMJnskel;
                  }

                  if (mounted) {
                    setState(() {
                      _isFirstLoad = false;
                      _isLoadingInitialData = false;
                    });
                  }
                }

                if (state.isSaved) {
                  if (mounted) {
                    setState(() {
                      isSaving = false;
                    });
                  }

                  if (!state.hasFailure) {
                    context
                        .read<MRekan1CrudBloc>()
                        .add(MRekan1CrudReloadEvent());

                    ScaffoldMessenger.of(context).showSnackBar(
                      successSnackBar(
                        "Informasi klien berhasil disimpan!",
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar("Data gagal disimpan!"),
                    );
                  }

                  context
                      .read<MRekanGeneralIdvCrudBloc>()
                      .add(MRekanGeneralIdvCrudResetStatusEvent());
                }
              },
              builder: (context, state) {
                if (_isLoadingInitialData) {
                  return const LoadingIndicator();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Form(
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
                                              await ImageUploader.pickAndUpload(
                                                  context);
                                            } finally {
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              if (mounted) {
                                                setState(
                                                    () => _isTapLocked = false);
                                              }
                                            }
                                          },
                                    containedInkWell: true,
                                    customBorder: const CircleBorder(),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Opacity(
                                          opacity: _isTapLocked
                                              ? 0.6
                                              : 1.0, // optional UX feedback
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                secondaryBlackColor,
                                            backgroundImage:
                                                (imageBytes != null &&
                                                        imageBytes.isNotEmpty)
                                                    ? MemoryImage(imageBytes)
                                                    : null,
                                            child: (imageBytes == null ||
                                                    imageBytes.isEmpty)
                                                ? _avatarFallback()
                                                : null,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: sGrey, width: 1),
                                              color: pGrey,
                                            ),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child: ShaderMask(
                                                    shaderCallback:
                                                        (Rect bounds) {
                                                      return const LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          Color(0xFFFCCF6F),
                                                          Color(0xFFEF7A28),
                                                        ],
                                                      ).createShader(bounds);
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/icons/camera.svg",
                                                      width: 22,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
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
                            const SizedBox(height: 20),
                            Text(
                              "Informasi Klien",
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
                                  buildFieldRekanNama(),
                                  const SizedBox(height: vPadding),
                                  buildFieldJenisKlien(),
                                  const SizedBox(height: vPadding),
                                  buildFieldPekerjaan(),
                                  const SizedBox(height: vPadding),
                                  buildFieldJenisKelamin(),
                                ],
                              ),
                            ),
                            const SizedBox(height: vPadding),
                            AppButton.primary(
                              text: "Simpan Perubahan",
                              isLoading: isSaving,
                              backgroundColor:
                                  isSaving ? secondaryBlackColor : primaryColor,
                              onPressed: isSaving
                                  ? null
                                  : () async {
                                      await onSaveForm();
                                    },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
    if (mounted) {
      setState(() {
        _isLoadingInitialData = true;
      });
    }

    mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
    _futureJenisKelamin = ComboMJnskelRepository().getComboMJnskel();

    // context.read<ProfileDownloadFotoBloc>()
    //     .add(LoadSecureImage());
  }

  Widget buildFieldPekerjaan() {
    return ReusableComboBoxV2<ComboMPekerjaanModel>(
      hintText: "Pekerjaan",
      comboKey: comboMPekerjaanKey,
      initItem: fieldComboMPekerjaan,
      loader: (q) => ComboMPekerjaanRepository().getComboMPekerjaan(),
      clientSideSearch: true,
      displayText: (item) => item.kerjaNama,
      compareItems: (a, b) => a.mpekerjaanId == b.mpekerjaanId,
      errorText: err('pekerjaan'),
      onChangedCallback: (value) {
        if (value != null) {
          setState(() {
            removeError(error: "Field ComboMPekerjaan tidak boleh kosong.");
            fieldComboMPekerjaan = value;
          });
          clearErr('pekerjaan');
          mRekanGeneralIdvCrudBloc.add(
            ComboMPekerjaanChangedEvent(comboMPekerjaan: value),
          );
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMPekerjaan = value;
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

  Widget buildFieldJenisKelamin() {
    return FutureBuilder<List<ComboMJnskelModel>>(
      future: _futureJenisKelamin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final jenisKelaminList = snapshot.data ?? [];

        if (jenisKelaminList.isEmpty) {
          return const Text('Tidak ada data jenis kelamin');
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kelamin',
                style: bodyTextStyle(context, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children: jenisKelaminList.map((item) {
                  final isSelected =
                      fieldComboMJnskel?.mjnskelId == item.mjnskelId;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          fieldComboMJnskel = item;
                        });
                        clearErr('jenisKelamin');

                        mRekanGeneralIdvCrudBloc.add(
                          ComboMJnskelChangedEvent(comboMJnskel: item),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? primaryColor : hintGrey,
                                width: 1,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.jenisDesc,
                            style: isSelected
                                ? inputTextStyle(context)
                                : bodyTextStyle(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              FormField<ComboMJnskelModel>(
                validator: (_) => err('jenisKelamin'),
                builder: (state) {
                  final errorText = err('jenisKelamin');
                  if (errorText == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorText,
                      style: TextStyle(color: pRed, fontSize: 12),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFieldRekanNama() {
    return appTextField(
      label: "Nama",
      controller: fieldRekanNamaController,
      keyboardType: TextInputType.text,
      inputFormatters: _xenditDisplayNameInputFormatters,
      errorText: err('nama'),
      validator: (_) => err('nama'),
      onChanged: (value) {
        if (value.trim().isNotEmpty) clearErr('nama');
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

  Future<void> onSaveForm() async {
    if (!validateGeneralIdvForm()) return;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (mounted) {
      setState(() {
        isSaving = true;
      });
    }

    final currentRecord = mRekanGeneralIdvCrudBloc.state.record;

    final record = MRekanGeneralIdvCrudModel(
      mjnskelId: fieldComboMJnskel?.mjnskelId,
      mpekerjaanId: fieldComboMPekerjaan?.mpekerjaanId,
      mrekan1Id: currentRecord?.mrekan1Id ?? '',
      rekanNama: fieldRekanNamaController.text.trim(),
      comboMPekerjaan: fieldComboMPekerjaan,
      comboMJnskel: fieldComboMJnskel,
    );

    mRekanGeneralIdvCrudBloc.add(
      MRekanGeneralIdvCrudUbahEvent(record: record),
    );
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  bool validateGeneralIdvForm() {
    clearErrs();

    bool ok = true;

    if (fieldComboMPekerjaan == null) {
      setErr('pekerjaan', kStringNullError);
      ok = false;
    }

    if (fieldComboMJnskel == null) {
      setErr('jenisKelamin', kStringNullError);
      ok = false;
    }

    if (fieldRekanNamaController.text.trim().isEmpty) {
      setErr('nama', kStringNullError);
      ok = false;
    }

    return ok;
  }

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  void clearErrs() {
    setState(() => fieldErrors.clear());
  }
}
