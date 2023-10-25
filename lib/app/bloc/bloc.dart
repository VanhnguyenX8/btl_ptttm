import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'event.dart';
import 'state.dart';

class TrafficBloc extends Bloc<TrafficEvent, TrafficState> {
  File? _image;
  final picker = ImagePicker();

  TrafficBloc() : super(InitialState()) {
    on<PickImageEvent>(_onPickImageEvent);
    on<UploadImageEvent>(_onUploadImageEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
  }

  Future<void> _onPickImageEvent(PickImageEvent event, Emitter<TrafficState> emit) async {
    final pickedFile = await picker.pickImage(source: event.source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      emit(ImagePickedState(_image!));
    } else {
      emit(ErrorState('No image selected.'));
    }
  }

  Future<void> _onUploadImageEvent(UploadImageEvent event, Emitter<TrafficState> emit) async {
    if (_image != null) {
      emit(LoadingState());
      // Logic to upload image
      // ... (giữ nguyên phần logic upload ở đây)
    } else {
      emit(ErrorState('No image to upload.'));
    }
  }
  void _onRemoveImageEvent(RemoveImageEvent event, Emitter<TrafficState> emit) {
    _image = null;
    emit(InitialState());
  }
}
