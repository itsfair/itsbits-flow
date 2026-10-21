import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod_cloud_storage_rustfs/serverpod_cloud_storage_rustfs.dart';
import 'package:serverpod_cloud_storage_s3_compat/serverpod_cloud_storage_s3_compat.dart';

void main(List<String> args) async {
  final client = http.Client();
  try {
    final uri = Uri.parse(args[0]);
    final accessKey = args[1];
    final secretKey = args[2];
    final bucket = args[3];
    final key = args[4];

    final s3 = S3Client(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: '',
      endpoints: RustFsEndpointConfig(baseUri: uri),
    );

    const payload = 'presign-probe';

    final putUri = s3.buildPresignedUri(
      key: key,
      method: 'PUT',
      expiration: const Duration(minutes: 15),
    );
    final putResponse = await client.put(
      putUri,
      body: utf8.encode(payload),
    );
    stdout.writeln('presigned PUT: ${putResponse.statusCode}');

    final getUri = s3.buildPresignedUri(
      key: key,
      method: 'GET',
      expiration: const Duration(minutes: 15),
    );
    stdout.writeln('presigned GET uri: $getUri');
    final getResponse = await client.get(getUri);
    stdout.writeln(
      'presigned GET: ${getResponse.statusCode} '
      '(body-match: ${utf8.decode(getResponse.bodyBytes) == payload})',
    );

    final anonymousResponse = await client.get(
      uri.replace(path: '/$bucket/$key'),
    );
    stdout.writeln('anonymous GET: ${anonymousResponse.statusCode}');

    final deleteResponse = await client.delete(
      s3.buildPresignedUri(
        key: key,
        method: 'DELETE',
        expiration: const Duration(minutes: 15),
      ),
    );
    stdout.writeln('presigned DELETE: ${deleteResponse.statusCode}');

    exitCode = (getResponse.statusCode == 200) ? 0 : 1;
  } finally {
    client.close();
  }
}
