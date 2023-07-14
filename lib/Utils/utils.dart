import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

String? validateName(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'Name must be more than 2 charater';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  }
}

String? validateText(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'Field must be more than 2 charater';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  }
}

String? validateTextJobTitle(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'Field must be more than 2 charater';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  } else if (value.length > 25) {
    return 'Job title can not be more than 25 characters.';
  }
}

String? validatePricewithPlaceHolder(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 2) {
    return 'Please add Amount';
  }
}

String? validateNamewithPlaceHolder(String? value, String? placeHolder) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return '${placeHolder} must be more than 2 charater';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between ${placeHolder}.';
  }
}

String? validateNameWithSpace(String? value, String? placeHolder) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return '${placeHolder} must be more than 2 charater';
  }
}

String? validateMobile(String? value) {
  print('value ${value}');
// Indian Mobile number are of 10 digit only
  if (value == null) {
    return null;
  } else if (value.length < 10) {
    print('false');
    return 'Phone number must be 1234567890.';
  }

  if (value.length > 14) return 'Mobile number cannot be more than 10 digits';
}

String? validatePasswordWithPlaceHolder(String? value, String? placeHolder) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value == null) {
    return 'Please enter $placeHolder';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Enter valid $placeHolder';
    } else {
      return null;
    }
  }
}

String? validatePassword(String? value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value == null) {
    return 'Please enter password';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Enter valid password';
    } else {
      return null;
    }
  }

  // if (value != null && value.length < 6) {
  //   return 'Password must be atleast 6 charaters';
  // } else {
  //   return null;
  // }
}

String? validateConfirmPassword(
    String? value, String placeholderText, String? passwordText) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value == null) {
    return 'Please enter $placeholderText';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Enter valid $placeholderText';
    } else {
      if (passwordText == null) {
        return null;
      } else {
        if (passwordText != value) {
          return 'Password and Confirm Password does not match';
        } else {
          return null;
        }
      }
    }
  }
}

String? validateEmail(String? value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value != null && !regex.hasMatch(value)) {
    return 'Enter Valid Email';
  } else {
    return null;
  }
}

String? validateMobileNew(String? value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value?.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value!)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String? validateField(String? value) {
  if (value != null && value.length == 0) {
    return 'Required';
  }
}

String? validateGraduationYear(String value) {
  if (value.length == 0) {
    return 'Required';
  } else if (value.contains('-')) {
    return 'Only numbers are allowed';
  } else if (value.length > 4) {
    return 'Example: 2005';
  } else {
    return null;
  }
}

Future<bool> isConnected() async {
  try {
//    final result = await InternetAddress.lookup('example.com');
//    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//      return true;
//    }else
//      return false;
    final result = await InternetAddress.lookup('example.com')
        .timeout(Duration(seconds: 3), onTimeout: () {
      return [];
    });
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

void IsConnected(Function(bool) connected) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connected(true);
    } else {
      connected(false);
    }
  } on SocketException catch (_) {
    connected(false);
  }
}

Timer? _timer;

Future<void> showLoading() {
  _timer = Timer(const Duration(seconds: 1), () {
    if (EasyLoading.isShow) {
      // hideLoading();
      // EasyLoading.showToast("Something went Wrong!, Try Again");
    }
  });

  return EasyLoading.show(
    status: "Loading..",
    maskType: EasyLoadingMaskType.black,
  );
}

Future<void> hideLoading() {
  _timer?.cancel();
  return EasyLoading.dismiss();
}

String formatDate(
    {required int dateInMilliSeconds, String dateFormat = "dd/MMM/yyyy"}) {
  // DateTime dateTime = DateFormat("yyyy-MM-dd").parse(dateString);
  if (dateInMilliSeconds == null) {
    return dateFormat;
  } else {
    return DateFormat(dateFormat)
        .format(DateTime.fromMillisecondsSinceEpoch(dateInMilliSeconds));
  }
}

//Date: 'EEEE, dd MMMM yyyy'  Time: 'hh:mm a'"
String formatTime(String timeString, String timeFormat) {
  DateTime dateTime = DateFormat("H:m").parse(timeString);
  return DateFormat(timeFormat).format(dateTime);
}

String formatDateAndTime(
    {required String dateString, String dateFormat = "MM-dd-yyyy hh:mm a"}) {
  DateTime dateTime = DateFormat("yyyy-MM-dd H:m:s").parse(dateString);
  return DateFormat(dateFormat).format(dateTime);
}

Future<File> _generateThumbnail(File imge) async {
  String? fileName = await VideoThumbnail.thumbnailFile(
    video: imge.path,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    maxHeight:
    350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 75,
  );

  print('----image--->>>$fileName');


  return File(fileName!);

}
/// Show option to select image from Gallery or Camera
void showImageSelectOption(context , bool? isVideo, Function completionHandler ) {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.pop(context);
              addImageFromSource(
                ImageSource.camera,
                (image) {
                  completionHandler(image , false, File(""));
                },
              );
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Gallery'),
            onPressed: () {
              addImageFromSource(
                ImageSource.gallery,
                (image) {
                  completionHandler(image , false, File(""));
                },
              );
              Navigator.pop(context);
            },
          ),
          if (isVideo ?? false)
          CupertinoActionSheetAction(
            child: Text('Video from Camera'),
            onPressed: () {
              addVideoFromSource(
                ImageSource.camera,
                    (image) {
                      Future<File> imgthump = _generateThumbnail(image as File) as Future<File>;
                      imgthump.then((value) {
                        completionHandler(image , true , value);
                      });
                },
              );
              Navigator.pop(context);
            },
          ),
          if (isVideo ?? false)
          CupertinoActionSheetAction(
            child: Text('Video from Gallery'),
            onPressed: () {
              addVideoFromSource(
                ImageSource.gallery,
                    (image) {
                      Future<File> imgthump = _generateThumbnail(image as File) as Future<File>;
                      imgthump.then((value) {
                        completionHandler(image , true , value);
                      });
                },
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  } else {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [

        ListTile(
          leading: Icon(Icons.camera_alt, size: 35),
          title: Text('Camera'),
          onTap: () {
            Navigator.pop(context);
            addImageFromSource(
              ImageSource.camera,
              (image) {
                completionHandler(image , false , File(""));
              },
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.photo,
            size: 35,
          ),
          title: Text('Gallery'),
          onTap: () {
            Navigator.pop(context);
            addImageFromSource(
              ImageSource.gallery,
              (image) {
                completionHandler(image , false,File(""));
              },
            );
          },
        ),
        if (isVideo ?? false )
        ListTile(
          leading: Icon(
            Icons.videocam,
            size: 35,
          ),
          title: Text('Video from Camera'),
          onTap: () {
            Navigator.pop(context);
            addVideoFromSource(
              ImageSource.camera,
                  (image) {
                    Future<File> imgthump = _generateThumbnail(image as File) as Future<File>;
                imgthump.then((value) {
                  completionHandler(image , true , value);
                });

              },
            );
          },
        ),
        if (isVideo ?? false)
        ListTile(
          leading: Icon(
            Icons.videocam,
            size: 35,
          ),
          title: Text('Video from Gallery'),
          onTap: () {
            Navigator.pop(context);
            addVideoFromSource(
              ImageSource.gallery,
                  (image) {
                    Future<File> imgthump = _generateThumbnail(image as File) as Future<File>;
                    imgthump.then((value) {
                      completionHandler(image , true , value);
                    });

              },
            );
          },
        ),
      ]),
    );
  }
}

/// Add image from selected source
void addImageFromSource(ImageSource source, Function completionHandler) {
  ImagePicker().pickImage(source: source, imageQuality: 25).then(
    (image) {
      if (image == null) return null;
      return completionHandler(File(image.path));
    },
  ).catchError(
    (error) {
      debugPrint('Failed to pick image: $error');
    },
  );
}

void addVideoFromSource(ImageSource source, Function completionHandler) {
  ImagePicker()
      .pickVideo(
    source: source,
  )
      .then((video) {
    if (video == null) return null;
    return completionHandler(File(video.path));
  });
}

String? validateAccountHolderNmae(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'Account holder name is required.';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  }
}

String? validateRoutingNumber(String? value) {
  Pattern pattern =
      r'^((0[0-9])|(1[0-2])|(2[1-9])|(3[0-2])|(6[1-9])|(7[0-2])|80)([0-9]{7})$';
  RegExp regex = RegExp(pattern.toString());
  if (value != null && !regex.hasMatch(value)) {
    return 'Enter 9 digit valid routing number.';
  } else {
    return null;
  }
}

String? validateAccountNumber(String? value) {
  Pattern pattern =
      r'^[0-9]{12}$';
  RegExp regex = RegExp(pattern.toString());
  if (value != null && !regex.hasMatch(value)) {
    return 'Enter 12 digit valid account number';
  } else {
    return null;
  }
}
String? validateFirstName(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'First name is required.';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  }
}

String? validateSSN(String? value) {
  Pattern pattern = r'^[0-9]{9}$';
  RegExp regex = RegExp(pattern.toString());
  if (value != null && !regex.hasMatch(value)) {
    return 'Please enter valid SSN.';
  } else {
    return null;
  }
}



String? validateLastName(String? value) {
  if (value == null) {
    return null;
  } else if (value.length < 3) {
    return 'Last name is required.';
  } else if (value.contains('  ')) {
    return 'double space is not allowed between text';
  }
}

