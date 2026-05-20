part of 'mlogoclientcari_bloc.dart';

class MlogoclientCariState extends Equatable {
  final ListStatus status;
  final List<MlogoclientCariModel> items;

  const MlogoclientCariState({
    this.status = ListStatus.initial,
    this.items = const [],
  });

  MlogoclientCariState copyWith({
    ListStatus? status,
    List<MlogoclientCariModel>? items,
  }) {
    return MlogoclientCariState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [
    status,
    items,
  ];
}