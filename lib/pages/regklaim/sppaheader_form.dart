import 'package:joss_app/blocs/regklaim/regklaim1crud_bloc.dart';
import 'package:joss_app/models/regklaim/sppadetail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/regklaim/sppaheader_bloc.dart';


class SppaHeaderFormPage extends StatefulWidget {
	final String sppa1Id;

	const SppaHeaderFormPage({super.key,required this.sppa1Id});

	@override
	SppaHeaderFormPageFormState createState() => SppaHeaderFormPageFormState();
}

class SppaHeaderFormPageFormState extends State<SppaHeaderFormPage> {
	late SppaHeaderBloc sppaHeaderBloc;
	final _formKey = GlobalKey<FormState>();
  List<SppaDetailModel> listSppaDetail = [];
	var fieldCobNamaController = TextEditingController();
	var fieldInsuredNamaController = TextEditingController();
	var fieldObjectAlamat1Controller = TextEditingController();
	var fieldObjectAlamat2Controller = TextEditingController();

	@override
	void initState() {
		super.initState();
		Future.delayed(const Duration(milliseconds: 500), () {
			loadData();
		});
	}

	@override
	Widget build(BuildContext context) {
		sppaHeaderBloc = BlocProvider.of<SppaHeaderBloc>(context);
		return BlocListener<Regklaim1CrudBloc, Regklaim1CrudState>(
          listener: (context, state) {
            if (state.isSaved) {
              if (!state.hasFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Klaim berhasil dilaporkan')),
                );
                _dismissDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal melaporkan klaim')),
                );
              }
            }
          },
          child: BlocConsumer<SppaHeaderBloc, SppaHeaderState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),									
                        buildFieldCobNama(),
                        buildFieldInsuredNama(),
                        buildFieldObjectAlamat1(),
                        buildFieldObjectAlamat2(),
                            const SizedBox(height: 20),
                            buildSppaDetailSection(),
                        const SizedBox(height: 25),
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
                                    var regklaim1crudbloc = context.read<Regklaim1CrudBloc>();
                                        regklaim1crudbloc.add(
                                          Regklaim1Tambah4PolisJpsEvent(
                                            sppa1Id: widget.sppa1Id));
                                  },
                                  child: const Text(
                                    'Lapor Klaim',
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
              );
              },
              listener: (context, state) {
                if (state.isLoaded) {
                  if (state.record != null){
                    fieldCobNamaController.text = state.record!.cobNama;
                    fieldInsuredNamaController.text = state.record!.insuredNama;
                    fieldObjectAlamat1Controller.text = state.record!.objectAlamat1;
                    fieldObjectAlamat2Controller.text = state.record!.objectAlamat2;
                        listSppaDetail = state.record!.sppaDetail;
                  }
                }
              },
            ),
        );
		}
	void loadData() {		
		sppaHeaderBloc.add(
			SppaHeaderLihatEvent(recordId: widget.sppa1Id));
		
	}

	Widget buildFieldCobNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldCobNamaController,
			decoration: const InputDecoration(
				labelText: "cobNama",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	Widget buildFieldInsuredNama(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldInsuredNamaController,
			decoration: const InputDecoration(
				labelText: "insuredNama",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	Widget buildFieldObjectAlamat1(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldObjectAlamat1Controller,
			decoration: const InputDecoration(
				labelText: "objectAlamat1",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	Widget buildFieldObjectAlamat2(){
		return TextFormField(
			keyboardType: TextInputType.multiline,
			minLines: 1,
			maxLines: 3,
			controller: fieldObjectAlamat2Controller,
			decoration: const InputDecoration(
				labelText: "objectAlamat2",
				floatingLabelBehavior: FloatingLabelBehavior.always,
			),			
		);
	}

	void _dismissDialog() {
		Navigator.pop(context);
	}

  Widget buildSppaDetailSection() {
    if (listSppaDetail.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'Detail tidak ada',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Detail SPPA',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listSppaDetail.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final d = listSppaDetail[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ ganti sesuai field model kamu
                    Text('No: ${index + 1}'),
                    const SizedBox(height: 4),
                    Text('sppa1Id: ${d.sppa1Id}'),
                    Text('periodeMulai: ${d.periodeMulai.toString()}'),
                    Text('periodeAkhir: ${d.periodeAkhir.toString()}'),
                    Text('stsLunas: ${d.stsLunas}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }


}
