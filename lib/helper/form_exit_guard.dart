class FormExitGuard {
  static Future<bool> multiCheck({
    required List<bool> oldExpanded,
    required List<bool> newExpanded,
    required Map<int, Future<bool> Function()> validators,
    required Map<int, Future<void> Function()> savers,
  }) async {

    for (int i = 0; i < oldExpanded.length; i++) {
      bool oldVal = oldExpanded[i];
      bool newVal = newExpanded[i];

      // intercept transisi TRUE → FALSE
      if (oldVal == true && newVal == false) {

        // cek VALIDASI dulu
        if (validators.containsKey(i)) {
          final valid = await validators[i]!();

          if (!valid) {
            print("❌ Form $i INVALID — ga boleh pindah");
            return false;
          }

          // kalau valid → SAVE
          if (savers.containsKey(i)) {
            await savers[i]!();
            print("💾 Form $i SAVED");
          }
        }
      }
    }

    return true; // semua aman
  }
}
