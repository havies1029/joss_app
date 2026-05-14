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

import '../../../widgets/apptheme/dropdown2.dart';

class KlaimmvklaimcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimmvklaimcrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		required this.formKey,
	});

	@override
	KlaimmvklaimcrudFormPageFormState createState() =>
			KlaimmvklaimcrudFormPageFormState();
}

class KlaimmvklaimcrudFormPageFormState
		extends State<KlaimmvklaimcrudFormPage> {
	late KlaimmvklaimcrudBloc klaimmvklaimcrudBloc;

	ComboRMatauangModel? fieldComboRMatauang;
	final comboRMatauangKey =
	GlobalKey<DropdownSearchState<ComboRMatauangModel>>();

	final fieldDolController =
	TextEditingController(text: DateTime.now().toIso8601String());
	final fieldKlaimAmountController = TextEditingController();
	final fieldKlaimBayarController = TextEditingController();
	final fieldKronologisController = TextEditingController();

	final Map<String, String?> fieldErrors = {};

	String? err(String key) => fieldErrors[key];

	void setErr(String key, String? msg) {
		setState(() {
			fieldErrors[key] = msg;
		});
	}

	void clearErr(String key) {
		if (!fieldErrors.containsKey(key)) return;
		setState(() {
			fieldErrors.remove(key);
		});
	}

	void clearErrsByPrefix(String prefix) {
		setState(() {
			fieldErrors.removeWhere((k, _) => k.startsWith(prefix));
		});
	}

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	void dispose() {
		fieldDolController.dispose();
		fieldKlaimAmountController.dispose();
		fieldKlaimBayarController.dispose();
		fieldKronologisController.dispose();
		super.dispose();
	}

	bool runFullValidation() {
		final ok = validateForm();
		widget.formKey.currentState?.validate();
		return ok;
	}

	bool validateForm() {
		final newErrors = <String, String?>{};
		bool ok = true;

		// final dol = DateTime.tryParse(fieldDolController.text.trim());
		// if (dol == null) {
		// 	newErrors['form.dol'] = 'Tanggal Kejadian tidak boleh kosong';
		// 	ok = false;
		// }

		final amount = parseAmount(fieldKlaimAmountController.text);
		if (amount <= 0) {
			newErrors['form.klaimAmount'] = 'Nilai Tagihan harus lebih besar dari 0';
			ok = false;
		}

		final kronologis = fieldKronologisController.text.trim();
		if (kronologis.isEmpty) {
			newErrors['form.kronologis'] = 'Kronologis Kejadian tidak boleh kosong';
			ok = false;
		}

		setState(() {
			fieldErrors
				..removeWhere((k, _) => k.startsWith('form.'))
				..addAll(newErrors);
		});

		return ok;
	}

	@override
	Widget build(BuildContext context) {
		klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);

		return BlocConsumer<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Form(
						key: widget.formKey,
						child: Column(
							children: [
								buildFieldDol(),
								const SizedBox(height: hPadding),
								buildFieldKronologis(),
								const SizedBox(height: hPadding),
								buildFieldKlaimAmount(),
								const SizedBox(height: hPadding),
								buildFieldKlaimBayar(),
								const SizedBox(height: hPadding),
							],
						),
					),
				);
			},
			listener: (context, state) {
				if (state.isLoaded) {
					setState(() {
						if (state.record != null) {
							fieldDolController.text = state.record!.dol.toIso8601String();
							fieldKlaimAmountController.text =
									NumberFormat("#,###").format(state.record!.klaimAmount);
							fieldKlaimBayarController.text =
									NumberFormat("#,###").format(state.record!.klaimBayar);
							fieldKronologisController.text = state.record!.kronologis;
						}
						fieldComboRMatauang = state.comboRMatauang;
					});
				}
			},
		);
	}

	void loadData() {
		if (widget.viewMode == "ubah") {
			klaimmvklaimcrudBloc.add(
				KlaimmvklaimcrudLihatEvent(recordId: widget.recordId),
			);
		}
	}

	Widget buildFieldCurrId() {
		return buildFieldComboRMatauang(
			comboKey: comboRMatauangKey,
			labelText: 'Mata Uang',
			initItem: fieldComboRMatauang,
			onChangedCallback: (value) {
				if (value != null) {
					klaimmvklaimcrudBloc.add(
						ComboRMatauangChangedEvent(comboRMatauang: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboRMatauang = value;
				}
			},
		);
	}

	Widget buildFieldDol() {
		return AppDateField(
			label: 'Tanggal Kejadian',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldDolController.text),
			validator: (_) => err('form.dol'),
			onChanged: (value) {
				if (value == null) {
					fieldDolController.clear();
					setErr('form.dol', 'Tanggal Kejadian tidak boleh kosong');
					return;
				}

				clearErr('form.dol');
				fieldDolController.text = value.toIso8601String();
				klaimmvklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
			},
		);
	}

	Widget buildFieldKlaimAmount() {
		return AppCurrencyAmountField(
			label: "Nilai Tagihan",
			currency: fieldComboRMatauang,
			errorText: err('form.klaimAmount'),
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

				if (amount > 0) {
					clearErr('form.klaimAmount');
				}
			},
			validator: (_) => err('form.klaimAmount'),
		);
	}

	Widget buildFieldKlaimBayar() {
		return appTextField(
			label: 'Nilai Terbayar',
			enabled: false,
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldKlaimBayarController,
		);
	}

	Widget buildFieldKronologis() {
		return appTextField(
			label: 'Kronologis Kejadian',
			keyboardType: TextInputType.multiline,
			maxLines: 10,
			controller: fieldKronologisController,
			errorText: err('form.kronologis'),
			validator: (_) => err('form.kronologis'),
			onChanged: (value) {
				klaimmvklaimcrudBloc.add(
					FieldKronologisChangedEvent(kronologis: value),
				);

				if (value.trim().isNotEmpty) {
					clearErr('form.kronologis');
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
	final String? errorText;

	const AppCurrencyAmountField({
		super.key,
		required this.label,
		required this.currency,
		required this.onCurrencyChanged,
		required this.amountController,
		required this.onAmountChanged,
		this.validator,
		this.errorText,
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
						border: Border.all(
							color: errorText != null ? Colors.red : sGrey,
						),
					),
					child: Row(
						children: [
							Padding(
								padding: const EdgeInsets.all(5),
								child: SizedBox(
									width: 100,
									child: ReusableComboBoxV2<ComboRMatauangModel>(
										hintText: "",
										initItem: currency,
										loader: (q) => ComboRMatauangRepository().getComboRMatauang(),
										clientSideSearch: true,
										displayText: (m) => m.rmatauangSimbol,
										compareItems: (a, b) => a.rmatauangKode == b.rmatauangKode,
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
				if (errorText != null) ...[
					const SizedBox(height: 6),
					Text(
						errorText!,
						style: const TextStyle(
							color: Colors.red,
							fontSize: 12,
						),
					),
				],
			],
		);
	}
}