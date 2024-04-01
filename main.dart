import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Image Viewer'),
        ),
        body: ImageFetcher(),
      ),
    );
  }
}

class ImageFetcher extends StatefulWidget {
  @override
  _ImageFetcherState createState() => _ImageFetcherState();
}

class _ImageFetcherState extends State<ImageFetcher> {
  String imageUrl = '';
  int currentImageId = 1;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/$currentImageId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['url']; 
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  void nextImage() {
    setState(() {
      currentImageId++; 
    });
    fetchImage();
  }

  @override
Widget build(BuildContext context) {
    return Center(
      child: imageUrl.isEmpty
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: nextImage, 
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
                TextButton(
                  onPressed: nextImage,
                  child: Text('Next Image'),
                ),
              ],
            ),
    );
  }
}
