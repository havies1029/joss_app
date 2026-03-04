import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KlaimmvklaimcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
  final GlobalKey<FormState> formKey; 

	const KlaimmvklaimcrudFormPage({super.key, required this.viewMode, required this.recordId, required this.formKey});

	@override
	KlaimmvklaimcrudFormPageFormState createState() => KlaimmvklaimcrudFormPageFormState();
}

class KlaimmvklaimcrudFormPageFormState extends State<KlaimmvklaimcrudFormPage> {
	late KlaimmvklaimcrudBloc klaimmvklaimcrudBloc;
	final List<String> errors = [];
	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey = GlobalKey<DropdownSearchState<ComboRMatauangModel>>();
	var fieldDolController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldKlaimAmountController = TextEditingController();
	var fieldKlaimBayarController = TextEditingController();
	var fieldKronologisController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);
		return BlocConsumer<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
							key: widget.formKey,
							child: Column(
								children: [
									const SizedBox(height: 10),
									buildFieldCurrId(),
									buildFieldDol(),
									buildFieldKlaimAmount(),
									buildFieldKlaimBayar(),
									buildFieldKronologis(),
									const SizedBox(height: 25),
									
								],
							)),
					),
				);
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldDolController.text = state.record!.dol.toIso8601String();
							fieldKlaimAmountController.text = NumberFormat("#,###").format(state.record!.klaimAmount);
							fieldKlaimBayarController.text = NumberFormat("#,###").format(state.record!.klaimBayar);
							fieldKronologisController.text = state.record!.kronologis;
						}
						fieldComboRMatauang = state.comboRMatauang;
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaimmvklaimcrudBloc.add(
			KlaimmvklaimcrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldCurrId(){
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'currId',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					
					klaimmvklaimcrudBloc.add(ComboRMatauangChangedEvent(comboRMatauang: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRMatauang = value;
				}
			},
			
		);
	}

	Widget buildFieldDol(){
		return DateTimeFormField(
			mode: DateTimeFieldPickerMode.date,
			dateFormat: DateFormat('dd/MM/yyyy'),
			initialValue: DateTime.tryParse(fieldDolController.text),
			decoration: const InputDecoration(
				labelText: "dol",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value != null) {
          klaimmvklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
				}
			},
			
		);
	}

	Widget buildFieldKlaimAmount(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimAmountController,
			decoration: const InputDecoration(
				labelText: "klaimAmount",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				final amount = parseAmount(value);
        klaimmvklaimcrudBloc.add(FieldKlaimAmountChangedEvent(klaimAmount: amount));
			},			
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldKlaimBayar(){
		return TextFormField(
      enabled: false,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimBayarController,
			decoration: const InputDecoration(
				labelText: "klaimBayar",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
		
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldKronologis(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 5,
			maxLines: 10,
			controller: fieldKronologisController,
			decoration: const InputDecoration(
				labelText: "kronologis",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),
			onChanged: (value) {
				if (value.isNotEmpty) {
				  klaimmvklaimcrudBloc.add(FieldKronologisChangedEvent(kronologis: value));
				}
			},
			
		);
	}

double parseAmount(String s) {
  final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), ''); // buang koma/spasi/dll
  if (cleaned.isEmpty) return 0;
  return double.tryParse(cleaned) ?? 0;
}


}
