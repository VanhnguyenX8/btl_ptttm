import 'dart:io';
import 'package:btl_ptttm/app/database/database.dart';
import 'package:btl_ptttm/app/model/traffic.dart';
import 'package:btl_ptttm/app/screen/traffic_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:btl_ptttm/app/controller/upload_image_controller.dart';

class TrafficWidget extends StatefulWidget {
  const TrafficWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrafficWidgetState createState() => _TrafficWidgetState();
}

class _TrafficWidgetState extends State<TrafficWidget> {
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final uploadImageController = UploadImageController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future getImageInCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Chưa chọn ảnh nào.');
      }
    });
  }

  Future<Traffic?> uploadImage() async {
    Traffic? trafficSign = await uploadImageController.uploadImage(_image);
    if (trafficSign != null) {
      // Chèn dữ liệu vào cơ sở dữ liệu SQLite
      await SqfliteDatabase().insertTrafficData(trafficSign);
    }
    return trafficSign;
  }

  @override
  Widget build(BuildContext context) {
    Size display = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
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
                onTap: () async {
                  Traffic? trafficSign = await uploadImage();
                  if (trafficSign != null) {
                    // ignore: use_build_context_synchronously
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Tên biển báo',
                            style: TextStyle(
                                color: Color(0xFF060A2C),
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          content: Text(
                            trafficSign.name,
                            style: const TextStyle(fontSize: 20),
                          ), // Sử dụng tên từ đối tượng Traffic
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
