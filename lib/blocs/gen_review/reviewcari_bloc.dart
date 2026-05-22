import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/list_extension.dart';
import 'package:joss_app/models/gen_review/reviewcari_model.dart';
import 'package:joss_app/repositories/gen_review/reviewcari_repository.dart';

part 'reviewcari_event.dart';
part 'reviewcari_state.dart';

class ReviewCariBloc extends Bloc<ReviewCariEvents, ReviewCariState> {
	ReviewCariBloc() : super(const ReviewCariState()) {
		on<FetchReviewCariEvent>(onFetchReviewCari);
		on<RefreshReviewCariEvent>(onRefreshReviewCari);
	}

	final List<ReviewCariModel> dummyItems = [
		ReviewCariModel(
			instansi: 'PT Nusantara Teknologi',
			isAktif: true,
			komentar: 'Pelayanan sangat cepat dan profesional.',
			nilai: 4.5,
			reviewTgl: DateTime(2024, 6, 12, 14, 21),
			review1Id: 'REV001',
			reviewer: 'Budi Santoso',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Universitas Indonesia',
			isAktif: true,
			komentar: 'Sistemnya mudah digunakan dan support responsif.',
			nilai: 4.8,
			reviewTgl: DateTime(2024, 6, 10, 10, 15),
			review1Id: 'REV002',
			reviewer: 'Siti Rahma',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'PT Global Logistik',
			isAktif: true,
			komentar: 'Layanan yang diberikan sangat memuaskan.',
			nilai: 4.3,
			reviewTgl: DateTime(2024, 5, 20, 9, 30),
			review1Id: 'REV003',
			reviewer: 'Ahmad Fauzi',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Bank Mandiri',
			isAktif: true,
			komentar: 'Implementasi berjalan lancar dan tim kooperatif.',
			nilai: 4.7,
			reviewTgl: DateTime(2024, 5, 18, 13, 10),
			review1Id: 'REV004',
			reviewer: 'Dewi Lestari',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Startup Digital ID',
			isAktif: true,
			komentar: 'Pengalaman kerja sama sangat baik.',
			nilai: 4.6,
			reviewTgl: DateTime(2024, 4, 10, 16, 45),
			review1Id: 'REV005',
			reviewer: 'Rizky Pratama',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'PT Solusi Digital',
			isAktif: true,
			komentar: 'Support cepat dan komunikasinya jelas.',
			nilai: 4.4,
			reviewTgl: DateTime(2024, 4, 8, 11, 20),
			review1Id: 'REV006',
			reviewer: 'Andi Wijaya',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Shopee Indonesia',
			isAktif: true,
			komentar: 'Sangat membantu kebutuhan operasional kami.',
			nilai: 4.9,
			reviewTgl: DateTime(2024, 3, 22, 15, 5),
			review1Id: 'REV007',
			reviewer: 'Maya Putri',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Tokopedia',
			isAktif: true,
			komentar: 'Proses cepat dan hasilnya sesuai kebutuhan.',
			nilai: 4.2,
			reviewTgl: DateTime(2024, 3, 15, 8, 40),
			review1Id: 'REV008',
			reviewer: 'Fajar Nugroho',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Traveloka',
			isAktif: true,
			komentar: 'UI rapi, mudah dipahami, dan stabil.',
			nilai: 4.8,
			reviewTgl: DateTime(2024, 2, 27, 14, 0),
			review1Id: 'REV009',
			reviewer: 'Linda Sari',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'Bukalapak',
			isAktif: true,
			komentar: 'Tim profesional dan responsif saat dibutuhkan.',
			nilai: 4.1,
			reviewTgl: DateTime(2024, 2, 12, 10, 30),
			review1Id: 'REV010',
			reviewer: 'Yoga Saputra',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'OVO',
			isAktif: true,
			komentar: 'Solusi yang diberikan sangat membantu.',
			nilai: 4.7,
			reviewTgl: DateTime(2024, 1, 25, 9, 15),
			review1Id: 'REV011',
			reviewer: 'Citra Dewi',
			skala: 5,
		),
		ReviewCariModel(
			instansi: 'DANA Indonesia',
			isAktif: true,
			komentar: 'Recommended untuk kebutuhan perusahaan.',
			nilai: 4.5,
			reviewTgl: DateTime(2024, 1, 10, 16, 10),
			review1Id: 'REV012',
			reviewer: 'Hendra Gunawan',
			skala: 5,
		),
	];

	Future<void> onRefreshReviewCari(
			RefreshReviewCariEvent event,
			Emitter<ReviewCariState> emit,
			) async {
		emit(const ReviewCariState());
		add(FetchReviewCariEvent());
	}

	Future<void> onFetchReviewCari(
			FetchReviewCariEvent event,
			Emitter<ReviewCariState> emit,
			) async {
		if (state.hasReachedMax) return;

		return emit(state.copyWith(
			items: dummyItems,
			hasReachedMax: true,
			status: ListStatus.success,
			hal: 1,
		));
	}
}