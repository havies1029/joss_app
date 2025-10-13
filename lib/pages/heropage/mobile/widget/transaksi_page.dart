import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_trslog/trslogcari_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/pages/base/base_background_sidepage.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  late TrslogCariBloc trslogCariBloc;
  String? selectedFilter;
  List<dynamic> allItems = [];
  List<dynamic> filteredItems = [];

  final List<String> filterOptions = [
    "Pembayaran Premi",
    "Klaim Asuransi",
    "Penutupan Asuransi",
  ];

  @override
  void initState() {
    super.initState();
    trslogCariBloc = BlocProvider.of<TrslogCariBloc>(context);
    _loadData();
  }

  void _loadData() {
    Future.delayed(const Duration(milliseconds: 300), () {
      trslogCariBloc.add(RefreshTrslogCariEvent(searchText: ''));
    });
  }

  void _applyFilter(String? filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == null) {
        filteredItems = List.from(allItems);
      } else {
        filteredItems =
            allItems
                .where(
                  (item) =>
              item.jenis_trs?.toLowerCase() == filter.toLowerCase(),
            )
                .toList();
      }
    });
  }

  void _updateItemsFromBloc(List<dynamic> items) {
    allItems = items;
    _applyFilter(selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Semua Transaksi",
      child: Container(
        color: secondaryBlackColor,
        child: Column(
          children: [
            const SizedBox(height: vPadding),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(
                        "Semua",
                        style: bodyTextStyle(context, fontSize: 16),
                      ),
                      selected: selectedFilter == null,
                      onSelected: (selected) {
                        if (selected) _applyFilter(null);
                      },
                      selectedColor: primaryColor,
                      backgroundColor: pGrey,
                      showCheckmark: false,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardBorderRadius),
                      ),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...filterOptions.map(
                          (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            filter,
                            style: bodyTextStyle(context, fontSize: 16),
                          ),
                          selected: selectedFilter == filter,
                          onSelected: (selected) {
                            if (selected) _applyFilter(filter);
                          },
                          selectedColor: primaryColor,
                          backgroundColor: pGrey,
                          showCheckmark: false,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              cardBorderRadius,
                            ),
                          ),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: vPadding),

            // Transaction List
            Expanded(
              child: BlocListener<TrslogCariBloc, TrslogCariState>(
                listener: (context, state) {
                  if (state.status == ListStatus.success) {
                    _updateItemsFromBloc(state.items);
                  }
                },
                child: BlocBuilder<TrslogCariBloc, TrslogCariState>(
                  builder: (context, state) {
                    if (state.status == ListStatus.initial) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state.status == ListStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: hintGrey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Gagal memuat data",
                                style: bodyTextStyle(context, fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Periksa koneksi internet Anda",
                                style: bodyTextStyle(
                                  context,
                                ).copyWith(color: hintGrey),
                              ),
                              const SizedBox(height: 16),
                              AppButton.primary(
                                text: "Coba Lagi",
                                onPressed: _loadData,
                                backgroundColor: pBlue,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/transaksi.svg",
                                width: 64,
                                height: 64,
                                color: hintGrey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                selectedFilter == null
                                    ? "Belum ada transaksi"
                                    : "Tidak ada transaksi",
                                style: bodyTextStyle(context, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              if (selectedFilter != null)
                                Text(
                                  "untuk kategori \"$selectedFilter\"",
                                  style: bodyTextStyle(
                                    context,
                                  ).copyWith(color: hintGrey),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _loadData();
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: _groupedTransactions().length,
                          itemBuilder: (context, groupIndex) {
                            final group = _groupedTransactions()[groupIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Month Header (Outside card)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: hPadding * 1.5,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        group['month'],
                                        style: bodyTextStyle(context, fontSize: 16),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${group['items'].length} Transaksi",
                                        style: bodyTextStyle(context, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),

                                // Card with transactions
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: hPadding * 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pGrey,
                                    borderRadius: BorderRadius.circular(cardBorderRadius),
                                    border: Border.all(color: sGrey),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: group['items'].length,
                                    separatorBuilder: (context, index) =>
                                        kDivider(color: sGrey),
                                    itemBuilder: (context, index) {
                                      final item = group['items'][index];
                                      return _buildTransactionItem(context, item);
                                    },
                                  ),
                                ),

                                const SizedBox(height: vPadding),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, dynamic item) {
    final iconAsset = _getIconAsset(item.jenis_trs);

    // Format tanggal
    String dateTimeStr = "-";
    if (item.trsTgl != null) {
      try {
        final tglDt =
        (item.trsTgl is String) ? DateTime.parse(item.trsTgl) : item.trsTgl;
        dateTimeStr = "${tglDt.day} ${_monthIndo(tglDt.month)} ${tglDt.year}";
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(hPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon dengan background
          SvgPicture.asset(iconAsset, width: 40, height: 40),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction type
                Text(
                  item.jenis_trs ?? "-",
                  style: bodyTextStyle(context, fontSize: 20),
                ),
                const SizedBox(height: 4),

                // Date and time
                Text(
                  dateTimeStr,
                  style: bodyTextStyle(
                    context,
                    fontSize: 16,
                  ).copyWith(color: hintGrey),
                ),
              ],
            ),
          ),

          // status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(item.status_nama),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status_nama ?? "-",
              style: bodyTextStyle(context, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getIconAsset(String? jenisTrs) {
    switch (jenisTrs?.toLowerCase()) {
      case 'pembayaran premi':
        return "assets/icons/pembayaran_premi.svg";
      case 'klaim asuransi':
        return "assets/icons/klaim_asuransi.svg";
      case 'penutupan asuransi':
        return "assets/icons/tagihan_pembayaran.svg";
      default:
        return "assets/icons/transaksi.svg";
    }
  }

  String _monthIndo(int month) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return bulan[month];
  }

  String _monthIndoFull(int month) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulan[month];
  }

  Color _getStatusColor(String? status) {
    if (status == null) return pGrey;
    switch (status.toLowerCase()) {
      case "berhasil":
      case "disetujui":
        return pGreen;
      case "ditolak":
        return pRed;
      case "diproses":
        return pBlue;
      default:
        return pGrey;
    }
  }

  List<Map<String, dynamic>> _groupedTransactions() {
    Map<String, List<dynamic>> grouped = {};

    for (var item in filteredItems) {
      if (item.trsTgl != null) {
        try {
          final tglDt = (item.trsTgl is String)
              ? DateTime.parse(item.trsTgl)
              : item.trsTgl;
          final monthYear = "${_monthIndoFull(tglDt.month)} ${tglDt.year}";

          if (!grouped.containsKey(monthYear)) {
            grouped[monthYear] = [];
          }
          grouped[monthYear]!.add(item);
        } catch (_) {}
      }
    }

    // Sort by date (newest first)
    List<Map<String, dynamic>> result = [];
    final sortedKeys = grouped.keys.toList()..sort((a, b) {
      try {
        final dateA = _parseMonthYear(a);
        final dateB = _parseMonthYear(b);
        return dateB.compareTo(dateA);
      } catch (_) {
        return 0;
      }
    });

    for (var key in sortedKeys) {
      result.add({
        'month': key,
        'items': grouped[key]!,
      });
    }

    return result;
  }

  DateTime _parseMonthYear(String monthYear) {
    final parts = monthYear.split(' ');
    if (parts.length != 2) return DateTime.now();

    final monthMap = {
      'Januari': 1, 'Februari': 2, 'Maret': 3, 'April': 4,
      'Mei': 5, 'Juni': 6, 'Juli': 7, 'Agustus': 8,
      'September': 9, 'Oktober': 10, 'November': 11, 'Desember': 12,
    };

    final month = monthMap[parts[0]] ?? 1;
    final year = int.tryParse(parts[1]) ?? DateTime.now().year;

    return DateTime(year, month);
  }
}