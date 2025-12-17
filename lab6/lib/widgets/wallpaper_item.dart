import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/wallpaper.dart';

class WallpaperItem extends StatelessWidget {
  final Wallpaper wallpaper;
  
  const WallpaperItem({
    super.key,
    required this.wallpaper,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Превью обоев
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: wallpaper.thumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.red),
                ),
              ),
            ),
          ),
          
          // Информация
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Разрешение
                Row(
                  children: [
                    const Icon(Icons.aspect_ratio, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${wallpaper.width} × ${wallpaper.height}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Категория
                Chip(
                  label: Text(
                    wallpaper.category.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getCategoryColor(wallpaper.category),
                ),
                
                const SizedBox(height: 12),
                
                // Статистика
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Просмотры
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${wallpaper.views}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    
                    // Избранное
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          '${wallpaper.favorites}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    
                    // ID
                    Text(
                      'ID: ${wallpaper.id.substring(0, 6)}...',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'anime':
        return Colors.pink[100]!;
      case 'people':
        return Colors.blue[100]!;
      case 'nature':
        return Colors.green[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}