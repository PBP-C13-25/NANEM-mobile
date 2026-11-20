import 'dart:convert';
import 'dart:io';

import '../../../core/config.dart';
import '../models/guide_models.dart';

class GuideApiException implements Exception {
  const GuideApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class GuideService {
  GuideService._();

  static final GuideService instance = GuideService._();

  static String? Function() cookieProvider = () => null;

  String _errorText(Map<String, dynamic> body) {
    final errors = body['errors'];
    if (errors is Map<String, dynamic>) {
      final messages = errors.values
          .expand((value) => value is List ? value : [value])
          .whereType<String>()
          .toList();
      if (messages.isNotEmpty) return messages.join(' ');
    }
    final detail = body['detail'];
    return detail is String ? detail : 'Data yang dikirim tidak valid.';
  }

  Map<String, dynamic> _handle(int statusCode, String text) {
    Map<String, dynamic> body = {};
    if (text.isNotEmpty) {
      try {
        final decoded = jsonDecode(text);
        body = decoded is Map<String, dynamic> ? decoded : {};
      } catch (_) {
        body = {};
      }
    }

    if (statusCode >= 200 && statusCode < 300) return body;

    if (statusCode == 401) {
      throw const GuideApiException('Sesi habis, silakan masuk lagi.', statusCode: 401);
    }
    if (statusCode == 403) {
      throw const GuideApiException('Kamu tidak punya akses ke halaman ini.', statusCode: 403);
    }
    if (statusCode == 404) {
      throw const GuideApiException('Tanaman atau panduan tidak ditemukan.', statusCode: 404);
    }
    if (statusCode == 400 || statusCode == 409) {
      throw GuideApiException(_errorText(body), statusCode: statusCode);
    }
    throw GuideApiException('Terjadi kesalahan di server.', statusCode: statusCode);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${Config.baseUrl}$path')
        .replace(queryParameters: query == null || query.isEmpty ? null : query);
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.openUrl(method, uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final cookie = cookieProvider();
      if (cookie != null) request.headers.set(HttpHeaders.cookieHeader, cookie);
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.add(utf8.encode(jsonEncode(body)));
      }
      final response = await request.close().timeout(const Duration(seconds: 20));
      final text = await utf8.decodeStream(response);
      return _handle(response.statusCode, text);
    } on GuideApiException {
      rethrow;
    } catch (_) {
      throw const GuideApiException(
        'Tidak bisa terhubung ke server. Periksa koneksi internetmu.',
      );
    } finally {
      client.close();
    }
  }

  Future<GuideResult> fetchGuide(int plantId) async {
    final body = await _request('GET', '/api/plants/$plantId/guide/');
    return GuideResult.fromJson(body);
  }

  Future<GuideListResult> fetchGuideList({String query = '', String status = ''}) async {
    final body = await _request('GET', '/api/guides/', query: {
      if (query.trim().isNotEmpty) 'q': query.trim(),
      if (status.isNotEmpty) 'status': status,
    });
    final plants = (body['plants'] as List<dynamic>)
        .map((e) => GuideListItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return GuideListResult(
      summary: GuideSummary.fromJson(body['summary'] as Map<String, dynamic>),
      items: plants,
    );
  }

  Future<void> saveGuide(int plantId, Map<String, dynamic> payload, {required bool exists}) async {
    await _request(exists ? 'PATCH' : 'POST', '/api/plants/$plantId/guide/', body: payload);
  }

  Future<void> deleteGuide(int plantId) async {
    await _request('DELETE', '/api/plants/$plantId/guide/');
  }
}