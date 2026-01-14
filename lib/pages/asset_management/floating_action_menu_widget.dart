import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';

enum ActionType {
  endorse,
  perpanjangan,
  aktifkanKembali,
  unduhPolis,
  lacakPolis,
  beliPolis,
  bayar
}

class ActionMenuItem {
  final ActionType type;
  final String label;
  final String iconAsset;
  final List<Color> gradientColors;
  final Color borderColor;
  final bool isEnabled;

  const ActionMenuItem({
    required this.type,
    required this.label,
    required this.iconAsset,
    required this.gradientColors,
    required this.borderColor,
    this.isEnabled = true,
  });
}

class FloatingActionMenuWidget extends StatefulWidget {
  final bool isFabEnabled;
  final List<ActionMenuItem> availableActions;
  final Function(ActionType type, List<dynamic> selectedItems) onActionTap;
  final List<dynamic> selectedItems;

  const FloatingActionMenuWidget({
    super.key,
    required this.availableActions,
    required this.onActionTap,
    this.isFabEnabled = true,
    required this.selectedItems,
  });

  @override
  State<FloatingActionMenuWidget> createState() =>
      _FloatingActionMenuWidgetState();
}

class _FloatingActionMenuWidgetState extends State<FloatingActionMenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // // Overlay backdrop saat menu terbuka
        // if (_isExpanded)
        //   GestureDetector(
        //     onTap: _toggleMenu,
        //     child: Container(
        //       color: Colors.black.withOpacity(0.3),
        //     ),
        //   ),

        // Action Menu Items
        Positioned(
          right: 20,
          bottom: 55,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isExpanded ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_isExpanded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.availableActions.reversed.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildActionButton(action),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),

        // Main FAB Button
        Positioned(
          right: 8,
          bottom: 0,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isExpanded ? sGrey : const Color(0xD4FF9144),
                ),
              ),
              child: FloatingActionButton(
                elevation: 0,
                highlightElevation: 0,
                backgroundColor: _isExpanded ? pGrey : primaryColor,
                onPressed: _toggleMenu,
                shape: const CircleBorder(),
                child: Icon(Icons.add, color: primaryLightColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ActionMenuItem action) {
    final isDisabled = !action.isEnabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: isDisabled ? const Color(0xFF404040) : labelLightColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            action.label,
            style: TextStyle(
              color: isDisabled ? const Color(0xFF5D5D5D) : primaryLightColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // button
        // Material(
        //   color: isDisabled ? const Color(0xFF404040) : action.bgColor,
        //   shape: const CircleBorder(),
        //   elevation: isDisabled ? 1 : 4,
        //   child: InkWell(
        //     onTap: isDisabled
        //         ? null
        //         : () {
        //       _toggleMenu();
        //       widget.onActionTap(action.type, widget.selectedItems);
        //     },
        //     customBorder: const CircleBorder(),
        //     child: Container(
        //       width: 29.07,
        //       height: 29.07,
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         border: Border.all(
        //           color: isDisabled ? const Color(0xFF5D5D5D) : action.borderColor,
        //         ),
        //       ),
        //       alignment: Alignment.center,
        //       child: SvgPicture.asset(
        //         action.iconAsset,
        //         width: 14.53,
        //         height: 14.53,
        //         colorFilter: ColorFilter.mode(
        //           isDisabled ? const Color(0xFF5D5D5D)  : Colors.white,
        //           BlendMode.srcIn,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                isDisabled
                    ? LinearGradient(
                      colors: [
                        const Color(0xFF404040),
                        const Color(0xFF404040),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: action.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            border: Border.all(
              color: isDisabled ? const Color(0xFF5D5D5D) : action.borderColor,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap:
                  isDisabled
                      ? null
                      : () {
                        _toggleMenu();
                        widget.onActionTap(action.type, widget.selectedItems);
                      },
              customBorder: const CircleBorder(),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDisabled
                            ? const Color(0xFF5D5D5D)
                            : action.borderColor,
                  ),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  action.iconAsset,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    isDisabled ? const Color(0xFF5D5D5D) : Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
