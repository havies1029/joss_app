part of 'klaimprogresscari_bloc.dart';

class KlaimprogresscariState extends Equatable {
	final ListStatus status;
	final List<KlaimprogresscariModel> items;
	final KlaimProgressNilaiKlaimModel? nilaiKlaim;
	final List<KlaimProgressJadwalBayarModel> jadwalBayar;
	final KlaimProgressInfoModel? klaimProgressInfo;
	final bool hasReachedMax;
	final String klaim1Id;

	const KlaimprogresscariState({
		this.status = ListStatus.initial,
		this.items = const <KlaimprogresscariModel>[],
		this.hasReachedMax = false,
		this.klaim1Id = '',
		this.nilaiKlaim,
		this.jadwalBayar = const [],
		this.klaimProgressInfo,
	});

	// helper untuk refresh/reset (biar gak emit 2x)
	KlaimprogresscariState reset({required String klaim1Id}) {
		return KlaimprogresscariState(
			status: ListStatus.initial,
			items: const [],
			hasReachedMax: false,
			klaim1Id: klaim1Id,
			nilaiKlaim: null,
			jadwalBayar: const [],
			klaimProgressInfo: null,
		);
	}

  static const _sentinel = Object();

	KlaimprogresscariState copyWith({
		Object? items = _sentinel,
		Object? nilaiKlaim = _sentinel,
		Object? jadwalBayar = _sentinel,
		bool? hasReachedMax,
		ListStatus? status,
		String? klaim1Id,
		Object? klaimProgressInfo = _sentinel,
	}) {
		return KlaimprogresscariState(
			items: identical(items, _sentinel) ? this.items : items as List<KlaimprogresscariModel>,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			klaim1Id: klaim1Id ?? this.klaim1Id,
			nilaiKlaim: identical(nilaiKlaim, _sentinel) ? this.nilaiKlaim : nilaiKlaim as KlaimProgressNilaiKlaimModel?,
			jadwalBayar: identical(jadwalBayar, _sentinel) ? this.jadwalBayar : jadwalBayar as List<KlaimProgressJadwalBayarModel>,
			klaimProgressInfo: identical(klaimProgressInfo, _sentinel) ? this.klaimProgressInfo : klaimProgressInfo as KlaimProgressInfoModel?,
		);
	}

	@override
	List<Object?> get props =>
			[status, items, hasReachedMax, klaim1Id, nilaiKlaim, jadwalBayar, klaimProgressInfo];
}