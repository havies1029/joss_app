part of 'rekanpiccobcari_bloc.dart';

abstract class RekanPicCobCariEvents extends Equatable {
  const RekanPicCobCariEvents();

  @override
  List<Object> get props => [];
}

class FetchRekanPicCobCariEvent extends RekanPicCobCariEvents {}

class RefreshRekanPicCobCariEvent extends RekanPicCobCariEvents {
  final String searchText;
  final String rekanPicId;
  const RefreshRekanPicCobCariEvent({required this.searchText, required this.rekanPicId});

  @override
  List<Object> get props => [searchText, rekanPicId];
}


class UpdateCheckboxRekanPicCobEvent extends RekanPicCobCariEvents {
  final RekanPicCobCariModel rekanPicCobItem;
  final bool isChecked;

  const UpdateCheckboxRekanPicCobEvent(
      {required this.rekanPicCobItem, required this.isChecked});

  @override
  List<Object> get props => [rekanPicCobItem, isChecked];
}

class RequestToUpdateRekanPicCobEvent extends RekanPicCobCariEvents {}

class Update2ApiJRekanPicCobEvent extends RekanPicCobCariEvents {
  final String rekanPicId;

  const Update2ApiJRekanPicCobEvent({required this.rekanPicId});
  @override
  List<Object> get props => [rekanPicId];
}

class InitialSelectedCOBRekanPicCobEvent extends RekanPicCobCariEvents {
  final List<RekanPicCobCariModel> selectedCOB;

  const InitialSelectedCOBRekanPicCobEvent(
      {required this.selectedCOB});

  @override
  List<Object> get props => [selectedCOB];
}