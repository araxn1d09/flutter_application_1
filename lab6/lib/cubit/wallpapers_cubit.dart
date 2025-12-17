import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wallpaper.dart';

// Состояния
class WallpapersState extends Equatable {
  const WallpapersState();
  
  @override
  List<Object> get props => [];
}

class WallpapersInitial extends WallpapersState {}
class WallpapersLoading extends WallpapersState {}
class WallpapersLoaded extends WallpapersState {
  final List<Wallpaper> wallpapers;
  const WallpapersLoaded(this.wallpapers);
  @override
  List<Object> get props => [wallpapers];
}
class WallpapersError extends WallpapersState {
  final String message;
  const WallpapersError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class WallpapersCubit extends Cubit<WallpapersState> {
  WallpapersCubit() : super(WallpapersInitial());

  Future<void> loadWallpapers() async {
    emit(WallpapersLoading());
    print('🔄 [CUBIT] Загрузка обоев с Wallhaven...');

    try {
      // Wallhaven API - работает без ключа для публичных обоев
      const String url = 'https://wallhaven.cc/api/v1/search?q=nature&sorting=random';
      print('🌐 [CUBIT] Запрос к: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'FlutterApp/1.0',
        },
      ).timeout(const Duration(seconds: 15));

      print('📡 [CUBIT] Ответ: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> wallpapersData = data['data'];
        
        print('✅ [CUBIT] Получено ${wallpapersData.length} обоев');
        
        final List<Wallpaper> wallpapers = wallpapersData.map((item) {
          return Wallpaper.fromJson(item);
        }).toList();
        
        emit(WallpapersLoaded(wallpapers));
        
      } else {
        print('❌ [CUBIT] Ошибка: ${response.statusCode}');
        emit(WallpapersError('Ошибка API: ${response.statusCode}'));
      }
      
    } catch (e) {
      print('💥 [CUBIT] Исключение: $e');
      emit(WallpapersError('Ошибка сети: $e'));
    }
  }

  // Альтернативный запрос с другими параметрами
  Future<void> loadAnimeWallpapers() async {
    emit(WallpapersLoading());
    
    try {
      const String url = 'https://wallhaven.cc/api/v1/search?q=anime&sorting=toplist';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Wallpaper> wallpapers = 
            (data['data'] as List).map((item) => Wallpaper.fromJson(item)).toList();
        
        emit(WallpapersLoaded(wallpapers));
      } else {
        emit(WallpapersError('Ошибка: ${response.statusCode}'));
      }
    } catch (e) {
      emit(WallpapersError('Ошибка: $e'));
    }
  }

  // Мок-данные на случай если API не работает
  Future<void> loadMockWallpapers() async {
    emit(WallpapersLoading());
    
    await Future.delayed(const Duration(seconds: 1));
    
    final List<Wallpaper> mockWallpapers = [
      Wallpaper(
        id: '1',
        url: 'https://w.wallhaven.cc/full/zy/wallhaven-zyx8v3.jpg',
        thumbnail: 'https://th.wallhaven.cc/small/zy/zyx8v3.jpg',
        width: 1920,
        height: 1080,
        category: 'anime',
        views: 15000,
        favorites: 500,
      ),
      Wallpaper(
        id: '2',
        url: 'https://w.wallhaven.cc/full/7p/wallhaven-7p39gy.png',
        thumbnail: 'https://th.wallhaven.cc/small/7p/7p39gy.jpg',
        width: 3840,
        height: 2160,
        category: 'general',
        views: 25000,
        favorites: 1200,
      ),
      Wallpaper(
        id: '3',
        url: 'https://w.wallhaven.cc/full/l8/wallhaven-l83o8y.png',
        thumbnail: 'https://th.wallhaven.cc/small/l8/l83o8y.jpg',
        width: 1920,
        height: 1080,
        category: 'people',
        views: 18000,
        favorites: 800,
      ),
      Wallpaper(
        id: '4',
        url: 'https://w.wallhaven.cc/full/6o/wallhaven-6o9vz5.jpg',
        thumbnail: 'https://th.wallhaven.cc/small/6o/6o9vz5.jpg',
        width: 2560,
        height: 1440,
        category: 'nature',
        views: 32000,
        favorites: 2100,
      ),
      Wallpaper(
        id: '5',
        url: 'https://w.wallhaven.cc/full/2y/wallhaven-2y8rr7.jpg',
        thumbnail: 'https://th.wallhaven.cc/small/2y/2y8rr7.jpg',
        width: 1920,
        height: 1080,
        category: 'general',
        views: 12000,
        favorites: 450,
      ),
    ];
    
    emit(WallpapersLoaded(mockWallpapers));
  }
}