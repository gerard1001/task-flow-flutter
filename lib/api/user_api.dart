import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/dio/dio_instance.dart';

var log = Logger(
  printer: PrettyPrinter(),
);

// class UserApi {
//   static Future<Response?> registerUser(
//       String firstName,
//       String lastName,
//       String email,
//       String password,
//       String gender,
//       String birtDate,
//       List<dynamic> categories,
//       File picture) async {
//     try {
//       Response? response =
//           await DioInstance.getDio().post('/user/register', data: {
//         "firstName": firstName,
//         "lastName": lastName,
//         "email": email,
//         "password": password,
//         "gender": gender,
//         "birthDate": birtDate,
//         "categories": categories,
//         "picture": await MultipartFile.fromFile(picture.path),
//       });
//       return response;
//     } on DioException catch (e) {
//       log.f(e);
//       return e.response!;
//     }
//   }
// }

class UserApi {
  static Future<Response?> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
    String birtDate,
    List<dynamic> categories,
    File picture,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "gender": gender,
        "birthDate": birtDate,
        "categories": categories,
        "picture": await MultipartFile.fromFile(picture.path),
      });

      Response? response =
          await DioInstance.getDio().post('/user/register', data: formData);
      return response;
    } on DioException catch (e) {
      log.f(e);
      return e.response!;
    }
  }
}
