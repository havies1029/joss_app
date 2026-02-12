import 'package:joss_app/pages/regklaim/sppaheader_form.dart';
import 'package:flutter/material.dart';

class SppaHeaderMainPage extends StatelessWidget {
  final String sppa1Id;  
	const SppaHeaderMainPage({super.key, required this.sppa1Id});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: Text('Polis Detail'),
      ),  
			backgroundColor: Colors.grey[100],
			body: SppaHeaderFormPage(sppa1Id: sppa1Id),
		);
	}
}
