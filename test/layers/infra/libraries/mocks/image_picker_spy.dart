import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class ImagePickerSpy extends Mock implements ImagePicker {
  final ImageSource source;

  ImagePickerSpy({required this.source, XFile? file}) {
    mockPickImage(file: file);
  }

  When mockPickImageCall() => when(() => pickImage(source: source));
  void mockPickImage({XFile? file}) => mockPickImageCall().thenAnswer((_) => Future.value(file));
  void mockPickImageError({Exception? error}) => mockPickImageCall().thenThrow(error ?? Exception("any_error"));
}
