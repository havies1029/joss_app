import 'package:flutter/material.dart';
import 'dart:async';
import 'package:joss_app/models/gen_profile/rekanpiccobcari_model.dart';
import 'package:joss_app/repositories/gen_profile/rekanpiccobcari_repository.dart';

class RekanPicCobMultiPage extends StatefulWidget {
  final String rekanPicId;
  const RekanPicCobMultiPage({super.key, required this.rekanPicId});

  @override
  State<RekanPicCobMultiPage> createState() => _RekanPicCobMultiPageState();
}

class _RekanPicCobMultiPageState extends State<RekanPicCobMultiPage> {
  List<RekanPicCobCariModel> cobOptions = [];
  List<RekanPicCobCariModel> filteredCob = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCobList();
    _searchController.addListener(_filterCob);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 🧠 Load daftar COB dari API
  Future<void> _loadCobList() async {
    setState(() => isLoading = true);
    try {
      final repo = RekanPicCobCariRepository();
      final list = await repo.getRekanPicCobCari(widget.rekanPicId, '', 0);
      cobOptions = list;
      filteredCob = List.from(list);

      debugPrint("✅ COB loaded: ${list.length} items");
      for (var e in list) {
        debugPrint("→ ${e.cobNama} | checked=${e.isChecked}");
      }
    } catch (e) {
      debugPrint("❌ Error load COB: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterCob() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCob = cobOptions
          .where((item) => item.cobNama.toLowerCase().contains(query))
          .toList();
    });
  }

  /// 💾 Submit perubahan ke server
  Future<void> _submitToServer() async {
    setState(() => isSaving = true);
    try {
      final repo = RekanPicCobCariRepository();

      // hanya kirim yang berubah (biar efisien)
      final listChecked = cobOptions
          .map((item) => RekanPicCobCariCheckboxModel(
        mcobId: item.mcobId,
        isChecked: item.isChecked,
      ))
          .toList();

      debugPrint("📦 Data dikirim: ${listChecked.length}");
      debugPrint(listChecked.map((e) => "${e.mcobId}:${e.isChecked}").join(", "));

      final result =
      await repo.rekanPicCobUpdateList(widget.rekanPicId, listChecked);

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Daftar COB berhasil disimpan ✅"),
          backgroundColor: Colors.green,
        ));

        // 🔁 reload ulang dari server untuk validasi hasilnya
        await _loadCobList();

        debugPrint("🟩 Reloaded dari server setelah update:");
        for (var e in cobOptions) {
          debugPrint("→ ${e.cobNama} | checked=${e.isChecked}");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal menyimpan data ❌"),
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      debugPrint("❌ Error POST: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Pilih Daftar COB"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search bar + Refresh
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.search, color: Colors.white70),
                        hintText: "Cari COB...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _loadCobList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.refresh,
                        color: Colors.white, size: 18),
                    label: const Text("Refresh",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

            // 📋 List COB
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredCob.length,
                itemBuilder: (_, index) {
                  final item = filteredCob[index];
                  return CheckboxListTile(
                    value: item.isChecked,
                    onChanged: (val) {
                      setState(() {
                        item.isChecked = val ?? false;
                      });
                    },
                    activeColor: Colors.orange,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(color: Colors.white54),
                    title: Text(item.cobNama,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15)),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),

            // 💾 Save button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : _submitToServer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Simpan Perubahan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
