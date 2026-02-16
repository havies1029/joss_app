part of 'groupcobcari_bloc.dart';

abstract class GroupcobCariEvents extends Equatable {
	const GroupcobCariEvents();

	@override
	List<Object> get props => [];
}

class FetchGroupcobCariEvent extends GroupcobCariEvents {}

class RefreshGroupcobCariEvent extends GroupcobCariEvents {
  final String statusId;
  final String searchText;
  const RefreshGroupcobCariEvent({required this.statusId, required this.searchText});

  @override
  List<Object> get props => [statusId, searchText];
}

class SelectDetailEvent extends GroupcobCariEvents {
  final String klaim1Id;
  const SelectDetailEvent(this.klaim1Id);
}

class UnselectDetailEvent extends GroupcobCariEvents {
  final String klaim1Id;
  const UnselectDetailEvent(this.klaim1Id);
}

class SelectItemEvent extends GroupcobCariEvents {
  final String klaim1Id;
  const SelectItemEvent(this.klaim1Id);
}

class UnselectItemEvent extends GroupcobCariEvents {
  final String klaim1Id;
  const UnselectItemEvent(this.klaim1Id);
}

class SelectKlaimRecordEvent extends GroupcobCariEvents {
  final KlaimdetailCariModel klaimRecord;
  const SelectKlaimRecordEvent(this.klaimRecord);
}
