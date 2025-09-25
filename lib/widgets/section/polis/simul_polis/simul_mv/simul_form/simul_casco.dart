import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/simulmv/simulmvcrud_bloc.dart';
import 'package:joss_app/models/combobox/combommvgrupojk_model.dart';
import 'package:joss_app/widgets/combobox/combommvgrupojk_widget.dart';
import 'package:joss_app/models/combobox/combommvjnscover_model.dart';
import 'package:joss_app/widgets/combobox/combommvjnscover_widget.dart';
import 'package:joss_app/models/combobox/combomwilayah_model.dart';
import 'package:joss_app/widgets/combobox/combomwilayah_widget.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulmvFormCascoPage extends StatefulWidget {
  final String viewMode;
  final String recordId;

  const SimulmvFormCascoPage(
      {super.key, required this.viewMode, required this.recordId});

  @override
  SimulmvCrudFormPageFormCascoState createState() =>
      SimulmvCrudFormPageFormCascoState();
}

class SimulmvCrudFormPageFormCascoState
    extends State<SimulmvFormCascoPage> {
  late SimulmvCrudBloc simulmvCrudBloc;
  final _formKey = GlobalKey<FormState>();
  var fieldCoverBulanController = TextEditingController();
  var fieldHargaController = TextEditingController();
  ComboMMvgrupOjkModel? fieldComboMMvgrupOjk;
  final comboMMvgrupOjkKey =
  GlobalKey<DropdownSearchState<ComboMMvgrupOjkModel>>();
  ComboMMvjnscoverModel? fieldComboMMvjnscover;
  final comboMMvjnscoverKey =
  GlobalKey<DropdownSearchState<ComboMMvjnscoverModel>>();
  ComboMWilayahModel? fieldComboMWilayah;
  final comboMWilayahKey = GlobalKey<DropdownSearchState<ComboMWilayahModel>>();
  var fieldThnBuatController =
  TextEditingController(text: DateTime.now().year.toString());
  final dropDownKeyTahun = GlobalKey<DropdownSearchState>();
  final List<String> _yearList = [];
  String selectedYear = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      loadData();
      int startYear = DateTime.now().year;
      int endYear = startYear - 10;
      selectedYear = startYear.toString();
      for (int i = startYear; i >= endYear; i--) {
        debugPrint("Tahun : $i");
        _yearList.add(i.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    simulmvCrudBloc = BlocProvider.of<SimulmvCrudBloc>(context);

    return BlocConsumer<SimulmvCrudBloc, SimulmvCrudState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Row 1: Jenis Kendaraan & Tahun Pembuatan
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: buildFieldJenisKendaraan(),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: buildFieldComboTahun(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 2: Jenis Cover & Harga Kendaraan
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: buildFieldJenisCover(),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: buildFieldHarga(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Wilayah & Lama Cover responsif tanpa padding
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;

                    final left = Flexible(flex: 1, child: buildFieldWilayah());
                    final right = Flexible(flex: 1, child: buildFieldLamaCover());

                    if (isMobile) {
                      // tumpuk vertikal di layar sempit
                      return Column(
                        children: [
                          left.child as Widget,
                          const SizedBox(height: 10),
                          right.child as Widget,
                        ],
                      );
                    }

                    // berdampingan di layar lebar
                    return Row(
                      children: [
                        left,
                        const SizedBox(width: 8),
                        right,
                      ],
                    );
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.isLoaded) {
          debugPrint("listener #X01");
          if (state.record != null) {
            fieldCoverBulanController.text = state.record!.coverBulan.toString();
            fieldHargaController.text = NumberFormat("#,###").format(state.record!.harga);
            fieldThnBuatController.text = state.record!.thnBuat.toString();
          }
          fieldComboMMvgrupOjk = state.comboMMvgrupOjk;
          fieldComboMMvjnscover = state.comboMMvjnscover;
          fieldComboMWilayah = state.comboMWilayah;
        }
      },
    );
  }

  void loadData() {
    if (widget.viewMode == "ubah") {
      simulmvCrudBloc.add(SimulmvCrudLihatEvent(recordId: widget.recordId));
    } else if (widget.viewMode == "tambah") {
      simulmvCrudBloc.add(SimulMVCrudInitValueEvent());
    }
  }

// Revisi buildFieldComboTahun dengan desain yang sama
  Widget buildFieldComboTahun() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Tahun Pembuatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // DropdownSearch dengan custom decoration
        DropdownSearch<String>(
          key: dropDownKeyTahun,
          selectedItem: selectedYear,
          items: (filter, infiniteScrollProps) => _yearList,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: '-- Pilih Tahun Pembuatan --',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              // Custom border dengan warna hijau
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF91C050),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF91C050),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF91C050),
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              // Hilangkan label text karena sudah ada di atas
              labelText: null,
            ),
          ),
          suffixProps: const DropdownSuffixProps(
            clearButtonProps: ClearButtonProps(isVisible: false),
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              iconOpened: Icon(Icons.keyboard_arrow_up, color: Color(0xFF91C050)),
            ),
          ),
          popupProps: PopupProps.modalBottomSheet(
            disableFilter: false,
            showSelectedItems: true,
            showSearchBox: false,
            itemBuilder: itemBuilderComboTahun,
            // Custom modal design
            modalBottomSheetProps: const ModalBottomSheetProps(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            containerBuilder: (context, popupWidget) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header modal
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih Tahun Pembuatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(child: popupWidget),
                  ],
                ),
              );
            },
          ),
          onChanged: (value) {
            simulmvCrudBloc
                .add(FieldTahunChangedEvent(tahun: int.parse(value ?? "0")));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Tahun Pembuatan tidak boleh kosong";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget itemBuilderComboTahun(
      BuildContext context, String item, bool isSelected, bool isDisabled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF91C050) : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0xFF91C050).withOpacity(0.1) : Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item,
          style: TextStyle(
            color: isSelected ? const Color(0xFF91C050) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(
          Icons.check_circle,
          color: Color(0xFF91C050),
          size: 20,
        )
            : null,
      ),
    );
  }


// Revisi buildFieldHarga dengan desain yang konsisten
  Widget buildFieldHarga() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Harga Kendaraan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldHargaController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: ",000,000,-",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti dropdown)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            value = value.replaceAll(",", "");
            simulmvCrudBloc
                .add(FieldHargaChangedEvent(harga: double.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Harga Kendaraan tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan harga > 0
            String cleanValue = value.replaceAll(",", "");
            double? harga = double.tryParse(cleanValue);
            if (harga == null || harga <= 0) {
              return "Harga harus lebih dari 0";
            }
            return null;
          },
        ),
      ],
    );
  }


  // Fungsi buildFieldJenisKendaraan yang sudah direvisi
  Widget buildFieldJenisKendaraan() {
    return buildFieldComboMMvgrupOjk(
      comboKey: comboMMvgrupOjkKey,
      labelText: 'Jenis Kendaraan',
      initItem: fieldComboMMvgrupOjk,
      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMMvgrupOjk tidak boleh kosong.");
          simulmvCrudBloc
              .add(ComboMMvgrupOjkChangedEvent(comboMMvgrupOjk: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvgrupOjk = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMMvgrupOjk tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldWilayah() {
    return buildFieldComboMWilayah(
      comboKey: comboMWilayahKey,
      labelText: 'Wilayah',
      initItem: fieldComboMWilayah,
      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMWilayah tidak boleh kosong.");
          simulmvCrudBloc.add(ComboMWilayahChangedEvent(comboMWilayah: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMWilayah = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMWilayah tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldJenisCover() {
    return buildFieldComboMMvjnscover(
      comboKey: comboMMvjnscoverKey,
      labelText: 'Jenis Cover',
      initItem: fieldComboMMvjnscover,
      onChangedCallback: (value) {
        if (value != null) {
          //removeError(error: "Field ComboMMvjnscover tidak boleh kosong.");
          simulmvCrudBloc
              .add(ComboMMvjnscoverChangedEvent(comboMMvjnscover: value));
        }
      },
      onSaveCallback: (value) {
        if (value != null) {
          fieldComboMMvjnscover = value;
        }
      },
      validatorCallback: (value) {
        if (value == null) {
          //addError(error: "Field ComboMMvjnscover tidak boleh kosong.");
        }
      },
    );
  }

  Widget buildFieldLamaCover() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field
        const Text(
          'Lama Cover',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField dengan custom decoration
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [ThousandsSeparatorInputFormatter()],
          controller: fieldCoverBulanController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            suffixText: " bulan",
            suffixStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            // Custom border dengan warna hijau (sama seperti field lainnya)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF91C050),
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            // Hilangkan floating label karena sudah ada label di atas
            labelText: null,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            simulmvCrudBloc
                .add(FieldLamaCoverChangedEvent(lama: int.tryParse(value) ?? 0));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Lama Cover tidak boleh kosong";
            }
            // Validasi tambahan untuk memastikan lama cover > 0
            int? lama = int.tryParse(value);
            if (lama == null || lama <= 0) {
              return "Lama cover harus lebih dari 0 bulan";
            }
            // Validasi maksimal (opsional, sesuaikan dengan business rule)
            if (lama > 120) { // contoh: maksimal 10 tahun
              return "Lama cover maksimal 120 bulan";
            }
            return null;
          },
        ),
      ],
    );
  }
}
