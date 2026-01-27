part of 'regreaktif1_bloc.dart';

abstract class Regreaktif1Events extends Equatable {
	const Regreaktif1Events();

	@override
	List<Object> get props => [];
}

class Regreaktif1TambahEvent extends Regreaktif1Events {
	final Regreaktif1Model record;
	const Regreaktif1TambahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regreaktif1UbahEvent extends Regreaktif1Events {
	final Regreaktif1Model record;
	const Regreaktif1UbahEvent({required this.record});

	@override
	List<Object> get props => [record];
}

class Regreaktif1HapusEvent extends Regreaktif1Events {
	final String recordId;
	const Regreaktif1HapusEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

class Regreaktif1LihatEvent extends Regreaktif1Events {
	final String recordId;
	const Regreaktif1LihatEvent({required this.recordId});

	@override
	List<Object> get props => [recordId];
}

