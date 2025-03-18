import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: "https://api-rimpa.nightbears.co", // เปลี่ยนเป็น URL ของ API จริง
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // เพิ่ม Interceptor เพื่อแนบ Token อัตโนมัติ
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle token expiration here (Optional)
        }
        return handler.next(e);
      },
    ));
  }

  // ดึง Token จาก SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Function สำหรับ GET
  Future<Response?> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      print("GET Error: $e");
      return null;
    }
  }

  // Function สำหรับ POST
  Future<Response?> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.post(endpoint, data: jsonEncode(data));
      return response;
    } catch (e) {
      print("POST Error: $e");
      return null;
    }
  }

  // Function สำหรับ PUT
  Future<Response?> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.put(endpoint, data: jsonEncode(data));
      return response;
    } catch (e) {
      print("PUT Error: $e");
      return null;
    }
  }
}
