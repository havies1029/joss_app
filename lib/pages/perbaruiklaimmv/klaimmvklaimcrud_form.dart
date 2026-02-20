import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/combobox/combormatauang_model.dart';
import 'package:joss_app/repositories/combobox/combormatauang_repository.dart';
import 'package:joss_app/widgets/combobox/combormatauang_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class KlaimmvklaimcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const KlaimmvklaimcrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	KlaimmvklaimcrudFormPageFormState createState() => KlaimmvklaimcrudFormPageFormState();
}

class KlaimmvklaimcrudFormPageFormState extends State<KlaimmvklaimcrudFormPage> {
	late KlaimmvklaimcrudBloc klaimmvklaimcrudBloc;
	final _formKey = GlobalKey<FormState>();
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
					child:  Form(
							key: _formKey,
							child: Column(
								children: [
									buildFieldDol(),
									const SizedBox(height: hPadding),
									buildFieldKronologis(),
									// const SizedBox(height: hPadding),
									// buildFieldCurrId(),
									const SizedBox(height: hPadding),
									buildFieldKlaimAmount(),
									const SizedBox(height: hPadding),
									buildFieldKlaimBayar(),
									const SizedBox(height: 15),
								],
							)),
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
		return AppDateField(
			label: 'Date Of Accident',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldDolController.text),
			onChanged: (value) {
				if (value != null) {
          klaimmvklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
				}
			},
		);
	}

	// Widget buildFieldKlaimAmount(){
	// 	return TextFormField(
	// 		keyboardType: TextInputType.number,
	// 		inputFormatters: [ThousandsSeparatorInputFormatter()],
	// 		controller: fieldKlaimAmountController,
	// 		decoration: const InputDecoration(
	// 			labelText: "klaimAmount",
	// 			floatingLabelBehavior: FloatingLabelBehavior.always,
	// 		),
	// 		onChanged: (value) {
	// 			final amount = parseAmount(value);
  //       klaimmvklaimcrudBloc.add(FieldKlaimAmountChangedEvent(klaimAmount: amount));
	// 		},
	// 		textAlign: TextAlign.right,
	// 	);
	// }

	Widget buildFieldKlaimAmount() {
		return AppCurrencyAmountField(
			label: "Nilai Tagihan",
			currency: fieldComboRMatauang,
			onCurrencyChanged: (v) {
				setState(() => fieldComboRMatauang = v);
				if (v != null) {
					klaimmvklaimcrudBloc.add(
						ComboRMatauangChangedEvent(comboRMatauang: v),
					);
				}
			},
			amountController: fieldKlaimAmountController,
			onAmountChanged: (rawText) {
				final amount = parseAmount(rawText);
				klaimmvklaimcrudBloc.add(
					FieldKlaimAmountChangedEvent(klaimAmount: amount),
				);
			},
			validator: (v) {
				if (v == null || v.trim().isEmpty) return kStringNullError;
				return null;
			},
		);
	}

	Widget buildFieldKlaimBayar(){
		return appTextField(
			label: 'Nilai Terbayar',
      enabled: false,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimBayarController,
		);
	}

	Widget buildFieldKronologis(){
		return appTextField(
			label: 'Kronologis Kejadian',
			keyboardType: TextInputType.multiline,
			maxLines: 10,
			controller: fieldKronologisController,
			onChanged: (value) {
				if (value.isNotEmpty) {
				  klaimmvklaimcrudBloc.add(FieldKronologisChangedEvent(kronologis: value));
				}
			},
		);
	}

double parseAmount(String s) {
  final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
  if (cleaned.isEmpty) return 0;
  return double.tryParse(cleaned) ?? 0;
}


}

class AppCurrencyAmountField extends StatelessWidget {
	final String label;
	final ComboRMatauangModel? currency;
	final ValueChanged<ComboRMatauangModel?> onCurrencyChanged;

	final TextEditingController amountController;
	final ValueChanged<String> onAmountChanged;
	final FormFieldValidator<String>? validator;

	const AppCurrencyAmountField({
		super.key,
		required this.label,
		required this.currency,
		required this.onCurrencyChanged,
		required this.amountController,
		required this.onAmountChanged,
		this.validator,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(label, style: inputTextStyle(context)),
				const SizedBox(height: 6),

				Container(
					height: 50,
					decoration: BoxDecoration(
						color: formGrey,
						borderRadius: BorderRadius.circular(cardBorderRadius),
						border: Border.all(color: sGrey),
					),
					child: Row(
						children: [
							Padding(
								padding: const EdgeInsets.all(5),
								child: SizedBox(
									width: 100,
									child: ReusableComboBox<ComboRMatauangModel>(
										hintText: "",
										initItem: currency,
										displayText: (m) => m.rmatauangSimbol,
										compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
										dataLoader: () =>
												ComboRMatauangRepository().getComboRMatauang(),
										enableSearch: false,
										onChangedCallback: onCurrencyChanged,
										onSaveCallback: onCurrencyChanged,
										maxHeight: 200,
									),
								),
							),

							Container(width: 1, height: 30, color: sGrey),

							Expanded(
								child: TextFormField(
									controller: amountController,
									keyboardType: TextInputType.number,
									textAlign: TextAlign.right,
									inputFormatters: [
										FilteringTextInputFormatter.digitsOnly,
										ThousandsSeparatorInputFormatter(),
									],
									onChanged: onAmountChanged,
									validator: validator,
									cursorColor: primaryLightColor,
									style: bodyTextStyle(context),
									decoration: const InputDecoration(
										hintText: "0",
										border: InputBorder.none,
										contentPadding:
										EdgeInsets.symmetric(horizontal: 12, vertical: 8),
									),
								),
							),
						],
					),
				),
			],
		);
	}
}
