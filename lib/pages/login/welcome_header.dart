import 'package:flutter/cupertino.dart';
import '../../common/constants.dart';

class WelcomeHeader extends StatelessWidget {
  final String type;

  const WelcomeHeader({super.key, required this.type});

  Map<String, Map<String, String>> get _content => {
    "register_client": {
      "title": "Baru di JPS?",
      "subtitle": "Yuk, buat akun dan mulai proteksi hidupmu.",
      "emoji": "🎉",
    },
    "login_client": {
      "title": "Selamat Datang Kembali!",
      "subtitle": "Yuk masuk, semua polis & klaimmu siap diakses.",
      "emoji": "👋",
    },
    "login_user": {
      "title": "Halo, siap lanjut proteksi?",
      "subtitle": "Yuk, Masuk dan urus polis & klaim dengan mudah.",
      "emoji": "👋",
    },
  };

  @override
  Widget build(BuildContext context) {
    final content = _content[type] ?? {};
    final title = content["title"] ?? "";
    final subtitle = content["subtitle"] ?? "";
    final emoji = content["emoji"] ?? "👋";

    // 🧠 Cek lebar layar
    final screenWidth = MediaQuery.of(context).size.width;
    final showEmoji = screenWidth > 360; // batas aman 360px (bisa lo ubah)

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: hPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: headingStyle(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showEmoji)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(emoji, style: headingStyle(context)),
                ),
            ],
          ),
          // Subtitle
          Text(
            subtitle,
            style: bodyTextStyle(context).copyWith(color: hintGrey),
          ),
        ],
      ),
    );
  }
}