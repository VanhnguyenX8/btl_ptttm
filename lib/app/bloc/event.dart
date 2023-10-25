import 'package:image_picker/image_picker.dart';

abstract class TrafficEvent {}

class PickImageEvent extends TrafficEvent {
  final ImageSource source;
  PickImageEvent(this.source);
}

class UploadImageEvent extends TrafficEvent {}
class RemoveImageEvent extends TrafficEvent {}