import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:joss_app/blocs/gen_profile/mrekanbankcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekanbankcrud_model.dart';

import 'package:joss_app/models/combobox/combombank_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../common/constants.dart';
import '../../../../../repositories/combobox/combombank_repository.dart';
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
  late final MRekanBankCrudBloc mRekanBankCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  final fieldMrekan1IdController = TextEditingController();
  final fieldRekNamaController = TextEditingController();
  final fieldRekNoController = TextEditingController();

  ComboMBankModel? fieldComboMBank;
  final comboMBankKey = GlobalKey<DropdownSearchState<ComboMBankModel>>();

  String? existingMrekanBankId;
  bool _isFirstLoad = true;
  @override
  void initState() {
    super.initState();
    mRekanBankCrudBloc = context.read<MRekanBankCrudBloc>();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
    });
  }

  void loadData() {

    final mrekan1Id = context.read<MRekan1CrudBloc>().state.record?.mrekan1Id;
    fieldMrekan1IdController.text = mrekan1Id ?? '';

    mRekanBankCrudBloc.add(
      MRekanBankCrudLihatEvent(recordId: mrekan1Id ?? ""),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Rekening Bank',
          child: Column(
            children: [
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

                    child: BlocListener<MRekanBankCrudBloc, MRekanBankCrudState>(
                      listenWhen: (prev, curr) =>
                      curr.isLoaded == true || curr.isSaved == true,

                      listener: (context, state) {
                        if (state.isLoaded && _isFirstLoad && state.record != null) {
                          _injectPayload(state.record!);
                        }

                        if (state.isSaved && !state.hasFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            successSnackBar("Data berhasil disimpan!"),
                          );
                          _isFirstLoad = true;
                        }
                      },

                      child: _buildFormContent(context),
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


  Widget _buildFormContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Rekening Bank",
            style: headingStyle(context, fontSize: getResponsiveFont(context, 22)),
          ),
          Text(
            "Lengkapi data rekening untuk pencairan klaim.",
            style: bodyTextStyle(context, fontSize: getResponsiveFont(context, 16))
                .copyWith(color: hintGrey),
          ),
          const SizedBox(height: vPadding),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: pGrey,
              border: Border.all(color: sGrey),
              borderRadius: BorderRadius.circular(cardBorderRadius),
            ),
            child: Column(
              children: [
                buildFieldNamaBank(),
                const SizedBox(height: vPadding),
                buildFieldRekNama(),
                const SizedBox(height: vPadding),
                buildFieldRekNo(),
              ],
            ),
          ),

          const SizedBox(height: vPadding),

          AppButton.primary(
            text: "Submit",
            onPressed: onSaveForm,
          )
        ],
      ),
    );
  }

  void _injectPayload(MRekanBankCrudModel record) {
    fieldMrekan1IdController.text = record.mrekan1Id;
    fieldRekNamaController.text   = record.rekNama;
    fieldRekNoController.text     = record.rekNo;

    fieldComboMBank = record.comboMBank;

    setState(() {});
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
      keyboardType: TextInputType.phone,
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
