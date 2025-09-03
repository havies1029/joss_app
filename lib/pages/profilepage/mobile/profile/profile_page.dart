import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import '../../../../repositories/user/user_repository.dart';
import '../../../base/base_background_firstpage.dart';
import '../../../base/base_background_sidepage.dart';
import '../../../home/home_tab_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalPadding = screenHeight * 0.03;
    final headerSpacing = screenHeight * 0.025;
    final userRepository = UserRepository();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => HomeTabWidget(userRepository: userRepository),
            ),
                (route) => false, // Hapus semua page, langsung ke home
          );
        },
      ),// ⬅️ kasih warna dasar hitam
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Profile Page',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: headerSpacing),
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryBlackColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border(
                              top: BorderSide(
                                color: primaryColor,
                                width: 4.0,
                              ),
                            ),
                          ),
                          child: Card(
                            color: secondaryBlackColor,
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Full width Card", style: TextStyle(color: Colors.white)),
                                  SizedBox(height: 8),
                                  Text("Sekarang hitamnya nempel ke sisi kiri kanan.",
                                      style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}