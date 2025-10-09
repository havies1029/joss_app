import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/models/gen_sppamv/sppamvcrud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../../blocs/local_prefs/simulasi_mv_local_cubit.dart';
import '../../../../../../repositories/combobox/combommvgrupojk_repository.dart';
import '../../../../../../repositories/combobox/combommvjnscover_repository.dart';
import '../../../../../../repositories/combobox/combommvmerk_repository.dart';
import '../../../../../../repositories/combobox/combommvtipe_repository.dart';
import '../../../../../../repositories/combobox/combomwarna_repository.dart';
import '../../../../../../repositories/combobox/combomwilayah_repository.dart';

class SppamvFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const SppamvFormPage({
		super.key,
		required this.viewMode,
		required this.recordId
	});

	@override
	SppamvFormPageState createState() => SppamvFormPageState();
}

class SppamvFormPageState extends State<SppamvFormPage> {
	late SppamvCrudBloc sppamvCrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];

	// Text Controllers - Personal Info
	var fieldInsuredNamaController = TextEditingController();
	var fieldInsuredAlamat1Controller = TextEditingController();
	var fieldInsuredAlamat2Controller = TextEditingController();

	// Text Controllers - Vehicle Info
	var fieldPolisiNoController = TextEditingController();
	var fieldRangkaNoController = TextEditingController();
	var fieldMesinNoController = TextEditingController();
	var fieldThnBuatController = TextEditingController();
	var fieldHargaController = TextEditingController();

	// Text Controllers - Premium & Coverage
	var fieldPremiController = TextEditingController();
	var fieldPremiAddController = TextEditingController();
	var fieldPremiCascoController = TextEditingController();
	var fieldPremiTotalController = TextEditingController();
	var fieldTsiController = TextEditingController();
	var fieldBiayaPolisController = TextEditingController();
	var fieldMateraiController = TextEditingController();

	// Text Controllers - Coverage Details
	var fieldAwController = TextEditingController();
	var fieldPadController = TextEditingController();
	var fieldPapController = TextEditingController();
	var fieldPllController = TextEditingController();
	var fieldTplController = TextEditingController();

	// Date Controllers
	var fieldSppaTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());

	// Boolean Controllers for Checkboxes
	bool _isTerrorism = false;
	bool _isEq = false;
	bool _isFlood = false;
	bool _isSrcc = false;

	// Combo Box Models and Keys
	ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
	final comboMMvgrupOjkKey = GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();

	ComboMMvjnscoverModel? fieldComboMMvjnscover;
	final comboMMvjnscoverKey = GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();

	ComboMMvmerkModel? fieldComboMMvmerk;
	final comboMMvmerkKey = GlobalKey<DropdownSearchState<ComboMMvmerkModel>>();

	ComboMMvtipeModel? fieldComboMMvtipe;
	final comboMMvtipeKey = GlobalKey<DropdownSearchState<ComboMMvtipeModel>>();

	ComboMWilayahModel? fieldComboMWilayah;
	final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();

	ComboMWarnaModel? fieldComboMWarna;
	final comboMWarnaKey = GlobalKey<DropdownSearchState<ComboMWarnaModel>>();

	@override
	void initState() {
		super.initState();

		Future.delayed(Duration.zero, () {
			final simul = context.read<SimulasiMvLocalCubit>().state;

			// Text
			fieldThnBuatController.text = simul.thnBuat?.toString() ?? '';
			fieldHargaController.text = simul.harga?.toString() ?? '';
			fieldAwController.text = simul.aw?.toString() ?? '';
			fieldPadController.text = simul.pad?.toString() ?? '';
			fieldPapController.text = simul.pap?.toString() ?? '';
			fieldPllController.text = simul.pll?.toString() ?? '';
			fieldTplController.text = simul.tpl?.toString() ?? '';

			// Checkbox values
			_isEq = simul.isEq ?? false;
			_isFlood = simul.isFlood ?? false;
			_isSrcc = simul.isSrcc ?? false;
			_isTerrorism = simul.isTerrorism ?? false;

			// Combo model assignment
			if (simul.mvgrupOjk != null) {
				comboMMvgrupOjkKey.currentState?.changeSelectedItem(simul.mvgrupOjk!); // langsung String
			}
			if (simul.mvjnscover != null) {
				comboMMvjnscoverKey.currentState?.changeSelectedItem(simul.mvjnscover!); // langsung String
			}
			if (simul.wilayah != null) {
				comboMWilayahKey.currentState?.changeSelectedItem(simul.wilayah!); // langsung String
			}
		});

		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	void dispose() {
		fieldThnBuatController.dispose();
		fieldHargaController.dispose();
		fieldAwController.dispose();
		fieldPadController.dispose();
		fieldPapController.dispose();
		fieldPllController.dispose();
		fieldTplController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		sppamvCrudBloc = BlocProvider.of<SppamvCrudBloc>(context);

		return BlocConsumer<SppamvCrudBloc, SppamvCrudState>(
			builder: (context, state) {
				return Form(
					key: _formKey,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text("Informasi Dasar", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldSppaTgl(),
							buildFieldPeriodeMulai(),
							buildFieldPeriodeAkhir(),

							const SizedBox(height: 24),

							// Section: Insured Information
							Text("Informasi Tertanggung", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldInsuredNama(),
							const SizedBox(height: 12),
							buildFieldInsuredAlamat1(),
							const SizedBox(height: 12),
							buildFieldInsuredAlamat2(),

							const SizedBox(height: 24),

							// Section: Vehicle Information
							Text("Data Kendaraan", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldJenisKendaraan(),
							buildFieldThnBuat(),
							const SizedBox(height: 12),
							buildFieldJenisCover(),
							buildFieldHarga(),

							const SizedBox(height: 24),

							// Section: Additional Coverage
							Text("Perlindungan Tambahan", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldIsEq(),
							buildFieldIsFlood(),
							buildFieldIsSrcc(),
							buildFieldIsTerrorism(),
							const SizedBox(height: 12),
							buildFieldPad(),
							buildFieldPap(),
							const SizedBox(height: 12),
							buildFieldPll(),
							buildFieldTpl(),
							const SizedBox(height: 12),
							buildFieldAw(),

							const SizedBox(height: 24),

							// Section: Coverage Information
							Text("Informasi Pertanggungan", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldWilayah(),
							const SizedBox(height: 12),
							buildFieldTsi(),

							const SizedBox(height: 24),

							// Section: Premium Information
							Text("Informasi Premi", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldPremi(),
							buildFieldPremiAdd(),
							const SizedBox(height: 12),
							buildFieldPremiCasco(),
							buildFieldPremiTotal(),
							const SizedBox(height: 12),
							buildFieldBiayaPolis(),
							buildFieldMaterai(),

							const SizedBox(height: 24),

							// Section: Vehicle Details
							Text("Detail Kendaraan", style: bodyTextStyle(context)),
							const SizedBox(height: 10),
							buildFieldMerkKendaraan(),
							buildFieldTipeKendaraan(),
							const SizedBox(height: 12),
							buildFieldWarnaKendaraan(),
							Container(), // Spacer
							const SizedBox(height: 12),
							buildFieldPolisiNo(),
							const SizedBox(height: 12),
							buildFieldRangkaNo(),
							buildFieldMesinNo(),

							const SizedBox(height: 30),
							FormError(errors: errors, key: null),
							const SizedBox(height: 20),

							// Action Buttons
							AppButton.primary(
								text: 'Batal',
								onPressed: () => Navigator.pop(context),
							),
							AppButton.primary(
								text: 'Simpan',
								onPressed: onSaveForm,
							),
							const SizedBox(height: 20),
						],
					),
				);
			},
			listener: (context, state) {
				if (state.isLoaded) {
					if (state.record != null) {
						// Populate form with existing data
						fieldInsuredNamaController.text = state.record!.insuredNama;
						fieldInsuredAlamat1Controller.text = state.record!.insuredAlamat1;
						fieldInsuredAlamat2Controller.text = state.record!.insuredAlamat2;
						fieldPolisiNoController.text = state.record!.polisiNo;
						fieldRangkaNoController.text = state.record!.rangkaNo;
						fieldMesinNoController.text = state.record!.mesinNo;
						fieldThnBuatController.text = state.record!.thnBuat.toString();
						fieldHargaController.text = NumberFormat("#,###").format(state.record!.harga);
						fieldPremiController.text = NumberFormat("#,###").format(state.record!.premi);
						fieldPremiAddController.text = NumberFormat("#,###").format(state.record!.premiAdd);
						fieldPremiCascoController.text = NumberFormat("#,###").format(state.record!.premiCasco);
						fieldPremiTotalController.text = NumberFormat("#,###").format(state.record!.premiTotal);
						fieldTsiController.text = NumberFormat("#,###").format(state.record!.tsi);
						fieldBiayaPolisController.text = NumberFormat("#,###").format(state.record!.biayaPolis);
						fieldMateraiController.text = NumberFormat("#,###").format(state.record!.materai);
						fieldAwController.text = NumberFormat("#,###").format(state.record!.aw);
						fieldPadController.text = NumberFormat("#,###").format(state.record!.pad);
						fieldPapController.text = NumberFormat("#,###").format(state.record!.pap);
						fieldPllController.text = NumberFormat("#,###").format(state.record!.pll);
						fieldTplController.text = NumberFormat("#,###").format(state.record!.tpl);
						fieldSppaTglController.text = state.record!.sppaTgl.toIso8601String();
						fieldPeriodeMulaiController.text = state.record!.periodeMulai.toIso8601String();
						fieldPeriodeAkhirController.text = state.record!.periodeAkhir.toIso8601String();
						_isEq = state.record!.isEq;
						_isFlood = state.record!.isFlood;
						_isSrcc = state.record!.isSrcc;
						_isTerrorism = state.record!.isTerrorism;
					}
					fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
					fieldComboMMvjnscover = state.comboMMvjnscover;
					fieldComboMMvmerk = state.comboMMvmerk;
					fieldComboMMvtipe = state.comboMMvtipe;
					fieldComboMWilayah = state.comboMWilayah;
					fieldComboMWarna = state.comboMWarna;
				}
			},
		);
	}

	void loadData() {
		if (widget.viewMode == "ubah") {
			sppamvCrudBloc.add(SppamvCrudLihatEvent(recordId: widget.recordId));
		} else if (widget.viewMode == "tambah") {
			// Add init event if needed
		}
	}

	// Date Fields
	Widget buildFieldSppaTgl() {
		return AppDateField(
			label: 'Tanggal SPPA',
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldSppaTglController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldSppaTglController.text = value.toIso8601String();
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


	Widget buildFieldPeriodeMulai() {
		return AppDateField(
			label: "Periode Mulai",
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPeriodeMulaiController.text = value.toIso8601String();
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

	Widget buildFieldPeriodeAkhir() {
		return AppDateField(
			label: "Periode Akhir",
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldPeriodeAkhirController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPeriodeAkhirController.text = value.toIso8601String();
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

// Personal Information Fields
	Widget buildFieldInsuredNama() {
		return appTextField(
			label: "Nama Tertanggung",
			controller: fieldInsuredNamaController,
			keyboardType: TextInputType.name,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldInsuredAlamat1() {
		return appTextField(
			label: "Alamat Tertanggung 1",
			controller: fieldInsuredAlamat1Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "";
				}
				return null;
			},
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldInsuredAlamat2() {
		return appTextField(
			label: "Alamat Tertanggung 2",
			hint: "Masukkan alamat tertanggung (opsional)",
			controller: fieldInsuredAlamat2Controller,
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldJenisKendaraan() {
		return ReusableComboBox<ComboMMvgrupOjkModel>(
			hintText: "Jenis Kendaraan",
			comboKey: comboMMvgrupOjkKey,
			initItem: fieldComboMMvgrupOjk,
			dataLoader: () => ComboMMvgrupOjkRepository().getComboMMvgrupOjk(),
			displayText: (item) => item.grupNama,
			compareItems: (a, b) => a.mmvgrupojkId == b.mmvgrupojkId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Jenis Kendaraan tidak boleh kosong.");
					sppamvCrudBloc.add(
						ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvgrupOjk = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Jenis Kendaraan tidak boleh kosong.");
					return "Field Jenis Kendaraan tidak boleh kosong.";
				}
				return null;
			},
		);
	}

	Widget buildFieldThnBuat() {
		final int currentYear = DateTime.now().year;
		final List<int> tahunList = [
			for (int y = currentYear; y >= 1980; y--) y
		];

		return ReusableComboBox<int>(
			hintText: "Tahun Pembuatan",
			initItem: fieldThnBuatController.text.isNotEmpty
					? int.tryParse(fieldThnBuatController.text)
					: null,
			dataLoader: () async => tahunList,
			displayText: (item) => item.toString(),
			compareItems: (a, b) => a == b,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldThnBuatController.text = value.toString();
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldThnBuatController.text = value.toString();
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: kStringNullError);
					return "Field Tahun Pembuatan tidak boleh kosong.";
				}
				return null;
			},
			enableSearch: false,
		);
	}

	Widget buildFieldMerkKendaraan() {
		return ReusableComboBox<ComboMMvmerkModel>(
			hintText: "Merk Kendaraan",
			comboKey: comboMMvmerkKey,
			initItem: fieldComboMMvmerk,
			dataLoader: () async {
				return await ComboMMvmerkRepository().getComboMMvmerk('');
			},
			displayText: (item) => item.nmMerk,
			compareItems: (a, b) => a.mmvmerkId == b.mmvmerkId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Merk Kendaraan tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvmerkChangedEvent(comboMMvmerk: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) fieldComboMMvmerk = value;
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Merk Kendaraan tidak boleh kosong.");
					return "Field Merk Kendaraan tidak boleh kosong.";
				}
				return null;
			},
			enableSearch: true,
		);
	}

	Widget buildFieldTipeKendaraan() {
		return ReusableComboBox<ComboMMvtipeModel>(
			hintText: "Tipe Kendaraan",
			comboKey: comboMMvtipeKey,
			initItem: fieldComboMMvtipe,
			dataLoader: () async {
				return await ComboMMvtipeRepository().getComboMMvtipe('');
			},
			displayText: (item) => item.nmTipe,
			compareItems: (a, b) => a.mmvtipeId == b.mmvtipeId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Tipe Kendaraan tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMMvtipeChangedEvent(comboMMvtipe: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvtipe = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Tipe Kendaraan tidak boleh kosong.");
					return "Field Tipe Kendaraan tidak boleh kosong.";
				}
				return null;
			},
			enableSearch: true,
		);
	}

	Widget buildFieldWarnaKendaraan() {
		return ReusableComboBox<ComboMWarnaModel>(
			hintText: "Warna Kendaraan",
			comboKey: comboMWarnaKey,
			initItem: fieldComboMWarna,
			dataLoader: () async {
				return await ComboMWarnaRepository().getComboMWarna('');
			},
			displayText: (item) => item.warnaDesc,
			compareItems: (a, b) => a.mwarnaId == b.mwarnaId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Warna Kendaraan tidak boleh kosong.");
					sppamvCrudBloc.add(ComboMWarnaChangedEvent(comboMWarna: value));
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMWarna = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Warna Kendaraan tidak boleh kosong.");
					return "Field Warna Kendaraan tidak boleh kosong.";
				}
				return null;
			},
			enableSearch: true,
		);
	}

	Widget buildFieldHarga() {
		return appTextField(
			label: "Harga Kendaraan",
			controller: fieldHargaController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPolisiNo() {
		return appTextField(
			label: "Nomor Polisi",
			controller: fieldPolisiNoController,
			keyboardType: TextInputType.text,
			textInputAction: TextInputAction.next,
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

	Widget buildFieldRangkaNo() {
		return appTextField(
			label: "Nomor Rangka",
			controller: fieldRangkaNoController,
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

	Widget buildFieldMesinNo() {
		return appTextField(
			label: "Nomor Mesin",
			controller: fieldMesinNoController,
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

	Widget buildFieldWilayah() {
		return ReusableComboBox<ComboMWilayahModel>(
			hintText: "Wilayah",
			comboKey: comboMWilayahKey,
			initItem: fieldComboMWilayah,
			dataLoader: () => ComboMWilayahRepository().getComboMWilayah(),
			displayText: (item) => item.wilayahNama,
			compareItems: (a, b) => a.mwilayahId == b.mwilayahId,
			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Wilayah tidak boleh kosong.");
					sppamvCrudBloc.add(
						ComboMWilayahChangedEvent(comboMWilayah: value),
					);
				}
			},
			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMWilayah = value;
				}
			},
			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Wilayah tidak boleh kosong.");
					return "Field Wilayah tidak boleh kosong.";
				}
				return null;
			},
		);
	}

	Widget buildFieldJenisCover() {
		return ReusableComboBox<ComboMMvjnscoverModel>(
			hintText: "Jenis Cover",
			comboKey: comboMMvjnscoverKey,
			initItem: fieldComboMMvjnscover,
			dataLoader: () => ComboMMvjnscoverRepository().getComboMMvjnscover(),
			displayText: (item) => item.coverName,
			compareItems: (a, b) => a.mmvjnscoverId == b.mmvjnscoverId,

			onChangedCallback: (value) {
				if (value != null) {
					removeError(error: "Field Jenis Cover tidak boleh kosong.");
					sppamvCrudBloc.add(
						ComboMMvjnscoverChangedEvent(comboMMvjnscover: value),
					);
				}
			},

			onSaveCallback: (value) {
				if (value != null) {
					fieldComboMMvjnscover = value;
				}
			},

			validatorCallback: (value) {
				if (value == null) {
					addError(error: "Field Jenis Cover tidak boleh kosong.");
					return "Field Jenis Cover tidak boleh kosong.";
				}
				return null;
			},
		);
	}

	Widget buildFieldTsi() {
		return appTextField(
			label: "Total Sum Insured (TSI)",
			controller: fieldTsiController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	// Premium Information Fields
	Widget buildFieldPremi() {
		return appTextField(
			label: "Premi",
			controller: fieldPremiController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPremiAdd() {
		return appTextField(
			label: "Premi Tambahan",
			controller: fieldPremiAddController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPremiCasco() {
		return appTextField(
			label: "Premi Casco",
			hint: "Masukkan premi casco",
			controller: fieldPremiCascoController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPremiTotal() {
		return appTextField(
			label: "Total Premi",
			controller: fieldPremiTotalController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldBiayaPolis() {
		return appTextField(
			label: "Biaya Polis",
			hint: "Masukkan biaya polis",
			controller: fieldBiayaPolisController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldMaterai() {
		return appTextField(
			label: "Materai",
			controller: fieldMateraiController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldAw() {
		return appTextField(
			label: "Authorized Workshop",
			controller: fieldAwController,
			keyboardType: TextInputType.number,
			suffix: Text("%", style: bodyTextStyle(context)),
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

	Widget buildFieldPad() {
		return appTextField(
			label: "PA Driver",
			controller: fieldPadController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPap() {
		return appTextField(
			label: "Passenger Liability",
			controller: fieldPapController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldPll() {
		return appTextField(
			label: "Public Liability (PLL)",
			controller: fieldPllController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	Widget buildFieldTpl() {
		return appTextField(
			label: "Third Party Liability (TPL)",
			hint: "Masukkan nilai TPL",
			controller: fieldTplController,
			keyboardType: TextInputType.number,
			prefix: Text("IDR | ", style: bodyTextStyle(context)),
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

	// Checkbox Fields for Additional Coverage with Custom Design
	Widget buildFieldIsEq() {
		return CheckboxWidget(
			leftLabel: '',
			rightLabel: 'EQ',
			initialValue: _isEq,
			callback: (value) {
				setState(() {
					_isEq = value;
				});
			},
		);
	}

	Widget buildFieldIsFlood() {
		return CheckboxWidget(
			leftLabel: '',
			rightLabel: 'Flood',
			initialValue: _isFlood,
			callback: (value) {
				setState(() {
					_isFlood = value;
				});
			},
		);
	}

	Widget buildFieldIsSrcc() {
		return CheckboxWidget(
			leftLabel: '',
			rightLabel: 'SRCC (Kerusuhan)',
			initialValue: _isSrcc,
			callback: (value) {
				setState(() {
					_isSrcc = value;
				});
			},
		);
	}

	Widget buildFieldIsTerrorism() {
		return CheckboxWidget(
			leftLabel: '',
			rightLabel: 'Terrorism',
			initialValue: _isTerrorism,
			callback: (value) {
				setState(() {
					_isTerrorism = value;
				});
			},
		);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			SppamvCrudModel record = SppamvCrudModel(
				aw: double.parse(fieldAwController.text.replaceAll(',', '')),
				biayaPolis: double.parse(fieldBiayaPolisController.text.replaceAll(',', '')),
				harga: double.parse(fieldHargaController.text.replaceAll(',', '')),
				insuredAlamat1: fieldInsuredAlamat1Controller.text,
				insuredAlamat2: fieldInsuredAlamat2Controller.text,
				insuredNama: fieldInsuredNamaController.text,
				isEq: _isEq,
				isFlood: _isFlood,
				isSrcc: _isSrcc,
				isTerrorism: _isTerrorism,
				materai: double.parse(fieldMateraiController.text.replaceAll(',', '')),
				mesinNo: fieldMesinNoController.text,
				mmvgrupojkId: fieldComboMMvgrupOjk?.mmvgrupojkId,
				mmvjnscoverId: fieldComboMMvjnscover?.mmvjnscoverId,
				mvmerkId: fieldComboMMvmerk?.mmvmerkId,
				mvtipeId: fieldComboMMvtipe?.mmvtipeId,
				mwilayahId: fieldComboMWilayah?.mwilayahId,
				pad: double.parse(fieldPadController.text.replaceAll(',', '')),
				pap: double.parse(fieldPapController.text.replaceAll(',', '')),
				periodeAkhir: DateTime.parse(fieldPeriodeAkhirController.text),
				periodeMulai: DateTime.parse(fieldPeriodeMulaiController.text),
				pll: double.parse(fieldPllController.text.replaceAll(',', '')),
				polisiNo: fieldPolisiNoController.text,
				premi: double.parse(fieldPremiController.text.replaceAll(',', '')),
				premiAdd: double.parse(fieldPremiAddController.text.replaceAll(',', '')),
				premiCasco: double.parse(fieldPremiCascoController.text.replaceAll(',', '')),
				premiTotal: double.parse(fieldPremiTotalController.text.replaceAll(',', '')),
				rangkaNo: fieldRangkaNoController.text,
				sppaTgl: DateTime.parse(fieldSppaTglController.text),
				sppa1Id: '',
				thnBuat: int.parse(fieldThnBuatController.text),
				tpl: double.parse(fieldTplController.text.replaceAll(',', '')),
				tsi: double.parse(fieldTsiController.text.replaceAll(',', '')),
				warnaId: fieldComboMWarna?.mwarnaId,
			);

			if (widget.viewMode == "tambah") {
				sppamvCrudBloc.add(SppamvCrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.sppa1Id = sppamvCrudBloc.state.record!.sppa1Id;
				sppamvCrudBloc.add(SppamvCrudUbahEvent(record: record));
			}
			Navigator.pop(context);
		}
	}

	void addError({required String error}) {
		if (!errors.contains(error)) {
			setState(() {
				errors.add(error);
			});
		}
	}

	void removeError({required String error}) {
		if (errors.contains(error)) {
			setState(() {
				errors.remove(error);
			});
		}
	}

	bool toBoolean(String value) {
		return value.toLowerCase() == 'true';
	}
}