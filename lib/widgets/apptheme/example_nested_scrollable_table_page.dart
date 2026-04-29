import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExampleNestedScrollableTablesPage extends StatelessWidget {
  const ExampleNestedScrollableTablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final table1 = _generateData('A', 'Aktif', 'Nonaktif');
    final table2 = _generateData('B', 'Pending', 'Selesai');
    final table3 = _generateData('C', 'Review', 'Valid');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Nested Scrollable Tables'),
      ),
      body: ParentScrollablePage(
        children: [
          ScrollableTableSection(title: 'Judul Tabel 1', data: table1),
          const SizedBox(height: 24),
          ScrollableTableSection(title: 'Judul Tabel 2', data: table2),
          const SizedBox(height: 24),
          ScrollableTableSection(title: 'Judul Tabel 3', data: table3),
        ],
      ),
    );
  }

  List<DummyData> _generateData(
      String prefix,
      String statusA,
      String statusB,
      ) {
    return List.generate(
      50,
          (i) => DummyData(
        no: i + 1,
        nama: 'Data $prefix ${i + 1}',
        status: i.isEven ? statusA : statusB,
      ),
    );
  }
}

class ParentScrollablePage extends StatefulWidget {
  final List<Widget> children;

  const ParentScrollablePage({
    super.key,
    required this.children,
  });

  static ParentScrollablePageState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ParentScrollablePageState>();
  }

  @override
  State<ParentScrollablePage> createState() => ParentScrollablePageState();
}

class ParentScrollablePageState extends State<ParentScrollablePage> {
  final ScrollController controller = ScrollController();

  void scrollBy(double delta) {
    if (!controller.hasClients) return;

    final position = controller.position;
    final nextOffset = (controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    controller.animateTo(
      nextOffset,
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.children,
      ),
    );
  }
}

class ScrollableTableSection extends StatefulWidget {
  final String title;
  final List<DummyData> data;

  const ScrollableTableSection({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  State<ScrollableTableSection> createState() => _ScrollableTableSectionState();
}

class _ScrollableTableSectionState extends State<ScrollableTableSection> {
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  void _handleWheelScroll(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!verticalController.hasClients) return;

    final delta = event.scrollDelta.dy;
    final position = verticalController.position;

    final isAtTop = position.pixels <= position.minScrollExtent;
    final isAtBottom = position.pixels >= position.maxScrollExtent;

    final isScrollingUp = delta < 0;
    final isScrollingDown = delta > 0;

    final shouldPassToParent =
        (isAtTop && isScrollingUp) || (isAtBottom && isScrollingDown);

    if (shouldPassToParent) {
      ParentScrollablePage.maybeOf(context)?.scrollBy(delta);
    }
  }

  bool _handleOverscroll(OverscrollNotification notification) {
    final overscroll = notification.overscroll;

    if (overscroll == 0) return false;

    ParentScrollablePage.maybeOf(context)?.scrollBy(overscroll);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 48;
    const int visibleRows = 8;
    const double tableHeight = rowHeight * visibleRows;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        NotificationListener<OverscrollNotification>(
          onNotification: _handleOverscroll,
          child: Listener(
            onPointerSignal: _handleWheelScroll,
            child: Container(
              height: tableHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Scrollbar(
                  controller: verticalController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: verticalController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Scrollbar(
                      controller: horizontalController,
                      thumbVisibility: true,
                      notificationPredicate: (notification) {
                        return notification.metrics.axis == Axis.horizontal;
                      },
                      child: SingleChildScrollView(
                        controller: horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Keterangan')),
                          ],
                          rows: widget.data.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Text('${item.no}')),
                                DataCell(Text(item.nama)),
                                DataCell(Text(item.status)),
                                DataCell(Text('Keterangan ${item.no}')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DummyData {
  final int no;
  final String nama;
  final String status;

  const DummyData({
    required this.no,
    required this.nama,
    required this.status,
  });
}