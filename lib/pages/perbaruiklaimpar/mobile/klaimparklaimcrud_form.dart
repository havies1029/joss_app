import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/repositories/combobox/combomjenisrugi_repository.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/models/combobox/combomjenisrugi_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../helper/indo_phone_result.dart';

class KlaimparklaimcrudFormPage extends StatefulWidget {
	final String cobGroupId;
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimparklaimcrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		required this.cobGroupId,
		required this.formKey,
	});

	@override
	KlaimparklaimcrudFormPageFormState createState() =>
			KlaimparklaimcrudFormPageFormState();
}

class KlaimparklaimcrudFormPageFormState
		extends State<KlaimparklaimcrudFormPage> {
	late KlaimparklaimcrudBloc klaimparklaimcrudBloc;

	final fieldDolController =
	TextEditingController(text: DateTime.now().toIso8601String());
	final fieldKeteranganController = TextEditingController();
	final fieldLaporAsuransiController =
	TextEditingController(text: DateTime.now().toIso8601String());
	final fieldLaporJpsController =
	TextEditingController(text: DateTime.now().toIso8601String());

	ComboMJenisrugiModel? fieldComboMJenisrugi;
	final comboMJenisrugiKey =
	GlobalKey<DropdownSearchState<ComboMJenisrugiModel>>();

	final fieldPenyebabController = TextEditingController();
	final fieldPicEmailController = TextEditingController();
	final fieldPicJabatanController = TextEditingController();
	final fieldPicNamaController = TextEditingController();
	final fieldPicTelpController = TextEditingController();

	bool isPolisJps = false;

	final fieldCobNamaController = TextEditingController();

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

	bool validateForm() {
		clearErrsByPrefix('form.');

		bool ok = true;

		final dol = DateTime.tryParse(fieldDolController.text.trim());
		if (dol == null) {
			setErr('form.dol', kStringNullError);
			ok = false;
		}

		final laporJps = DateTime.tryParse(fieldLaporJpsController.text.trim());
		if (laporJps == null) {
			setErr('form.laporJps', kStringNullError);
			ok = false;
		}

		if (!isPolisJps) {
			final laporAsuransi =
			DateTime.tryParse(fieldLaporAsuransiController.text.trim());
			if (laporAsuransi == null) {
				setErr('form.laporAsuransi', kStringNullError);
				ok = false;
			}
		}

		final picNama = fieldPicNamaController.text.trim();
		if (picNama.isEmpty) {
			setErr('form.picNama', kStringNullError);
			ok = false;
		}

		final picJabatan = fieldPicJabatanController.text.trim();
		if (picJabatan.isEmpty) {
			setErr('form.picJabatan', kStringNullError);
			ok = false;
		}

		final email = fieldPicEmailController.text.trim();
		if (email.isEmpty) {
			setErr('form.picEmail', kEmailNullError);
			ok = false;
		} else if (!emailValidatorRegExp.hasMatch(email)) {
			setErr('form.picEmail', 'Format email tidak valid');
			ok = false;
		}

		final telp = fieldPicTelpController.text.trim();
		if (telp.isEmpty) {
			setErr('form.picTelp', kPhoneNumberNullError);
			ok = false;
		} else {
			final res = IndoPhoneHelper.normalize(telp);
			if (!res.isValid) {
				setErr('form.picTelp', res.error ?? "Nomor HP tidak valid");
				ok = false;
			}
		}

		if (fieldComboMJenisrugi == null) {
			setErr(
				'form.mjenisrugiId',
				"Field ComboMJenisrugi tidak boleh kosong.",
			);
			ok = false;
		}

		final penyebab = fieldPenyebabController.text.trim();
		if (penyebab.isEmpty) {
			setErr('form.penyebab', kStringNullError);
			ok = false;
		}

		final keterangan = fieldKeteranganController.text.trim();
		if (keterangan.isEmpty) {
			setErr('form.keterangan', kStringNullError);
			ok = false;
		}

		return ok;
	}

	bool runFullValidation() {
		final ok = validateForm();
		widget.formKey.currentState?.validate();
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
		fieldDolController.dispose();
		fieldKeteranganController.dispose();
		fieldLaporAsuransiController.dispose();
		fieldLaporJpsController.dispose();
		fieldPenyebabController.dispose();
		fieldPicEmailController.dispose();
		fieldPicJabatanController.dispose();
		fieldPicNamaController.dispose();
		fieldPicTelpController.dispose();
		fieldCobNamaController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		klaimparklaimcrudBloc = BlocProvider.of<KlaimparklaimcrudBloc>(context);

		return BlocConsumer<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Form(
						key: widget.formKey,
						child: Column(
							children: [
								if (widget.cobGroupId == "10003") ...[
									buildFieldCobNama(),
									const SizedBox(height: hPadding),
								],
								Row(
									children: [
										Flexible(child: buildFieldDol()),
										const SizedBox(width: 8),
										Flexible(child: buildFieldLaporJps()),
									],
								),
								const SizedBox(height: hPadding),
								buildFieldLaporAsuransi(),
								const SizedBox(height: hPadding),
								buildFieldPicNama(),
								const SizedBox(height: hPadding),
								buildFieldPicJabatan(),
								const SizedBox(height: hPadding),
								buildFieldPicEmail(),
								const SizedBox(height: hPadding),
								buildFieldPicTelp(),
								const SizedBox(height: hPadding),
								buildFieldMjenisrugiId(),
								const SizedBox(height: hPadding),
								buildFieldPenyebab(),
								const SizedBox(height: hPadding),
								buildFieldKeterangan(),
								const SizedBox(height: hPadding),
							],
						),
					),
				);
			},
			listener: (context, state) {
				if (state.isLoaded) {
					if (state.record != null) {
						fieldDolController.text = state.record!.dol.toIso8601String();
						fieldKeteranganController.text = state.record!.keterangan;
						fieldLaporAsuransiController.text =
								state.record!.laporAsuransi.toIso8601String();
						fieldLaporJpsController.text =
								state.record!.laporJps.toIso8601String();
						fieldPenyebabController.text = state.record!.penyebab;
						fieldPicEmailController.text = state.record!.picEmail;
						fieldPicJabatanController.text = state.record!.picJabatan;
						fieldPicNamaController.text = state.record!.picNama;
						fieldPicTelpController.text =
								IndoPhoneHelper.toDisplay(state.record!.picTelp);
						isPolisJps = state.record?.isPolisJps ?? false;
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
				KlaimparklaimcrudLihatEvent(recordId: widget.recordId),
			);
		}
	}

	Widget buildFieldCobNama() {
		return appTextField(
			label: 'Kategori Asuransi',
			enabled: false,
			controller: fieldCobNamaController,
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
				if (value != null) {
					fieldDolController.text = value.toIso8601String();
					clearErr('form.dol');
					klaimparklaimcrudBloc.add(FieldDolChangedEvent(dol: value));
				}
			},
		);
	}

	Widget buildFieldKeterangan() {
		return appTextField(
			label: 'Keterangan',
			keyboardType: TextInputType.multiline,
			maxLines: 10,
			controller: fieldKeteranganController,
			errorText: err('form.keterangan'),
			validator: (_) => err('form.keterangan'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.keterangan');
				}
				klaimparklaimcrudBloc.add(
					FieldKeteranganChangedEvent(keterangan: value),
				);
			},
		);
	}

	Widget buildFieldLaporAsuransi() {
		return AppDateField(
			label: 'Tanggal ke Asuransi',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			enabled: !isPolisJps,
			initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
			validator: (_) => err('form.laporAsuransi'),
			onChanged: (value) {
				if (value != null) {
					fieldLaporAsuransiController.text = value.toIso8601String();
					clearErr('form.laporAsuransi');
					klaimparklaimcrudBloc.add(
						FieldLaporAsuransiChangedEvent(laporAsuransi: value),
					);
				}
			},
		);
	}

	Widget buildFieldLaporJps() {
		return AppDateField(
			label: 'Tanggal ke JPS',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldLaporJpsController.text),
			validator: (_) => err('form.laporJps'),
			onChanged: (value) {
				if (value != null) {
					fieldLaporJpsController.text = value.toIso8601String();
					clearErr('form.laporJps');
					klaimparklaimcrudBloc.add(
						FieldLaporJpsChangedEvent(laporJps: value),
					);
				}
			},
		);
	}

	Widget buildFieldMjenisrugiId() {
		return ReusableComboBox<ComboMJenisrugiModel>(
			comboKey: comboMJenisrugiKey,
			hintText: 'Jenis Kerugian',
			initItem: fieldComboMJenisrugi,
			dataLoader: () => ComboMJenisrugiRepository().getComboMJenisrugi(),
			displayText: (item) => item.rugiDesc,
			compareItems: (a, b) => a.mjenisrugiId == b.mjenisrugiId,
			errorText: err('form.mjenisrugiId'),
			validatorCallback: (_) => err('form.mjenisrugiId'),
			onChangedCallback: (value) {
				fieldComboMJenisrugi = value;
				if (value != null) {
					clearErr('form.mjenisrugiId');
					klaimparklaimcrudBloc.add(
						ComboMJenisrugiChangedEvent(comboMJenisrugi: value),
					);
				}
			},
			onSaveCallback: (value) {
				fieldComboMJenisrugi = value;
			},
		);
	}

	Widget buildFieldPenyebab() {
		return appTextField(
			label: 'Penyebab Kerugian',
			keyboardType: TextInputType.multiline,
			maxLines: 5,
			controller: fieldPenyebabController,
			errorText: err('form.penyebab'),
			validator: (_) => err('form.penyebab'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.penyebab');
				}
				klaimparklaimcrudBloc.add(
					FieldPenyebabChangedEvent(penyebab: value),
				);
			},
		);
	}

	Widget buildFieldPicEmail() {
		return appTextField(
			label: 'Email',
			controller: fieldPicEmailController,
			keyboardType: TextInputType.emailAddress,
			errorText: err('form.picEmail'),
			validator: (_) => err('form.picEmail'),
			onChanged: (value) {
				final email = value.trim();

				if (email.isEmpty) {
					clearErr('form.picEmail');
				} else if (emailValidatorRegExp.hasMatch(email)) {
					clearErr('form.picEmail');
				} else {
					setErr('form.picEmail', 'Format email tidak valid');
				}

				klaimparklaimcrudBloc.add(
					FieldPicEmailChangedEvent(picEmail: value),
				);
			},
		);
	}

	Widget buildFieldPicJabatan() {
		return appTextField(
			label: 'Jabatan',
			controller: fieldPicJabatanController,
			errorText: err('form.picJabatan'),
			validator: (_) => err('form.picJabatan'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.picJabatan');
				}
				klaimparklaimcrudBloc.add(
					FieldPicJabatanChangedEvent(picJabatan: value),
				);
			},
		);
	}

	Widget buildFieldPicNama() {
		return appTextField(
			label: 'PIC Tertanggung',
			controller: fieldPicNamaController,
			errorText: err('form.picNama'),
			inputFormatters: [
				FilteringTextInputFormatter.allow(
					RegExp(r"[a-zA-Z0-9 .,'-]"),
				),
			],
			validator: (_) => err('form.picNama'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.picNama');
				}
				klaimparklaimcrudBloc.add(
					FieldPicNamaChangedEvent(picNama: value),
				);
			},
		);
	}

	Widget buildFieldPicTelp() {
		return appTextField(
			label: 'No Telp PIC',
			controller: fieldPicTelpController,
			keyboardType: TextInputType.phone,
			prefix: Text(
				"+62 | ",
				style: inputTextStyle(context, color: primaryLightColor),
			),
			errorText: err('form.picTelp'),
			validator: (_) => err('form.picTelp'),
			onChanged: (value) {
				final telp = value.trim();

				if (telp.isEmpty) {
					clearErr('form.picTelp');
				} else {
					final res = IndoPhoneHelper.normalize(telp);
					if (res.isValid) {
						clearErr('form.picTelp');
					} else {
						setErr('form.picTelp', res.error ?? "Nomor HP tidak valid");
					}
				}

				klaimparklaimcrudBloc.add(
					FieldPicTelpChangedEvent(picTelp: value),
				);
			},
		);
	}
}