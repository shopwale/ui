import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/http_modal.dart';
import 'package:local_genie_vendor/services/secure_storage_service.dart';

final _serverHost = dotenv.get("API_HOST");
// final _serverPort = dotenv.get("API_PORT");

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class HttpService {
  final Uri _serviceEndpoint;

  static getPort(int port) {
    if (port == 1) return dotenv.get("CUSTOMER_PORT");
    if (port == 2) return dotenv.get("VENDOR_PORT");
    // if (port == 3) return dotenv.get("MANAGE_CUSTOMER_PORT");
  }

  HttpService(String servicePath, int port)
      : _serviceEndpoint =
            Uri.http('$_serverHost:${getPort(port)}', '/$servicePath');

  Future<dynamic> get({Map<String, dynamic> queryParams = const {}}) async {
    final requestUri = _serviceEndpoint.replace(queryParameters: queryParams);
    print(requestUri);

    await updateHeader();

    final response = await http.get(
      requestUri,
      headers: headers,
    );
    await updateCookie(response);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await removeCookie();
      throw {'message': json.decode(response.body)['message'], 'code': 401};
    } else {
      throw {'message': 'Error while getting data from $_serviceEndpoint.'};
    }
  }

  Future<dynamic> post(
      {Map<String, dynamic> queryParams = const {},
      dynamic body,
      bool skipCookie = false}) async {
    final requestUri = _serviceEndpoint;
    if (!skipCookie) {
      await updateHeader();
    }

    final response = await http.post(
      requestUri,
      body: json.encode(body),
      headers: headers,
    );
    if (!skipCookie) {
      await updateCookie(response);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await removeCookie();
    }
    throw ErrorI.fromJson(json.decode(response.body));
  }

  Future<dynamic> patch({
    Map<String, dynamic> queryParams = const {},
    dynamic body,
  }) async {
    final requestUri = _serviceEndpoint;
    await updateHeader();

    final response = await http.patch(
      requestUri,
      body: json.encode(body),
      headers: headers,
    );

    await updateCookie(response);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await removeCookie();
    }
    throw ErrorI.fromJson(json.decode(response.body));
  }

  Future<dynamic> put({
    Map<String, dynamic> queryParams = const {},
    dynamic body,
  }) async {
    final requestUri = _serviceEndpoint;
    await updateHeader();

    final response = await http.put(
      requestUri,
      body: json.encode(body),
      headers: headers,
    );
    await updateCookie(response);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await removeCookie();
    }
    throw ErrorI.fromJson(json.decode(response.body));
  }

  Future<dynamic> delete({
    Map<String, dynamic> queryParams = const {},
    dynamic body,
  }) async {
    final requestUri = _serviceEndpoint;
    await updateHeader();

    final response = await http.delete(
      requestUri,
      body: json.encode(body),
      headers: headers,
    );
    await updateCookie(response);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      await removeCookie();
      throw {'message': json.decode(response.body)['message'], 'code': 401};
    } else {
      throw {'message': 'Error while getting data from $_serviceEndpoint.'};
    }
  }

  Future<void> updateCookie(http.Response response) async {
    String rawCookie = response.headers['set-cookie'] ?? "";

    if (rawCookie.isEmpty) {
      final secureStorage = SecureStorage();

      rawCookie = await secureStorage.readSecureData(cookieKey);
    }

    if (rawCookie.isNotEmpty) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  Future<void> removeCookie() async {
    final secureStorage = SecureStorage();

    await secureStorage.deleteSecureData(cookieKey);
    headers['cookie'] = "";
  }

  Future<void> updateHeader() async {
    String rawCookie = headers['cookie'] ?? "";

    if (rawCookie.isEmpty) {
      final secureStorage = SecureStorage();

      rawCookie = await secureStorage.readSecureData(cookieKey);
    }

    headers['cookie'] = rawCookie;
  }
}

class ServerResponseI<T> {
  String message;
  int code;
  List<T> data;

  ServerResponseI({
    this.message = "",
    this.code = 0,
    this.data = const [],
  });

  ServerResponseI.fromJson(Map<String, dynamic> json)
      : this(
          message: json['message'] ?? "",
          code: json['code'] ?? "",
          data: (json['data'] != null) ? json['data'].cast<T>() : [],
        );
}
