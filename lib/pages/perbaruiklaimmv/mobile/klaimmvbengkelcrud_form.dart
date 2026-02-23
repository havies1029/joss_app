import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/combobox/combombengkel_repository.dart';
import 'package:joss_app/repositories/combobox/combomjnsbengkel_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayahbengkel_repository.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvbengkelcrud_model.dart';
import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KlaimmvbengkelcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimmvbengkelcrudFormPage({super.key, required this.viewMode, required this.recordId, required this.formKey});

	@override
	KlaimmvbengkelcrudFormPageFormState createState() => KlaimmvbengkelcrudFormPageFormState();
}

class KlaimmvbengkelcrudFormPageFormState extends State<KlaimmvbengkelcrudFormPage> {
	late KlaimmvbengkelcrudBloc klaimmvbengkelcrudBloc;
	final List<String> errors = [];
	ComboMBengkelModel? fieldComboMBengkel;
	final comboMBengkelKey = GlobalKey<DropdownSearchState<ComboMBengkelModel>>();
	ComboMJnsbengkelModel? fieldComboMJnsbengkel;
	final comboMJnsbengkelKey = GlobalKey<DropdownSearchState<ComboMJnsbengkelModel>>();
	ComboMWilayahBengkelModel? fieldComboMWilayahBengkel;
	final comboMWilayahBengkelKey = GlobalKey<DropdownSearchState<ComboMWilayahBengkelModel>>();
	var fieldNamaBengkelLainController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimmvbengkelcrudBloc = BlocProvider.of<KlaimmvbengkelcrudBloc>(context);
		return BlocConsumer<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Form(
							key: widget.formKey,
							child: Column(
								children: [
									buildFieldMjnsbengkelId(),
									const SizedBox(height: hPadding),
									if (fieldComboMJnsbengkel?.mjnsbengkelId == "10")
										buildFieldMwilayahbengkelId(),
									const SizedBox(height: hPadding),
									if (fieldComboMJnsbengkel?.mjnsbengkelId == "10")
										buildFieldMbengkelId(),
									const SizedBox(height: hPadding),
									if (fieldComboMJnsbengkel?.mjnsbengkelId == "20")
										buildFieldNamaBengkelLain(),
									const SizedBox(height: hPadding),
									FormError(
										errors: errors,
										key: null,
									),

								],
							)),
				);
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldNamaBengkelLainController.text = state.record!.namaBengkelLain;
						}
						fieldComboMBengkel = state.comboMBengkel;
						fieldComboMJnsbengkel = state.comboMJnsbengkel;
						fieldComboMWilayahBengkel = state.comboMWilayahBengkel;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaimmvbengkelcrudBloc.add(
			KlaimmvbengkelcrudLihatEvent(recordId: widget.recordId));
		}
	}

	// Widget buildFieldMbengkelId(){
	// 	return buildFieldComboMBengkel(
  //     mwilayahbengkelId: fieldComboMWilayahBengkel?.mwilayahbengkelId ?? '',
	// 		comboKey: comboMBengkelKey,
	// 		labelText: 'Nama Bengkel',
	// 		initItem: fieldComboMBengkel,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 					error: "Field ComboMBengkel tidak boleh kosong.");
	// 				klaimmvbengkelcrudBloc.add(ComboMBengkelChangedEvent(comboMBengkel: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMBengkel = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 					error: "Field ComboMBengkel tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	Widget buildFieldMbengkelId() {
		return ReusableComboBox<ComboMBengkelModel>(
			comboKey: comboMBengkelKey,
			hintText: "Nama Bengkel",
			initItem: fieldComboMBengkel,
			dataLoader: () => ComboMBengkelRepository()
					.getComboMBengkel(
				fieldComboMWilayahBengkel?.mwilayahbengkelId ?? '',
				"",
			),
			dataLoaderWithFilter: (filter) =>
					ComboMBengkelRepository().getComboMBengkel(
						fieldComboMWilayahBengkel?.mwilayahbengkelId ?? '',
						filter,
					),
			displayText: (item) => item.bengkelNama,
			compareItems: (a, b) => a.mbengkelId == b.mbengkelId,
			enableSearch: true,
			showClearButton: false,
				onChangedCallback: (value) {
								if (value != null) {
									removeError(
										error: "Field ComboMBengkel tidak boleh kosong.");
									klaimmvbengkelcrudBloc.add(ComboMBengkelChangedEvent(comboMBengkel: value));
								}
							},
							onSaveCallback: (value) {
								if (value != null) {
									fieldComboMBengkel = value;
								}
							},
							validatorCallback: (value) {
								if (value == null) {
									addError(
										error: "Field ComboMBengkel tidak boleh kosong.");
								}
							},
		);
	}

	// Widget buildFieldMjnsbengkelId(){
	// 	return buildFieldComboMJnsbengkel(
	// 		comboKey: comboMJnsbengkelKey,
	// 		labelText: 'Jenis Bengkel',
	// 		initItem: fieldComboMJnsbengkel,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 					error: "Field ComboMJnsbengkel tidak boleh kosong.");
  //
  //         // reset UI dropdown bengkel
  //         comboMBengkelKey.currentState?.clear();
  //         comboMWilayahBengkelKey.currentState?.clear();
	// 				klaimmvbengkelcrudBloc.add(ComboMJnsbengkelChangedEvent(comboMJnsbengkel: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMJnsbengkel = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 					error: "Field ComboMJnsbengkel tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	Widget buildFieldMjnsbengkelId() {
		return ReusableComboBox<ComboMJnsbengkelModel>(
			comboKey: comboMJnsbengkelKey,
			hintText: "Jenis Bengkel",
			initItem: fieldComboMJnsbengkel,
			dataLoader: () => ComboMJnsbengkelRepository().getComboMJnsbengkel(),
			displayText: (item) => item.jenisNama,
			compareItems: (a, b) => a.mjnsbengkelId == b.mjnsbengkelId,
				onChangedCallback: (value) {
								if (value != null) {
									removeError(
										error: "Field ComboMJnsbengkel tidak boleh kosong.");

					        // reset UI dropdown bengkel
					        comboMBengkelKey.currentState?.clear();
					        comboMWilayahBengkelKey.currentState?.clear();
									klaimmvbengkelcrudBloc.add(ComboMJnsbengkelChangedEvent(comboMJnsbengkel: value));
								}
							},
							onSaveCallback: (value) {
								if (value != null) {
									fieldComboMJnsbengkel = value;
								}
							},
							validatorCallback: (value) {
								if (value == null) {
									addError(
										error: "Field ComboMJnsbengkel tidak boleh kosong.");
								}
							},
		);
	}

	// Widget buildFieldMwilayahbengkelId(){
	// 	return buildFieldComboMWilayahBengkel(
	// 		comboKey: comboMWilayahBengkelKey,
	// 		labelText: 'Wilayah Bengkel',
	// 		initItem: fieldComboMWilayahBengkel,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 					error: "Field ComboMWilayahBengkel tidak boleh kosong.");
	//
  //         // reset UI dropdown bengkel
  //         comboMBengkelKey.currentState?.clear();
	// 				klaimmvbengkelcrudBloc.add(ComboMWilayahBengkelChangedEvent(comboMWilayahBengkel: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMWilayahBengkel = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 					error: "Field ComboMWilayahBengkel tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	Widget buildFieldMwilayahbengkelId() {
		return ReusableComboBox<ComboMWilayahBengkelModel>(
			comboKey: comboMWilayahBengkelKey,
			hintText: "Wilayah Bengkel",
			initItem: fieldComboMWilayahBengkel,
			dataLoader: () =>
					ComboMWilayahBengkelRepository().getComboMWilayahBengkel(""),
			dataLoaderWithFilter: (filter) =>
					ComboMWilayahBengkelRepository()
							.getComboMWilayahBengkel(filter),
			displayText: (item) => item.wilayahNama,
			compareItems: (a, b) =>
			a.mwilayahbengkelId == b.mwilayahbengkelId,
			enableSearch: true,
			showClearButton: false,
				onChangedCallback: (value) {
								if (value != null) {
									removeError(
										error: "Field ComboMWilayahBengkel tidak boleh kosong.");

					        // reset UI dropdown bengkel
					        comboMBengkelKey.currentState?.clear();
									klaimmvbengkelcrudBloc.add(ComboMWilayahBengkelChangedEvent(comboMWilayahBengkel: value));
								}
							},
							onSaveCallback: (value) {
								if (value != null) {
									fieldComboMWilayahBengkel = value;
								}
							},
							validatorCallback: (value) {
								if (value == null) {
									addError(
										error: "Field ComboMWilayahBengkel tidak boleh kosong.");
								}
							},
		);
	}

	Widget buildFieldNamaBengkelLain(){
		return appTextField(
			label: "Nama Bengkel Lain",
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			controller: fieldNamaBengkelLainController,
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
        klaimmvbengkelcrudBloc.add(FieldNamaBengkelLainChangedEvent(namaBengkelLain: value));
			},
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
		if (widget.formKey.currentState!.validate()) {
			widget.formKey.currentState!.save();
			KlaimmvbengkelcrudModel record = KlaimmvbengkelcrudModel(
				klaim1Id: '',
				mbengkelId: fieldComboMBengkel?.mbengkelId,
				mjnsbengkelId: fieldComboMJnsbengkel?.mjnsbengkelId,
				mwilayahbengkelId: fieldComboMWilayahBengkel?.mwilayahbengkelId,
				namaBengkelLain: fieldNamaBengkelLainController.text,
			);
			if (widget.viewMode == "tambah") {
				klaimmvbengkelcrudBloc.add(KlaimmvbengkelcrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.klaim1Id = klaimmvbengkelcrudBloc.state.record!.klaim1Id;
				klaimmvbengkelcrudBloc.add(KlaimmvbengkelcrudUbahEvent(record: record));
			}
			_dismissDialog();
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
