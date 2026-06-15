import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/common/plat_nomor_formatter.dart';
import 'package:joss_app/repositories/combobox/combomjenisrugimv_repository.dart';
import 'package:joss_app/repositories/regklaim/sppapoliscari_repository.dart';
import 'package:joss_app/widgets/apptheme/dropdown2.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/combobox/combomjenisrugimv_model.dart';
import '../../../../../models/regklaim/sppapoliscari_model.dart';

class UserPolisPage extends StatefulWidget {
  final String cobKlaimId;
  final String cobKlaimNama;

  final SppapoliscariModel? selectedPolis;
  final ValueChanged<SppapoliscariModel?> onPolisChanged;

  final ComboMJenisrugimvModel? selectedJenisKerugian;
  final ValueChanged<ComboMJenisrugimvModel?> onJenisKerugianChanged;

  final String keterangan;
  final ValueChanged<String> onKeteranganChanged;

  const UserPolisPage({
    super.key,
    required this.cobKlaimId,
    required this.cobKlaimNama,
    required this.selectedPolis,
    required this.onPolisChanged,
    required this.selectedJenisKerugian,
    required this.onJenisKerugianChanged,
    required this.keterangan,
    required this.onKeteranganChanged,
  });

  @override
  State<UserPolisPage> createState() => _UserPolisPageState();
}

class _UserPolisPageState extends State<UserPolisPage> {
  late Future<List<ComboMJenisrugimvModel>> _futureJenisKerugian;

  final TextEditingController fieldKeteranganController =
  TextEditingController();

  final Map<String, String?> fieldErrors = {};

  String? err(String key) => fieldErrors[key];

  void setErr(String key, String? msg) {
    setState(() => fieldErrors[key] = msg);
  }

  void clearErr(String key) {
    if (!fieldErrors.containsKey(key)) return;
    setState(() => fieldErrors.remove(key));
  }

  @override
  void initState() {
    super.initState();

    _futureJenisKerugian =
        ComboMJenisrugimvRepository().getComboMJenisrugimv();

    fieldKeteranganController.text = widget.keterangan;
  }

  @override
  void didUpdateWidget(covariant UserPolisPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.keterangan != widget.keterangan &&
        fieldKeteranganController.text != widget.keterangan) {
      fieldKeteranganController.text = widget.keterangan;
    }
  }

  @override
  void dispose() {
    fieldKeteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: vPadding),
      child: Container(
        decoration: BoxDecoration(
          color: pGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cari Data Polis",
              style: TextStyle(
                color: primaryLightColor,
                fontSize: getResponsiveFont(context, 18),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: hPadding),
            buildFieldComboSppaPolis(),

            if (widget.cobKlaimId == '10002') ...[
              const SizedBox(height: hPadding),
              buildFieldJenisKerugian(),
            ],

            const SizedBox(height: hPadding),
            buildFieldLokasiResiko(),
          ],
        ),
      ),
    );
  }

  Widget buildFieldComboSppaPolis() =>
      ReusableComboBoxV2<SppapoliscariModel>(
        hintText: "No. Polis",
        initItem: widget.selectedPolis,
        params: {
          "cobKlaimId": widget.cobKlaimId,
        },
        loader: (query) {
          return SppapoliscariRepository().getSppapoliscari(
            query.params["cobKlaimId"] ?? "",
            query.searchText,
          );
        },
        displayText: (i) {
          final noPolis = i.polisNo.trim();
          return noPolis.isEmpty ? '-' : noPolis;
        },
        compareItems: (a, b) => a.sppaId == b.sppaId,
        onChangedCallback: (v) {
          widget.onPolisChanged(v);
        },
        customItemBuilder: (context, item, isSelected, isDisabled) {
          final noPolis =
          item.polisNo.trim().isEmpty ? '-' : item.polisNo.trim();
          final objek =
          item.sppaNoRef.trim().isEmpty ? '-' : item.sppaNoRef.trim();
          final detail =
          item.objectDesc.trim().isEmpty ? '-' : item.objectDesc.trim();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: hPadding * 1.5,
                  vertical: hPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No Polis: $noPolis", style: bodyTextStyle(context)),
                    const SizedBox(height: 4),
                    Text("Objek : $objek", style: bodyTextStyle(context)),
                    const SizedBox(height: 4),
                    Text("Detail : $detail", style: bodyTextStyle(context)),
                  ],
                ),
              ),
              kDivider(color: sGrey),
            ],
          );
        },
        onSaveCallback: (SppapoliscariModel? p1) {},
      );

  Widget buildFieldJenisKerugian() {
    return FutureBuilder<List<ComboMJenisrugimvModel>>(
      future: _futureJenisKerugian,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final jenisKerugianList = snapshot.data ?? [];

        if (jenisKerugianList.isEmpty) {
          return const Text('Tidak ada data jenis kerugian');
        }

        return FormField<ComboMJenisrugimvModel>(
          initialValue: widget.selectedJenisKerugian,
          validator: (_) {
            if (widget.cobKlaimId == '10002' &&
                widget.selectedJenisKerugian == null) {
              return kStringNullError;
            }
            return null;
          },
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Kerugian',
                  style: bodyTextStyle(
                    context,
                    fontSize: getResponsiveFont(context, 18),
                  ),
                ),
                const SizedBox(height: hPadding),
                Row(
                  children: jenisKerugianList.map((item) {
                    final isSelected =
                        widget.selectedJenisKerugian?.mjenisrugimvId ==
                            item.mjenisrugimvId;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onJenisKerugianChanged(item);
                          fieldState.didChange(item);
                          clearErr('form1.jenisKerugian');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? primaryColor : hintGrey,
                                  width: 1,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                ),
                              )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.jenisrugiNama,
                                overflow: TextOverflow.ellipsis,
                                style: isSelected
                                    ? inputTextStyle(context)
                                    : bodyTextStyle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: hPadding),
                if (fieldState.hasError || err('form1.jenisKerugian') != null)
                  Text(
                    fieldState.errorText ?? err('form1.jenisKerugian') ?? '',
                    style: const TextStyle(color: pRed, fontSize: 12),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildFieldLokasiResiko() => appTextField(
    label: widget.cobKlaimId == '10002' ? "Nomor Polisi" : "Keterangan",
    controller: fieldKeteranganController,
    maxLines: widget.cobKlaimId == '10002' ? 1 : 4,
    keyboardType: TextInputType.text,
    inputFormatters: widget.cobKlaimId == '10002'
        ? [
      PlatNomorFormatter(),
    ]
        : [
      FilteringTextInputFormatter.allow(
        RegExp(r"[0-9a-zA-Z ,./\-#()]"),
      ),
    ],
    errorText: err('form1.keterangan'),
    validator: (_) => null,
    onChanged: (v) {
      widget.onKeteranganChanged(v);
      if (v.trim().isNotEmpty) clearErr('form1.keterangan');
    },
  );
}