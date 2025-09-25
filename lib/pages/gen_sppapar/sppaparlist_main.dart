import 'package:flutter/material.dart';
import 'package:joss_app/pages/gen_sppapar/sppaparlist_list.dart';

class SppaparListMainPage extends StatelessWidget {
	const SppaparListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar SPPA PAR"),       
      ),
			backgroundColor: Colors.grey[100],
			body: const SppaparListPage(),
		);
	}
}
