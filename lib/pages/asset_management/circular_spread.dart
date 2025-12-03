<<<<<<< HEAD
  import 'dart:math' as Math;
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import '../../common/constants.dart';
  
  class MiniActionButton {
    final String iconPath;
    final Color? color;
    final Gradient? gradient;
    final Color? borderColor;
    final String label;
    final VoidCallback onTap;
  
    MiniActionButton({
      required this.iconPath,
      this.color,
      this.gradient,
      this.borderColor,
      required this.label,
      required this.onTap,
    }) : assert(color != null || gradient != null,
    'MiniActionButton must have either a color or gradient.');
  }
  
  class BottomCenterAddButton extends StatefulWidget {
    final double size;
    final VoidCallback? onTap;
    final List<MiniActionButton>? actions;
  
    const BottomCenterAddButton({
      super.key,
      this.size = 70,
      this.onTap,
      this.actions,
    });
  
    @override
    State<BottomCenterAddButton> createState() => _BottomCenterAddButtonState();
  }
  
    class _BottomCenterAddButtonState extends State<BottomCenterAddButton> {
      bool isToggled = false;
  
      @override
      Widget build(BuildContext context) {
        final screen = MediaQuery.of(context).size;
        final centerX = screen.width / 2;
        final baseY = screen.height * 0.86;
  
        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (isToggled) ..._buildSmallButtons(centerX, baseY),
  
            // 🌟 TOMBOL UTAMA
            Positioned(
              top: baseY,
              left: centerX - widget.size / 2,
              child: _buildMainButton(),
            ),
          ],
        );
      }
  
      // 🎯 MAIN BUTTON (ADD / CLOSE)
      Widget _buildMainButton() {
        return GestureDetector(
          onTap: () {
            setState(() => isToggled = !isToggled);
            widget.onTap?.call();
          },
          child: AnimatedScale(
            scale: isToggled ? 0.9 : 1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isToggled
                    ? null
                    : const LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: isToggled ? formGrey : null,
                border: isToggled
                    ? Border.all(color: unselectedColor, width: 2)
                    : null,
                boxShadow: const [
                  BoxShadow(
                    color: secondaryBlackColor,
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isToggled ? Icons.close : Icons.add,
                  key: ValueKey(isToggled),
                  color: primaryLightColor,
                  size: isToggled ? 32 : 38,
                ),
              ),
            ),
          ),
        );
      }
  
    // 🟡 MINI BUTTON + LABEL (PAKET PER INDEX)
    List<Widget> _buildSmallButtons(double centerX, double baseY) {
      final actions = widget.actions ?? [];
      final count = actions.length;
      if (count == 0) return [];
  
      final List<Widget> children = [];
  
      final double radius = 95;          // jarak button dari pusat
      final double btnSize = 50;
      final double verticalOffset = 25;
      final double horizontalFactor = 0.9;
      final double gapFromButton = 38;   // jarak label dari button (konstan)
  
      // pusat arc (titik referensi radial)
      final double centerYArc = baseY + verticalOffset;
  
      for (var i = 0; i < count; i++) {
        final item = actions[i];
  
        // sudut 180° → 0°
        final double angleDeg = 180 - (i * 180 / (count - 1));
        final double angle = angleDeg * (Math.pi / 180);
  
        final double dx = radius * Math.cos(angle) * horizontalFactor;
        final double dy = radius * Math.sin(angle);
  
        // posisi CENTER button
        final double btnCenterX = centerX + dx;
        final double btnCenterY = centerYArc - dy;
  
        // vektor dari pusat arc → button (di koordinat UI)
        final double vx = dx;
        final double vy = btnCenterY - centerYArc; // (y button - y center)
  
        final double len = Math.sqrt(vx * vx + vy * vy);
        final double ux = vx / (len == 0 ? 1 : len);
        final double uy = vy / (len == 0 ? 1 : len);
  
        // posisi CENTER label, menjauh dari button sejauh gapFromButton
        final double labelCenterX = btnCenterX + ux * gapFromButton;
        final double labelCenterY = btnCenterY + uy * gapFromButton;
  
        // posisi TOP-LEFT untuk Positioned
        final double btnTop = btnCenterY - btnSize / 2;
        final double btnLeft = btnCenterX - btnSize / 2;
  
        // asumsi tinggi label ~ 24
        const double labelHeightApprox = 24;
        final double labelTop = labelCenterY - labelHeightApprox / 2;
        final double labelLeft = labelCenterX - 9999; // akan dibungkus Align? nope -> kita pakai width dynamic
  
        // BUTTON
        children.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            top: btnTop,
            left: btnLeft,
            child: _buildMiniButton(item, btnSize),
          ),
        );
  
        // LABEL – pakai Positioned normal, tapi pakai centerX/Y yang udah dihitung
        children.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            top: labelTop,
            left: labelCenterX,
            child: _buildLabel(item.label, vx < 0), // ✔️ cek apakah tombol di kiri/kanan
          ),
        );
  
      }
  
      return children;
    }
  
    // 🟢 MINI BUTTON TANPA LABEL
    Widget _buildMiniButton(MiniActionButton item, double size) {
      return AnimatedScale(
        scale: isToggled ? 1 : 0.6,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: isToggled ? 1 : 0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          child: GestureDetector(
            onTap: item.onTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: item.gradient,
                color: item.gradient == null ? item.color : null,
                border: Border.all(
                  color: item.borderColor ?? primaryLightColor,
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: secondaryBlackColor,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  item.iconPath,
                  width: size * 0.45,
                  height: size * 0.45,
                  colorFilter: const ColorFilter.mode(
                    primaryLightColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  
    // 📝 LABEL KECIL ABU-ABU
    Widget _buildLabel(String text, bool isLeftSide) {
      return AnimatedOpacity(
        opacity: isToggled ? 1 : 0,
        duration: const Duration(milliseconds: 260),
        child: Transform.translate(
          offset: Offset(
            isLeftSide ? -60 : 0, // ⬅️ dinamis: jika kiri geser ke kiri, jika kanan geser ke kanan
            0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: labelLightColor.withOpacity(0.88),
              borderRadius: BorderRadius.circular(cardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: primaryLightColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
  
  }
=======
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
>>>>>>> 4c71cf7a2c4b0aea542dd4d1b7fb25b42ec91398
