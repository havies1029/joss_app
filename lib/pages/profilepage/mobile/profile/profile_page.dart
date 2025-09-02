import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../../blocs/profile/profile_upload_foto_bloc.dart';
import '../../../../common/constants.dart';
import '../../../base/base_background_sidepage.dart';
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
                          // 🔹 Container hitam + border oranye full width
                          Container(
                            width: double.infinity, // ⬅️ biar mepet kiri-kanan
                            margin: const EdgeInsets.only(top: 60), // hanya kasih ruang untuk avatar
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
                                child: BlocBuilder<UserProfileCubit, UserProfileState>(
                                  builder: (context, state) {
                                    final displayName =
                                    (state.nama?.trim().isNotEmpty ?? false) ? state.nama!.trim() : "User";

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 40), // ruang bawah avatar
                                        // Text(
                                        //   displayName,
                                        //   style: const TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 18,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          // 🔹 Avatar di tengah atas
                          Positioned(
                            top: 0,
                            child: BlocBuilder<UserProfileCubit, UserProfileState>(
                              builder: (context, state) {
                                final imageBytes = state.fotoBytes;

                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    // 🔹 Foto Profil
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: primaryColor,
                                      backgroundImage: (imageBytes != null && imageBytes.isNotEmpty)
                                          ? MemoryImage(imageBytes)
                                          : null,
                                      child: (imageBytes == null || imageBytes.isEmpty)
                                          ? Text(
                                        state.nama != null && state.nama!.isNotEmpty
                                            ? state.nama![0].toUpperCase()
                                            : "U",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                          : null,
                                    ),

                                    // 🔹 Tombol Kamera (upload)
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final picker = ImagePicker();
                                          final picked = await picker.pickImage(source: ImageSource.gallery);

                                          if (picked != null) {
                                            final bytes = await picked.readAsBytes();
                                            final fileName = picked.name;

                                            // ⬇️ Trigger upload pakai bloc
                                            context.read<ProfileUploadFotoBloc>().add(
                                              UploadProfilePicture(bytes, fileName),
                                            );

                                            // Opsional: update langsung ke UserProfileCubit biar avatar ganti instan
                                            context.read<UserProfileCubit>().setProfile(
                                              fotoBytes: bytes,
                                            );
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.black87,
                                          child: Icon(Icons.camera_alt, color: primaryColor, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
