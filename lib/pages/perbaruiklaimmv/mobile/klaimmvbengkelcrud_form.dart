import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/combobox/combombengkel_repository.dart';
import 'package:joss_app/repositories/combobox/combomjnsbengkel_repository.dart';
import 'package:joss_app/repositories/combobox/combomwilayahbengkel_repository.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvbengkelcrud_model.dart';
import 'package:joss_app/models/combobox/combombengkel_model.dart';
import 'package:joss_app/models/combobox/combomjnsbengkel_model.dart';
import 'package:joss_app/models/combobox/combomwilayahbengkel_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../widgets/apptheme/dropdown2.dart';

class KlaimmvbengkelcrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimmvbengkelcrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		required this.formKey,
	});

	@override
	KlaimmvbengkelcrudFormPageFormState createState() =>
			KlaimmvbengkelcrudFormPageFormState();
}

class KlaimmvbengkelcrudFormPageFormState
		extends State<KlaimmvbengkelcrudFormPage> {
	late KlaimmvbengkelcrudBloc klaimmvbengkelcrudBloc;

	ComboMBengkelModel? fieldComboMBengkel;
	final comboMBengkelKey = GlobalKey<DropdownSearchState<ComboMBengkelModel>>();

	ComboMJnsbengkelModel? fieldComboMJnsbengkel;
	final comboMJnsbengkelKey =
	GlobalKey<DropdownSearchState<ComboMJnsbengkelModel>>();

	ComboMWilayahBengkelModel? fieldComboMWilayahBengkel;
	final comboMWilayahBengkelKey =
	GlobalKey<DropdownSearchState<ComboMWilayahBengkelModel>>();

	final fieldNamaBengkelLainController = TextEditingController();

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

	bool runFullValidation() {
		final ok = validateForm();
		widget.formKey.currentState?.validate();
		return ok;
	}

	bool validateForm() {
		clearErrsByPrefix('form.');

		bool ok = true;

		if (fieldComboMJnsbengkel == null) {
			setErr('form.mjnsbengkelId', 'Field Jenis Bengkel tidak boleh kosong.');
			ok = false;
		}

		final jenisId = fieldComboMJnsbengkel?.mjnsbengkelId;

		if (jenisId == "10") {
			if (fieldComboMWilayahBengkel == null) {
				setErr(
					'form.mwilayahbengkelId',
					'Field Wilayah Bengkel tidak boleh kosong.',
				);
				ok = false;
			}

			if (fieldComboMBengkel == null) {
				setErr('form.mbengkelId', 'Field Nama Bengkel tidak boleh kosong.');
				ok = false;
			}
		}

		if (jenisId == "20") {
			final namaBengkelLain = fieldNamaBengkelLainController.text.trim();
			if (namaBengkelLain.isEmpty) {
				setErr('form.namaBengkelLain', kStringNullError);
				ok = false;
			}
		}

		return ok;
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
		fieldNamaBengkelLainController.dispose();
		super.dispose();
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
								if (fieldComboMJnsbengkel?.mjnsbengkelId == "10")
									const SizedBox(height: hPadding),
								if (fieldComboMJnsbengkel?.mjnsbengkelId == "10")
									buildFieldMbengkelId(),
								if (fieldComboMJnsbengkel?.mjnsbengkelId == "20")
									const SizedBox(height: hPadding),
								if (fieldComboMJnsbengkel?.mjnsbengkelId == "20")
									buildFieldNamaBengkelLain(),
								const SizedBox(height: hPadding),
							],
						),
					),
				);
			},
			listener: (context, state) {
				if (state.isLoaded) {
					if (state.record != null) {
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
				KlaimmvbengkelcrudLihatEvent(recordId: widget.recordId),
			);
		}
	}

	Widget buildFieldMbengkelId() {
		return ReusableComboBoxV2<ComboMBengkelModel>(
			comboKey: comboMBengkelKey,
			hintText: "Nama Bengkel",
			initItem: fieldComboMBengkel,
			params: {
				"mwilayahbengkelId":
				fieldComboMWilayahBengkel?.mwilayahbengkelId ?? '',
			},
			loader: (q) {
				final wilayahId = q.get<String>("mwilayahbengkelId") ?? '';
				return ComboMBengkelRepository().getComboMBengkel(
					wilayahId,
					q.searchText,
				);
			},
			displayText: (item) => item.bengkelNama,
			compareItems: (a, b) => a.mbengkelId == b.mbengkelId,
			enableSearch: true,
			showClearButton: false,
			errorText: err('form.mbengkelId'),
			validatorCallback: (v) => v == null ? kStringNullError : null,
			onChangedCallback: (value) {
				setState(() {
					fieldComboMBengkel = value;
					if (value != null) {
						clearErr('form.mbengkelId');
					}
				});
				if (value != null) {
					klaimmvbengkelcrudBloc.add(
						ComboMBengkelChangedEvent(comboMBengkel: value),
					);
				}
			},
			onSaveCallback: (value) {
				fieldComboMBengkel = value;
			},
		);
	}

	Widget buildFieldMjnsbengkelId() {
		return ReusableComboBoxV2<ComboMJnsbengkelModel>(
			comboKey: comboMJnsbengkelKey,
			hintText: "Jenis Bengkel",
			initItem: fieldComboMJnsbengkel,
			loader: (q) => ComboMJnsbengkelRepository().getComboMJnsbengkel(),
			clientSideSearch: true,
			displayText: (item) => item.jenisNama,
			compareItems: (a, b) => a.mjnsbengkelId == b.mjnsbengkelId,
			errorText: err('form.mjnsbengkelId'),
			validatorCallback: (v) => v == null ? kStringNullError : null,
			onChangedCallback: (value) {
				setState(() {
					fieldComboMJnsbengkel = value;
					comboMBengkelKey.currentState?.clear();
					comboMWilayahBengkelKey.currentState?.clear();
					fieldComboMBengkel = null;
					fieldComboMWilayahBengkel = null;
					fieldNamaBengkelLainController.clear();
					clearErr('form.mjnsbengkelId');
					clearErr('form.mbengkelId');
					clearErr('form.mwilayahbengkelId');
					clearErr('form.namaBengkelLain');
				});
				if (value != null) {
					klaimmvbengkelcrudBloc.add(
						ComboMJnsbengkelChangedEvent(comboMJnsbengkel: value),
					);
				}
			},
			onSaveCallback: (value) {
				fieldComboMJnsbengkel = value;
			},
		);
	}

	Widget buildFieldMwilayahbengkelId() {
		return ReusableComboBoxV2<ComboMWilayahBengkelModel>(
			comboKey: comboMWilayahBengkelKey,
			hintText: "Wilayah Bengkel",
			initItem: fieldComboMWilayahBengkel,
			loader: (q) {
				return ComboMWilayahBengkelRepository()
						.getComboMWilayahBengkel(q.searchText);
			},
			displayText: (item) => item.wilayahNama,
			compareItems: (a, b) =>
			a.mwilayahbengkelId == b.mwilayahbengkelId,
			enableSearch: true,
			showClearButton: false,
			errorText: err('form.mwilayahbengkelId'),
			validatorCallback: (v) => v == null ? kStringNullError : null,
			onChangedCallback: (value) {
				setState(() {
					fieldComboMWilayahBengkel = value;
					comboMBengkelKey.currentState?.clear();
					fieldComboMBengkel = null;
					clearErr('form.mwilayahbengkelId');
					clearErr('form.mbengkelId');
				});
				if (value != null) {
					klaimmvbengkelcrudBloc.add(
						ComboMWilayahBengkelChangedEvent(
							comboMWilayahBengkel: value,
						),
					);
				}
			},
			onSaveCallback: (value) {
				fieldComboMWilayahBengkel = value;
			},
		);
	}

	Widget buildFieldNamaBengkelLain() {
		return appTextField(
			label: "Nama Bengkel Lain",
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			controller: fieldNamaBengkelLainController,
			errorText: err('form.namaBengkelLain'),
			validator: (_) => err('form.namaBengkelLain'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.namaBengkelLain');
				}
				klaimmvbengkelcrudBloc.add(
					FieldNamaBengkelLainChangedEvent(namaBengkelLain: value),
				);
			},
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		final isValid = validateForm();
		widget.formKey.currentState?.validate();

		if (!isValid) return;

		widget.formKey.currentState?.save();

		KlaimmvbengkelcrudModel record = KlaimmvbengkelcrudModel(
			klaim1Id: '',
			mbengkelId: fieldComboMBengkel?.mbengkelId,
			mjnsbengkelId: fieldComboMJnsbengkel?.mjnsbengkelId,
			mwilayahbengkelId: fieldComboMWilayahBengkel?.mwilayahbengkelId,
			namaBengkelLain: fieldNamaBengkelLainController.text,
		);

		if (widget.viewMode == "tambah") {
			klaimmvbengkelcrudBloc.add(
				KlaimmvbengkelcrudTambahEvent(record: record),
			);
		} else if (widget.viewMode == "ubah") {
			record.klaim1Id = klaimmvbengkelcrudBloc.state.record!.klaim1Id;
			klaimmvbengkelcrudBloc.add(
				KlaimmvbengkelcrudUbahEvent(record: record),
			);
		}

		_dismissDialog();
	}
}