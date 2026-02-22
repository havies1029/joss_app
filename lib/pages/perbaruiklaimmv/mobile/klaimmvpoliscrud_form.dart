import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/combobox/combominsurer_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/widgets/combobox/combominsurer_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KlaimmvpoliscrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimmvpoliscrudFormPage({super.key, required this.viewMode, required this.recordId, required this.formKey});

	@override
	KlaimmvpoliscrudFormPageFormState createState() => KlaimmvpoliscrudFormPageFormState();
}

class KlaimmvpoliscrudFormPageFormState extends State<KlaimmvpoliscrudFormPage> {
	late KlaimmvpoliscrudBloc klaimmvpoliscrudBloc;
	final List<String> errors = [];
	var fieldInsuredNamaController = TextEditingController();
	var fieldLaporAsuransiController = TextEditingController(text: DateTime.now().toIso8601String());
	ComboMInsurerModel? fieldComboMInsurer;
	final comboMInsurerKey = GlobalKey<DropdownSearchState<ComboMInsurerModel>>();
	ComboMMvjnscoverModel? fieldComboMMvjnscover;
	final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
	var fieldNoChasisController = TextEditingController();
	var fieldNoPlatController = TextEditingController();
	var fieldPolisAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPolisNoController = TextEditingController();
	var fieldSppa1IdController = TextEditingController();
  var isPolisJps = false;

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);
		return BlocConsumer<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Form(
							key: widget.formKey,
							child: Column(
								children: [
									Row(
										children: [
											Flexible(child: buildFieldPolisMulai()),
											const SizedBox(width: 8),
											Flexible(child: buildFieldPolisAkhir()),
										],
									),
									const SizedBox(height: hPadding),
									buildFieldLaporAsuransi(),
									const SizedBox(height: hPadding),
									buildFieldInsuredNama(),
									const SizedBox(height: hPadding),
									buildFieldNoPlat(),
									const SizedBox(height: hPadding),
									buildFieldNoChasis(),
									const SizedBox(height: hPadding),
									buildFieldMinsurerId(),
									const SizedBox(height: hPadding),
									buildFieldPolisNo(),
									const SizedBox(height: hPadding),
									buildFieldMmvjnscoverId(),
									if (isPolisJps) ...[
										const SizedBox(height: hPadding),
										buildFieldSppa1Id(),
									],
									const SizedBox(height: 15),
									FormError(
										errors: errors,
										key: null,
									),
								],
							))
				);
				},
			listener: (context, state) {
				if (state.isLoaded) {
					if (state.record != null) {
						fieldInsuredNamaController.text = state.record!.insuredNama;
						fieldLaporAsuransiController.text = state.record!.laporAsuransi.toIso8601String();
						fieldNoChasisController.text = state.record!.noChasis;
						fieldNoPlatController.text = state.record!.noPlat;
						fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
						fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
						fieldPolisNoController.text = state.record!.polisNo;
						fieldSppa1IdController.text = state.record!.sppa1Id ?? '';
					}
					fieldComboMInsurer = state.comboMInsurer;
					fieldComboMMvjnscover = state.comboMMvjnscover;
					isPolisJps = state.record?.isPolisJps ?? false;
				}
			},
        buildWhen: (previous, current) {
          return previous.isLoaded != current.isLoaded;
        },
        listenWhen: (previous, current) {
          return previous.isLoaded != current.isLoaded;
        },
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaimmvpoliscrudBloc.add(
			KlaimmvpoliscrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldInsuredNama(){
		return appTextField(
			label: 'Tertanggung',
      enabled: isPolisJps ? false : true,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: "Nama Tertanggung tidak boleh kosong");
				}
				klaimmvpoliscrudBloc.add(FieldInsuredNamaChangedEvent(insuredNama: value));
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: "Nama Tertanggung tidak boleh kosong");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldLaporAsuransi(){
		return AppDateField(
			label: 'Tanggal ke Asuransi',
			lastDate: DateTime(2100),
			firstDate: DateTime(2000),
      enabled: isPolisJps ? false : true,
			initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: "Lapor Asuransi tidak boleh kosong");
					fieldLaporAsuransiController.text = value.toIso8601String();

					klaimmvpoliscrudBloc.add(FieldLaporAsuransiChangedEvent(laporAsuransi: value));
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: "Lapor Asuransi tidak boleh kosong");
					return "";
				}
				return null;
			},
		);
	}

	// Widget buildFieldMinsurerId(){
	// 	return buildFieldComboMInsurer(
  //     enabled: isPolisJps ? false : true,
	// 		comboKey: comboMInsurerKey,
	// 		labelText: 'minsurerId',
	// 		initItem: fieldComboMInsurer,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 					error: "Field ComboMInsurer tidak boleh kosong.");
	// 				klaimmvpoliscrudBloc.add(ComboMInsurerChangedEvent(comboMInsurer: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMInsurer = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 					error: "Field ComboMInsurer tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	Widget buildFieldMinsurerId() {
		return ReusableComboBox<ComboMInsurerModel>(
			hintText: 'Insurance',
			comboKey: comboMInsurerKey,
			initItem: fieldComboMInsurer,
			isEnabled: isPolisJps ? false : true,
			dataLoaderWithFilter: (filter) {
				return ComboMInsurerRepository().getComboMInsurer(filter);
			},
			dataLoader: () {
				return ComboMInsurerRepository().getComboMInsurer("");
			},
			displayText: (item) => item.insurerNama,
			compareItems: (item, selectedItem) =>
			item.minsurerId == selectedItem.minsurerId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Asuransi tidak boleh kosong.");
					klaimmvpoliscrudBloc.add(ComboMInsurerChangedEvent(comboMInsurer: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMInsurer = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Asuransi tidak boleh kosong.");
				}
			},
		);
	}


	// Widget buildFieldMmvjnscoverId(){
	// 	return buildFieldComboMMvjnscover(
  //     enabled: isPolisJps ? false : true,
	// 		comboKey: comboMMvjnscoverKey,
	// 		labelText: 'mmvjnscoverId',
	// 		initItem: fieldComboMMvjnscover,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 					error: "Field ComboMMvjnscover tidak boleh kosong.");
	// 				klaimmvpoliscrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMMvjnscover = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 					error: "Field ComboMMvjnscover tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	// Widget buildFieldMmvjnscoverId() {
	// 	return ReusableComboBox<ComboMMvjnscoverModel>(
	// 		hintText: 'Coverage',
	// 		comboKey: comboMMvjnscoverKey,
	// 		initItem: fieldComboMMvjnscover,
	// 		isEnabled: isPolisJps ? false : true,
	// 		dataLoader: () {
	// 			return ComboMMvjnscoverRepository().getComboMMvjnscover();
	// 		},
	// 		enableSearch: false,
	// 		displayText: (item) => item.coverName,
	// 		compareItems: (item, selectedItem) =>
	// 		item.mmvjnscoverId == selectedItem.mmvjnscoverId,
	// 		onChangedCallback: (value) {
	// 			if (value != null) {
	// 				removeError(
	// 						error: "Jenis Cover tidak boleh kosong.");
	// 				klaimmvpoliscrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
	// 			}
	// 		},
	// 		onSaveCallback: (value) {
	// 			if (value != null) {
	// 				fieldComboMMvjnscover = value;
	// 			}
	// 		},
	// 		validatorCallback: (value) {
	// 			if (value == null) {
	// 				addError(
	// 						error: "Jenis Cover tidak boleh kosong.");
	// 			}
	// 		},
	// 	);
	// }

	Widget buildFieldMmvjnscoverId() => ReusableComboBox<ComboMMvjnscoverModel>(
		hintText: "Jenis Cover",
		initItem: fieldComboMMvjnscover,
		dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
		displayText: (i) => i.coverName,
		compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
		validatorCallback: (value) {
			if (value == null) {
				addError(
						error: "Jenis Cover tidak boleh kosong.");
			}
		},
		onChangedCallback: (value) {
			if (value != null) {
				removeError(
						error: "Jenis Cover tidak boleh kosong.");
				fieldComboMMvjnscover = value;
				klaimmvpoliscrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
			}
		},
		onSaveCallback: (value) {
			if (value != null) {
				fieldComboMMvjnscover = value;
			}
		},
	);

	Widget buildFieldNoChasis(){
		return appTextField(
			label: 'No Chassis',
			controller: fieldNoChasisController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: "No Chasis tidak boleh kosong");
				}
				klaimmvpoliscrudBloc.add(FieldNoChasisChangedEvent(noChasis: value));
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: "No Chasis tidak boleh kosong");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldNoPlat(){
		return appTextField(
			label: 'No Plat',
			controller: fieldNoPlatController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: "No Plat tidak boleh kosong");
				}
				klaimmvpoliscrudBloc.add(FieldNoPlatChangedEvent(noPlat: value));
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: "No Plat tidak boleh kosong");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldPolisAkhir(){
		return AppDateField(
      enabled: isPolisJps ? false : true,
			initialValue: DateTime.tryParse(fieldPolisAkhirController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: "Polis Akhir tidak boleh kosong");
					fieldPolisAkhirController.text = value.toIso8601String();
					klaimmvpoliscrudBloc.add(FieldPolisAkhirChangedEvent(polisAkhir: value));
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: "Polis Akhir tidak boleh kosong");
					return "";
				}
				return null;
			},
			label: 'Sampai',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
		);
	}

	Widget buildFieldPolisMulai(){
		return AppDateField(
      enabled: isPolisJps ? false : true,
			initialValue: DateTime.tryParse(fieldPolisMulaiController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: "Polis Mulai tidak boleh kosong");
					fieldPolisMulaiController.text = value.toIso8601String();
					klaimmvpoliscrudBloc.add(FieldPolisMulaiChangedEvent(polisMulai: value));
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: "Polis Mulai tidak boleh kosong");
					return "";
				}
				return null;
			},
			label: 'Dari',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
		);
	}

	Widget buildFieldPolisNo(){
		return appTextField(
			label: 'No Polis',
      enabled: isPolisJps ? false : true,
			controller: fieldPolisNoController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: "Polis No tidak boleh kosong");
				}
				klaimmvpoliscrudBloc.add(FieldPolisNoChangedEvent(polisNo: value));
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: "Polis No tidak boleh kosong");
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldSppa1Id(){
		return appTextField(
			label: 'ID SPPA',
      enabled: false,
			controller: fieldSppa1IdController,
			onChanged: (value) {
				if (value.isNotEmpty) {
				removeError(error: kStringNullError);
				}
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
