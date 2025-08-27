part of '../../common/constants.dart';


/// Responsive Font Size
double getResponsiveFont(BuildContext context, double base) {
  if (isDesktop(context)) return base * 1.22;
  if (isTablet(context)) return base * 1.12;
  return base;
}

/// Text Styles
TextStyle headingStyle(BuildContext ctx) =>
    TextStyle(fontSize: getResponsiveFont(ctx, 30), color: primaryLightColor);

TextStyle customInputStyle(
    BuildContext ctx, {
      double fontSize = 18,
      Color color = primaryColor,
      TextDecoration decoration = TextDecoration.none,
      FontWeight? fontWeight,
    }) {
  return TextStyle(
    fontSize: getResponsiveFont(ctx, fontSize),
    color: color,
    decoration: decoration,
    fontWeight: fontWeight,
  );
}

class HoverableText extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle Function(bool isHovering) styleBuilder;
  final int? maxLines;
  final TextOverflow? overflow;

  const HoverableText({
    Key? key,
    required this.text,
    required this.styleBuilder,
    this.onTap,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

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

