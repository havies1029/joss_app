import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  final SharedPreferences _sp;
  AppPrefs(this._sp);

  // === Auth Related ===
  static const _kLastLoginEmail = 'lastLoginEmail';
  static const _kGoogleDisplayName = 'googleDisplayName';

  String? get lastLoginEmail => _sp.getString(_kLastLoginEmail);
  String? get googleDisplayName => _sp.getString(_kGoogleDisplayName);

  Future<void> setLastLoginEmail(String? v) async {
    if (v == null || v.isEmpty) {
      await _sp.remove(_kLastLoginEmail);
    } else {
      await _sp.setString(_kLastLoginEmail, v);
    }
  }

  Future<void> setGoogleDisplayName(String? v) async {
    if (v == null || v.isEmpty) {
      await _sp.remove(_kGoogleDisplayName);
    } else {
      await _sp.setString(_kGoogleDisplayName, v);
    }
  }

  // === Artikel Related ===
  static const _kBerita1Id = 'berita1Id';
  static const _kGambarArtikel = 'gambarArtikel';
  static const _kJudulArtikel = 'judulArtikel';

  String? get berita1Id => _sp.getString(_kBerita1Id);
  String? get gambarArtikel => _sp.getString(_kGambarArtikel);
  String? get judulArtikel => _sp.getString(_kJudulArtikel);

  Future<void> setBerita1Id(String? v) async {
    if (v == null || v.isEmpty) {
      await _sp.remove(_kBerita1Id);
    } else {
      await _sp.setString(_kBerita1Id, v);
    }
  }

  Future<void> setGambarArtikel(String? v) async {
    if (v == null || v.isEmpty) {
      await _sp.remove(_kGambarArtikel);
    } else {
      await _sp.setString(_kGambarArtikel, v);
    }
  }

  Future<void> setJudulArtikel(String? v) async {
    if (v == null || v.isEmpty) {
      await _sp.remove(_kJudulArtikel);
    } else {
      await _sp.setString(_kJudulArtikel, v);
    }
  }
}
