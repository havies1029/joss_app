import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
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
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
							key: widget.formKey,
							child: Column(
								children: [
									const SizedBox(height: 10),
                  
									buildFieldPolisMulai(),
									buildFieldPolisAkhir(),
									buildFieldLaporAsuransi(),
									buildFieldInsuredNama(),
									buildFieldNoPlat(),
									buildFieldNoChasis(),
									buildFieldMinsurerId(),
									buildFieldPolisNo(),
									buildFieldMmvjnscoverId(),
                  if (isPolisJps) 
									  buildFieldSppa1Id(),
									const SizedBox(height: 25),
									FormError(
										errors: errors,
										key: null,
									),									
								],
							)),
					),
				);
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldInsuredNamaController.text = state.record!.insuredNama;
							isPolisJps = state.record!.isPolisJps;
							fieldLaporAsuransiController.text = state.record!.laporAsuransi.toIso8601String();
							fieldNoChasisController.text = state.record!.noChasis;
							fieldNoPlatController.text = state.record!.noPlat;
							fieldPolisAkhirController.text = state.record!.polisAkhir.toIso8601String();
							fieldPolisMulaiController.text = state.record!.polisMulai.toIso8601String();
							fieldPolisNoController.text = state.record!.polisNo;
							fieldSppa1IdController.text = state.record!.sppa1Id;
						}
						fieldComboMInsurer = state.comboMInsurer;
						fieldComboMMvjnscover = state.comboMMvjnscover;
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
		return TextFormField(
      enabled: isPolisJps ? false : true,
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			decoration: const InputDecoration(
				labelText: "Nama Tertanggung",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		return DateTimeFormField(
      enabled: isPolisJps ? false : true,
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
			decoration: const InputDecoration(
				labelText: "Lapor Asuransi",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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

	Widget buildFieldMinsurerId(){
		return buildFieldComboMInsurer(     
      enabled: isPolisJps ? false : true,       
			comboKey: comboMInsurerKey,
			labelText: 'Asuransi',
			initItem: fieldComboMInsurer,
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

	Widget buildFieldMmvjnscoverId(){
		return buildFieldComboMMvjnscover(
      enabled: isPolisJps ? false : true,
			comboKey: comboMMvjnscoverKey,
			labelText: 'Jenis Cover',
			initItem: fieldComboMMvjnscover,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
						error: "Jenis Cover tidak boleh kosong.");
					klaimmvpoliscrudBloc.add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvjnscover = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
						error: "Jenis Cover tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldNoChasis(){
		return TextFormField(
			controller: fieldNoChasisController,
			decoration: const InputDecoration(
				labelText: "No Chasis",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		return TextFormField(
			controller: fieldNoPlatController,
			decoration: const InputDecoration(
				labelText: "No Plat",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
      enabled: isPolisJps ? false : true,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPolisAkhirController.text),
			decoration: const InputDecoration(
				labelText: "Polis Akhir",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		);
	}

	Widget buildFieldPolisMulai(){
		return DateTimeFormField(
      enabled: isPolisJps ? false : true,
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldPolisMulaiController.text),
			decoration: const InputDecoration(
				labelText: "Polis Mulai",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		);
	}

	Widget buildFieldPolisNo(){
		return TextFormField(
      enabled: isPolisJps ? false : true,
			controller: fieldPolisNoController,
			decoration: const InputDecoration(
				labelText: "Polis No",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
		return TextFormField(
      enabled: false,
			controller: fieldSppa1IdController,
			decoration: const InputDecoration(
				labelText: "sppa1Id",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
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
