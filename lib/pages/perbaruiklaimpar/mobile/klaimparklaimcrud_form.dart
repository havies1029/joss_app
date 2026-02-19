import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:joss_app/widgets/combobox/combomjenisrugi_widget.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KlaimparklaimcrudFormPage extends StatefulWidget {
	final String cobGroupId;
	final String viewMode;
	final String recordId;

	const KlaimparklaimcrudFormPage({super.key, required this.viewMode, required this.recordId, required this.cobGroupId});

	@override
	KlaimparklaimcrudFormPageFormState createState() => KlaimparklaimcrudFormPageFormState();
}

class KlaimparklaimcrudFormPageFormState extends State<KlaimparklaimcrudFormPage> {
	late KlaimparklaimcrudBloc klaimparklaimcrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldDolController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldKeteranganController = TextEditingController();
	var fieldLaporAsuransiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldLaporJpsController = TextEditingController(text: DateTime.now().toIso8601String());
	ComboMJenisrugiModel? fieldComboMJenisrugi;
	final comboMJenisrugiKey = GlobalKey<DropdownSearchState<ComboMJenisrugiModel>>();
	var fieldPenyebabController = TextEditingController();
	var fieldPicEmailController = TextEditingController();
	var fieldPicJabatanController = TextEditingController();
	var fieldPicNamaController = TextEditingController();
	var fieldPicTelpController = TextEditingController();
	var isPolisJps = false;
	var fieldCobNamaController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimparklaimcrudBloc = BlocProvider.of<KlaimparklaimcrudBloc>(context);
		return BlocConsumer<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
								key: _formKey,
								child: Column(
									children: [
										const SizedBox(height: 10),
										if (widget.cobGroupId == "10003") buildFieldCobNama(),
										buildFieldDol(),
										buildFieldLaporJps(),
										buildFieldLaporAsuransi(),
										buildFieldPicNama(),
										buildFieldPicJabatan(),
										buildFieldPicEmail(),
										buildFieldPicTelp(),
										buildFieldMjenisrugiId(),
										buildFieldPenyebab(),
										buildFieldKeterangan(),
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
						fieldDolController.text = state.record!.dol.toIso8601String();
						fieldKeteranganController.text = state.record!.keterangan;
						fieldLaporAsuransiController.text = state.record!.laporAsuransi.toIso8601String();
						fieldLaporJpsController.text = state.record!.laporJps.toIso8601String();
						fieldPenyebabController.text = state.record!.penyebab;
						fieldPicEmailController.text = state.record!.picEmail;
						fieldPicJabatanController.text = state.record!.picJabatan;
						fieldPicNamaController.text = state.record!.picNama;
						fieldPicTelpController.text = state.record!.picTelp;
						isPolisJps = state.record!.isPolisJps;
						fieldCobNamaController.text = state.record!.cobNama;
					}
					fieldComboMJenisrugi = state.comboMJenisrugi;
				}
			},
		);
	}
	void loadData() {
		if (widget.viewMode == "ubah") {
			klaimparklaimcrudBloc.add(
					KlaimparklaimcrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCobNama() {
		return TextFormField(
				enabled: false,
				controller: fieldCobNamaController,
				decoration: const InputDecoration(
					labelText: "Nama COB",
					floatingLabelBehavior: FloatingLabelBehavior.always,
				)
		);
	}

	Widget buildFieldDol(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldDolController.text),
			decoration: const InputDecoration(
				labelText: "Tanggal Kejadian (DOL)",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldDolController.text = value.toIso8601String();
					klaimparklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
				}

			},
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldKeterangan(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 3,
			maxLines: 10,
			controller: fieldKeteranganController,
			decoration: const InputDecoration(
				labelText: "Keterangan",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldKeteranganChangedEvent(keterangan: value));
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

	Widget buildFieldLaporAsuransi(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
			decoration: const InputDecoration(
				labelText: "Lapor Asuransi",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldLaporAsuransiController.text = value.toIso8601String();
					klaimparklaimcrudBloc.add(FieldLaporAsuransiChangedEvent(laporAsuransi: value));
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldLaporJps(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldLaporJpsController.text),
			decoration: const InputDecoration(
				labelText: "Tgl Lapor JPS",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldLaporJpsController.text = value.toIso8601String();
					klaimparklaimcrudBloc.add(FieldLaporJpsChangedEvent(laporJps: value));
				}
			},
			validator: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
		);
	}

	Widget buildFieldMjenisrugiId(){
		return buildFieldComboMJenisrugi(
			comboKey: comboMJenisrugiKey,
			labelText: 'Jenis Kerugian',
			initItem: fieldComboMJenisrugi,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(
							error: "Field ComboMJenisrugi tidak boleh kosong.");
					klaimparklaimcrudBloc.add(ComboMJenisrugiChangedEvent(comboMJenisrugi: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMJenisrugi = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(
							error: "Field ComboMJenisrugi tidak boleh kosong.");
				}
			},
		);
	}

	Widget buildFieldPenyebab(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 2,
			maxLines: 5,
			controller: fieldPenyebabController,
			decoration: const InputDecoration(
				labelText: "Penyebab",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldPenyebabChangedEvent(penyebab: value));
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

	Widget buildFieldPicEmail(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldPicEmailController,
			decoration: const InputDecoration(
				labelText: "Email PIC",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldPicEmailChangedEvent(picEmail: value));
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

	Widget buildFieldPicJabatan(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldPicJabatanController,
			decoration: const InputDecoration(
				labelText: "Jabatan PIC",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldPicJabatanChangedEvent(picJabatan: value));
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

	Widget buildFieldPicNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldPicNamaController,
			decoration: const InputDecoration(
				labelText: "Nama PIC",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldPicNamaChangedEvent(picNama: value));
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

	Widget buildFieldPicTelp(){
		return TextFormField(
			controller: fieldPicTelpController,
			decoration: const InputDecoration(
				labelText: "Telp PIC",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
				klaimparklaimcrudBloc.add(FieldPicTelpChangedEvent(picTelp: value));
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
