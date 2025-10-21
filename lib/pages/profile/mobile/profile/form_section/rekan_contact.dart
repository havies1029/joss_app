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
    mRekanContactCrudBloc = BlocProvider.of<MRekanContactCrudBloc>(context);

    SizeConfig().init(context);

    return BaseBackgroundSidePage(
      title: "Kontak & Alamat",
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxHeight, // ✅ full tinggi layar
            color: secondaryBlackColor, // ✅ ganti warna utama
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // ✅ tetap isi seluruh layar walau konten sedikit
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: BlocConsumer<MRekanContactCrudBloc, MRekanContactCrudState>(
                    listener: (context, state) {
                      // 🟢 Muat data dari API (seperti semula)
                      if (state.isLoaded && _isFirstLoad) {
                        if (state.record != null) {
                          fieldAlamat1Controller.text = state.record!.alamat1;

                          // Email fallback dari profil
                          if (state.record!.email.isNotEmpty) {
                            fieldEmailController.text = state.record!.email;
                          } else {
                            final profile = context.read<UserProfileCubit>().state;
                            if (fieldEmailController.text.isEmpty &&
                                (profile.email?.isNotEmpty ?? false)) {
                              fieldEmailController.text = profile.email!;
                            }
                          }

                          // Telepon fallback dari profil
                          if (state.record!.telp.isNotEmpty) {
                            fieldTelpController.text = state.record!.telp;
                          } else {
                            final profile = context.read<UserProfileCubit>().state;
                            if (fieldTelpController.text.isEmpty &&
                                (profile.telepon?.isNotEmpty ?? false)) {
                              fieldTelpController.text = profile.telepon!;
                            }
                          }

                          fieldComboMKota = state.comboMKota;
                          fieldComboMPropinsi = state.comboMPropinsi;
                          fieldComboRKodepos = state.comboRKodepos;
                        }
                      }

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
                              "Kontak & Alamat",
                              textAlign: TextAlign.start,
                              style: headingStyle(context, fontSize: 22)
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "Gunakan email yang aktif dan alamat yang jelas.",
                              style: bodyTextStyle(
                                context,
                                fontSize: 16,
                              ).copyWith(color: hintGrey),
                            ),
                            const SizedBox(height: 20),

                            // 🧩 Card form utama
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: secondaryBlackColor.withOpacity(0.2), // ✅ transparan halus
                                border: Border.all(color: sGrey.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(cardBorderRadius),
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
    mRekanContactCrudBloc.add(MRekanContactCrudLihatEvent());

    final profile = context.read<UserProfileCubit>().state;

    if (fieldEmailController.text.isEmpty && (profile.email?.isNotEmpty ?? false)) {
      fieldEmailController.text = profile.email!;
    }

    if (fieldTelpController.text.isEmpty && (profile.telepon?.isNotEmpty ?? false)) {
      fieldTelpController.text = profile.telepon!;
    }
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
      hintText: "Kodepos (Opsional)",
      showClearButton: true,
      comboKey: comboRKodeposKey,
      initItem: fieldComboRKodepos,
      dataLoader: () => ComboRKodeposRepository().getComboRKodepos(
        fieldComboMKota?.mkotaId ?? "",
        "",
      ),
      displayText: (item) => item.kodeposNo,
      compareItems: (a, b) => a.rkodeposId == b.rkodeposId,
      onChangedCallback: (value) {
        if (value != null) {
          // ✅ kalau user pilih kodepos baru
          mRekanContactCrudBloc.add(
            ComboRKodeposChangedEvent(comboRKodepos: value),
          );
          fieldComboRKodepos = value;
        } else {
          // ✅ kalau user hapus / clear pilihan
          fieldComboRKodepos = const ComboRKodeposModel(); // 🔥 reset total, bukan null
          mRekanContactCrudBloc.add(
            ComboRKodeposChangedEvent(
              comboRKodepos: fieldComboRKodepos ?? const ComboRKodeposModel(),
            ),
          );
        }
        setState(() {}); // refresh tampilan
      },

      onSaveCallback: (value) {
        fieldComboRKodepos = value;
      },
    );
  }

  void onSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      MRekanContactCrudModel record = MRekanContactCrudModel(
        alamat1: fieldAlamat1Controller.text,
        email: fieldEmailController.text,
        mkotaId: fieldComboMKota?.mkotaId,          // biarkan null normal
        mpropinsiId: fieldComboMPropinsi?.mpropinsiId, // biarkan null normal
        mrekancontact1Id: '',
        rkodeposId: fieldComboRKodepos?.rkodeposId ?? "", // 🔥 khusus ini aja jadi ""
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
