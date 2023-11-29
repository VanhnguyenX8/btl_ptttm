import 'dart:convert';
import 'dart:io';
import 'package:btl_ptttm/app/model/image_respone.dart';
import 'package:btl_ptttm/app/screen/traffic_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:btl_ptttm/app/controller/upload_image_controller.dart';

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
  final uploadImageController = UploadImageController();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future<void> getImageInCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    ImageResponse? response = await uploadImageController.uploadImage(_image);

    if (response != null && response.base64Image != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Ảnh từ máy chủ',
              style: TextStyle(
                  color: Color(0xFF060A2C),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(
                  base64.decode(response.base64Image!
                      .toString()
                      .split(',')
                      .last
                      .trim()), // Thay đổi ở đây
                  width: 300,
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
                if (response.textList.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: response.textList.asMap().entries.map((entry) {
                      int index = entry.key;
                      String text = entry.value;
                      return Text(
                        '${index + 1}: $text',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
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
  }

  @override
  Widget build(BuildContext context) {
    Size display = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrafficListScreen()),
            );
          },
          child: const Icon(
            Icons.history,
            color: Colors.white,
          ),
        ),
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
                            icon: const Icon(Icons.close, color: Colors.red),
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
              onTap: uploadImage,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
