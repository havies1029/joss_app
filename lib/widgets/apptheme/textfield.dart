part of '../../common/constants.dart';

class appTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enabled;
  final int? maxLines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? height;

  const appTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled,
    this.maxLines,
    this.keyboardType,
    this.validator,
    this.focusNode,
    this.onTap,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      onTap: onTap,
      cursorColor: primaryLightColor,
      style: TextStyle(
        color: primaryLightColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelInputStyle(context),
        hintText: hint,
        hintStyle: inputHintStyle(context),
        filled: true,
        fillColor: pGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: sGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: sGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: errorTextStyle(context),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );

    // Jika ada custom height, bungkus dengan SizedBox
    if (height != null) {
      textField = SizedBox(
        height: height,
        child: textField,
      );
    }

    // Jika ada padding, bungkus dengan Padding
    if (padding != null) {
      return Padding(
        padding: padding!,
        child: textField,
      );
    }

    return textField;
  }
}