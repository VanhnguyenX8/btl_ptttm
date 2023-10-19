import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TrafficWidget extends StatefulWidget {
  const TrafficWidget({Key? key}) : super(key: key);

  @override
  _TrafficWidgetState createState() => _TrafficWidgetState();
}

class _TrafficWidgetState extends State<TrafficWidget> {
  final List<File> _images = [];
  File? _imageCamera;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _fileNameController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }
  
  Future getImageInCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageCamera = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _createPdf(String fileName) async {
    final pdf = pdfWidgets.Document();

    for (var img in _images) {
      final image = pdfWidgets.MemoryImage(img.readAsBytesSync());
      pdf.addPage(pdfWidgets.Page(
          build: (pdfWidgets.Context context) =>
              pdfWidgets.Center(child: pdfWidgets.Image(image))));
    }

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      // print('Could not get external storage directory');
      return;
    }

    final file = File(p.join(directory.path, "$fileName.pdf"));
    // print("File được lưu tại: ${file.path}");
    await file.writeAsBytes(await pdf.save());

    _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Đã chuyển đổi thành PDF!')));
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
                child: _images.isEmpty
                    ? GestureDetector(
                        onTap: getImageInCamera,
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: display.width / 428 * 200,
                            color: const Color(0xFF8BC1FC),
                          ),
                        ))
                    : ListView.builder(
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Image.file(_images[index]));
                        },
                      ),
              ),
              GestureDetector(
                onTap: () async {
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
                        content: const Text(
                        'Biển báo cấm đỗ'
                         
                        ),
                        actions: [
                          // TextButton(
                          //   child: Text(
                          //     'Convert',
                          //     style: TextStyle(
                          //         color: const Color(0xFF4B93F4),
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: display.width * 0.043),
                          //   ),
                          //   onPressed: () async {
                          //     Navigator.of(context).pop();
                          //     await _createPdf(_fileNameController.text);
                          //   },
                          // ),
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
