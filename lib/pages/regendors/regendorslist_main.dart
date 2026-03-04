import 'package:joss_app/pages/regendors/regendorscari_list.dart';
import 'package:flutter/material.dart';

class RegEndorsListMainPage extends StatelessWidget {
	const RegEndorsListMainPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('RegEndors List'),
      ),
			backgroundColor: Colors.grey[100],
			body: const RegendorsCariPage(),
		);
	}
}
