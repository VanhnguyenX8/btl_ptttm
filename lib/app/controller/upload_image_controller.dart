import 'dart:convert';
import 'dart:io';
import 'package:btl_ptttm/app/model/traffic.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UploadImageController {
  Future<Traffic?> uploadImage(File? image) async {
    if (image == null) return null;

    var uri = Uri.parse('http://192.168.81.150:8080/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      try {
        var jsonData = jsonDecode(responseBody);
        return Traffic.fromJson(jsonData);
      } catch (e) {
        print('Lỗi parse JSON: $e');
        return null;
      }
    } else {
      print('Tải lỗi: ${response.statusCode}.');
      return null;
    }
  }
}
