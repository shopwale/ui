import 'dart:convert';
import 'package:http/http.dart' as http;

class DbClient {
  static final _serverAddress = 'localshopwala.com:3000';
  final Uri _serviceEndpoint;

  DbClient(String servicePath)
      : _serviceEndpoint = Uri.http(_serverAddress, servicePath);

  Future<dynamic> get({Map<String, dynamic> queryParams}) async {
    final requestUri = _serviceEndpoint.replace(queryParameters: queryParams);
    final response = await http.get(requestUri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error while getting data from $_serviceEndpoint.');
    }
  }

  Future<dynamic> post({
    Map<String, dynamic> queryParams = const {},
    dynamic body,
  }) async {
    final requestUri =
        _serviceEndpoint; //.replace(queryParameters: queryParams);
    final response = await http.post(
      requestUri,
      body: json.encode(body),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error while getting data from $_serviceEndpoint.');
    }
  }
}
