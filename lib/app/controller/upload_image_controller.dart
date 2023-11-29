import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:btl_ptttm/app/model/image_respone.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadImageController {
  Future<ImageResponse?> uploadImage(File? image) async {
    if (image == null) return null;

    var uri = Uri.parse('http://192.168.222.18:5000/process-image');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    try {
      var response = await http.Client().send(request).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Timeout occurred.');
        },
      );

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');

        try {
          var jsonData = jsonDecode(responseBody);
          var imageResponse = ImageResponse.fromJson(jsonData);
          if (imageResponse.base64Image != null) {
            return imageResponse;
          } else {
            print('Dữ liệu hình ảnh không tồn tại hoặc không hợp lệ.');
            return null;
          }
        } catch (e) {
          print('Lỗi parse JSON: $e');
          return null;
        }
      } else {
        print('Tải lỗi: ${response.statusCode}.');
        return null;
      }
    } on TimeoutException catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    } catch (e) {
      print('Lỗi khi gửi yêu cầu: $e');
      return null;
    }
  }
}
