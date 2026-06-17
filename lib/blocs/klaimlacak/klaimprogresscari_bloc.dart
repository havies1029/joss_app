import 'package:joss_app/models/klaimlacak/klaim_progress_info_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_jadwal_bayar_model.dart';
import 'package:joss_app/models/klaimlacak/klaim_progress_nilai_klaim_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/klaimlacak/klaimprogresscari_model.dart';
import 'package:joss_app/repositories/klaimlacak/klaimprogresscari_repository.dart';

part 'klaimprogresscari_event.dart';
part 'klaimprogresscari_state.dart';

class KlaimprogresscariBloc
		extends Bloc<KlaimprogresscariEvents, KlaimprogresscariState> {
	KlaimprogresscariBloc() : super(const KlaimprogresscariState()) {
		on<FetchKlaimprogresscariEvent>(onFetchKlaimprogresscari);
		on<RefreshKlaimprogresscariEvent>(onRefreshKlaimprogresscari);
		on<InjectDummyKlaimprogresscariEvent>(onInjectDummyKlaimprogresscari);
	}

	Future<void> onRefreshKlaimprogresscari(
			RefreshKlaimprogresscariEvent event,
			Emitter<KlaimprogresscariState> emit,
			) async {
		// reset total state lama, tapi klaim1Id tetap masuk
		emit(
			KlaimprogresscariState(
				klaim1Id: event.klaim1Id,
			),
		);

		add(FetchKlaimprogresscariEvent());
	}

	Future<void> onFetchKlaimprogresscari(
			FetchKlaimprogresscariEvent event,
			Emitter<KlaimprogresscariState> emit,
			) async {
		if (state.hasReachedMax) return;
		if (state.klaim1Id.trim().isEmpty) return;

		emit(state.copyWith(status: ListStatus.loadingMore));

		try {
			final repo = KlaimprogresscariRepository();
			final result = await repo.getKlaimprogresscari(state.klaim1Id);

			emit(
				state.copyWith(
					items: result?.listProgress ?? const [],
					nilaiKlaim: result?.nilaiKlaim,
					jadwalBayar: result?.jadwalBayar ?? const [],
					klaimProgressInfo: result?.klaimProgressInfo,
					hasReachedMax: true,
					status: ListStatus.success,
				),
			);
		} catch (e) {
			emit(state.copyWith(status: ListStatus.failure));
		}
	}

	Future<void> onInjectDummyKlaimprogresscari(
			InjectDummyKlaimprogresscariEvent event,
			Emitter<KlaimprogresscariState> emit,
			) async {
		emit(
			KlaimprogresscariState(
				klaim1Id: event.klaim1Id,
				status: ListStatus.success,
				hasReachedMax: true,
				items: _dummyProgressItems(),
				nilaiKlaim: _dummyNilaiKlaim(),
				jadwalBayar: _dummyJadwalBayar(),
				klaimProgressInfo: _dummyProgressInfo(),
			),
		);
	}

	List<KlaimprogresscariModel> _dummyProgressItems() {
		return [
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY001',
				progressNama: 'Mobil Masuk Bengkel',
				progressDesc:
				'Unit kendaraan sudah diterima oleh bengkel rekanan untuk pengecekan awal.',
				progressTgl: DateTime(2026, 5, 7, 9, 30),
				fileUrl: null,
				actioncode: '',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY002',
				progressNama: 'Dokumen Klaim Diterima',
				progressDesc:
				'Dokumen klaim sudah diterima dan sedang dilakukan proses verifikasi.',
				progressTgl: DateTime(2026, 5, 8, 10, 15),
				fileUrl: 'assets/dummy/test1.pdf',
				actioncode: 'file',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY006',
				progressNama: 'Lampiran Estimasi Bengkel',
				progressDesc:
				'File estimasi biaya perbaikan dari bengkel rekanan.',
				progressTgl: DateTime(2026, 5, 9, 13, 10),
				fileUrl: 'assets/dummy/test1.pdf',
				actioncode: 'file',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY003',
				progressNama: 'Nilai Klaim',
				progressDesc: '',
				progressTgl: DateTime(2026, 5, 10, 14, 20),
				fileUrl: null,
				actioncode: 'nilai_klaim',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY004',
				progressNama: 'Jadwal Pembayaran',
				progressDesc: '',
				progressTgl: DateTime(2026, 5, 12, 11, 0),
				fileUrl: null,
				actioncode: 'table_payment',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY005',
				progressNama: 'Foto Progress Bengkel',
				progressDesc:
				'Foto progress pengerjaan kendaraan dari pihak bengkel.',
				progressTgl: DateTime(2026, 5, 13, 15, 45),
				fileUrl:
				'https://dummyimage.com/900x600/2b2b2b/ffffff.png&text=Progress+Bengkel',
				actioncode: 'image',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY007',
				progressNama:
				'Judul Progress Sangat Panjang Untuk Menguji Apakah Text Akan Turun Baris Dengan Aman Di Layar Mobile',
				progressDesc:
				'Deskripsi progress ini sengaja dibuat panjang untuk memastikan card tetap rapi, tidak overflow ke kanan, tidak menabrak timeline, dan tetap enak dibaca pada ukuran layar kecil maupun tablet.',
				progressTgl: DateTime(2026, 5, 14, 8, 5),
				fileUrl: null,
				actioncode: '',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY008',
				progressNama: 'File Lampiran Nama Panjang',
				progressDesc:
				'Testing card file dengan nama file panjang supaya overflow text bisa diuji.',
				progressTgl: DateTime(2026, 5, 14, 10, 30),
				fileUrl:
				'Dokumen_Klaim_Kendaraan_Dengan_Nama_File_Sangat_Panjang_Final_Revisi_12_Tahun_2026.pdf',
				actioncode: 'file',
			),
			KlaimprogresscariModel(
				klaimprogressId: 'DUMMY009',
				progressNama: 'Foto Dengan Deskripsi Panjang',
				progressDesc:
				'Testing layout ketika card punya gambar di kanan dan teks di kiri yang panjang. Ini penting karena di mobile ruang horizontal kecil.',
				progressTgl: DateTime(2026, 5, 15, 13, 45),
				fileUrl:
				'https://dummyimage.com/900x600/2b2b2b/ffffff.png&text=Damage+Photo',
				actioncode: 'image',
			),
			KlaimprogresscariModel(
				klaimprogressId: '',
				progressNama: 'Mobil Selesai',
				progressDesc: '',
				progressTgl: null,
				fileUrl: null,
				actioncode: '',
			),
			KlaimprogresscariModel(
				klaimprogressId: '',
				progressNama: 'Mobil Diambil atau Diantar oleh Klien',
				progressDesc: '',
				progressTgl: null,
				fileUrl: null,
				actioncode: '',
			),
		];
	}

	KlaimProgressNilaiKlaimModel _dummyNilaiKlaim() {
		return KlaimProgressNilaiKlaimModel(
			curr: 'IDR',
			klaimAmount: 5069015.00,
		);
	}

	List<KlaimProgressJadwalBayarModel> _dummyJadwalBayar() {
		return [
			KlaimProgressJadwalBayarModel(
				penanggung: 'PT. AVRIST GENERAL INSURANCE',
				sharePersen: 100.00,
				curr: 'IDR',
				nilaiBayar: 113100100.53,
				jadwalBayar: DateTime(2026, 6, 25),
				metodeBayar: '',
			),
			KlaimProgressJadwalBayarModel(
				penanggung: 'PT. CONTOH ASURANSI INDONESIA DENGAN NAMA PANJANG',
				sharePersen: 50.5,
				curr: 'IDR',
				nilaiBayar: 25000000.75,
				jadwalBayar: DateTime(2026, 7, 2),
				metodeBayar: 'Cashless',
			),
		];
	}

	KlaimProgressInfoModel _dummyProgressInfo() {
		return KlaimProgressInfoModel(
			groupStatusId: '20',
			klaimNilaiId: '',
		);
	}
}