import 'package:btl_ptttm/app/database/database.dart';
import 'package:flutter/material.dart';
import 'package:btl_ptttm/app/model/traffic.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TrafficListScreen extends StatefulWidget {
  @override
  State<TrafficListScreen> createState() => _TrafficListScreenState();
}

class _TrafficListScreenState extends State<TrafficListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Đổi màu icon "back" thành màu đỏ
        ),
        title: const Text(
          'Lịch sử biển đã tra',
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 90,
        backgroundColor: const Color(0xFF8BC1FC),
      ),
      body: FutureBuilder<List<Traffic>>(
        future: SqfliteDatabase().fetchAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          } else {
            final trafficList = snapshot.data;
            return ListView.builder(
              itemCount: trafficList?.length,
              itemBuilder: (context, index) {
                final traffic = trafficList?[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(traffic!.name),
                    leading: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF8BC1FC), // Màu đường viền
                            width: 1.0, // Độ rộng của đường viền
                          ),
                        ),
                        child: CachedNetworkImage(
                          width: 50,
                          height: 50,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    ),
                            imageUrl:
                                'http://192.168.1.15:8080/public${traffic.link}'),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await SqfliteDatabase()
                            .deleteTrafficByLink(traffic.link);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
