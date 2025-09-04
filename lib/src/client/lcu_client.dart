import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../exceptions/lcu_exceptions.dart';
import '../models/lcu_connection.dart';

/// HTTP client for League Client Update (LCU) API communication.
/// 
/// This class provides a configured HTTP client that handles the specific
/// requirements of the LCU API including SSL certificate validation bypass,
/// basic authentication, and proper error handling.
class LcuClient {
  final LcuConnection _connection;
  late final http.Client _httpClient;

  /// Creates a new [LcuClient] instance with the provided connection information.
  /// 
  /// The client is configured to:
  /// - Accept self-signed certificates (required for LCU API)
  /// - Use HTTP basic authentication with riot credentials
  /// - Handle LCU-specific error responses
  LcuClient(this._connection) {
    _httpClient = _createHttpClient();
  }

  /// Creates an HTTP client configured for LCU API communication.
  /// 
  /// This client bypasses SSL certificate validation since the LCU API
  /// uses self-signed certificates. This is safe because the API only
  /// runs locally on the same machine.
  http.Client _createHttpClient() {
    // Create HttpClient with SSL certificate validation bypass
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    
    // Wrap in IOClient
    return IOClient(httpClient);
  }

  /// Performs a GET request to the specified LCU API endpoint.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint path (e.g., '/lol-summoner/v1/current-summoner')
  /// 
  /// Returns the parsed JSON response as a Map.
  /// 
  /// Throws [LcuConnectionException] for network-level errors.
  /// Throws [LcuApiException] for API-level errors (4xx, 5xx responses).
  Future<Map<String, dynamic>> get(String endpoint) async {
    return _makeRequest('GET', endpoint);
  }

  /// Performs a POST request to the specified LCU API endpoint.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint path
  /// - [body]: Optional request body data
  /// 
  /// Returns the parsed JSON response as a Map.
  /// 
  /// Throws [LcuConnectionException] for network-level errors.
  /// Throws [LcuApiException] for API-level errors (4xx, 5xx responses).
  Future<Map<String, dynamic>> post(String endpoint, [Map<String, dynamic>? body]) async {
    return _makeRequest('POST', endpoint, body);
  }

  /// Performs a PUT request to the specified LCU API endpoint.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint path
  /// - [body]: Optional request body data
  /// 
  /// Returns the parsed JSON response as a Map.
  /// 
  /// Throws [LcuConnectionException] for network-level errors.
  /// Throws [LcuApiException] for API-level errors (4xx, 5xx responses).
  Future<Map<String, dynamic>> put(String endpoint, [Map<String, dynamic>? body]) async {
    return _makeRequest('PUT', endpoint, body);
  }

  /// Performs a DELETE request to the specified LCU API endpoint.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint path
  /// 
  /// Returns the parsed JSON response as a Map.
  /// 
  /// Throws [LcuConnectionException] for network-level errors.
  /// Throws [LcuApiException] for API-level errors (4xx, 5xx responses).
  Future<Map<String, dynamic>> delete(String endpoint) async {
    return _makeRequest('DELETE', endpoint);
  }

  /// Internal method that handles the actual HTTP request execution.
  /// 
  /// This method:
  /// 1. Constructs the full URL from base URL and endpoint
  /// 2. Sets up authentication headers
  /// 3. Handles request body encoding
  /// 4. Executes the request with proper error handling
  /// 5. Parses and returns the response
  Future<Map<String, dynamic>> _makeRequest(
    String method, 
    String endpoint, 
    [Map<String, dynamic>? body]
  ) async {
    try {
      final url = Uri.parse('${_connection.baseUrl}$endpoint');
      final headers = _buildHeaders();

      http.Response response;
      
      switch (method) {
        case 'GET':
          response = await _httpClient.get(url, headers: headers);
          break;
        case 'POST':
          response = await _httpClient.post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await _httpClient.put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _httpClient.delete(url, headers: headers);
          break;
        default:
          throw LcuConnectionException('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw LcuConnectionException(
        'Failed to connect to LCU API: ${e.message}',
        null,
        e,
      );
    } on HttpException catch (e) {
      throw LcuConnectionException(
        'HTTP error: ${e.message}',
        null,
        e,
      );
    } catch (e) {
      if (e is LcuException) {
        rethrow;
      }
      throw LcuConnectionException(
        'Unexpected error during API request: ${e.toString()}',
        null,
        e,
      );
    }
  }

  /// Builds the HTTP headers required for LCU API requests.
  /// 
  /// Includes:
  /// - Authorization header with basic auth credentials
  /// - Content-Type header for JSON requests
  /// - Accept header for JSON responses
  Map<String, String> _buildHeaders() {
    final credentials = base64Encode(utf8.encode('riot:${_connection.authToken}'));
    
    return {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Handles HTTP response parsing and error checking.
  /// 
  /// This method:
  /// 1. Checks for successful status codes (200-299)
  /// 2. Parses JSON response body
  /// 3. Throws appropriate exceptions for error responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw LcuApiException(
          'Failed to parse response JSON: ${e.toString()}',
          response.statusCode,
        );
      }
    } else {
      // Try to parse error details from response body
      Map<String, dynamic>? errorDetails;
      try {
        if (response.body.isNotEmpty) {
          errorDetails = jsonDecode(response.body) as Map<String, dynamic>;
        }
      } catch (e) {
        // Ignore JSON parsing errors for error responses
      }

      throw LcuApiException(
        'LCU API returned error: ${response.reasonPhrase ?? 'Unknown error'}',
        response.statusCode,
        errorDetails,
      );
    }
  }

  /// Closes the HTTP client and releases resources.
  /// 
  /// Call this method when you're done using the client to prevent
  /// resource leaks.
  void close() {
    _httpClient.close();
  }
}