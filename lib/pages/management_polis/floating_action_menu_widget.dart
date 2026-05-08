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
  bayar,
  lihatPolis,
  lihatPolisPar,
  lihatPolisEq,
  klaimBaru,
  perbaruiKlaim,
  lacakKlaim,
  batalKlaim,
  hubungiJps
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

  ActionMenuItem copyWith({
    ActionType? type,
    String? label,
    String? iconAsset,
    List<Color>? gradientColors,
    Color? borderColor,
    bool? isEnabled,
  }) {
    return ActionMenuItem(
      type: type ?? this.type,
      label: label ?? this.label,
      iconAsset: iconAsset ?? this.iconAsset,
      gradientColors: gradientColors ?? this.gradientColors,
      borderColor: borderColor ?? this.borderColor,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class FloatingActionMenuWidget extends StatefulWidget {
  final List<ActionMenuItem> availableActions;
  final Function(ActionType type, List<dynamic> selectedItems) onActionTap;
  final List<dynamic> selectedItems;

  const FloatingActionMenuWidget({
    super.key,
    required this.availableActions,
    required this.onActionTap,
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

  bool get _hasEnabledAction =>
      widget.availableActions.any((action) => action.isEnabled);

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
  void didUpdateWidget(covariant FloatingActionMenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final actionsChanged = oldWidget.availableActions != widget.availableActions;
    final selectionChanged = oldWidget.selectedItems.length != widget.selectedItems.length;

    if (actionsChanged || selectionChanged) {
      if (_isExpanded) {
        _isExpanded = false;
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (widget.availableActions.isEmpty) return;

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
    final mainFabColor = _isExpanded ? pGrey : primaryColor;
    final mainFabBorderColor = _isExpanded ? sGrey : const Color(0xD4FF9144);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.availableActions.reversed.map((action) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildActionButton(action),
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        if (_isExpanded) const SizedBox(height: 7),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.8,
                  color: mainFabBorderColor,
                ),
              ),
              child: FloatingActionButton(
                elevation: 0,
                highlightElevation: 0,
                backgroundColor: mainFabColor,
                onPressed: _toggleMenu,
                shape: const CircleBorder(),
                child: Icon(
                  _isExpanded ? Icons.close : Icons.add,
                  color: primaryLightColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildActionButton(ActionMenuItem action) {
    final isDisabled = !action.isEnabled;
    final canTriggerGuardWhenDisabled =
        isDisabled &&
            (action.type == ActionType.perpanjangan ||
                action.type == ActionType.aktifkanKembali);
    return Opacity(
      opacity: isDisabled ? 0.55 : 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isDisabled ? const Color(0xFF404040) : labelLightColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              action.label,
              style: TextStyle(
                color: isDisabled ? const Color(0xFF8A8A8A) : primaryLightColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDisabled
                  ? const LinearGradient(
                      colors: [Color(0xFF404040), Color(0xFF404040)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: action.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: Border.all(
                width: 0.8,
                color: isDisabled ? const Color(0xFF5D5D5D) : action.borderColor,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                // onTap: isDisabled
                //     ? null
                //     : () {
                //
                //         debugPrint(
                //           'FAB ITEM CLICK => type=${action.type}, '
                //           'label=${action.label}, '
                //           'enabled=${action.isEnabled}, '
                //           'selectedItems=${widget.selectedItems.length}',
                //         );
                //
                //         _toggleMenu();
                //         widget.onActionTap(action.type, widget.selectedItems);
                //
                //         debugPrint('FAB ITEM CLICK => callback sent to parent');
                //
                //       },
                onTap: (isDisabled && !canTriggerGuardWhenDisabled)
                    ? null
                    : () {
                  debugPrint(
                    'FAB ITEM CLICK => type=${action.type}, '
                        'label=${action.label}, '
                        'enabled=${action.isEnabled}, '
                        'selectedItems=${widget.selectedItems.length}',
                  );

                  _toggleMenu();
                  widget.onActionTap(action.type, widget.selectedItems);

                  debugPrint('FAB ITEM CLICK => callback sent to parent');
                },
                customBorder: const CircleBorder(),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.8,
                      color: isDisabled
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
                      isDisabled ? const Color(0xFF8A8A8A) : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}