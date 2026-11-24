import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nanem_mobile/features/catalog/service/catalog_service.dart';

void main() {
  late HttpServer server;
  late CatalogService service;
  late Future<void> Function(HttpRequest request) handler;
  final plant = <String, dynamic>{
    'id': 7,
    'name': 'Kangkung',
    'category': 'sayur',
    'space_needed': 'small',
    'supports_soil': true,
    'supports_hydroponic': false,
    'sunlight': ['full_sun'],
  };

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    service = CatalogService(baseUrl: 'http://127.0.0.1:${server.port}');
    CatalogService.cookieProvider = () => 'sessionid=test-session';
    server.listen((request) async => handler(request));
  });
  tearDown(() async {
    CatalogService.cookieProvider = () => null;
    await server.close(force: true);
  });

  Future<void> respond(
    HttpRequest request,
    Object? data, {
    int status = 200,
  }) async {
    request.response.statusCode = status;
    request.response.headers.contentType = ContentType.json;
    if (data != null) request.response.write(jsonEncode(data));
    await request.response.close();
  }

  test(
    'List sends encoded filters, page and the shared session cookie',
    () async {
      handler = (request) async {
        expect(request.method, 'GET');
        expect(request.uri.path, '/api/plants/');
        expect(request.uri.queryParameters, {
          'q': 'daun bawang',
          'category': 'sayur',
          'page': '2',
        });
        expect(
          request.headers.value(HttpHeaders.cookieHeader),
          'sessionid=test-session',
        );
        await respond(request, {
          'count': 7,
          'next': null,
          'previous': '?page=1',
          'results': [plant],
        });
      };
      final page = await service.fetchPlants(
        filters: {'q': 'daun bawang', 'category': 'sayur'},
        page: 2,
      );
      expect(page.results.single.id, 7);
    },
  );

  test(
    'Create, patch, detail and bodyless delete follow the API contract',
    () async {
      final seen = <String>[];
      handler = (request) async {
        seen.add('${request.method} ${request.uri.path}');
        if (request.method == 'POST' || request.method == 'PATCH') {
          final body = jsonDecode(await utf8.decodeStream(request));
          expect(body['indoor'], isNull);
          expect(body['supports_hydroponic'], false);
        }
        await respond(
          request,
          request.method == 'DELETE' ? null : plant,
          status: request.method == 'DELETE'
              ? 204
              : request.method == 'POST'
              ? 201
              : 200,
        );
      };
      final body = {...plant, 'indoor': null};
      await service.savePlant(body);
      await service.savePlant(body, id: 7);
      await service.fetchPlant(7);
      await service.deletePlant(7);
      expect(seen, [
        'POST /api/plants/',
        'PATCH /api/plants/7/',
        'GET /api/plants/7/',
        'DELETE /api/plants/7/',
      ]);
    },
  );

  test(
    'Field and non-field validation errors remain available to the form',
    () async {
      handler = (request) => respond(request, {
        'errors': {
          'name': ['Nama sudah digunakan.'],
          '__all__': ['Pilih media tanam.'],
        },
      }, status: 400);
      await expectLater(
        service.savePlant({}),
        throwsA(
          isA<CatalogApiException>()
              .having((error) => error.statusCode, 'status', 400)
              .having((error) => error.fields['name'], 'name error', [
                'Nama sudah digunakan.',
              ]),
        ),
      );
    },
  );

  test(
    'Authorization and missing records are errors, not empty successful pages',
    () async {
      for (final code in [401, 403, 404, 500]) {
        handler = (request) =>
            respond(request, {'detail': 'Rejected'}, status: code);
        await expectLater(
          service.fetchPlants(),
          throwsA(
            isA<CatalogApiException>().having(
              (error) => error.statusCode,
              'status',
              code,
            ),
          ),
        );
      }
    },
  );

  test('An HTML success response produces a readable error', () async {
    handler = (request) async {
      request.response.write('<html>Unexpected page</html>');
      await request.response.close();
    };
    await expectLater(
      service.fetchPlants(),
      throwsA(isA<CatalogApiException>()),
    );
  });
}
