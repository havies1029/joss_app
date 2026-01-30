import 'package:joss_app/pages/regendors/regendors2cari_list.dart';
import 'package:flutter/material.dart';

class Regendors2CariMainPage extends StatelessWidget {
  final String regendors1Id;
  const Regendors2CariMainPage({super.key, required this.regendors1Id});  

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Endors'),
      ),
			backgroundColor: Colors.grey[100],
			body: Regendors2CariPage(regendors1Id: regendors1Id),
		);
	}
}
