import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_endors/endors1crud_bloc.dart';
import 'package:joss_app/models/gen_endors/endors1crud_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:date_field/date_field.dart';


class Endors1CrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;
	final dynamic? data;
	final String? pageTitle;

	const Endors1CrudFormPage({
		super.key,
		required this.viewMode,
		required this.recordId,
		this.data,
		this.pageTitle,
	});


	@override
	Endors1CrudFormPageFormState createState() => Endors1CrudFormPageFormState();
}

class Endors1CrudFormPageFormState extends State<Endors1CrudFormPage> {
	late Endors1CrudBloc endors1CrudBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldEndorsTglController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldInsuredNamaController = TextEditingController();
	var fieldMstsendorsIdController = TextEditingController();
	var fieldNoteKonfirmasiController = TextEditingController();
	var fieldNotePerubahanController = TextEditingController();
	var fieldPeriodeAkhirController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPeriodeMulaiController = TextEditingController(text: DateTime.now().toIso8601String());
	var fieldPremiController = TextEditingController();
	var fieldSppa1IdController = TextEditingController();
	var fieldStatusEndorsController = TextEditingController();
	var fieldTsiController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();

			if (widget.viewMode == "tambah" && widget.data != null) {
				final data = widget.data;

				try {
					final dataMap = data is Map<String, dynamic> ? data : data.toJson();

					debugPrint("🟢 [Endors1Crud] dataMap: $dataMap");

					setState(() {
						// ✅ deteksi otomatis jenis aset
						final sppaId = dataMap["asetParId"] ??
								dataMap["asetMvId"] ??
								dataMap["asethealthId"] ??
								dataMap["asetHullId"] ??
								dataMap["asetId"] ?? '';

						fieldSppa1IdController.text = sppaId.toString();

						debugPrint("✅ [Endors1Crud] Auto-fill berhasil:");
						debugPrint("   - sppa1Id: ${fieldSppa1IdController.text}");
					});

				} catch (e) {
					debugPrint("❌ [Endors1Crud] Gagal auto-fill endorsement: $e");
					debugPrint("❌ [Endors1Crud] Stack trace: ${StackTrace.current}");
				}
			} else {
				debugPrint("⚠️ [Endors1Crud] Auto-fill dilewati - viewMode: ${widget.viewMode}, data null: ${widget.data == null}");
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		endors1CrudBloc = BlocProvider.of<Endors1CrudBloc>(context);
		return BlocConsumer<Endors1CrudBloc, Endors1CrudState>(
			builder: (context, state) {
				return BaseBackgroundSidePage(
						title: '${widget.pageTitle ?? "Form Endorse"} Polis',
						child: SingleChildScrollView(
							child: Container(
								color: secondaryBlackColor,
								padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
								child: Form(
										key: _formKey,
										child: Column(
											children: [
												const SizedBox(height: 25),
												// buildFieldEndorsTgl(),
												// const SizedBox(height: 10),
												// buildFieldInsuredNama(),
												// const SizedBox(height: 10),
												// buildFieldMstsendorsId(),
												// const SizedBox(height: 10),
												// buildFieldNoteKonfirmasi(),
												// const SizedBox(height: 10),
												buildFieldNotePerubahan(),
												// const SizedBox(height: 10),
												// buildFieldPeriodeAkhir(),
												// const SizedBox(height: 10),
												// buildFieldPeriodeMulai(),
												// const SizedBox(height: 10),
												// buildFieldPremi(),
												// const SizedBox(height: 10),
												// buildFieldSppa1Id(),
												// const SizedBox(height: 10),
												// buildFieldStatusEndors(),
												// const SizedBox(height: 10),
												// buildFieldTsi(),
												const SizedBox(height: 25),

												AppButton.primary(
													text: 'Save',
													backgroundColor: primaryColor,
													onPressed: () {
														_showPengajuanDialog(context);
													},
												),
												const SizedBox(height: 10),
												AppButton.primary(
													text: 'Close',
													backgroundColor: hintGrey,
													onPressed: _dismissDialog,
												),
											],
										)),
							),
						));
			},
				listener: (context, state) async {
					if (state.isSaved && !state.hasFailure) {
						debugPrint("✅ [UI] Endorse berhasil disimpan, update status polis → Diproses");

						// 🔹 Setelah ubah status, tutup form dan refresh detail polis
						if (context.mounted) {
							Navigator.pop(context, true); // true → artinya butuh refresh
						}
					}
				}
		);
	}

	void loadData() {
		if (widget.viewMode == "ubah") {
			endors1CrudBloc.add(
					Endors1CrudLihatEvent(recordId: widget.recordId));
		} else {
		}
	}

	Widget buildFieldEndorsTgl(){
		return AppDateField(
			label: 'Tanggal endorse', firstDate: DateTime(2000), // batas awal biar valid
			lastDate: DateTime(2100),
			initialValue: DateTime.tryParse(fieldEndorsTglController.text),
			onChanged: (value) {
				if (value != null) {
					debugPrint("🔵 [Endors1Crud] endorsTgl changed: $value");
					removeError(error: kStringNullError);
					fieldEndorsTglController.text = value.toIso8601String();
				}
			},
		);
	}

	Widget buildFieldInsuredNama(){
		return appTextField(
			keyboardType: TextInputType.multiline,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			label: 'Insured Name',
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldMstsendorsId(){
		return appTextField(
			controller: fieldMstsendorsIdController,label:'MstendorseID',
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldNoteKonfirmasi(){
		return appTextField(
			keyboardType: TextInputType.multiline,
			label: 'Note Konfirmasi',
			maxLines: 3,
			controller: fieldNoteKonfirmasiController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
		);
	}

	Widget buildFieldNotePerubahan() {
		return appTextField(
			label: "Catatan Perubahan",
			controller: fieldNotePerubahanController,
			keyboardType: TextInputType.multiline,
			maxLines: 8,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			},
			validator: (value) {
				if (value == null || value.isEmpty) {
					addError(error: kStringNullError);
					return "Catatan perubahan wajib diisi";
				}
				return null;
			},
		);
	}

	Widget buildFieldPeriodeAkhir(){
		return AppDateField(
			label: 'Periode Akhir', firstDate: DateTime(2000), // batas awal biar valid
			lastDate: DateTime(2100),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPeriodeAkhirController.text = value.toIso8601String();
				}
			},
		);
	}

	Widget buildFieldPeriodeMulai(){
		return AppDateField(
			initialValue: DateTime.tryParse(fieldPeriodeMulaiController.text),
			onChanged: (value) {
				if (value != null) {
					removeError(error: kStringNullError);
					fieldPeriodeMulaiController.text = value.toIso8601String();
				}
			}, label: 'Periode Mulai', firstDate: DateTime(2000), // batas awal biar valid
			lastDate: DateTime(2100),
		);
	}

	Widget buildFieldPremi(){
		return appTextField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			}, label: 'Premi',
		);
	}

	Widget buildFieldSppa1Id(){
		return appTextField(
			controller: fieldSppa1IdController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			}, label: 'SPPA ID',
		);
	}

	Widget buildFieldStatusEndors(){
		return appTextField(
			controller: fieldStatusEndorsController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			}, label: 'Status Endorse',
		);
	}

	Widget buildFieldTsi(){
		return appTextField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldTsiController,
			onChanged: (value) {
				if (value.isNotEmpty) {
					removeError(error: kStringNullError);
				}
			}, label: 'TSI',
		);
	}

	void _showPengajuanDialog(BuildContext context) {
		showDialog(
			context: context,
			barrierDismissible: true,
			builder: (context) {
				return Dialog(
					backgroundColor: formGrey,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(10),
					),
					child: Padding(
						padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								// 🔹 Icon atas
								const Icon(
									Icons.info_outline_rounded,
									color: Colors.white,
									size: 40,
								),
								const SizedBox(height: 12),

								// 🔹 Pesan
								Text(
									"Pengajuan diproses tim internal.",
									textAlign: TextAlign.center,
									style: headingStyle(context,
										fontSize: 17.49,
									),
								),
								const SizedBox(height: 12),

								AppButton.primary(
									text: 'Ajukan Sekarang',
										backgroundColor: const Color(0xFF0ED7FF),
									onPressed: onSaveForm
								),

							],
						),
					),
				);
			},
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		debugPrint("🟢 [Endors1Crud] onSaveForm() called");
		debugPrint("🟢 [Endors1Crud] Form validation started...");

		if (_formKey.currentState!.validate()) {
			debugPrint("✅ [Endors1Crud] Form validation passed");
			_formKey.currentState!.save();

			try {
				Endors1CrudModel record = Endors1CrudModel(
					endorsTgl: DateTime.parse(fieldEndorsTglController.text),
					endors1Id: '',
					insuredNama: fieldInsuredNamaController.text,
					mstsendorsId: fieldMstsendorsIdController.text,
					noteKonfirmasi: fieldNoteKonfirmasiController.text,
					notePerubahan: fieldNotePerubahanController.text,
					periodeAkhir: DateTime.parse(fieldPeriodeAkhirController.text),
					periodeMulai: DateTime.parse(fieldPeriodeMulaiController.text),

					// ✅ gunakan konversi aman
					premi: _safeDouble(fieldPremiController.text),
					sppa1Id: fieldSppa1IdController.text,
					statusEndors: fieldStatusEndorsController.text,
					tsi: _safeDouble(fieldTsiController.text),
				);


				debugPrint("✅ [Endors1Crud] Record created:");
				debugPrint("   - sppa1Id: ${record.sppa1Id}");

				if (widget.viewMode == "tambah") {
					debugPrint("🟢 [Endors1Crud] Dispatching Tambah event");
					endors1CrudBloc.add(Endors1CrudTambahEvent(record: record));
				} else if (widget.viewMode == "ubah") {
					record.endors1Id = endors1CrudBloc.state.record!.endors1Id;
					debugPrint("🟢 [Endors1Crud] Dispatching Ubah event - ID: ${record.endors1Id}");
					endors1CrudBloc.add(Endors1CrudUbahEvent(record: record));
				}

				_dismissDialog();
				debugPrint("✅ [Endors1Crud] Save completed successfully");

			} catch (e) {
				debugPrint("❌ [Endors1Crud] Error saving record: $e");
				debugPrint("❌ [Endors1Crud] Stack trace: ${StackTrace.current}");
			}
		} else {
			debugPrint("❌ [Endors1Crud] Form validation failed");
			debugPrint("❌ [Endors1Crud] Errors: $errors");
		}
	}

	void addError({required String error}) {
		if (!errors.contains(error)){
			setState(() {
				errors.add(error);
			});
			debugPrint("⚠️ [Endors1Crud] Error added: $error");
		}
	}

	void removeError({required String error}) {
		if (errors.contains(error)){
			setState(() {
				errors.remove(error);
			});
			debugPrint("✅ [Endors1Crud] Error removed: $error");
		}
	}
}
double _safeDouble(String? text) {
	if (text == null) return 0;
	final clean = text.replaceAll(',', '').trim();
	if (clean.isEmpty) return 0;
	return double.tryParse(clean) ?? 0;
}
