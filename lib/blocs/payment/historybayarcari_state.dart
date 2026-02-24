part of 'historybayarcari_bloc.dart';

class HistorybayarCariState extends Equatable {

	final ListStatus status;
	final List<HistorybayarCariModel> items;
	final bool hasReachedMax;
	final int hal;
  final String statusId;
  final String searchText;
	final HistorybayarCariModel? selectedItem;
	final bool isDownloading;
	final String downloadPath;
  final bool isLoading;
  final bool isLoaded;

	const HistorybayarCariState(
		{this.status = ListStatus.initial,
		this.items = const <HistorybayarCariModel>[],
		this.hasReachedMax = false,
		this.hal = 0,
    this.statusId = '',
    this.searchText = '',
		this.selectedItem,
		this.isDownloading = false,
		this.downloadPath = '',
    this.isLoading = false,
    this.isLoaded = false
   });

	const HistorybayarCariState.success(List<HistorybayarCariModel> items)
			: this(status: ListStatus.success, items: items);

	const HistorybayarCariState.failure() : this(status: ListStatus.failure);

	HistorybayarCariState copyWith(
		{List<HistorybayarCariModel>? items,
		bool? hasReachedMax,
		ListStatus? status,
		int? hal,
    String? statusId,
    String? searchText,
		HistorybayarCariModel? selectedItem,
		bool? isDownloading,
		String? downloadPath,
    bool? isLoading,
    bool? isLoaded,
   }) {

		return HistorybayarCariState(
			items: items ?? this.items,
			hasReachedMax: hasReachedMax ?? this.hasReachedMax,
			status: status ?? this.status,
			hal: hal ?? this.hal,
      statusId: statusId ?? this.statusId,
      searchText: searchText ?? this.searchText,
			selectedItem: selectedItem ?? this.selectedItem,
			isDownloading: isDownloading ?? this.isDownloading,
			downloadPath: downloadPath ?? this.downloadPath,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
		);
	}

	@override
	List<Object?> get props => [status, items, hasReachedMax, hal, statusId, searchText, selectedItem,  isDownloading, downloadPath];
}
