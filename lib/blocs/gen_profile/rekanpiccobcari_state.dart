part of 'rekanpiccobcari_bloc.dart';

class RekanPicCobCariState extends Equatable {
  final ListStatus status;
  final List<RekanPicCobCariModel> items;
  final List<RekanPicCobCariModel> selectedItems;
  final bool hasReachedMax;
  final bool isSaved;
  final bool isSaving;
  final bool hasFailure;
  final bool requestToUpdate;
  final bool isFetchingMore;
  final String searchText;
  final String rekanPicId;
  final int hal;

  const RekanPicCobCariState({
    this.status = ListStatus.initial,
    this.items = const <RekanPicCobCariModel>[],
    this.selectedItems = const <RekanPicCobCariModel>[],
    this.hasReachedMax = false,
    this.isSaved = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.requestToUpdate = false,
    this.isFetchingMore = false,
    this.searchText = '',
    this.rekanPicId = '',
    this.hal = 0,
  });

  RekanPicCobCariState copyWith({
    ListStatus? status,
    List<RekanPicCobCariModel>? items,
    List<RekanPicCobCariModel>? selectedItems,
    bool? hasReachedMax,
    bool? isSaved,
    bool? isSaving,
    bool? hasFailure,
    bool? requestToUpdate,
    bool? isFetchingMore,
    String? searchText,
    String? rekanPicId,
    int? hal,
  }) {
    return RekanPicCobCariState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedItems: selectedItems ?? this.selectedItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isSaved: isSaved ?? this.isSaved,
      isSaving: isSaving ?? this.isSaving,
      hasFailure: hasFailure ?? this.hasFailure,
      requestToUpdate: requestToUpdate ?? this.requestToUpdate,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      searchText: searchText ?? this.searchText,
      rekanPicId: rekanPicId ?? this.rekanPicId,
      hal: hal ?? this.hal,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    selectedItems,
    hasReachedMax,
    isSaved,
    isSaving,
    hasFailure,
    requestToUpdate,
    isFetchingMore,
    searchText,
    rekanPicId,
    hal,
  ];
}