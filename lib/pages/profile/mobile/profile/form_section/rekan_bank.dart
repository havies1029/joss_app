import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

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

  const MRekanBankCrudFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
  });

  @override
  MRekanBankCrudFormPageFormState createState() =>
      MRekanBankCrudFormPageFormState();
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
  bool _isFirstLoad = true;
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
    _filteredRekanBankList =
        _allRekanBankList
            .where((item) => item.mrekan1Id == currentMrekan1Id)
            .toList();

    // Debug biar jelas
    if (_filteredRekanBankList.isNotEmpty) {
      final item = _filteredRekanBankList.first;
      debugPrint("🎯 RekanBank ditemukan untuk mrekan1Id=$currentMrekan1Id:");
      debugPrint(
        "- ${item.mrekanbankId} | ${item.mrekan1Id} | ${item.rekNama} | ${item.rekNo}",
      );
    } else {
      debugPrint("⚠️ Tidak ada RekanBank untuk mrekan1Id=$currentMrekan1Id");
    }
  }

  @override
  Widget build(BuildContext context) {
    mRekanBankCrudBloc = BlocProvider.of<MRekanBankCrudBloc>(context);
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Rekening Bank',
          child: Column(
            children: [
              BlocListener<MRekanBankListBloc, MRekanBankListState>(
                listenWhen: (prev, curr) => prev.items != curr.items,
                listener: (context, state) async {
                  _allRekanBankList = state.items;

                  final currentMrekan1Id = fieldMrekan1IdController.text;
                  final filtered =
                      _allRekanBankList
                          .where((item) => item.mrekan1Id == currentMrekan1Id)
                          .toList();

                  if (filtered.isNotEmpty) {
                    final item = filtered.first;
                    existingMrekanBankId = item.mrekanbankId;

                    setState(() {
                      fieldMrekan1IdController.text = item.mrekan1Id;
                      fieldRekNamaController.text = item.rekNama;
                      fieldRekNoController.text = item.rekNo;

                      fieldComboMBank = ComboMBankModel(
                        mbankId: item.mbankId,
                        bankNama: item.bankNama,
                      );
                    });
                  } else {
                    existingMrekanBankId = null;
                    debugPrint(
                      "⚠️ Tidak ada RekanBank untuk mrekan1Id=$currentMrekan1Id",
                    );
                  }


                },
                child: const SizedBox.shrink(),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: secondaryBlackColor,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: BlocConsumer<
                        MRekanBankCrudBloc,
                        MRekanBankCrudState
                    >(
                      listener: (context, state) {
                        // 🔸 Load data record (tetap di sini)
                        if (state.isLoaded && _isFirstLoad) {
                          if (state.record != null) {
                            fieldMrekan1IdController.text = state.record!.mrekan1Id;
                            fieldRekNamaController.text = state.record!.rekNama;
                            fieldRekNoController.text = state.record!.rekNo;
                          }
                          fieldComboMBank = state.comboMBank;
                        }

                        // ✅ Pindahkan ke luar
                        if (state.isSaved && !state.hasFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            successSnackBar("Data berhasil disimpan 🎉"),
                          );
                          _isFirstLoad = true; // biar kalau mau reload manual, bisa nanti
                        }

                      },

                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Rekening Bank",
                                style: headingStyle(context, fontSize: 22),
                              ),
                              Text(
                                "Lengkapi data rekening untuk pencairan klaim.",
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
                                    // Fields
                                    buildFieldNamaBank(),
                                    // const SizedBox(height: 16),
                                    // BlocListener<UserProfileCubit, UserProfileState>(
                                    //   listenWhen: (prev, curr) => prev.mrekan1Id != curr.mrekan1Id,
                                    //   listener: (context, state) {
                                    //     final next = state.mrekan1Id ?? '';
                                    //     if (fieldMrekan1IdController.text != next) {
                                    //       fieldMrekan1IdController.text = next;
                                    //     }
                                    //   },
                                    //   child: buildFieldMrekan1Id(),
                                    // ),
                                    const SizedBox(height: 16),
                                    buildFieldRekNama(),
                                    const SizedBox(height: 16),
                                    buildFieldRekNo(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFieldNamaBank() {
    return ReusableComboBox<ComboMBankModel>(
      hintText: "Bank",
      comboKey: comboMBankKey,
      initItem: fieldComboMBank,
      dataLoader: () => ComboMBankRepository().getComboMBank(),
      displayText: (item) => item.bankNama,
      compareItems: (a, b) => a.mbankId == b.mbankId,
      onChangedCallback: (value) {
        if (value != null) {
          removeError(error: kStringNullError);
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
          return kStringNullError;
        }
        return null;
      },
    );
  }

  // Widget buildFieldMrekan1Id() {
  //   return appTextField(
  //     label: "MRekan1Id",
  //     controller: fieldMrekan1IdController,
  //     enabled: false, // readonly
  //     suffixIcon: const Icon(Icons.lock_outline, size: 18),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         addError(error: kStringNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //   );
  // }

  Widget buildFieldRekNama() {
    return appTextField(
      label: "Nama Rekening",
      controller: fieldRekNamaController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  Widget buildFieldRekNo() {
    return appTextField(
      label: "Nomor Rekening",
      controller: fieldRekNoController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return kStringNullError;
        }
        return null;
      },
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final record = MRekanBankCrudModel(
        mbankId: fieldComboMBank?.mbankId,
        mrekan1Id: fieldMrekan1IdController.text,
        mrekanbankId: existingMrekanBankId ?? '',
        rekNama: fieldRekNamaController.text,
        rekNo: fieldRekNoController.text,
      );

      if (existingMrekanBankId != null && existingMrekanBankId!.isNotEmpty) {
        mRekanBankCrudBloc.add(MRekanBankCrudUbahEvent(record: record));
      } else {
        mRekanBankCrudBloc.add(MRekanBankCrudTambahEvent(record: record));
      }

    } else {
      debugPrint("[onSaveForm] Validasi form gagal.");
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
