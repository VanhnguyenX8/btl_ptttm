import 'dart:io';

abstract class TrafficState {}

class InitialState extends TrafficState {}

class ImagePickedState extends TrafficState {
  final File image;
  ImagePickedState(this.image);
}

class LoadingState extends TrafficState {}

class ImageUploadedState extends TrafficState {
  final String imageUrl;
  ImageUploadedState(this.imageUrl);
}

class ErrorState extends TrafficState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}
