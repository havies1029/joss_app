import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/form_error.dart';
import 'package:joss_app/blocs/gen_regmv/regmv6form_bloc.dart';
import 'package:joss_app/models/gen_regmv/regmv6form_model.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';


class Regmv6FormFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const Regmv6FormFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	Regmv6FormFormPageFormState createState() => Regmv6FormFormPageFormState();
}

class Regmv6FormFormPageFormState extends State<Regmv6FormFormPage> {
	late Regmv6FormBloc regmv6FormBloc;
	final _formKey = GlobalKey<FormState>();
	final List<String> errors = [];
	var fieldDiskonPersenController = TextEditingController();
	var fieldPremiAddController = TextEditingController();
	var fieldPremiAwController = TextEditingController();
	var fieldPremiCascoController = TextEditingController();
	var fieldPremiDiskonController = TextEditingController();
	var fieldPremiEqController = TextEditingController();
	var fieldPremiFloodController = TextEditingController();
	var fieldPremiNetController = TextEditingController();
	var fieldPremiPadController = TextEditingController();
	var fieldPremiPapController = TextEditingController();
	var fieldPremiPllController = TextEditingController();
	var fieldPremiSrccController = TextEditingController();
	var fieldPremiSubtotalController = TextEditingController();
	var fieldPremiTbodController = TextEditingController();
	var fieldPremiTerrorismController = TextEditingController();
	var fieldPremiTjhController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		regmv6FormBloc = BlocProvider.of<Regmv6FormBloc>(context);
		return BlocConsumer<Regmv6FormBloc, Regmv6FormState>(
			builder: (context, state) {
				return Dialog(
					shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
					child: SingleChildScrollView(
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Form(
								key: _formKey,
								child: Column(
									children: [
										const SizedBox(height: 10),
										Text(
											"${widget.viewMode == "tambah" ? "Tambah" : "Ubah"} Hitung Premi",
											style: const TextStyle(
												fontSize: 20.0,
												color: Color(0xffff6101),
												fontWeight: FontWeight.w600,
												fontFamily: 'Hind',
												fontStyle: FontStyle.italic,
												decoration: TextDecoration.underline,
											),
										),
										const SizedBox(height: 25),
										buildFieldDiskonPersen(),
										buildFieldPremiAdd(),
										buildFieldPremiAw(),
										buildFieldPremiCasco(),
										buildFieldPremiDiskon(),
										buildFieldPremiEq(),
										buildFieldPremiFlood(),
										buildFieldPremiNet(),
										buildFieldPremiPad(),
										buildFieldPremiPap(),
										buildFieldPremiPll(),
										buildFieldPremiSrcc(),
										buildFieldPremiSubtotal(),
										buildFieldPremiTbod(),
										buildFieldPremiTerrorism(),
										buildFieldPremiTjh(),
										buildFieldRegmv1Id(),
										const SizedBox(height: 25),
										FormError(
											errors: errors,
											key: null,
										),
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceAround,
											children: [
												SizedBox(
													width: MediaQuery.of(context).size.width * 0.3,
													height: 60,
													child: Padding(
														padding: const EdgeInsets.only(top: 30.0),
														child: ElevatedButton(
															onPressed: () {
																_dismissDialog();
															},
															child: const Text(
																'Close',
																style: TextStyle(fontSize: 13.0),
															),
														),
													),
												),
												SizedBox(
													width: MediaQuery.of(context).size.width * 0.3,
													height: 60,
													child: Padding(
														padding: const EdgeInsets.only(top: 30.0),
														child: ElevatedButton(
															onPressed: () {
																onSaveForm();
															},
															child: const Text(
																'Save',
																style: TextStyle(fontSize: 13.0),
															),
														),
													),
												),
											],
										),
									],
								)),
						),
					));
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldDiskonPersenController.text = NumberFormat("#,###").format(state.record!.diskonPersen);
							fieldPremiAddController.text = NumberFormat("#,###").format(state.record!.premiAdd);
							fieldPremiAwController.text = NumberFormat("#,###").format(state.record!.premiAw);
							fieldPremiCascoController.text = NumberFormat("#,###").format(state.record!.premiCasco);
							fieldPremiDiskonController.text = NumberFormat("#,###").format(state.record!.premiDiskon);
							fieldPremiEqController.text = NumberFormat("#,###").format(state.record!.premiEq);
							fieldPremiFloodController.text = NumberFormat("#,###").format(state.record!.premiFlood);
							fieldPremiNetController.text = NumberFormat("#,###").format(state.record!.premiNet);
							fieldPremiPadController.text = NumberFormat("#,###").format(state.record!.premiPad);
							fieldPremiPapController.text = NumberFormat("#,###").format(state.record!.premiPap);
							fieldPremiPllController.text = NumberFormat("#,###").format(state.record!.premiPll);
							fieldPremiSrccController.text = NumberFormat("#,###").format(state.record!.premiSrcc);
							fieldPremiSubtotalController.text = NumberFormat("#,###").format(state.record!.premiSubtotal);
							fieldPremiTbodController.text = NumberFormat("#,###").format(state.record!.premiTbod);
							fieldPremiTerrorismController.text = NumberFormat("#,###").format(state.record!.premiTerrorism);
							fieldPremiTjhController.text = NumberFormat("#,###").format(state.record!.premiTjh);
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		regmv6FormBloc.add(
			Regmv6FormLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldDiskonPersen(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldDiskonPersenController,
			decoration: const InputDecoration(
				labelText: "diskonPersen",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiAdd(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiAddController,
			decoration: const InputDecoration(
				labelText: "premiAdd",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiAw(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiAwController,
			decoration: const InputDecoration(
				labelText: "premiAw",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiCasco(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiCascoController,
			decoration: const InputDecoration(
				labelText: "premiCasco",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiDiskon(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiDiskonController,
			decoration: const InputDecoration(
				labelText: "premiDiskon",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiEq(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiEqController,
			decoration: const InputDecoration(
				labelText: "premiEq",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiFlood(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiFloodController,
			decoration: const InputDecoration(
				labelText: "premiFlood",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiNet(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiNetController,
			decoration: const InputDecoration(
				labelText: "premiNet",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiPad(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiPadController,
			decoration: const InputDecoration(
				labelText: "premiPad",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiPap(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiPapController,
			decoration: const InputDecoration(
				labelText: "premiPap",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiPll(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiPllController,
			decoration: const InputDecoration(
				labelText: "premiPll",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiSrcc(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiSrccController,
			decoration: const InputDecoration(
				labelText: "premiSrcc",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiSubtotal(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiSubtotalController,
			decoration: const InputDecoration(
				labelText: "premiSubtotal",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiTbod(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTbodController,
			decoration: const InputDecoration(
				labelText: "premiTbod",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiTerrorism(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTerrorismController,
			decoration: const InputDecoration(
				labelText: "premiTerrorism",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldPremiTjh(){
		return TextFormField(
			keyboardType: TextInputType.number,
			inputFormatters: [ThousandsSeparatorInputFormatter()],
			controller: fieldPremiTjhController,
			decoration: const InputDecoration(
				labelText: "premiTjh",
				floatingLabelBehavior: FloatingLabelBehavior.always,
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
			textAlign: TextAlign.right,
		);
	}

	Widget buildFieldRegmv1Id(){
		return TextFormField(
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			Regmv6FormModel record = Regmv6FormModel(
				diskonPersen: double.parse(fieldDiskonPersenController.text.replaceAll(',', '')),
				premiAdd: double.parse(fieldPremiAddController.text.replaceAll(',', '')),
				premiAw: double.parse(fieldPremiAwController.text.replaceAll(',', '')),
				premiCasco: double.parse(fieldPremiCascoController.text.replaceAll(',', '')),
				premiDiskon: double.parse(fieldPremiDiskonController.text.replaceAll(',', '')),
				premiEq: double.parse(fieldPremiEqController.text.replaceAll(',', '')),
				premiFlood: double.parse(fieldPremiFloodController.text.replaceAll(',', '')),
				premiNet: double.parse(fieldPremiNetController.text.replaceAll(',', '')),
				premiPad: double.parse(fieldPremiPadController.text.replaceAll(',', '')),
				premiPap: double.parse(fieldPremiPapController.text.replaceAll(',', '')),
				premiPll: double.parse(fieldPremiPllController.text.replaceAll(',', '')),
				premiSrcc: double.parse(fieldPremiSrccController.text.replaceAll(',', '')),
				premiSubtotal: double.parse(fieldPremiSubtotalController.text.replaceAll(',', '')),
				premiTbod: double.parse(fieldPremiTbodController.text.replaceAll(',', '')),
				premiTerrorism: double.parse(fieldPremiTerrorismController.text.replaceAll(',', '')),
				premiTjh: double.parse(fieldPremiTjhController.text.replaceAll(',', '')),
				regmv6Id: '',
			);
			if (widget.viewMode == "tambah") {
				regmv6FormBloc.add(Regmv6FormTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.regmv6Id = regmv6FormBloc.state.record!.regmv6Id;
				regmv6FormBloc.add(Regmv6FormUbahEvent(record: record));
			}
			_dismissDialog();
		}
	}

	void addError({required String error}) {
		if (!errors.contains(error)){
			setState(() {
				errors.add(error);
			});
		}
	}

	void removeError({required String error}) {
		if (errors.contains(error)){
			setState(() {
				errors.remove(error);
			});
		}
	}

}
