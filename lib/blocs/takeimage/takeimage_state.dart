part of 'takeimage_cubit.dart';

@immutable
abstract class TakeImageState extends Equatable {
  const TakeImageState();
  @override
  List<Object?> get props => [];
}

class TakenImageState extends TakeImageState {
  final File? pickedFile;

  const TakenImageState({this.pickedFile});

  @override
  List<Object?> get props => [pickedFile];
}


class SavedImageState extends TakeImageState {}

class InitImageState extends TakeImageState {}
