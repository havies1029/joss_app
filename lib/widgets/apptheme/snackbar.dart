part of '../../common/constants.dart';

SnackBar appSnackBar({
  required String message,
  IconData? icon,
  Color? backgroundColor,
  Color? iconColor,
  Color? textColor,
  Duration? duration,
  double? borderRadius,
  SnackBarBehavior? behavior,
  EdgeInsets? margin,
  double? elevation,
}) {
  return SnackBar(
    content: Row(
      children: [
        if (icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(icon, color: iconColor ?? primaryLightColor),
          ),
        ],
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor ?? primaryLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor ?? primaryColor,
    behavior: behavior ?? SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? cardBorderRadius),
    ),
    margin: margin ?? const EdgeInsets.all(16),
    elevation: elevation ?? defaultElevation,
    duration: duration ?? const Duration(seconds: 3),
  );
}

// Factory khusus Success/Error/Info dengan opsi custom icon
SnackBar errorSnackBar(String message, {IconData? icon}) => appSnackBar(
  message: message,
  icon: icon ?? Icons.error_outline,
  backgroundColor: pRed,
);

SnackBar successSnackBar(String message, {IconData? icon}) => appSnackBar(
  message: message,
  icon: icon ?? Icons.check_circle_outline,
  backgroundColor: primaryColor,
);

SnackBar infoSnackBar(String message, {IconData? icon}) => appSnackBar(
  message: message,
  icon: icon ?? Icons.info_outline,
  backgroundColor: pBlue,
);
