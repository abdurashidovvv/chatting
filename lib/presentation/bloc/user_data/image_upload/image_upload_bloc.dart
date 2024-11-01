import 'dart:io';
import 'package:chatting/presentation/bloc/user_data/image_upload/image_upload_event.dart';
import 'package:chatting/presentation/bloc/user_data/image_upload/image_upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  ImageUploadBloc() : super(ImageUploadInitial());

  Stream<ImageUploadState> mapEventToState(ImageUploadEvent event) async* {
    if (event is UploadImageEvent) {
      yield ImageUploading();
      try {
        final pickedFile = await _picker.pickImage(source: event.source);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          String downloadUrl = await uploadImageToFirebase(_image!);
          yield ImageUploaded(downloadUrl);
        } else {
          yield ImageUploadError("Rasm tanlanmadi");
        }
      } catch (e) {
        yield ImageUploadError('Xato yuz berdi: $e');
      }
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    // Rasmni Firebase Storage ga yuklash jarayoni
    // ...
    return "downloadUrl"; // Rasm yuklangan URL
  }
}
