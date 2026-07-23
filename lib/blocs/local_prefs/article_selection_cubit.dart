import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/helper/app_prefs.dart';

class ArticleSelectionState {
  final String? berita1Id;
  final String? gambarArtikel;
  final String? judulArtikel;

  const ArticleSelectionState({
    this.berita1Id,
    this.gambarArtikel,
    this.judulArtikel,
  });

  ArticleSelectionState copyWith({
    String? berita1Id,
    String? gambarArtikel,
    String? judulArtikel,
  }) {
    return ArticleSelectionState(
      berita1Id: berita1Id ?? this.berita1Id,
      gambarArtikel: gambarArtikel ?? this.gambarArtikel,
      judulArtikel: judulArtikel ?? this.judulArtikel,
    );
  }
}

class ArticleSelectionCubit extends Cubit<ArticleSelectionState> {
  final AppPrefs prefs;
  ArticleSelectionCubit(this.prefs) : super(const ArticleSelectionState()) {
    _hydrate();
  }

  void _hydrate() {
    emit(ArticleSelectionState(
      berita1Id: prefs.berita1Id,
      gambarArtikel: prefs.gambarArtikel,
      judulArtikel: prefs.judulArtikel,
    ));
  }

  Future<void> selectArticle({
    String? berita1Id,
    String? gambarArtikel,
    String? judulArtikel,
  }) async {
    emit(ArticleSelectionState(
      berita1Id: berita1Id,
      gambarArtikel: gambarArtikel,
      judulArtikel: judulArtikel,
    ));

    await prefs.setBerita1Id(berita1Id);
    await prefs.setGambarArtikel(gambarArtikel);
    await prefs.setJudulArtikel(judulArtikel);
  }

  Future<void> clearSelection() async {
    await prefs.setBerita1Id(null);
    await prefs.setGambarArtikel(null);
    await prefs.setJudulArtikel(null);
    emit(const ArticleSelectionState());
  }
}
