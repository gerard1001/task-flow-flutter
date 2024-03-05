import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:task_flow_flutter/api/dio/dio_instance.dart';

var log = Logger(
  printer: PrettyPrinter(),
);

class UserApi {
  static Future<Response?> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
    String birtDate,
    List<String>? categories,
    File? picture,
  ) async {
    try {
      Map<String, dynamic> categoriesMap = {};
      if (categories != null) {
        for (int i = 0; i < categories.length; i++) {
          categoriesMap['categories[$i]'] = categories[i];
        }
      }

      FormData formData = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "gender": gender,
        "birthDate": birtDate,
        ...categoriesMap,
        "picture": await MultipartFile.fromFile(picture!.path),
      });

      Response? response =
          await DioInstance.getDio().post('/user/register', data: formData);
      return response;
    } on DioException catch (e) {
      log.f(e);
      return e.response!;
    }
  }

  static Future<Response?> loginUser(String email, String password) async {
    try {
      Response? response =
          await DioInstance.getDio().post('/user/login', data: {
        "email": email,
        "password": password,
      });
      return response;
    } on DioException catch (e) {
      log.f(e);
      return e.response!;
    }
  }

  static Future<Response?> getUserByToken() async {
    try {
      final String loginToken = Hive.box('user').get('token', defaultValue: '');

      Response? response = await DioInstance.getDio().get('/user/token',
          options: Options(headers: {
            "Authorization": "Bearer $loginToken",
          }));
      log.i('************************************************************');
      log.i(response);
      log.i('************************************************************');
      return response;
    } on DioException catch (e) {
      log.f(e);
      return e.response!;
    }
  }
}
