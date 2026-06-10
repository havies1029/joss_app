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
  final String? errorText;

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
    this.errorText,
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
      obscuringCharacter: '*',
      inputFormatters: _getDefaultFormatters(),
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      textInputAction: textInputAction,
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        labelStyle: (enabled ?? true)
            ? inputTextStyle(context)
            : bodyTextStyle(context),
        hintText: hint ?? 'Masukkan $label...',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: (enabled ?? true) ? formGrey : sGrey,
        contentPadding: const EdgeInsets.all(10),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: bodyTextStyle(context).copyWith(
          color: Colors.red,
          fontSize: 12,
        ),
        prefix: prefix,
        suffix: suffix,
        suffixIcon: suffixIcon,
        errorText: errorText,
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

enum AppDateFieldMode {
  date,
  monthYear,
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
  final bool enabled;
  final AppDateFieldMode mode;

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
    this.enabled = true,
    this.mode = AppDateFieldMode.date,
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

  @override
  void didUpdateWidget(AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      selectedDate = widget.initialValue;
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    if (widget.mode == AppDateFieldMode.monthYear) {
      await _pickMonthYear(context);
      return;
    }

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


  Future<void> _pickMonthYear(BuildContext context) async {
    final now = DateTime.now();

    int selectedMonth = selectedDate?.month ?? now.month;
    int selectedYear = selectedDate?.year ?? now.year;

    await showModalBottomSheet(
      context: context,
      backgroundColor: formGrey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(cardBorderRadius),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: headingStyle(context).copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          dropdownColor: formGrey,
                          value: selectedMonth,
                          style: const TextStyle(
                            color: primaryLightColor,
                          ),
                          decoration: InputDecoration(
                            labelText: "Bulan",
                            labelStyle: const TextStyle(
                              color: primaryLightColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              borderSide: const BorderSide(color: sGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                          ),
                          iconEnabledColor: primaryLightColor,
                          items: List.generate(12, (i) {
                            final month = i + 1;
                            return DropdownMenuItem(
                              value: month,
                              child: Text(
                                month.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  color: primaryLightColor,
                                ),
                              ),
                            );
                          }),
                          onChanged: (v) {
                            if (v == null) return;
                            setModalState(() {
                              selectedMonth = v;
                            });
                          },
                        )
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          dropdownColor: formGrey,
                          value: selectedYear,
                          style: const TextStyle(
                            color: primaryLightColor,
                          ),
                          decoration: InputDecoration(
                            labelText: "Tahun",
                            labelStyle: const TextStyle(
                              color: primaryLightColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              borderSide: const BorderSide(color: sGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(cardBorderRadius),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                          ),
                          iconEnabledColor: primaryLightColor,
                          items: List.generate(16, (i) {
                            final year = now.year + i;
                            return DropdownMenuItem(
                              value: year,
                              child: Text(
                                year.toString(),
                                style: const TextStyle(
                                  color: primaryLightColor,
                                ),
                              ),
                            );
                          }),
                          onChanged: (v) {
                            if (v == null) return;
                            setModalState(() {
                              selectedYear = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton.primary(
                    text: "Pilih",
                    onPressed: () {
                      final picked = DateTime(selectedYear, selectedMonth, 1);

                      setState(() {
                        selectedDate = picked;
                      });

                      widget.onChanged?.call(picked);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.enabled;

    // Samakan pola disabled dengan appTextField
    final Color bgColor = isEnabled ? formGrey : sGrey;
    final Color borderColor = sGrey;
    final Color iconColor = isEnabled ? primaryLightColor : sGrey;

    Widget field = TextFormField(
      enabled: widget.enabled,
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? widget.mode == AppDateFieldMode.monthYear
            ? DateFormat('MM / yyyy').format(selectedDate!)
            : DateFormat('yyyy-MM-dd').format(selectedDate!)
            : '',
      ),
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: isEnabled
            ? inputTextStyle(context)
            : bodyTextStyle(context),
        hintText: 'Pilih ${widget.label}',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: bgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          borderSide: BorderSide(color: borderColor),
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
        errorStyle: bodyTextStyle(context).copyWith(
          color: Colors.red,
          fontSize: 12,
        ),

        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEnabled && selectedDate != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: primaryLightColor,
                onPressed: () {
                  setState(() => selectedDate = null);
                  widget.onChanged?.call(null);
                },
              ),
            Icon(
              Icons.event,
              color: iconColor,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      validator: (v) {
        if (widget.validator != null) {
          return widget.validator!(selectedDate);
        }
        return null;
      },
      onTap: widget.enabled ? () => _pickDate(context) : null,
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