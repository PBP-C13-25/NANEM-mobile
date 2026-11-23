import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../core/auth/auth_state.dart';
import '../../../core/config.dart';
import '../models/plant.dart';

class CatalogApiException implements Exception {
  const CatalogApiException(
    this.message, {
    this.statusCode,
    this.fields = const {},
  });

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fields;

  @override
  String toString() => message;
}

/// Transport native Android/iOS. Tidak membuat sesi atau login sendiri.
class CatalogService {
  CatalogService({this.baseUrl = Config.baseUrl});

  static final instance = CatalogService();

  /// Sambungkan ke penyimpan cookie login bersama; pola sama dengan GuideService.
  /// Selama belum disambungkan, server tetap menolak request yang perlu login.
  static String? Function() cookieProvider = () => null;

  final String baseUrl;

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, String> query = const {},
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      return await (() async {
        final uri = Uri.parse('$baseUrl$path')
            .replace(queryParameters: query.isEmpty ? null : query);
        final request = await client.openUrl(method, uri);
        request.headers.set(HttpHeaders.acceptHeader, 'application/json');
        final cookie = cookieProvider();
        if (cookie != null && cookie.isNotEmpty) {
          request.headers.set(HttpHeaders.cookieHeader, cookie);
        }
        if (body != null) {
          request.headers.contentType = ContentType.json;
          request.write(jsonEncode(body));
        }
        final response = await request.close();
        final text = await utf8.decodeStream(response);
        Map<String, dynamic> data = {};
        if (text.isNotEmpty) {
          try {
            final decoded = jsonDecode(text);
            if (decoded is Map<String, dynamic>) data = decoded;
          } on FormatException {
            if (response.statusCode >= 200 && response.statusCode < 300) {
              throw const CatalogApiException(
                'Respons server tidak dapat dibaca.',
              );
            }
          }
        }
        final code = response.statusCode;
        if (code >= 200 && code < 300) return data;
        final fields = <String, List<String>>{};
        if (data['errors'] is Map) {
          for (final entry in (data['errors'] as Map).entries) {
            final value = entry.value;
            fields[entry.key.toString()] = value is List
                ? value.map((item) => item.toString()).toList()
                : [value.toString()];
          }
        }
        if (code == 401) AuthState.instance.handleUnauthorized();
        final message = switch (code) {
          400 => 'Periksa kembali data tanaman.',
          401 => 'Sesi habis, silakan masuk lagi.',
          403 => 'Kamu tidak punya akses untuk tindakan ini.',
          404 => 'Data tanaman tidak ditemukan.',
          _ => 'Server belum dapat memproses permintaan. Coba lagi.',
        };
        throw CatalogApiException(message, statusCode: code, fields: fields);
      })().timeout(const Duration(seconds: 25));
    } on CatalogApiException {
      rethrow;
    } on TimeoutException {
      throw const CatalogApiException('Koneksi terlalu lama. Coba lagi.');
    } on IOException {
      throw const CatalogApiException(
        'Tidak dapat terhubung. Periksa koneksi internetmu.',
      );
    } finally {
      client.close(force: true);
    }
  }

  Future<PlantPage> fetchPlants({
    Map<String, String> filters = const {},
    int page = 1,
  }) async {
    final data = await _request(
      'GET',
      '/api/plants/',
      query: {...filters, 'page': '$page'},
    );
    return PlantPage.fromJson(data);
  }

  Future<Plant> fetchPlant(int id) async =>
      Plant.fromJson(await _request('GET', '/api/plants/$id/'));

  Future<Plant> savePlant(Map<String, dynamic> values, {int? id}) async =>
      Plant.fromJson(
        await _request(
          id == null ? 'POST' : 'PATCH',
          id == null ? '/api/plants/' : '/api/plants/$id/',
          body: values,
        ),
      );

  Future<void> deletePlant(int id) async {
    await _request('DELETE', '/api/plants/$id/');
  }
}
