class Wallpaper {
  final String id;
  final String url;
  final String thumbnail;
  final int width;
  final int height;
  final String category;
  final int views;
  final int favorites;

  Wallpaper({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.width,
    required this.height,
    required this.category,
    required this.views,
    required this.favorites,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id']?.toString() ?? 'unknown',
      url: json['path'] ?? '',
      thumbnail: json['thumbs']?['large'] ?? json['path'] ?? '',
      width: json['resolution_x'] ?? 1920,
      height: json['resolution_y'] ?? 1080,
      category: json['category'] ?? 'general',
      views: json['views'] ?? 0,
      favorites: json['favorites'] ?? 0,
    );
  }
}