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

import '../../../common/loading_indicator.dart';
import '../../../common/plat_nomor_formatter.dart';
import '../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../repositories/combobox/combomjenisrugimv_repository.dart';
import '../../../widgets/apptheme/dropdown2.dart';

class KlaimmvklaimcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;
	final String cobGroupId;

	const KlaimmvklaimcrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		required this.formKey,
		required this.cobGroupId,
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
	ComboMJenisrugimvModel? fieldComboMJenisrugimv;
	late Future<List<ComboMJenisrugimvModel>> _futureJenisKerugian;

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

	Future<void> _loadDefaultCurrency() async {
		final currencies = await ComboRMatauangRepository().getComboRMatauang();

		if (!mounted || currencies.isEmpty) return;

		final idrCurrency = currencies.firstWhere(
					(curr) => curr.rmatauangKode == '001' || curr.rmatauangSimbol == 'IDR',
			orElse: () => currencies.first,
		);

		setState(() {
			fieldComboRMatauang = idrCurrency;
		});
	}

	@override
	void initState() {
		super.initState();
		_futureJenisKerugian =
				ComboMJenisrugimvRepository().getComboMJenisrugimv();

		_loadDefaultCurrency();

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
								buildFieldJenisKerugian(),
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
			listener: (context, state) async {
				if (state.isLoaded) {
					ComboMJenisrugimvModel? selectedJenisRugi;

					if (state.record?.mjenisrugimvId?.isNotEmpty == true) {
						final listJenisRugi = await _futureJenisKerugian;

						for (final item in listJenisRugi) {
							if (item.mjenisrugimvId == state.record!.mjenisrugimvId) {
								selectedJenisRugi = item;
								break;
							}
						}
					}

					if (!mounted) return;

					setState(() {
						if (state.record != null) {
							if (state.record!.dol != null) {
								fieldDolController.text = state.record!.dol!.toIso8601String();
							}

							fieldKlaimAmountController.text =
									NumberFormat("#,###").format(state.record!.klaimAmount);

							fieldKlaimBayarController.text =
									NumberFormat("#,###").format(state.record!.klaimBayar);


							fieldKronologisController.text =
									state.record?.kronologis ?? '';

							fieldComboMJenisrugimv = selectedJenisRugi;
						}

						if (state.comboRMatauang != null) {
							fieldComboRMatauang = state.comboRMatauang;
						}
					});
				}
			},
		);
	}

	void loadData() {
		// if (widget.viewMode == "ubah") {
		// 	klaimmvklaimcrudBloc.add(
		// 		KlaimmvklaimcrudLihatEvent(recordId: widget.recordId),
		// 	);
		// }
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

	Widget buildFieldJenisKerugian() {
		return FutureBuilder<List<ComboMJenisrugimvModel>>(
			future: _futureJenisKerugian,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const Center(child: LoadingIndicator());
				}

				if (snapshot.hasError) {
					return Text('Error: ${snapshot.error}');
				}

				final jenisKerugianList = snapshot.data ?? [];

				if (jenisKerugianList.isEmpty) {
					return const Text('Tidak ada data jenis kerugian');
				}

				return FormField<ComboMJenisrugimvModel>(
					initialValue: fieldComboMJenisrugimv,
					validator: (_) => err('form.mjenisrugimvId'),
					builder: (fieldState) {
						return Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'Jenis Kerugian',
									style: bodyTextStyle(
										context,
										fontSize: getResponsiveFont(context, 18),
									),
								),
								const SizedBox(height: hPadding),

								Row(
									children: jenisKerugianList.map((item) {
										final isSelected =
												fieldComboMJenisrugimv?.mjenisrugimvId ==
														item.mjenisrugimvId;

										return Expanded(
											child: GestureDetector(
												onTap: () {
													setState(() {
														fieldComboMJenisrugimv = item;
													});

													fieldState.didChange(item);

													klaimmvklaimcrudBloc.add(
														FieldMjenisrugimvIdChangedEvent(
															mjenisrugimvId: item.mjenisrugimvId,
														),
													);

													clearErr('form.mjenisrugimvId');
												},
												child: Row(
													children: [
														Container(
															width: 20,
															height: 20,
															decoration: BoxDecoration(
																shape: BoxShape.circle,
																border: Border.all(
																	color: isSelected
																			? primaryColor
																			: hintGrey,
																),
															),
															child: isSelected
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
														Flexible(
															child: Text(
																item.jenisrugiNama,
																overflow: TextOverflow.ellipsis,
																style: isSelected
																		? inputTextStyle(context)
																		: bodyTextStyle(context),
															),
														),
													],
												),
											),
										);
									}).toList(),
								),

								if (fieldState.hasError ||
										err('form.mjenisrugimvId') != null)
									Padding(
										padding: const EdgeInsets.only(top: 6),
										child: Text(
											fieldState.errorText ??
													err('form.mjenisrugimvId') ??
													'',
											style: const TextStyle(
												color: pRed,
												fontSize: 12,
											),
										),
									),
							],
						);
					},
				);
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
			inputFormatters: [
				FilteringTextInputFormatter.allow(
					RegExp(r"[0-9a-zA-Z ,./\-#()]"),
				),
			],
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
									textAlign: TextAlign.left,
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