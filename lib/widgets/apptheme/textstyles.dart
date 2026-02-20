part of '../../common/constants.dart';

/// Responsive Font Size
double getResponsiveFont(BuildContext context, double base) {
  if (isDesktop(context)) return base * 1.22;
  if (isTablet(context)) return base * 1.12;
  return base;
}

/// Textstyles
TextStyle headingStyle(BuildContext ctx, {double fontSize = 30}) => TextStyle(
    fontSize: getResponsiveFont(ctx, fontSize),
    color: primaryLightColor,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0);

TextStyle inputTextStyle(BuildContext ctx, {Color? color}) => TextStyle(
    fontSize: getResponsiveFont(ctx, 18),
    color: color ?? primaryColor,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0);

TextStyle bodyTextStyle(
  BuildContext ctx, {
  double fontSize = 18,
  TextDecoration decoration = TextDecoration.none,
}) =>
    TextStyle(
        fontSize: getResponsiveFont(ctx, fontSize),
        color: primaryLightColor,
        fontWeight: FontWeight.w400,
        decoration: decoration,
        height: 1,
        letterSpacing: 0);

class HoverableText extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle Function(bool isHovering) styleBuilder;
  final int? maxLines;
  final TextOverflow? overflow;

  const HoverableText({
    super.key,
    required this.text,
    required this.styleBuilder,
    this.onTap,
    this.maxLines,
    this.overflow,
  });

  @override
  State<HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<HoverableText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: widget.styleBuilder(_isHovering),
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        ),
      ),
    );
  }
}
