import 'package:flutter/material.dart';

class HubungiCs extends StatelessWidget {
  final void Function(String layanan) onPilihLayanan;

  const HubungiCs({
    super.key,
    required this.onPilihLayanan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF262626),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 70,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),

                  const Text(
                    "Pilih Layanan Klaim",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pilih kategori layanan untuk memulai percakapan",
                    style: TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _ServiceItem(
                    icon: Icons.home,
                    iconColor: Color(0xFF9CCC4A),
                    title: "Klaim Properti",
                    subtitle: "Tim Customer Service",
                    onTap: () => onPilihLayanan("Klaim Properti"),
                  ),
                  const SizedBox(height: 14),

                  _ServiceItem(
                    icon: Icons.directions_car,
                    iconColor: Color(0xFF4285F4),
                    title: "Klaim Kendaraan Bermotor",
                    subtitle: "Tim Customer Service",
                    onTap: () => onPilihLayanan("Klaim Kendaraan Bermotor"),
                  ),
                  const SizedBox(height: 14),

                  _ServiceItem(
                    icon: Icons.menu,
                    iconColor: Color(0xFF565656),
                    title: "Klaim Lainnya",
                    subtitle: "Tim Customer Service",
                    onTap: () => onPilihLayanan("Klaim Lainnya"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF444444),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFF00F36A),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}