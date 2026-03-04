part of 'berita1cari_bloc.dart';

class Berita1CariState extends Equatable {
	final ListStatus status;
	final List<Berita1CariModel> items;
	final bool hasReachedMax;
	final int jenis;
	final int hal;
	final String? berita1Id; // ⬅️ Tambahan penting

	const Berita1CariState({
		this.status = ListStatus.initial,
		this.items = const <Berita1CariModel>[],
		this.hasReachedMax = false,
		this.jenis = 1,
		this.hal = 0,
		this.berita1Id, // ⬅️ Tambahkan ke konstruktor
	});

	const Berita1CariState.success(List<Berita1CariModel> items)
			: this(status: ListStatus.success, items: items);

	const Berita1CariState.failure() : this(status: ListStatus.failure);

	Berita1CariState copyWith({
		List<Berita1CariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? jenis,
		int? hal,
		String? berita1Id, // ⬅️ Tambahan di copyWith
	}) {
		return Berita1CariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			jenis: jenis ?? this.jenis,
			hal: hal ?? this.hal,
			berita1Id: berita1Id ?? this.berita1Id, // ⬅️ Tambahkan
		);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, jenis, hal, berita1Id];
}
