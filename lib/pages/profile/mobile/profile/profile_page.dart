
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../blocs/user_profile/user_profile_state.dart';
import '../../../../common/constants.dart';
import '../../../../repositories/user/user_repository.dart';
import '../../../base/base_background_firstpage.dart';
import '../../../base/base_background_sidepage.dart';
import '../../../home/home_tab_widget.dart';
import 'package:joss_app/blocs/user_profile/user_profile_cubit.dart';

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
  Future<void> _pickAndUpload(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final fileName = picked.name;

      // trigger upload
      context.read<ProfileUploadFotoBloc>().add(UploadProfilePicture(bytes, fileName));

      // optimistic UI
      context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto: $e')),
      );
    }
  }

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
    final headerSpacing = screenHeight * 0.025;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBlackColor,
      body: SafeArea(
        child: BaseBackgroundSidePage(
          backgroundAsset: "assets/images/background_gradient.png",
          fadeHeight: 300,
          title: 'Profile Page',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: headerSpacing),

                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: secondaryBlackColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border(
                                top: BorderSide(color: primaryColor, width: 4.0),
                              ),
                            ),
                            child: Card(
                              color: secondaryBlackColor,
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 96, 16, 16),
                                    child: BlocBuilder<UserProfileCubit, UserProfileState>(
                                      buildWhen: (prev, curr) {
                                        final p = prev.fotoBytes?.lengthInBytes ?? -1;
                                        final c = curr.fotoBytes?.lengthInBytes ?? -1;
                                        return p != c;
                                      },
                                      builder: (context, state) {
                                        return const Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 16),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    child: BlocBuilder<UserProfileCubit, UserProfileState>(
                                      buildWhen: (prev, curr) {
                                        final p = prev.fotoBytes?.lengthInBytes ?? -1;
                                        final c = curr.fotoBytes?.lengthInBytes ?? -1;
                                        return p != c;
                                      },
                                      builder: (context, state) {
                                        final imageBytes = state.fotoBytes;
                                        return InkResponse(
                                          onTap: () => _pickAndUpload(context),
                                          containedInkWell: true,
                                          customBorder: const CircleBorder(),
                                          radius: 64,
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [

                                              Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primaryBlackColor,
                                                  border: Border.all(color: sGrey, width: 2),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor: secondaryBlackColor,
                                                  backgroundImage: (imageBytes != null && imageBytes.isNotEmpty)
                                                      ? MemoryImage(imageBytes)
                                                      : null,
                                                  child: (imageBytes == null || imageBytes.isEmpty)
                                                      ? const Icon(Icons.person, color: Colors.white, size: 48)
                                                      : null,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                right: 4,
                                                child: IgnorePointer(
                                                  ignoring: true,
                                                  child: CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.black87,
                                                    child: Icon(Icons.camera_alt, color: primaryColor, size: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
