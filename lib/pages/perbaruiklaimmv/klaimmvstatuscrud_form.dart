import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvstatuscrud_bloc.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaimmvstatuscrud_model.dart';
import 'package:string_validator/string_validator.dart';
import 'package:joss_app/widgets/checkbox_widget.dart';


class KlaimmvstatuscrudFormPage extends StatefulWidget {
	final String viewMode;
	final String recordId;

	const KlaimmvstatuscrudFormPage({super.key, required this.viewMode, required this.recordId});

	@override
	KlaimmvstatuscrudFormPageFormState createState() => KlaimmvstatuscrudFormPageFormState();
}

class KlaimmvstatuscrudFormPageFormState extends State<KlaimmvstatuscrudFormPage> {
	late KlaimmvstatuscrudBloc klaimmvstatuscrudBloc;
	final _formKey = GlobalKey<FormState>();
	var fieldIsPilihController = TextEditingController();
	var fieldStatusNamaController = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		klaimmvstatuscrudBloc = BlocProvider.of<KlaimmvstatuscrudBloc>(context);
		return BlocConsumer<KlaimmvstatuscrudBloc, KlaimmvstatuscrudState>(
			builder: (context, state) {
				return SingleChildScrollView(
					child: Padding(
						padding: const EdgeInsets.all(8.0),
						child: Form(
							key: _formKey,
							child: Column(
								children: [
									const SizedBox(height: 10),
									buildFieldIsPilih(),
									buildFieldStatusNama(),
									
								],
							)),
					),
				);
				},
				listener: (context, state) {
					if (state.isLoaded) {
						if (state.record != null){
							fieldIsPilihController.text = state.record!.isPilih.toString();
							fieldStatusNamaController.text = state.record!.statusNama;
						}
					}
				},
			);
		}
	void loadData() {
		if (widget.viewMode == "ubah") {
		klaimmvstatuscrudBloc.add(
			KlaimmvstatuscrudLihatEvent(recordId: widget.recordId));
		}
	}

	Widget buildFieldIsPilih(){
		return CheckboxWidget(
			leftLabel: "",
			rightLabel: "isPilih",
			initialValue: toBoolean(fieldIsPilihController.text),
			callback: (value) {
				setState(() {
					fieldIsPilihController.text = value.toString();
				});
			}
		);
	}

	Widget buildFieldStatusNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldStatusNamaController,
			decoration: const InputDecoration(
				labelText: "statusNama",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

	void onSaveForm() {
		if (_formKey.currentState!.validate()) {
			_formKey.currentState!.save();
			KlaimmvstatuscrudModel record = KlaimmvstatuscrudModel(
				isPilih: toBoolean(fieldIsPilihController.text),
				klaim1Id: '',
				statusNama: fieldStatusNamaController.text,
			);
			if (widget.viewMode == "tambah") {
				klaimmvstatuscrudBloc.add(KlaimmvstatuscrudTambahEvent(record: record));
			} else if (widget.viewMode == "ubah") {
				record.klaim1Id = klaimmvstatuscrudBloc.state.record!.klaim1Id;
				klaimmvstatuscrudBloc.add(KlaimmvstatuscrudUbahEvent(record: record));
			}
			_dismissDialog();
		}
	}

}
