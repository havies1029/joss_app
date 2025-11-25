// import 'package:flutter/material.dart';
//
// class FloatingMenuMasterWidget extends StatefulWidget {
//   final VoidCallback? onTambah;
//
//   const FloatingMenuMasterWidget({
//     super.key,
//     this.onTambah,
//   });
//
//   @override
//   State<FloatingMenuMasterWidget> createState() =33
//       _FloatingMenuMasterWidgetState();
// }
//
// class _FloatingMenuMasterWidgetState extends State<FloatingMenuMasterWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//
//   bool _isOpen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void toggleMenu() {
//     setState(() {
//       _isOpen = !_isOpen;
//       _isOpen ? _controller.forward() : _controller.reverse();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 16,
//       bottom: 16,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // Menu items
//           ..._buildMenuItems(),
//
//           const SizedBox(height: 16),
//
//           // Main FAB with shadow and modern design
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: FloatingActionButton(
//               elevation: 0,
//               backgroundColor: const Color(0xFF6366F1),
//               onPressed: toggleMenu,
//               child: AnimatedRotation(
//                 duration: const Duration(milliseconds: 300),
//                 turns: _isOpen ? 0.125 : 0,
//                 child: Icon(
//                   _isOpen ? Icons.close_rounded : Icons.add_rounded,
//                   size: 28,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildMenuItems() {
//     final items = [
//       _MenuItemData(
//         icon: Icons.shopping_bag_outlined,
//         color: const Color(0xFFF59E0B),
//         label: "Beli Polis",
//         onTap: () => debugPrint("🔥 Beli Polis"),
//       ),
//       _MenuItemData(
//         icon: Icons.edit_outlined,
//         color: const Color(0xFF3B82F6),
//         label: "Endorse",
//         onTap: () => debugPrint("🔥 Endorse"),
//       ),
//       _MenuItemData(
//         icon: Icons.search_rounded,
//         color: const Color(0xFF6B7280),
//         label: "Lacak",
//         onTap: () => debugPrint("🔥 Lacak Polis"),
//       ),
//       _MenuItemData(
//         icon: Icons.autorenew_rounded,
//         color: const Color(0xFF06B6D4),
//         label: "Perpanjang",
//         onTap: () => debugPrint("🔥 Perpanjangan"),
//       ),
//       _MenuItemData(
//         icon: Icons.power_settings_new_rounded,
//         color: const Color(0xFFEC4899),
//         label: "Aktifkan",
//         onTap: () => debugPrint("🔥 Aktifkan"),
//       ),
//       _MenuItemData(
//         icon: Icons.download_outlined,
//         color: const Color(0xFF10B981),
//         label: "Unduh",
//         onTap: () => debugPrint("🔥 Unduh Polis"),
//       ),
//     ];
//
//     return items.asMap().entries.map((entry) {
//       final index = entry.key;
//       final item = entry.value;
//       final delay = index * 0.05;
//
//       return ScaleTransition(
//         scale: _scaleAnimation,
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: _buildMenuItem(item, delay),
//           ),
//         ),
//       );
//     }).toList().reversed.toList();
//   }
//
//   Widget _buildMenuItem(_MenuItemData item, double delay) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: (300 + delay * 1000).toInt()),
//       tween: Tween(begin: 0.0, end: _isOpen ? 1.0 : 0.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - value) * 20),
//           child: Opacity(
//             opacity: value,
//             child: child,
//           ),
//         );
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Label chip
//           if (_isOpen)
//             Container(
//               margin: const EdgeInsets.only(right: 12),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 item.label,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ),
//
//           // Button
//           Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 item.onTap?.call();
//                 toggleMenu();
//               },
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: item.color,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: item.color.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   item.icon,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MenuItemData {
//   final IconData icon;
//   final Color color;
//   final String label;
//   final VoidCallback? onTap;
//
//   _MenuItemData({
//     required this.icon,
//     required this.color,
//     required this.label,
//     this.onTap,
//   });
// }

import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';

class MenuPolisCircular extends StatelessWidget {
  const MenuPolisCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomCenter,
      radius: 100,
      toggleButtonSize: 50,
      toggleButtonColor: const Color(0xFF1A1A2E),
      toggleButtonIconColor: Colors.white,
      toggleButtonPadding: 12,
      toggleButtonMargin: 12,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
      animationDuration: const Duration(milliseconds: 400),
      toggleButtonBoxShadow: [
        BoxShadow(
          color: const Color(0xFF1A1A2E).withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      items: [
        CircularMenuItem(
          icon: Icons.search_rounded,
          color: const Color(0xFF6C63FF),
          iconColor: Colors.white,
          onTap: () => debugPrint("Lacak Polis"),
        ),
        CircularMenuItem(
          icon: Icons.refresh_rounded,
          color: const Color(0xFF00D9FF),
          iconColor: Colors.white,
          onTap: () => debugPrint("Perpanjangan"),
        ),
        CircularMenuItem(
          icon: Icons.power_settings_new_rounded,
          color: const Color(0xFFFF6B9D),
          iconColor: Colors.white,
          onTap: () => debugPrint("Aktifkan"),
        ),
        CircularMenuItem(
          icon: Icons.edit_rounded,
          color: const Color(0xFF4A90E2),
          iconColor: Colors.white,
          onTap: () => debugPrint("Endorse"),
        ),
        CircularMenuItem(
          icon: Icons.shopping_cart_rounded,
          color: const Color(0xFFFFC107),
          iconColor: Colors.white,
          onTap: () => debugPrint("Beli Polis"),
        ),
        CircularMenuItem(
          icon: Icons.file_download_rounded,
          color: const Color(0xFF4CAF50),
          iconColor: Colors.white,
          onTap: () => debugPrint("Unduh Polis"),
        ),
      ],
    );
  }
}
