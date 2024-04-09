import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoViewer(),
    );
  }
}

class PhotoViewer extends StatefulWidget {
  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  int _photoId = 1;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchPhoto(_photoId);
  }

  Future<void> _fetchPhoto(int photoId) async {
    try {
      final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/photos/$photoId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Se quiser usar a miniatura, altere para _imageUrl = data['thumbnailUrl'];
          _imageUrl = data['url'];
        });
      } else {
        print('Erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erros capturados: $e');
    }
  }

  void _nextPhoto() {
    setState(() {
      _photoId++;
      _fetchPhoto(_photoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste Fotos'),
      ),
      body: Center(
        child: _imageUrl.isNotEmpty
            ? ElevatedButton(
                onPressed: _nextPhoto,
                child: Image.network(_imageUrl, width: 300, height: 300,
                    errorBuilder: (context, error, stackTrace) {
                  return Text('Erro ao carregar img');
                }),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
