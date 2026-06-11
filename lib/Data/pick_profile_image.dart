import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickProfileImage({
  required ImagePicker picker,
  required Box userBox,
  required void Function(void Function()) setState,
}) async {

  var pickedFile = await picker.pickImage(
    source: ImageSource.camera,
  );

  if (pickedFile != null) {
    setState(() {
      userBox.put('profilePath', pickedFile.path);
    });
  }
}