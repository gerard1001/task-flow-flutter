import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:task_flow_flutter/api/dio/dio_instance.dart';

class TaskApi {
  static Future<Response?> getTasks() async {
    try {
      final String loginToken = Hive.box('user').get('token', defaultValue: '');

      Response? response = await DioInstance.getDio().get(
        '/task',
        options: Options(
          headers: {
            'Authorization': 'Bearer $loginToken',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }
}
