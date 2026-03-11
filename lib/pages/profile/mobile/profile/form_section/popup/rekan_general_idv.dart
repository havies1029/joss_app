import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';

import '../../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../../../../common/app_data.dart';
import '../../../../../../common/loading_indicator.dart';
import '../../../../../../helper/image_uploader.dart';
import '../../../../../../repositories/combobox/combomjnskel_repository.dart';
import '../../../../../../repositories/combobox/combompekerjaan_repository.dart';
import '../../../../../base/base_background_sidepage.dart';

class MRekanGeneralIdvPopUpPage extends StatefulWidget {
  final bool popTwice;

  const MRekanGeneralIdvPopUpPage({
    super.key,
    this.popTwice = true,
  });

  @override
  MRekanGeneralIdvPopUpPageFormState createState() =>
      MRekanGeneralIdvPopUpPageFormState();
}

class MRekanGeneralIdvPopUpPageFormState
    extends State<MRekanGeneralIdvPopUpPage> {
  late final MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  late Future<List<ComboMJnskelModel>> _futureJenisKelamin =
  ComboMJnskelRepository().getComboMJnskel();

  final fieldRekanNamaController = TextEditingController();
  var fieldNamaBadanUsahaController = TextEditingController();

  final List<String> errors = [];
  ComboMPekerjaanModel? fieldComboMPekerjaan;
  final comboMPekerjaanKey = GlobalKey<DropdownSearchState<ComboMPekerjaanModel>>();

  ComboMJnskelModel? fieldComboMJnskel;
  final comboMJnsKelKey = GlobalKey<DropdownSearchState<ComboMJnskelModel>>();
  bool _isFirstLoad = true;
  @override
  void initState() {
    super.initState();
    mRekanGeneralIdvCrudBloc = context.read<MRekanGeneralIdvCrudBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Informasi Klien',
      onBack: () {
        if (widget.popTwice) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;

          if (widget.popTwice) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: BlocConsumer<MRekanGeneralIdvCrudBloc, MRekanGeneralIdvCrudState>(
                      listenWhen: (prev, curr) =>
                      curr.isLoaded == true ||
                          prev.isSaved != curr.isSaved && curr.isSaved,
                      listener: (context, state) {
                        if (state.isLoaded && state.record != null && _isFirstLoad) {
                          final rec = state.record!;

                          if (fieldRekanNamaController.text.trim().isEmpty) {
                            final formName = rec.rekanNama.trim();
                            final fallbackName =
                            (context.read<MRekan1CrudBloc>().state.record?.rekanNama ?? '')
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

                          final mjenisClient =
                              context.read<MRekan1CrudBloc>().state.record?.mjnsclientId;

                          if (fieldNamaBadanUsahaController.text.trim().isEmpty) {
                            if (mjenisClient == '10') {
                              fieldNamaBadanUsahaController.text = "Individu";
                            } else if (mjenisClient == '20') {
                              fieldNamaBadanUsahaController.text = "Perusahaan";
                            }
                          }

                          if (fieldComboMPekerjaan == null) {
                            fieldComboMPekerjaan = rec.comboMPekerjaan;
                          }

                          if (fieldComboMJnskel == null) {
                            fieldComboMJnskel = rec.comboMJnskel;
                          }

                          _isFirstLoad = false;
                        }

                        if (state.isSaved && !state.hasFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            successSnackBar("Data berhasil disimpan!"),
                          );

                          if (widget.popTwice) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
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
                                                      child: _avatarFallback(),
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
                                  borderRadius: BorderRadius.circular(cardBorderRadius),
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
            );
          },
        ),
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
    mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
    _futureJenisKelamin = ComboMJnskelRepository().getComboMJnskel();
    // final name =
    //     context.read<MRekan1CrudBloc>().state.record?.rekanNama;
    //
    // if (fieldRekanNamaController.text.isEmpty && (name?.isNotEmpty ?? false)) {
    //   fieldRekanNamaController.text = name!;
    // }
  }

  Widget buildFieldPekerjaan() {
    return ReusableComboBox<ComboMPekerjaanModel>(
      hintText: "Pekerjaan",
      comboKey: comboMPekerjaanKey,
      initItem: fieldComboMPekerjaan,
      dataLoader: () => ComboMPekerjaanRepository().getComboMPekerjaan(),
      displayText: (item) => item.kerjaNama,
      compareItems: (a, b) => a.mpekerjaanId == b.mpekerjaanId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMPekerjaan tidak boleh kosong.");
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
                validator: (value) {
                  if (fieldComboMJnskel == null) {
                    return kStringNullError;
                  }
                  return null;
                },
                builder: (state) {
                  if (!state.hasError) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText!,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
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
      mRekanGeneralIdvCrudBloc.add(
        MRekanGeneralIdvCrudUbahEvent(record: record),
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
