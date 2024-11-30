import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'ProviderrCls/providerr.dart';
import 'button.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  // Download image function
  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      // Request permission to write to external storage (for Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permission to access storage denied")),
          );
          return;
        }
      }

      Dio dio = Dio();

      // Get the public Downloads directory (for Android)
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      // Make sure the directory exists
      if (!await downloadsDirectory!.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      // Define the save path
      String savePath = '${downloadsDirectory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Download the image
      await dio.download(imageUrl, savePath);

      // Notify the user using ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image downloaded successfully to $savePath")),
      );

    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download image: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // Trigger the API call when the page is first loaded
    final imageNotifier = Provider.of<ImageNotifier>(context, listen: false);
    imageNotifier.getApiData();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              "https://media.istockphoto.com/id/1195696110/photo/hands-using-mobile-payments-digital-marketing-banking-network-online-shopping-and-icon.jpg?s=2048x2048&w=is&k=20&c=L66tF46AUFCt_yZRXKjp-XT6SrgVLdAzChiB7qE5Arg=", // Replace with the actual image URL
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Follow",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabButtonn("Activity"),
              TabButtonn("Community"),
              TabButtonn("Shop", isSelected: true),
            ],
          ),
        ),
        toolbarHeight: 150,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "All products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Consumer<ImageNotifier>(
                    builder: (context, imageNotifier, child) {
                      if (imageNotifier.images.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MasonryGridView.builder(
                            gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                            ),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: imageNotifier.images.length,
                            itemBuilder: (context, index) {
                              final highResUrl =
                              imageNotifier.images[index]["urls"]["full"];
                              return GestureDetector(
                                onTap: () {
                                  _downloadImage(context,highResUrl);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageNotifier.images[index]["urls"]
                                      ["small"],
                                      fit: BoxFit.cover,
                                      height: index % 2 == 0 ? 250 : 170,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Static button container above the scrollable grid
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(20), // Gap from the bottom edge
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.home, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
