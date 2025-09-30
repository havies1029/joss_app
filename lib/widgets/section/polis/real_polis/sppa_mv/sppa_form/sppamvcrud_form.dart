import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_sppamv/sppamvcrud_bloc.dart';
import 'package:joss_app/models/gen_sppamv/sppamvcrud_model.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/widgets/combobox/combommvgrupojk_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:joss_app/models/combobox/combommvmerk_model.dart';
import 'package:joss_app/widgets/combobox/combommvmerk_widget.dart';
import 'package:joss_app/models/combobox/combommvtipe_model.dart';
import 'package:joss_app/widgets/combobox/combommvtipe_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:joss_app/models/combobox/combomwarna_model.dart';
import 'package:joss_app/widgets/combobox/combomwarna_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';
import 'package:string_validator/string_validator.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../../blocs/local_prefs/simulasi_mv_local_cubit.dart';

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
				return Dialog(
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
					child: Container(
						decoration: BoxDecoration(
							color: Colors.white, // ✅ full background putih
							borderRadius: BorderRadius.circular(20),
						),
						child: SingleChildScrollView(
							child: Padding(
								padding: const EdgeInsets.all(20.0),
								child: Form(
									key: _formKey,
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											// Header Title
											const SizedBox(height: 25),

											// Section: Basic Information
											_buildSectionHeader("Informasi Dasar"),
											const SizedBox(height: 16),
											buildFieldSppaTgl(),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldPeriodeMulai(),
												buildFieldPeriodeAkhir(),
											]),

											const SizedBox(height: 24),

											// Section: Insured Information
											_buildSectionHeader("Informasi Tertanggung"),
											const SizedBox(height: 16),
											buildFieldInsuredNama(),
											const SizedBox(height: 12),
											buildFieldInsuredAlamat1(),
											const SizedBox(height: 12),
											buildFieldInsuredAlamat2(),

											const SizedBox(height: 24),

											// Section: Vehicle Information
											_buildSectionHeader("Data Kendaraan", icon: Icons.directions_car),
											const SizedBox(height: 16),
											_buildResponsiveRow([
												buildFieldJenisKendaraan(),
												buildFieldThnBuat(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldJenisCover(),
												buildFieldHarga(),
											]),

											const SizedBox(height: 24),

											// Section: Additional Coverage
											_buildSectionHeader("Perlindungan Tambahan", icon: Icons.security),
											const SizedBox(height: 16),
											_buildCheckboxGrid([
												buildFieldIsEq(),
												buildFieldIsFlood(),
												buildFieldIsSrcc(),
												buildFieldIsTerrorism(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldPad(),
												buildFieldPap(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldPll(),
												buildFieldTpl(),
											]),
											const SizedBox(height: 12),
											buildFieldAw(),

											const SizedBox(height: 24),

											// Section: Coverage Information
											_buildSectionHeader("Informasi Pertanggungan"),
											const SizedBox(height: 16),
											buildFieldWilayah(),
											const SizedBox(height: 12),
											buildFieldTsi(),

											const SizedBox(height: 24),

											// Section: Premium Information
											_buildSectionHeader("Informasi Premi"),
											const SizedBox(height: 16),
											_buildResponsiveRow([
												buildFieldPremi(),
												buildFieldPremiAdd(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldPremiCasco(),
												buildFieldPremiTotal(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldBiayaPolis(),
												buildFieldMaterai(),
											]),

											const SizedBox(height: 24),

											// Section: Vehicle Details
											_buildSectionHeader("Detail Kendaraan"),
											const SizedBox(height: 16),
											_buildResponsiveRow([
												buildFieldMerkKendaraan(),
												buildFieldTipeKendaraan(),
											]),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldWarnaKendaraan(),
												Container(), // Spacer
											]),
											const SizedBox(height: 12),
											buildFieldPolisiNo(),
											const SizedBox(height: 12),
											_buildResponsiveRow([
												buildFieldRangkaNo(),
												buildFieldMesinNo(),
											]),

											const SizedBox(height: 30),
											FormError(errors: errors, key: null),
											const SizedBox(height: 20),

											// Action Buttons
											_buildActionButtons(),
											const SizedBox(height: 20),
										],
									),
								),
							),
						),
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


	// Custom Input Decoration sesuai design
	InputDecoration _buildInputDecoration(String label, {String? prefix, String? suffix}) {
		return InputDecoration(
			labelText: label,
			prefixText: prefix,
			suffixText: suffix,
			floatingLabelBehavior: FloatingLabelBehavior.always,
			border: OutlineInputBorder(
				borderRadius: BorderRadius.circular(8.0),
				borderSide: BorderSide(color: Colors.grey.shade300),
			),
			enabledBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(8.0),
				borderSide: BorderSide(color: Colors.grey.shade300),
			),
			focusedBorder: OutlineInputBorder(
				borderRadius: BorderRadius.circular(8.0),
				borderSide: const BorderSide(color: Color(0xff91C050), width: 2.0),
			),
			filled: true,
			fillColor: Colors.grey.shade50,
			contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
			labelStyle: TextStyle(
				color: Colors.grey.shade700,
				fontSize: 14.0,
				fontWeight: FontWeight.w500,
			),
		);
	}

	Widget _buildSectionHeader(String title, {IconData? icon}) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
			decoration: BoxDecoration(
				color: const Color(0xff91C050).withOpacity(0.1),
				borderRadius: BorderRadius.circular(8.0),
				border: Border.all(color: const Color(0xff91C050).withOpacity(0.3)),
			),
			child: Row(
				children: [
					if (icon != null) ...[
						Icon(
							icon,
							color: const Color(0xff91C050),
							size: 20.0,
						),
						const SizedBox(width: 8.0),
					],
					Text(
						title,
						style: const TextStyle(
							fontSize: 16.0,
							fontWeight: FontWeight.w600,
							color: Color(0xff91C050),
						),
					),
				],
			),
		);
	}

	Widget _buildResponsiveRow(List<Widget> children) {
		return LayoutBuilder(
			builder: (context, constraints) {
				if (constraints.maxWidth < 600) {
					return Column(
						children: children.where((child) => child.runtimeType != Container || (child as Container).child != null).map((child) =>
								Padding(
									padding: const EdgeInsets.only(bottom: 12.0),
									child: child,
								)
						).toList(),
					);
				} else {
					return Row(
						children: children.asMap().entries.map((entry) {
							int index = entry.key;
							Widget child = entry.value;

							if (child.runtimeType == Container && (child as Container).child == null) {
								return Expanded(child: Container());
							}

							return Expanded(
								child: Padding(
									padding: EdgeInsets.only(
										right: index < children.length - 1 ? 12.0 : 0,
									),
									child: child,
								),
							);
						}).toList(),
					);
				}
			},
		);
	}

	Widget _buildCheckboxGrid(List<Widget> checkboxes) {
		return LayoutBuilder(
			builder: (context, constraints) {
				if (constraints.maxWidth < 600) {
					return Column(
						children: checkboxes.map((checkbox) =>
								Padding(
									padding: const EdgeInsets.only(bottom: 8.0),
									child: checkbox,
								)
						).toList(),
					);
				} else {
					return Column(
						children: [
							Row(
								children: [
									Expanded(child: checkboxes[0]),
									const SizedBox(width: 12.0),
									Expanded(child: checkboxes[1]),
								],
							),
							const SizedBox(height: 8.0),
							Row(
								children: [
									Expanded(child: checkboxes[2]),
									const SizedBox(width: 12.0),
									Expanded(child: checkboxes[3]),
								],
							),
						],
					);
				}
			},
		);
	}

	Widget _buildActionButtons() {
		return LayoutBuilder(
			builder: (context, constraints) {
				final isMobile = constraints.maxWidth < 600;
				final buttonWidth = isMobile ? double.infinity : constraints.maxWidth * 0.4;

				return isMobile
						? Column(
					children: [
						SizedBox(
							width: buttonWidth,
							height: 50,
							child: ElevatedButton(
								onPressed: () => Navigator.pop(context),
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.grey[600],
									foregroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8.0),
									),
								),
								child: const Text('Batal'),
							),
						),
						const SizedBox(height: 12),
						SizedBox(
							width: buttonWidth,
							height: 50,
							child: ElevatedButton(
								onPressed: onSaveForm,
								style: ElevatedButton.styleFrom(
									backgroundColor: const Color(0xff91C050),
									foregroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8.0),
									),
								),
								child: const Text('Simpan'),
							),
						),
					],
				)
						: Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						SizedBox(
							width: buttonWidth,
							height: 50,
							child: ElevatedButton(
								onPressed: () => Navigator.pop(context),
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.grey[600],
									foregroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8.0),
									),
								),
								child: const Text('Batal'),
							),
						),
						SizedBox(
							width: buttonWidth,
							height: 50,
							child: ElevatedButton(
								onPressed: onSaveForm,
								style: ElevatedButton.styleFrom(
									backgroundColor: const Color(0xff91C050),
									foregroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8.0),
									),
								),
								child: const Text('Simpan'),
							),
						),
					],
				);
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
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header (pisah dari field)
				const Text(
					"Tanggal SPPA",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				DateTimeFormField(
					mode: DateTimeFieldPickerMode.date,
					dateFormat: DateFormat('dd/MM/yyyy'),
					initialValue: DateTime.tryParse(fieldSppaTglController.text),
					decoration: InputDecoration(
						hintText: "-- Pilih Tanggal --",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
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
				),
			],
		);
	}


	Widget buildFieldPeriodeMulai() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Periode Mulai",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				DateTimeFormField(
					mode: DateTimeFieldPickerMode.date,
					dateFormat: DateFormat('dd/MM/yyyy'),
					initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
					decoration: InputDecoration(
						hintText: "-- Pilih Tanggal --",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
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
				),
			],
		);
	}

	Widget buildFieldPeriodeAkhir() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Periode Akhir",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				DateTimeFormField(
					mode: DateTimeFieldPickerMode.date,
					dateFormat: DateFormat('dd/MM/yyyy'),
					initialValue: DateTime.tryParse(fieldPeriodeAkhirController.text),
					decoration: InputDecoration(
						hintText: "-- Pilih Tanggal --",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
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
				),
			],
		);
	}

// Personal Information Fields
	Widget buildFieldInsuredNama() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Nama Tertanggung",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					controller: fieldInsuredNamaController,
					decoration: InputDecoration(
						hintText: "Masukkan nama tertanggung",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
				),
			],
		);
	}


	Widget buildFieldInsuredAlamat1() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Alamat Tertanggung 1",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.multiline,
					minLines: 1,
					maxLines: 3,
					controller: fieldInsuredAlamat1Controller,
					decoration: InputDecoration(
						hintText: "Masukkan alamat tertanggung",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldInsuredAlamat2() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Alamat Tertanggung 2",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.multiline,
					minLines: 1,
					maxLines: 3,
					controller: fieldInsuredAlamat2Controller,
					decoration: InputDecoration(
						hintText: "Masukkan alamat tertanggung (opsional)",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
					),
					onChanged: (value) {
						if (value.isNotEmpty) {
							removeError(error: kStringNullError);
						}
					},
				),
			],
		);
	}

	// Vehicle Information Fields
	Widget buildFieldJenisKendaraan() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Jenis Kendaraan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMMvgrupOjk(
					comboKey: comboMMvgrupOjkKey,
					labelText: '', // ❌ jangan pakai label di dalam field
					initItem: fieldComboMMvgrupOjk,
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
						}
					},
				),
			],
		);
	}

	Widget buildFieldThnBuat() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Tahun Pembuatan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				TextFormField(
					controller: fieldThnBuatController,
					readOnly: true,
					decoration: InputDecoration(
						hintText: "-- Pilih Tahun --",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding:
						const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
					validator: (value) {
						if (value == null || value.isEmpty) {
							addError(error: kStringNullError);
							return "";
						}
						return null;
					},
					onTap: () async {
						final currentYear = DateTime.now().year;
						final selected = await showDatePicker(
							context: context,
							initialDate: DateTime(currentYear),
							firstDate: DateTime(1980),
							lastDate: DateTime(currentYear),
							initialDatePickerMode: DatePickerMode.year,
						);
						if (selected != null) {
							fieldThnBuatController.text = selected.year.toString();
							removeError(error: kStringNullError);
						}
					},
				),
			],
		);
	}

	Widget buildFieldMerkKendaraan() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Merk Kendaraan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMMvmerk(
					comboKey: comboMMvmerkKey,
					labelText: '', // ❌ jangan pakai labelText di dalam field
					initItem: fieldComboMMvmerk,
					onChangedCallback: (value) {
						if (value != null) {
							removeError(error: "Field Merk Kendaraan tidak boleh kosong.");
							sppamvCrudBloc.add(
								ComboMMvmerkChangedEvent(comboMMvmerk: value),
							);
						}
					},
					onSaveCallback: (value) {
						if (value != null) {
							fieldComboMMvmerk = value;
						}
					},
					validatorCallback: (value) {
						if (value == null) {
							addError(error: "Field Merk Kendaraan tidak boleh kosong.");
						}
					},

					// // 🔹 Custom decoration biar konsisten
					// decoration: InputDecoration(
					// 	hintText: "-- Pilih Merk Kendaraan --",
					// 	hintStyle: TextStyle(
					// 		fontFamily: 'Satoshi-Regular',
					// 		fontSize: 15,
					// 		color: const Color(0xFF1C1C1C).withOpacity(0.4),
					// 	),
					// 	enabledBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
					// 	),
					// 	focusedBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
					// 	),
					// 	contentPadding: const EdgeInsets.symmetric(
					// 		vertical: 14,
					// 		horizontal: 12,
					// 	),
					// ),
				),
			],
		);
	}


	Widget buildFieldTipeKendaraan() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Tipe Kendaraan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMMvtipe(
					comboKey: comboMMvtipeKey,
					labelText: '', // ❌ jangan pakai label di dalam field
					initItem: fieldComboMMvtipe,
					onChangedCallback: (value) {
						if (value != null) {
							removeError(error: "Field Tipe Kendaraan tidak boleh kosong.");
							sppamvCrudBloc.add(
								ComboMMvtipeChangedEvent(comboMMvtipe: value),
							);
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
						}
					},

					// // 🔹 Custom decoration biar konsisten
					// decoration: InputDecoration(
					// 	hintText: "-- Pilih Tipe Kendaraan --",
					// 	hintStyle: TextStyle(
					// 		fontFamily: 'Satoshi-Regular',
					// 		fontSize: 15,
					// 		color: const Color(0xFF1C1C1C).withOpacity(0.4),
					// 	),
					// 	enabledBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
					// 	),
					// 	focusedBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
					// 	),
					// 	contentPadding: const EdgeInsets.symmetric(
					// 		vertical: 14,
					// 		horizontal: 12,
					// 	),
					// ),
				),
			],
		);
	}

	Widget buildFieldWarnaKendaraan() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Warna Kendaraan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMWarna(
					comboKey: comboMWarnaKey,
					labelText: '', // ❌ header jangan di dalam field
					initItem: fieldComboMWarna,
					onChangedCallback: (value) {
						if (value != null) {
							removeError(error: "Field Warna Kendaraan tidak boleh kosong.");
							sppamvCrudBloc.add(
								ComboMWarnaChangedEvent(comboMWarna: value),
							);
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
						}
					},

					// // 🔹 Custom decoration konsisten
					// decoration: InputDecoration(
					// 	hintText: "-- Pilih Warna Kendaraan --",
					// 	hintStyle: TextStyle(
					// 		fontFamily: 'Satoshi-Regular',
					// 		fontSize: 15,
					// 		color: const Color(0xFF1C1C1C).withOpacity(0.4),
					// 	),
					// 	enabledBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
					// 	),
					// 	focusedBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
					// 	),
					// 	contentPadding: const EdgeInsets.symmetric(
					// 		vertical: 14,
					// 		horizontal: 12,
					// 	),
					// ),
				),
			],
		);
	}

	Widget buildFieldHarga() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Harga Kendaraan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldHargaController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan harga kendaraan",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldPolisiNo() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Nomor Polisi",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					controller: fieldPolisiNoController,
					decoration: InputDecoration(
						hintText: "Masukkan nomor polisi",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}


	Widget buildFieldRangkaNo() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Nomor Rangka",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					controller: fieldRangkaNoController,
					decoration: InputDecoration(
						hintText: "Masukkan nomor rangka",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldMesinNo() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Nomor Mesin",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					controller: fieldMesinNoController,
					decoration: InputDecoration(
						hintText: "Masukkan nomor mesin",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	// Coverage Information Fields
	Widget buildFieldWilayah() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Wilayah",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMWilayah(
					comboKey: comboMWilayahKey,
					labelText: '', // ❌ header jangan di dalam field
					initItem: fieldComboMWilayah,
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
						}
					},

					// // 🔹 Dekorasi konsisten
					// decoration: InputDecoration(
					// 	hintText: "-- Pilih Wilayah --",
					// 	hintStyle: TextStyle(
					// 		fontFamily: 'Satoshi-Regular',
					// 		fontSize: 15,
					// 		color: const Color(0xFF1C1C1C).withOpacity(0.4),
					// 	),
					// 	enabledBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
					// 	),
					// 	focusedBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
					// 	),
					// 	contentPadding: const EdgeInsets.symmetric(
					// 		vertical: 14,
					// 		horizontal: 12,
					// 	),
					// ),
				),
			],
		);
	}
	Widget buildFieldJenisCover() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Jenis Cover",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field (Combo)
				buildFieldComboMMvjnscover(
					comboKey: comboMMvjnscoverKey,
					labelText: '', // ❌ jangan pakai label di dalam field
					initItem: fieldComboMMvjnscover,
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
						}
					},

					// // 🔹 Custom decoration konsisten
					// decoration: InputDecoration(
					// 	hintText: "-- Pilih Jenis Cover --",
					// 	hintStyle: TextStyle(
					// 		fontFamily: 'Satoshi-Regular',
					// 		fontSize: 15,
					// 		color: const Color(0xFF1C1C1C).withOpacity(0.4),
					// 	),
					// 	enabledBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
					// 	),
					// 	focusedBorder: OutlineInputBorder(
					// 		borderRadius: BorderRadius.circular(8),
					// 		borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
					// 	),
					// 	contentPadding: const EdgeInsets.symmetric(
					// 		vertical: 14,
					// 		horizontal: 12,
					// 	),
					// ),
				),
			],
		);
	}

	Widget buildFieldTsi() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Total Sum Insured (TSI)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldTsiController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan nilai TSI",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	// Premium Information Fields
	Widget buildFieldPremi() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Premi",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPremiController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan premi",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldPremiAdd() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Premi Tambahan",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPremiAddController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan premi tambahan",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldPremiCasco() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Premi Casco",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPremiCascoController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan premi casco",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldPremiTotal() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Total Premi",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPremiTotalController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan total premi",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}

	Widget buildFieldBiayaPolis() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// 🔹 Header
				const Text(
					"Biaya Polis",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				// 🔹 Field
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldBiayaPolisController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan biaya polis",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(
							vertical: 14,
							horizontal: 12,
						),
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
				),
			],
		);
	}
	Widget buildFieldMaterai() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Materai",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldMateraiController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan materai",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding:
						const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
				),
			],
		);
	}

	Widget buildFieldAw() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Authorized Workshop",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldAwController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan persentase",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						suffixText: "%",
						suffixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding:
						const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
				),
			],
		);
	}

	Widget buildFieldPad() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"PA Driver",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPadController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan PA Driver",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding:
						const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
				),
			],
		);
	}

	Widget buildFieldPap() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Passenger Liability",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),
				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPapController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan passenger liability",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding:
						const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
				),
			],
		);
	}

	Widget buildFieldPll() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Public Liability (PLL)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldPllController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan nilai PLL",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
					onChanged: (value) {
						if (value.isNotEmpty) removeError(error: kStringNullError);
					},
					validator: (value) {
						if (value == null || value.isEmpty) {
							addError(error: kStringNullError);
							return "";
						}
						return null;
					},
				),
			],
		);
	}


	Widget buildFieldTpl() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					"Third Party Liability (TPL)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 16,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				const SizedBox(height: 8),

				TextFormField(
					keyboardType: TextInputType.number,
					inputFormatters: [ThousandsSeparatorInputFormatter()],
					controller: fieldTplController,
					textAlign: TextAlign.left,
					decoration: InputDecoration(
						hintText: "Masukkan nilai TPL",
						hintStyle: TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							color: const Color(0xFF1C1C1C).withOpacity(0.4),
						),
						prefixText: "IDR ",
						prefixStyle: const TextStyle(
							fontFamily: 'Satoshi-Regular',
							fontSize: 15,
							fontWeight: FontWeight.w500,
							color: Color(0xFF1C1C1C),
						),
						enabledBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 1.2),
						),
						focusedBorder: OutlineInputBorder(
							borderRadius: BorderRadius.circular(8),
							borderSide: const BorderSide(color: Color(0xFF91C050), width: 2),
						),
						contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
					),
					onChanged: (value) {
						if (value.isNotEmpty) removeError(error: kStringNullError);
					},
					validator: (value) {
						if (value == null || value.isEmpty) {
							addError(error: kStringNullError);
							return "";
						}
						return null;
					},
				),
			],
		);
	}


	// Checkbox Fields for Additional Coverage with Custom Design
	Widget buildFieldIsEq() {
		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(8.0),
				border: Border.all(color: const Color(0xFF91C050), width: 1.2),
				color: Colors.white,
			),
			child: CheckboxListTile(
				title: const Text(
					"EQ (Gempa)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 15,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				value: _isEq,
				onChanged: (value) {
					setState(() {
						_isEq = value ?? false;
					});
				},
				activeColor: const Color(0xff91C050),
				checkColor: Colors.white,
				contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
				controlAffinity: ListTileControlAffinity.leading,
			),
		);
	}

	Widget buildFieldIsFlood() {
		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(8.0),
				border: Border.all(color: const Color(0xFF91C050), width: 1.2),
				color: Colors.white,
			),
			child: CheckboxListTile(
				title: const Text(
					"Flood (Banjir)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 15,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				value: _isFlood,
				onChanged: (value) {
					setState(() {
						_isFlood = value ?? false;
					});
				},
				activeColor: const Color(0xff91C050),
				checkColor: Colors.white,
				contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
				controlAffinity: ListTileControlAffinity.leading,
			),
		);
	}

	Widget buildFieldIsSrcc() {
		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(8.0),
				border: Border.all(color: const Color(0xFF91C050), width: 1.2),
				color: Colors.white,
			),
			child: CheckboxListTile(
				title: const Text(
					"SRCC (Kerusuhan)",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 15,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				value: _isSrcc,
				onChanged: (value) {
					setState(() {
						_isSrcc = value ?? false;
					});
				},
				activeColor: const Color(0xff91C050),
				checkColor: Colors.white,
				contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
				controlAffinity: ListTileControlAffinity.leading,
			),
		);
	}

	Widget buildFieldIsTerrorism() {
		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(8.0),
				border: Border.all(color: const Color(0xFF91C050), width: 1.2),
				color: Colors.white,
			),
			child: CheckboxListTile(
				title: const Text(
					"Terrorism",
					style: TextStyle(
						fontFamily: 'Satoshi-Regular',
						fontSize: 15,
						fontWeight: FontWeight.w500,
						color: Color(0xFF1C1C1C),
					),
				),
				value: _isTerrorism,
				onChanged: (value) {
					setState(() {
						_isTerrorism = value ?? false;
					});
				},
				activeColor: const Color(0xff91C050),
				checkColor: Colors.white,
				contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
				controlAffinity: ListTileControlAffinity.leading,
			),
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

	// Helper method untuk boolean parsing
	bool toBoolean(String value) {
		return value.toLowerCase() == 'true';
	}
}