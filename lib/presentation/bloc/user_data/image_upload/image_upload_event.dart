import 'package:image_picker/image_picker.dart';

abstract class ImageUploadEvent {}

class UploadImageEvent extends ImageUploadEvent {
  final ImageSource source;

  UploadImageEvent(this.source);
}
