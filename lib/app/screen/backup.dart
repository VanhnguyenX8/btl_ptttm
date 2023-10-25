import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class TrafficWidget extends StatefulWidget {
  const TrafficWidget({Key? key}) : super(key: key);

  @override
  _TrafficWidgetState createState() => _TrafficWidgetState();
}

class _TrafficWidgetState extends State<TrafficWidget> {
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Cập nhật _image
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future getImageInCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Cập nhật _image
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future<String?> uploadImage() async {
    if (_image == null) return null;

    var uri = Uri.parse('http://192.168.1.8:8080/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
      var jsonData = jsonDecode(responseBody);
      print('Thông tin: ${jsonData['name']}');
      return jsonData['name']; // Trả về tên biển báo
    } else {
      print('Tải lỗi: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size display = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: const Color(0xFF8BC1FC),
          title: const Text(
            "Nhận diện biển báo",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: getImage,
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _image == null
                    ? GestureDetector(
                        onTap: getImageInCamera,
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: display.width / 428 * 200,
                            color: const Color(0xFF8BC1FC),
                          ),
                        ))
                    : Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.file(_image!),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage();
                  String? trafficSignName = await uploadImage();
                  if (trafficSignName != null) {
                    // ignore: use_build_context_synchronously
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Tên biển báo',
                            style: TextStyle(
                                color: const Color(0xFF060A2C),
                                fontWeight: FontWeight.bold,
                                fontSize: display.width * 0.043),
                          ),
                          content: Text(
                              trafficSignName), // Sử dụng biến trafficSignName ở đây
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: display.width * 0.043),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF40A1FA),
                    ),
                    child: Center(
                      child: Text(
                        'Chọn',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: display.width * 0.050),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
