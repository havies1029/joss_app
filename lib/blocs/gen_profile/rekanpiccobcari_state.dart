part of 'rekanpiccobcari_bloc.dart';

class RekanPicCobCariState extends Equatable {
  final ListStatus status;
  final List<RekanPicCobCariModel> items;
  final List<RekanPicCobCariModel> selectedItems;
  final bool hasReachedMax;
  final String searchText;
  final String rekanPicId;
  final int hal;  
  final bool isSaving;
  final bool isSaved;  
  final bool requestToUpdate;
  final bool hasFailure;
  const RekanPicCobCariState(
      {this.status = ListStatus.initial,
      this.items = const <RekanPicCobCariModel>[],
      this.selectedItems = const <RekanPicCobCariModel>[],
      this.hasReachedMax = false,
      this.searchText = "",
      this.rekanPicId = "",
      this.hal = 0,
      this.isSaving = false,
      this.isSaved = false,
      this.requestToUpdate = false,
      this.hasFailure = false});

  const RekanPicCobCariState.success(List<RekanPicCobCariModel> items)
      : this(status: ListStatus.success, items: items);

  const RekanPicCobCariState.failure() : this(status: ListStatus.failure);

  RekanPicCobCariState copyWith(
      {List<RekanPicCobCariModel>? items,
      List<RekanPicCobCariModel>? selectedItems,
      bool? hasReachedMax,
      ListStatus? status,
      String? searchText,
      String? rekanPicId,
      int? hal,
      bool? isSaving,
      bool? isSaved,
      bool? requestToUpdate,
      bool? hasFailure}) {
    return RekanPicCobCariState(
        items: items ?? this.items,
        selectedItems: selectedItems ?? this.selectedItems,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status,
        searchText: searchText ?? this.searchText,
        rekanPicId: rekanPicId ?? this.rekanPicId,
        hal: hal ?? this.hal,
        isSaving: isSaving ?? this.isSaving,
        isSaved: isSaved ?? this.isSaved,
        requestToUpdate: requestToUpdate ?? this.requestToUpdate,
        hasFailure: hasFailure ?? this.hasFailure
        );
  }

  @override
  List<Object> get props =>
      [status, items, selectedItems, hasReachedMax, searchText, rekanPicId, hal, isSaving, isSaved, hasFailure, requestToUpdate];
}
