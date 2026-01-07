import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
  }
}

