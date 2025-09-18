import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:joss_app/blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';
import 'package:joss_app/blocs/gen_profile/mrekan1crud_bloc.dart';

import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:joss_app/widgets/combobox/combombank_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../blocs/gen_profile/mrekanbanklist_bloc.dart';
import '../../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../common/constants.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../models/gen_profile/mrekanbanklist_model.dart';
import '../../../../../repositories/combobox/combombank_repository.dart';
import '../../../../../widgets/form_error.dart';
import '../../../../base/base_background_sidepage.dart';


class MRekanBankCrudFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const MRekanBankCrudFormPage({super.key, required this.viewMode, required this.recordId});

  @override
  MRekanBankCrudFormPageFormState createState() => MRekanBankCrudFormPageFormState();
}

class MRekanBankCrudFormPageFormState extends State<MRekanBankCrudFormPage> {
  late MRekanBankCrudBloc mRekanBankCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  ComboMBankModel? fieldComboMBank;
  final comboMBankKey = GlobalKey<DropdownSearchState<ComboMBankModel>>();
  var fieldMrekan1IdController = TextEditingController();
  var fieldRekNamaController = TextEditingController();
  var fieldRekNoController = TextEditingController();
  String? existingMrekanBankId; // simpan id kalau ketemu

  // di dalam MRekanBankCrudFormPageFormState
  List<MRekanBankListModel> _allRekanBankList = [];
  List<MRekanBankListModel> _filteredRekanBankList = [];
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<MRekanBankListBloc>().add(
        RefreshMRekanBankListEvent(searchText: "", hal: 0),
      );
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }


  void loadData() {
    if (widget.viewMode == "ubah") {
      mRekanBankCrudBloc.add(
        MRekanBankCrudLihatEvent(recordId: widget.recordId),
      );
    }

    final profile = context.read<UserProfileCubit>().state;
    fieldMrekan1IdController.text = profile.mrekan1Id ?? '';

    // 🔥 Filter list berdasarkan mrekan1Id (pasti 1 atau kosong)
    final currentMrekan1Id = fieldMrekan1IdController.text;
    _filteredRekanBankList = _allRekanBankList
        .where((item) => item.mrekan1Id == currentMrekan1Id)
        .toList();

    // Debug biar jelas
    if (_filteredRekanBankList.isNotEmpty) {
      final item = _filteredRekanBankList.first;
      debugPrint("🎯 RekanBank ditemukan untuk mrekan1Id=$currentMrekan1Id:");
      debugPrint("- ${item.mrekanbankId} | ${item.mrekan1Id} | ${item.rekNama} | ${item.rekNo}");
    } else {
      debugPrint("⚠️ Tidak ada RekanBank untuk mrekan1Id=$currentMrekan1Id");
    }
  }


  @override
  Widget build(BuildContext context) {
    mRekanBankCrudBloc = BlocProvider.of<MRekanBankCrudBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final headerSpacing = screenHeight * 0.025;

    const double avatarRadius = 50;
    const double avatarRingPadding = 3;
    const double avatarBorderWidth = 2;
    const double contentTopPadding = 120;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Rekening Bank',
          child: Column(
            children: [
              SizedBox(height: headerSpacing * 4),

              // ⬇️ Tambahin BlocBuilder di sini buat nyimpen list
              BlocListener<MRekanBankListBloc, MRekanBankListState>(
                listenWhen: (prev, curr) => prev.items != curr.items,
                listener: (context, state) async {
                  _allRekanBankList = state.items;

                  final currentMrekan1Id = fieldMrekan1IdController.text;
                  final filtered = _allRekanBankList
                      .where((item) => item.mrekan1Id == currentMrekan1Id)
                      .toList();

                  if (filtered.isNotEmpty) {
                    final item = filtered.first;
                    existingMrekanBankId = item.mrekanbankId;

                    // 🔥 Prefill field otomatis
                    setState(() {
                      fieldMrekan1IdController.text = item.mrekan1Id;
                      fieldRekNamaController.text   = item.rekNama;
                      fieldRekNoController.text     = item.rekNo;

                      // Dropdown bank (butuh ComboMBankModel)
                      fieldComboMBank = ComboMBankModel(
                        mbankId: item.mbankId,
                        bankNama: item.bankNama,
                      );
                    });

                    debugPrint("🎯 Prefill RekanBank ditemukan untuk mrekan1Id=$currentMrekan1Id:");
                    debugPrint("- ${item.mrekanbankId} | ${item.mrekan1Id} | ${item.bankNama} | ${item.rekNama} | ${item.rekNo}");
                  } else {
                    existingMrekanBankId = null;
                    debugPrint("⚠️ Tidak ada RekanBank untuk mrekan1Id=$currentMrekan1Id");
                  }
                },
                child: const SizedBox.shrink(),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: secondaryBlackColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: Border(
                        top: BorderSide(color: primaryColor, width: 4.0),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // FORM lama tetap jalan
                        CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                16,
                                contentTopPadding,
                                16,
                                24 + MediaQuery.of(context).viewInsets.bottom,
                              ),
                              sliver: SliverFillRemaining(
                                hasScrollBody: false,
                                child: BlocConsumer<MRekanBankCrudBloc, MRekanBankCrudState>(
                                  listener: (context, state) {
                                    if (state.isLoaded) {
                                      if (state.record != null) {
                                        fieldMrekan1IdController.text = state.record!.mrekan1Id;
                                        fieldRekNamaController.text = state.record!.rekNama;
                                        fieldRekNoController.text = state.record!.rekNo;
                                      }
                                      fieldComboMBank = state.comboMBank;
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
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Rekening Bank",
                                                  style: TextStyle(
                                                    fontSize: getResponsiveFont(context, 22),
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryLightColor,
                                                  ),
                                                ),
                                                Text(
                                                  "Lengkapi data rekening untuk pencairan klaim.",
                                                  style: TextStyle(
                                                    fontSize: getResponsiveFont(context, 16),
                                                    fontWeight: FontWeight.w400,
                                                    color: sGrey,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Fields
                                          buildFieldMbankId(),
                                          const SizedBox(height: vPadding),
                                          BlocListener<UserProfileCubit, UserProfileState>(
                                            listenWhen: (prev, curr) => prev.mrekan1Id != curr.mrekan1Id,
                                            listener: (context, state) {
                                              final next = state.mrekan1Id ?? '';
                                              if (fieldMrekan1IdController.text != next) {
                                                fieldMrekan1IdController.text = next;
                                              }
                                            },
                                            child: buildFieldMrekan1Id(),
                                          ),
                                          const SizedBox(height: vPadding),
                                          buildFieldRekNama(),
                                          const SizedBox(height: vPadding),
                                          buildFieldRekNo(),

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

                        // Avatar tetap
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





  // Widget buildFieldMbankId(){
  //   return buildFieldComboMBank(
  //     comboKey: comboMBankKey,
  //     labelText: 'mbankId',
  //     initItem: fieldComboMBank,
  //     onChangedCallback: (value) {
  //       if (value != null) {
  //         removeError(
  //             error: "Field ComboMBank tidak boleh kosong.");
  //         mRekanBankCrudBloc.add(ComboMBankChangedEvent(comboMBank: value));
  //       }
  //     },
  //     onSaveCallback: (value) {
  //       if (value != null) {
  //         fieldComboMBank = value;
  //       }
  //     },
  //     validatorCallback: (value) {
  //       if (value == null) {
  //         addError(
  //             error: "Field ComboMBank tidak boleh kosong.");
  //       }
  //     },
  //   );
  // }

  Widget buildFieldMbankId() {
    return ReusableComboBox<ComboMBankModel>(
      labelText: "Pilih Bank",
      searchHintText: "Cari nama bank...",
      comboKey: comboMBankKey,
      initItem: fieldComboMBank,
      dataLoader: () => ComboMBankRepository().getComboMBank(),
      displayText: (item) => item.bankNama,
      compareItems: (a, b) => a.mbankId == b.mbankId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: "Field ComboMBank tidak boleh kosong.");
          mRekanBankCrudBloc.add(ComboMBankChangedEvent(comboMBank: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMBank = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          addError(error: "Field ComboMBank tidak boleh kosong.");
          return "Field ComboMBank tidak boleh kosong.";
        }
        return null;
      },
      // Optional styling:
      showClearButton: true,
      customItemBuilder:
          (context, item, isSelected, isDisabled) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration:
        !isSelected
            ? null
            : BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: ListTile(selected: isSelected, title: Text(item.bankNama)),
      ),
    );
  }

  // MRekan1Id (readonly)
  Widget buildFieldMrekan1Id() {
    return appTextField(
      label: "MRekan1Id",
      controller: fieldMrekan1IdController,
      enabled: false, // readonly
      suffixIcon: const Icon(Icons.lock_outline, size: 18),
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
    );
  }

// RekNama (multiline)
  Widget buildFieldRekNama() {
    return appTextField(
      label: "rekNama",
      controller: fieldRekNamaController,
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

// RekNo (single line)
  Widget buildFieldRekNo() {
    return appTextField(
      label: "rekNo",
      controller: fieldRekNoController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kStringNullError);
          return "";
        }
        return null;
      },
    );
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = MRekanBankCrudModel(
        mbankId: fieldComboMBank?.mbankId,
        mrekan1Id: fieldMrekan1IdController.text,
        mrekanbankId: existingMrekanBankId ?? '', // isi kalau update
        rekNama: fieldRekNamaController.text,
        rekNo: fieldRekNoController.text,
      );

      debugPrint("📤 [onSaveForm] Data yang akan dikirim: ${record.toJson()}");

      if (existingMrekanBankId != null && existingMrekanBankId!.isNotEmpty) {
        // 🔥 Update record
        debugPrint("✏️ [onSaveForm] Update ID: $existingMrekanBankId");
        mRekanBankCrudBloc.add(MRekanBankCrudUbahEvent(record: record));
      } else {
        // 🔥 Tambah record baru
        debugPrint("➕ [onSaveForm] Tambah record baru");
        mRekanBankCrudBloc.add(MRekanBankCrudTambahEvent(record: record));
      }

      _dismissDialog();
    } else {
      debugPrint("❌ [onSaveForm] Validasi form gagal.");
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
