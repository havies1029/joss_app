part of 'calmv3form_bloc.dart';

abstract class Calmv3FormEvents extends Equatable {
	const Calmv3FormEvents();

	@override
	List<Object> get props => [];
}

// ✅ Event baru untuk load data dari Calmv1 & Calmv2
class Calmv3FormLoadDataEvent extends Calmv3FormEvents {
	final String calmv1Id;
	const Calmv3FormLoadDataEvent({required this.calmv1Id});

	@override
	List<Object> get props => [calmv1Id];
}

// ✅ Event baru untuk hitung ulang saat diskon berubah
class Calmv3FormCalculateEvent extends Calmv3FormEvents {
	final double diskonPersen;
	const Calmv3FormCalculateEvent({required this.diskonPersen});

	@override
	List<Object> get props => [diskonPersen];
}

// Event yang sudah ada (tetap sama)
class Calmv3FormTambahEvent extends Calmv3FormEvents {
	final Calmv3FormModel record;
	const Calmv3FormTambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv3FormUbahEvent extends Calmv3FormEvents {
	final Calmv3FormModel record;
	const Calmv3FormUbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv3FormHapusEvent extends Calmv3FormEvents {
	final String recordId;
	const Calmv3FormHapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Calmv3FormLihatEvent extends Calmv3FormEvents {
	final String calmv1Id;
	const Calmv3FormLihatEvent({required this.calmv1Id});

	@override
	List<Object> get props => [calmv1Id];
}

class Calmv3FormHitungPremiEvent extends Calmv3FormEvents {
	final String calmv1Id;
	const Calmv3FormHitungPremiEvent({required this.calmv1Id});

	@override
	List<Object> get props => [calmv1Id];
}

class Calmv3FormDraftEvent extends Calmv3FormEvents {
	final Calmv3FormModel record;
	const Calmv3FormDraftEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Calmv3ResetStatusEvent extends Calmv3FormEvents {
	const Calmv3ResetStatusEvent();
}