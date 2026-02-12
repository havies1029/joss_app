import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:joss_app/repositories/user/user_repository.dart';

part 'takeimage_state.dart';

class TakeImageCubit extends Cubit<TakeImageState> {

    TakeImageCubit() : super(InitImageState());

  Future<void> setImageProfile(File pickedFile) async {
    
    emit(TakenImageState(pickedFile: pickedFile));

    UserRepository userRepo = UserRepository();
    await userRepo.uploadFotoProfile(pickedFile);

    emit(SavedImageState());
  }

}


