part of '../../common/constants.dart';

class appTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefix;
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
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  const appTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.obscureText = false,
    this.onChanged,
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
    this.textInputAction,
    this.autovalidateMode,
  });

  List<TextInputFormatter>? _getDefaultFormatters() {
    if (inputFormatters != null) return inputFormatters;

    switch (keyboardType) {
      case TextInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextInputType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextInputType.emailAddress:
        return [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@._\-+]'),
          ),
        ];
      case TextInputType.url:
        return [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9:/?&=._\-#]'),
          ),
        ];
      case TextInputType.visiblePassword:
        return null;
      case TextInputType.name:
        return [
          FilteringTextInputFormatter.allow(
            RegExp(r"[a-zA-ZÀ-ÿ'\- ]"),
          ),
        ];
      case TextInputType.text:
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      inputFormatters: _getDefaultFormatters(), 
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      textInputAction: textInputAction,
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: (enabled ?? true)
            ? inputTextStyle(context)
            : bodyTextStyle(context),
        hintText: hint ?? 'Masukkan $label...',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: (enabled ?? true) ? formGrey : sGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: sGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: sGrey),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: sGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: primaryColor),
        ),
        prefix: prefix,
        suffix: suffix,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );

    if (height != null) {
      textField = SizedBox(height: height, child: textField);
    }
    if (padding != null) {
      return Padding(padding: padding!, child: textField);
    }
    return textField;
  }
}

class AppDateField extends StatefulWidget {
  final String label;
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
              onPrimary: primaryLightColor,
              onSurface: primaryBlackColor,
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
        hintText: 'Pilih ${widget.label}',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: formGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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