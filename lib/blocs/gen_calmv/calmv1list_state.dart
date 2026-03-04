part of 'calmv1list_bloc.dart';

class Calmv1ListState extends Equatable {

	final ListStatus status;
	final List<Calmv1ListModel> items;
	final bool hasReachedMax;
	final int hal;
	final String viewMode;
	final String searchText;
	final String recordId;
	final bool isProcessing;
	final bool isProcessed;
	final bool hasFailure;
	final String processMessage;

	const Calmv1ListState(
			{this.status = ListStatus.initial,
				this.items = const <Calmv1ListModel>[],
				this.hasReachedMax = false,
				this.hal = 0,
				this.viewMode = "",
				this.searchText = "",
				this.recordId = "",
				this.isProcessing = false,
				this.isProcessed = false,
				this.hasFailure = false,
				this.processMessage = "",});

	Calmv1ListState copyWith(
			{List<Calmv1ListModel>? items,
				bool? hasReachedMax,
				ListStatus? status,
				int? hal,
				String? viewMode,
				String? searchText,
				String? recordId,
				bool? isProcessing,
				bool? isProcessed,
				bool? hasFailure,
				String? processMessage,}) {
		return Calmv1ListState(
				items: items ?? this.items,
				hasReachedMax: hasReachedMax ?? this.hasReachedMax,
				status: status ?? this.status,
				hal: hal ?? this.hal,
				viewMode: viewMode ?? this.viewMode,
				searchText: searchText ?? this.searchText,
				recordId: recordId ?? this.recordId,
				isProcessing: isProcessing ?? this.isProcessing,
				isProcessed: isProcessed ?? this.isProcessed,
				hasFailure: hasFailure ?? this.hasFailure,
				processMessage: processMessage ?? this.processMessage);
	}

	@override
	List<Object> get props => [status, items, hasReachedMax, hal, viewMode, recordId, searchText, isProcessing, isProcessed, hasFailure, processMessage];
}
