abstract class ImageUploadState {}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploading extends ImageUploadState {}

class ImageUploaded extends ImageUploadState {
  final String downloadUrl;

  ImageUploaded(this.downloadUrl);
}

class ImageUploadError extends ImageUploadState {
  final String message;

  ImageUploadError(this.message);
}
