import 'package:dio/dio.dart';
import 'package:task_flow_flutter/api/dio/dio_instance.dart';

class CategoryApi {
  static Future<Response?> getCategories() async {
    try {
      Response? response = await DioInstance.getDio().get('/category');
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }
}
