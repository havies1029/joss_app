import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/helper/international_phone_result.dart';

class AppPhoneNumberField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final int countryCode;
  final ValueChanged<int> onCountryCodeChanged;
  final String? errorText;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AppPhoneNumberField({
    super.key,
    required this.label,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeChanged,
    this.hint,
    this.errorText,
    this.helperText,
    this.helperStyle,
    this.suffixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final country = InternationalPhoneHelper.fallbackCountry(countryCode);
    final isEnabled = enabled;

    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: primaryLightColor,
      style: bodyTextStyle(context),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        labelStyle: isEnabled ? inputTextStyle(context) : bodyTextStyle(context),
        hintText: hint ?? 'Masukkan $label...',
        hintStyle: inputTextStyle(context, color: sGrey),
        filled: true,
        fillColor: isEnabled ? formGrey : sGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        prefixIcon: _PhoneCountryPrefix(
          country: country,
          enabled: isEnabled,
          onChanged: onCountryCodeChanged,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        suffixIcon: suffixIcon,
        border: _border(borderColor ?? sGrey),
        enabledBorder: _border(borderColor ?? sGrey),
        disabledBorder: _border(borderColor ?? sGrey),
        focusedBorder: _border(focusedBorderColor ?? primaryColor),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
        errorStyle: bodyTextStyle(context).copyWith(
          color: Colors.red,
          fontSize: 12,
        ),
        errorText:
            errorText != null && errorText!.trim().isNotEmpty ? errorText : null,
        helperText: helperText,
        helperStyle: helperStyle,
      ),
    );
  }
}

class _PhoneCountryPrefix extends StatelessWidget {
  final PhoneCountryCode country;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _PhoneCountryPrefix({
    required this.country,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => _showCountryPicker(context) : null,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                country.displayText,
                style: inputTextStyle(context, color: primaryLightColor),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/icons/dropdown.svg', width: 10),
              const SizedBox(width: 8),
              Container(width: 1, height: 22, color: sGrey),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<PhoneCountryCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _CountryPickerSheet(selectedCode: country.dialCode),
    );

    if (selected == null) return;
    onChanged(selected.dialCode);
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final int selectedCode;

  const _CountryPickerSheet({required this.selectedCode});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PhoneCountryCode> get _items {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return InternationalPhoneHelper.countries;

    return InternationalPhoneHelper.countries.where((item) {
      return item.dialCodeText.contains(q) ||
          item.isoCode.toLowerCase().contains(q) ||
          item.name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.72,
          minHeight: 260,
        ),
        decoration: const BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(cardBorderRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 12),
              decoration: BoxDecoration(
                color: sGrey,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: TextField(
                controller: _searchController,
                style: inputTextStyle(context, color: primaryLightColor),
                cursorColor: primaryLightColor,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Cari kode negara...',
                  hintStyle: inputTextStyle(context, color: hintGrey),
                  prefixIcon: Icon(Icons.search, color: hintGrey, size: 18),
                  filled: true,
                  fillColor: pGrey,
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
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'Kode negara tidak ditemukan',
                        style: bodyTextStyle(context).copyWith(
                          color: hintGrey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => kDivider(color: sGrey),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final selected = item.dialCode == widget.selectedCode;

                        return InkWell(
                          onTap: () => Navigator.pop(context, item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: hPadding * 1.5,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 64,
                                  child: Text(
                                    item.displayText,
                                    style: bodyTextStyle(context).copyWith(
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: bodyTextStyle(
                                      context,
                                      fontSize: 13,
                                    ).copyWith(color: hintGrey),
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
