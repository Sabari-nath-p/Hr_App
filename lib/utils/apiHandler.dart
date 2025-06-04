import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:hr_app/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:hr_app/utils/CustomAlerts.dart';
import 'package:hr_app/utils/responseModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum Api { POST, GET, PATCH, PUT, DELETE }

class ApiService {
  static String baseUrl = "https://api.paytrack.aws-web.alpha.logidots.com";

  static Future<String?> getAuthToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("AUTHKEY");
  }

  static Future<void> request({
    required String endpoint,
    Api method = Api.POST,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(ResponseModel data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    try {
      // Prepare URL
      final Uri uri = Uri.parse('$baseUrl$endpoint');
      // Prepare headers
      final Map<String, String> requestHeaders = headers ?? {};
      requestHeaders['Content-Type'] = 'application/json';
      requestHeaders["Accept"] = 'application/json';

      // Add auth token if required
      if (requiresAuth) {
        final String? token = await getAuthToken();
        if (token != null) {
          requestHeaders['Authorization'] = 'Bearer $token';
        } else if (onUnauthenticated != null) {
          onUnauthenticated();
          return;
        }
      }

      // Prepare request
      http.Response response;

      // Execute request based on method
      switch (method) {
        case Api.GET:
          response = await http.get(uri, headers: requestHeaders);
          break;
        case Api.POST:
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case Api.PUT:
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case Api.DELETE:
          response = await http.delete(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case Api.PATCH:
          response = await http.patch(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      log("[ ${method} ] $endpoint ==> ${response.statusCode}");
      print(response.body);
      // Handle response based on status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success response
        if (onSuccess != null) {
          onSuccess(
            ResponseModel(
              statusCode: response.statusCode,
              data: json.decode(response.body),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        if (onUnauthenticated != null) {
          onUnauthenticated();
        } else {
          Get.offAll(
            () => AuthenticationScreen(),
            transition: Transition.rightToLeft,
          );
          Customalerts.errorAlert(
            title: "Session Expired",
            body:
                "You need to log in to continue. Please sign in and try again.",
          );
        }
      } else if (response.statusCode >= 500) {
        if (onServerError != null) {
          onServerError(
            response.statusCode,
            response.body.isNotEmpty ? response.body : 'Server error occurred',
          );
        } else {
          Customalerts.errorAlert(
            title: "Server Error",
            body: "Something went wrong on our end. Please try again late.",
          );
        }
      } else {
        // Other errors

        if (onSuccess != null) {
          onSuccess(
            ResponseModel(
              statusCode: response.statusCode,
              data: json.decode(response.body),
            ),
          );
        }
      }
    } on SocketException catch (e) {
      // Network error
      if (onNetworkError != null) {
        onNetworkError('Network error: ${e.message}');
      } else {
        Customalerts.errorAlert(
          title: "No Internet Connection",
          body:
              "You're currently offline. Please check your connection and try again.",
        );
      }
    } catch (e) {
      // Other errors
      if (onError != null) {
        onError(e);
      }
      if (kDebugMode) {
        print('API Request Error: $e');
      }
    }
  }

  // Convenience methods for common HTTP methods
  Future<void> get({
    required String endpoint,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.GET,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.POST,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> put({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.PUT,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> delete({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.DELETE,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> patch({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.PATCH,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }
}
