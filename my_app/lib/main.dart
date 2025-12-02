import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wrap с картинками'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              _buildImageContainer('https://picsum.photos/100/100?random=1'),
              _buildImageContainer('https://picsum.photos/100/100?random=2'),
              _buildImageContainer('https://picsum.photos/100/100?random=3'),
              _buildImageContainer('https://picsum.photos/100/100?random=4'),
              _buildImageContainer('https://picsum.photos/100/100?random=5'),
              _buildImageContainer('https://picsum.photos/100/100?random=6'),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildImageContainer(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}