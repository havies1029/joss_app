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
