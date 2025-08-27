part of 'beritalaincari_bloc.dart';

class BeritaLainCariState extends Equatable {
	final ListStatus status;
	final List<Berita1CariModel> items;
	final bool hasReachedMax;
	final int jenis;
	final int hal;
	final String? berita1Id; // ⬅️ Tambahan

	const BeritaLainCariState({
		this.status = ListStatus.initial,
		this.items = const <Berita1CariModel>[],
		this.hasReachedMax = false,
		this.jenis = 1,
		this.hal = 0,
		this.berita1Id, // ⬅️ Tambahan
	});

	const BeritaLainCariState.success(List<Berita1CariModel> items)
			: this(status: ListStatus.success, items: items);

	const BeritaLainCariState.failure() : this(status: ListStatus.failure);

	BeritaLainCariState copyWith({
		List<Berita1CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? jenis,
		int? hal,
		String? berita1Id, // ⬅️ Tambahan
	}) {
		return BeritaLainCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			jenis: jenis ?? this.jenis,
			hal: hal ?? this.hal,
			berita1Id: berita1Id ?? this.berita1Id, // ⬅️ Tambahan
		);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, jenis, hal, berita1Id];
}
