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

	KlaimprogresscariState copyWith({
		List<KlaimprogresscariModel>? items,
		KlaimProgressNilaiKlaimModel? nilaiKlaim,
		List<KlaimProgressJadwalBayarModel>? jadwalBayar,
		bool? hasReachedMax,
		ListStatus? status,
		String? klaim1Id,
		KlaimProgressInfoModel? klaimProgressInfo,
	}) {
		return KlaimprogresscariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			klaim1Id: klaim1Id ?? this.klaim1Id,
			nilaiKlaim: nilaiKlaim ?? this.nilaiKlaim,
			jadwalBayar: jadwalBayar ?? this.jadwalBayar,
			klaimProgressInfo: klaimProgressInfo ?? this.klaimProgressInfo,
		);
	}

	@override
	List<Object?> get props =>
			[status, items, hasReachedMax, klaim1Id, nilaiKlaim, jadwalBayar, klaimProgressInfo];
}