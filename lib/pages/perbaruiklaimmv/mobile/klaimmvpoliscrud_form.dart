import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/plat_nomor_formatter.dart';
import 'package:joss_app/repositories/combobox/combominsurer_repository.dart';
import 'package:joss_app/repositories/combobox/combommvjnscover_repository.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/models/combobox/combominsurer_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../blocs/gen_regmv/polis_tanggal_bloc.dart';
import '../../../blocs/gen_regmv/polis_tanggal_event.dart';
import '../../../blocs/gen_regmv/polis_tanggal_state.dart';
import '../../../common/rangka_no_formatter.dart';

class KlaimmvpoliscrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final GlobalKey<FormState> formKey;

	const KlaimmvpoliscrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		required this.formKey,
	});

	@override
	KlaimmvpoliscrudFormPageFormState createState() =>
			KlaimmvpoliscrudFormPageFormState();
}

class KlaimmvpoliscrudFormPageFormState
		extends State<KlaimmvpoliscrudFormPage> {
	late KlaimmvpoliscrudBloc klaimmvpoliscrudBloc;

	final fieldInsuredNamaController = TextEditingController();
	final fieldLaporAsuransiController =
	TextEditingController(text: DateTime.now().toIso8601String());
	final fieldNoChasisController = TextEditingController();
	final fieldNoPlatController = TextEditingController();
	final fieldPolisNoController = TextEditingController();
	final fieldSppa1IdController = TextEditingController();

	ComboMInsurerModel? fieldComboMInsurer;
	final comboMInsurerKey = GlobalKey<DropdownSearchState<ComboMInsurerModel>>();

	ComboMMvjnscoverModel? fieldComboMMvjnscover;
	final comboMMvjnscoverKey =
	GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();

	bool isPolisJps = false;

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
		Future.delayed(const Duration(milliseconds: 500), loadData);
	}

	@override
	void dispose() {
		fieldInsuredNamaController.dispose();
		fieldLaporAsuransiController.dispose();
		fieldNoChasisController.dispose();
		fieldNoPlatController.dispose();
		fieldPolisNoController.dispose();
		fieldSppa1IdController.dispose();
		super.dispose();
	}

	bool runFullValidation() {
		final ok = validateForm();
		widget.formKey.currentState?.validate();
		return ok;
	}

	bool validateForm() {
		clearErrsByPrefix('form.');

		bool ok = true;

		final insuredNama = fieldInsuredNamaController.text.trim();
		if (insuredNama.isEmpty) {
			setErr('form.insuredNama', 'Nama Tertanggung tidak boleh kosong');
			ok = false;
		}

		final laporAsuransi =
		DateTime.tryParse(fieldLaporAsuransiController.text.trim());
		if (!isPolisJps && laporAsuransi == null) {
			setErr('form.laporAsuransi', 'Lapor Asuransi tidak boleh kosong');
			ok = false;
		}

		final noPlat = fieldNoPlatController.text.trim();
		if (noPlat.isEmpty) {
			setErr('form.noPlat', 'No Plat tidak boleh kosong');
			ok = false;
		}

		final noChasis = fieldNoChasisController.text.trim();
		if (noChasis.isEmpty) {
			setErr('form.noChasis', 'No Chasis tidak boleh kosong');
			ok = false;
		}

		if (!isPolisJps && fieldComboMInsurer == null) {
			setErr('form.minsurerId', 'Asuransi tidak boleh kosong.');
			ok = false;
		}

		final polisNo = fieldPolisNoController.text.trim();
		if (!isPolisJps && polisNo.isEmpty) {
			setErr('form.polisNo', 'Polis No tidak boleh kosong');
			ok = false;
		}

		if (!isPolisJps && fieldComboMMvjnscover == null) {
			setErr('form.mmvjnscoverId', 'Jenis Cover tidak boleh kosong.');
			ok = false;
		}

		final sppa1Id = fieldSppa1IdController.text.trim();
		if (isPolisJps && sppa1Id.isEmpty) {
			setErr('form.sppa1Id', kStringNullError);
			ok = false;
		}

		final polisTanggalState = context.read<PolisTanggalBloc>().state;

		if (!isPolisJps && polisTanggalState.mulai == null) {
			setErr('form.polisMulai', 'Polis Mulai tidak boleh kosong');
			ok = false;
		}

		if (!isPolisJps && polisTanggalState.berakhir == null) {
			setErr('form.polisBerakhir', 'Polis Akhir tidak boleh kosong');
			ok = false;
		}

		return ok;
	}

	void loadData() {
		if (widget.viewMode == "ubah") {
			klaimmvpoliscrudBloc
					.add(KlaimmvpoliscrudLihatEvent(recordId: widget.recordId));
		}

		WidgetsBinding.instance.addPostFrameCallback((_) {
			final now = DateTime.now();
			final today = DateTime(now.year, now.month, now.day);

			context.read<PolisTanggalBloc>().add(PolisMulaiChanged(today));
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
										Flexible(child: buildFieldPolisBerakhir()),
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
								const SizedBox(height: hPadding),
							],
						),
					),
				);
			},
			listener: (context, state) {
				if (state.isLoaded) {
					if (state.record != null) {
						fieldInsuredNamaController.text = state.record!.insuredNama;
						fieldLaporAsuransiController.text =
								state.record!.laporAsuransi.toIso8601String();
						fieldNoChasisController.text = state.record!.noChasis;
						fieldNoPlatController.text = state.record!.noPlat;
						fieldPolisNoController.text = state.record!.polisNo;
						fieldSppa1IdController.text = state.record!.sppa1Id;

						final mulai = state.record!.polisMulai;
						context.read<PolisTanggalBloc>().add(PolisMulaiChanged(mulai));
					}

					fieldComboMInsurer = state.comboMInsurer;
					fieldComboMMvjnscover = state.comboMMvjnscover;
					isPolisJps = state.record?.isPolisJps ?? false;
				}
			},
			buildWhen: (previous, current) => previous.isLoaded != current.isLoaded,
			listenWhen: (previous, current) => previous.isLoaded != current.isLoaded,
		);
	}

	Widget buildFieldInsuredNama() {
		return appTextField(
			label: 'Tertanggung',
			enabled: !isPolisJps,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			errorText: err('form.insuredNama'),
			validator: (_) => err('form.insuredNama'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.insuredNama');
				}
				klaimmvpoliscrudBloc
						.add(FieldInsuredNamaChangedEvent(insuredNama: value));
			},
		);
	}

	Widget buildFieldLaporAsuransi() {
		return AppDateField(
			label: 'Tanggal ke Asuransi',
			lastDate: DateTime(2100),
			firstDate: DateTime(2000),
			enabled: !isPolisJps,
			initialValue: DateTime.tryParse(fieldLaporAsuransiController.text),
			validator: (_) => err('form.laporAsuransi'),
			// errorText: err('form.laporAsuransi'),
			onChanged: (value) {
				if (value != null) {
					clearErr('form.laporAsuransi');
					fieldLaporAsuransiController.text = value.toIso8601String();
					klaimmvpoliscrudBloc
							.add(FieldLaporAsuransiChangedEvent(laporAsuransi: value));
				}
			},
		);
	}

	Widget buildFieldMinsurerId() {
		return ReusableComboBox<ComboMInsurerModel>(
			hintText: 'Asuransi',
			comboKey: comboMInsurerKey,
			initItem: fieldComboMInsurer,
			isEnabled: !isPolisJps,
			dataLoaderWithFilter: (filter) {
				return ComboMInsurerRepository().getComboMInsurer(filter);
			},
			dataLoader: () {
				return ComboMInsurerRepository().getComboMInsurer("");
			},
			displayText: (item) => item.insurerNama,
			compareItems: (item, selectedItem) =>
			item.minsurerId == selectedItem.minsurerId,
			errorText: err('form.minsurerId'),
			validatorCallback: (_) => err('form.minsurerId'),
			onChangedCallback: (value) {
				if (isPolisJps) return;
				fieldComboMInsurer = value;

				if (value != null) {
					clearErr('form.minsurerId');
					klaimmvpoliscrudBloc
							.add(ComboMInsurerChangedEvent(comboMInsurer: value));
				}
			},
			onSaveCallback: (value) {
				fieldComboMInsurer = value;
			},
		);
	}

	Widget buildFieldMmvjnscoverId() {
		return ReusableComboBox<ComboMMvjnscoverModel>(
			hintText: "Jenis Cover",
			comboKey: comboMMvjnscoverKey,
			isEnabled: !isPolisJps,
			initItem: fieldComboMMvjnscover,
			dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
			displayText: (i) => i.coverName,
			compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,
			errorText: err('form.mmvjnscoverId'),
			validatorCallback: (_) => err('form.mmvjnscoverId'),
			onChangedCallback: (value) {
				if (isPolisJps) return;
				fieldComboMMvjnscover = value;

				if (value != null) {
					clearErr('form.mmvjnscoverId');
					klaimmvpoliscrudBloc.add(
						ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
					);
				}
			},
			onSaveCallback: (value) {
				fieldComboMMvjnscover = value;
			},
		);
	}

	Widget buildFieldNoChasis() {
		return appTextField(
			label: 'No Rangka',
			controller: fieldNoChasisController,
			inputFormatters: [
				RangkaNoFormatter(),
			],
			errorText: err('form.noChasis'),
			validator: (_) => err('form.noChasis'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.noChasis');
				}
				klaimmvpoliscrudBloc.add(FieldNoChasisChangedEvent(noChasis: value));
			},
		);
	}

	Widget buildFieldNoPlat() {
		return appTextField(
			label: 'No Plat',
			controller: fieldNoPlatController,
			inputFormatters: [
				PlatNomorFormatter(),
			],
			errorText: err('form.noPlat'),
			validator: (_) => err('form.noPlat'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.noPlat');
				}
				klaimmvpoliscrudBloc.add(FieldNoPlatChangedEvent(noPlat: value));
			},
		);
	}

	Widget buildFieldPolisMulai() {
		return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
			buildWhen: (prev, curr) => prev.mulai != curr.mulai,
			builder: (context, state) {
				final today = DateTime(
					DateTime.now().year,
					DateTime.now().month,
					DateTime.now().day,
				);

				return AppDateField(
					label: 'Tanggal Mulai',
					initialValue: state.mulai,
					firstDate: today,
					lastDate: DateTime(2100),
					enabled: !isPolisJps,
					// errorText: err('form.polisMulai'),
					validator: (_) => err('form.polisMulai'),
					onChanged: (dt) {
						if (dt == null) return;
						clearErr('form.polisMulai');
						context.read<PolisTanggalBloc>().add(PolisMulaiChanged(dt));
						klaimmvpoliscrudBloc
								.add(FieldPolisMulaiChangedEvent(polisMulai: dt));
					},
				);
			},
		);
	}

	Widget buildFieldPolisBerakhir() {
		return BlocBuilder<PolisTanggalBloc, PolisTanggalState>(
			buildWhen: (prev, curr) => prev.berakhir != curr.berakhir,
			builder: (context, state) {
				return AppDateField(
					key: ValueKey(state.berakhir.toIso8601String()),
					label: 'Tanggal Berakhir',
					enabled: !isPolisJps,
					initialValue: state.berakhir,
					firstDate: DateTime(2000),
					lastDate: DateTime(2100),
					// errorText: err('form.polisBerakhir'),
					validator: (_) => err('form.polisBerakhir'),
					onChanged: (dt) {
						if (dt == null) return;
						clearErr('form.polisBerakhir');
						klaimmvpoliscrudBloc
								.add(FieldPolisAkhirChangedEvent(polisAkhir: dt));
					},
				);
			},
		);
	}

	Widget buildFieldPolisNo() {
		return appTextField(
			label: 'No Polis',
			enabled: !isPolisJps,
			controller: fieldPolisNoController,
			errorText: err('form.polisNo'),
			validator: (_) => err('form.polisNo'),
			onChanged: (value) {
				if (isPolisJps) return;
				if (value.trim().isNotEmpty) {
					clearErr('form.polisNo');
				}
				klaimmvpoliscrudBloc.add(FieldPolisNoChangedEvent(polisNo: value));
			},
		);
	}

	Widget buildFieldSppa1Id() {
		return appTextField(
			label: 'ID SPPA',
			enabled: false,
			controller: fieldSppa1IdController,
			errorText: err('form.sppa1Id'),
			validator: (_) => err('form.sppa1Id'),
			onChanged: (value) {
				if (value.trim().isNotEmpty) {
					clearErr('form.sppa1Id');
				}
			},
		);
	}
}