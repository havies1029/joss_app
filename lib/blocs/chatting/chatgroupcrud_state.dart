part of 'chatgroupcrud_bloc.dart';

class ChatGroupCrudState extends Equatable {
  final GroupchatModel? chatmsg;
  final bool isLoading;
  final bool isLoaded;
  final bool isSaving;
  final bool isSaved;
  final bool hasFailure;
  final String viewMode;
  final bool isDisplayed;
  final bool isUploading;
  final bool isUploaded;
  final DateTime? lastFetch;

  const ChatGroupCrudState(
      {this.chatmsg,
      this.isLoading = false,
      this.isLoaded = false,
      this.isSaved = false,
      this.isSaving = false,
      this.hasFailure = false,
      this.viewMode = "tambah",
      this.isDisplayed = false,
      this.isUploading = false,
      this.isUploaded = false,
      this.lastFetch});

  ChatGroupCrudState initState() {    
    return const ChatGroupCrudState();
  }

  ChatGroupCrudState copyWith({
    GroupchatModel? chatmsg,
    bool? isLoading,
    bool? isLoaded,
    bool? isSaving,
    bool? isSaved,
    bool? hasFailure,
    String? viewMode,
    bool? isDisplayed,
    bool? isUploading,
    bool? isUploaded,
    DateTime? lastFetch,
  }) {
    return ChatGroupCrudState(
        chatmsg: chatmsg ?? this.chatmsg,
        isLoading: isLoading ?? this.isLoading,
        isLoaded: isLoaded ?? this.isLoaded,
        isSaving: isSaving ?? this.isSaving,
        isSaved: isSaved ?? this.isSaved,
        hasFailure: hasFailure ?? this.hasFailure,
        viewMode: viewMode ?? this.viewMode,
        isDisplayed: isDisplayed ?? this.isDisplayed,
        isUploading: isUploading ?? this.isUploading,
        isUploaded: isUploaded ?? this.isUploaded,
        lastFetch: lastFetch ?? this.lastFetch);
  }

  @override
  List<Object> get props => [
        isLoading,
        isLoaded,
        isSaving,
        isSaved,
        hasFailure,
        viewMode,
        isDisplayed,
        isUploading,
        isUploaded
      ];
}
