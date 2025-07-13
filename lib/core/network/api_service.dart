import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final Future<String?> Function()? getToken;

  ApiService(this._baseUrl, {this.getToken});

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    String? token;
    if (getToken != null) {
      token = await getToken!();
    }

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST $endpoint failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    String? token;
    if (getToken != null) {
      token = await getToken!();
    }

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
        ...?headers,
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET $endpoint failed: ${response.body}');
    }
  }
}
