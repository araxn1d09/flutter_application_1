import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мои картинки',
      home: ImageWrapScreen(),
    );
  }
}

class ImageWrapScreen extends StatelessWidget {
  // Пути к картинкам - БЕЗ папки assets!
  final List<String> imagePaths = [
    'images/car.jpg',
    'images/cat.jpg', 
    'images/dog.jpg',
    'images/flower.jpg',
    'images/house.jpg',
    'images/tree.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Картинки из папки images/'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(20),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          alignment: WrapAlignment.center,
          children: imagePaths.map((imagePath) {
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Если картинка не найдена
                      return Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              imagePath.split('/').last,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}