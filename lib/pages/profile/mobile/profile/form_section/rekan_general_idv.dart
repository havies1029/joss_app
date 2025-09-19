import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';

import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/gen_profile/mrekangeneralidvcrud_bloc.dart';
import 'package:joss_app/models/gen_profile/mrekangeneralidvcrud_model.dart';
import 'package:joss_app/models/combobox/combompekerjaan_model.dart';
import 'package:joss_app/models/combobox/combomjnskel_model.dart';

import '../../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import '../../../../../blocs/user_profile/user_profile_cubit.dart';
import '../../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../../helper/image_uploader.dart';
import '../../../../../repositories/combobox/combomjnskel_repository.dart';
import '../../../../../repositories/combobox/combompekerjaan_repository.dart';
import '../../../../base/base_background_sidepage.dart';

class MRekanGeneralIdvCrudFormPage extends StatefulWidget {
  const MRekanGeneralIdvCrudFormPage({super.key});

  @override
  MRekanGeneralIdvCrudFormPageFormState createState() =>
      MRekanGeneralIdvCrudFormPageFormState();
}

class MRekanGeneralIdvCrudFormPageFormState
    extends State<MRekanGeneralIdvCrudFormPage> {
  late MRekanGeneralIdvCrudBloc mRekanGeneralIdvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  ComboMPekerjaanModel? fieldComboMPekerjaan;
  ComboMJnskelModel? fieldComboMJnskel;
  final comboMPekerjaanKey =
      GlobalKey<DropdownSearchState<ComboMPekerjaanModel>>();
  final comboMJnsKelKey = GlobalKey<DropdownSearchState<ComboMJnskelModel>>();
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
    mRekanGeneralIdvCrudBloc = BlocProvider.of<MRekanGeneralIdvCrudBloc>(
      context,
    );
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          title: 'Informasi Klien',
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
                      border: const Border(
                        top: BorderSide(color: primaryColor),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: BlocConsumer<
                        MRekanGeneralIdvCrudBloc,
                        MRekanGeneralIdvCrudState
                      >(
                        listener: (context, state) {
                          if (state.isLoaded) {
                            if (state.record != null) {
                              fieldRekanNamaController.text =
                                  state.record!.rekanNama;
                            }
                            fieldComboMPekerjaan = state.comboMPekerjaan;
                            fieldComboMJnskel = state.comboMJnskel;
                          }
                          if (state.isSaved && !state.hasFailure) {
                            context.read<MRekan1CrudBloc>().add(
                              MRekan1CrudLihatEvent(),
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
                                // Heading + subheading
                                Text(
                                  "Informasi Klien",
                                  textAlign: TextAlign.start,
                                  style: headingStyle(context, fontSize: 22),
                                ),
                                Text(
                                  "Lengkapi identitas dasar Anda dengan benar.",
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
                                      buildFieldRekanNama(),
                                      const SizedBox(height: 16),
                                      buildFieldJenisKlien(),
                                      const SizedBox(height: 16),
                                      buildFieldPekerjaan(),
                                      const SizedBox(height: 16),
                                      buildFieldJenisKelamin(),
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
    mRekanGeneralIdvCrudBloc.add(MRekanGeneralIdvCrudLihatEvent());
  }

  Widget buildFieldPekerjaan() {
    return ReusableComboBox<ComboMPekerjaanModel>(
      hintText: "Pekerjaan",
      searchHintText: "Cari Pekerjaan...",
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
      future: ComboMJnskelRepository().getComboMJnskel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Tidak ada data jenis kelamin');
        }

        List<ComboMJnskelModel> jenisKelaminList = snapshot.data!;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kelamin',
                style: bodyTextStyle(context, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children:
                    jenisKelaminList.asMap().entries.map((entry) {
                      int index = entry.key;
                      ComboMJnskelModel item = entry.value;
                      bool isSelected =
                          fieldComboMJnskel?.mjnskelId == item.mjnskelId;

                      return Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                fieldComboMJnskel = item;
                                mRekanGeneralIdvCrudBloc.add(
                                  ComboMJnskelChangedEvent(comboMJnskel: item),
                                );
                                setState(() {});
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
                                        color:
                                            isSelected
                                                ? primaryColor
                                                : hintGrey,
                                        width: 1,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child:
                                        isSelected
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
                                    style:
                                        isSelected
                                            ? inputTextStyle(context)
                                            : bodyTextStyle(context),
                                  ),
                                ],
                              ),
                            ),
                            // Spacer between options (except for last item)
                            if (index < jenisKelaminList.length - 1)
                              const SizedBox(width: 24),
                          ],
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
                  return state.hasError
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(color: pRed, fontSize: 12),
                        ),
                      )
                      : const SizedBox.shrink();
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
      label: "Individu",
      controller: TextEditingController(),
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
