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
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final EdgeInsets? padding;
  final double? height;
  final TextInputAction? textInputAction;

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
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.onTap,
    this.onFieldSubmitted,
    this.padding,
    this.height,
    this.textInputAction
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
      textInputAction: textInputAction,
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: inputTextStyle(context),
        hintText: hint,
        hintStyle: inputTextStyle(context, color: sGrey),
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
        errorStyle: TextStyle(
          color: pRed,
          fontSize: getResponsiveFont(context, 15),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );

    // Jika ada custom height, bungkus dengan SizedBox
    if (height != null) {
      textField = SizedBox(height: height, child: textField);
    }

    // Jika ada padding, bungkus dengan Padding
    if (padding != null) {
      return Padding(padding: padding!, child: textField);
    }

    return textField;
  }
}

class AppDateField extends StatefulWidget {
  final String label;
  final String? hint;
  final DateTime? initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final FormFieldValidator<DateTime>? validator;
  final ValueChanged<DateTime?>? onChanged;
  final EdgeInsets? padding;
  final double? height;

  const AppDateField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    required this.firstDate,
    required this.lastDate,
    this.validator,
    this.onChanged,
    this.padding,
    this.height,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialValue;
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: widget.label,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget field = TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : '',
      ),
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: inputTextStyle(context),
        hintText: widget.hint ?? 'Pilih tanggal',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: pGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: const BorderSide(color: sGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: const BorderSide(color: sGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(
          color: pRed,
          fontSize: getResponsiveFont(context, 15),
        ),
        suffixIcon: const Icon(Icons.event, color: primaryLightColor),
      ),
      validator: (v) {
        if (widget.validator != null) {
          return widget.validator!(selectedDate);
        }
        return null;
      },
      onTap: () => _pickDate(context),
    );

    if (widget.height != null) {
      field = SizedBox(height: widget.height, child: field);
    }

    if (widget.padding != null) {
      return Padding(padding: widget.padding!, child: field);
    }

    return field;
  }
}
