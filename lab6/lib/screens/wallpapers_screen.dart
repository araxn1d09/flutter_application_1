import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wallpapers_cubit.dart';
import '../widgets/wallpaper_item.dart';

class WallpapersScreen extends StatefulWidget {
  const WallpapersScreen({super.key});

  @override
  State<WallpapersScreen> createState() => _WallpapersScreenState();
}

class _WallpapersScreenState extends State<WallpapersScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем при открытии
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WallpapersCubit>().loadWallpapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallhaven Обои'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WallpapersCubit>().loadWallpapers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.animation),
            onPressed: () {
              context.read<WallpapersCubit>().loadAnimeWallpapers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.smart_display),
            onPressed: () {
              context.read<WallpapersCubit>().loadMockWallpapers();
            },
          ),
        ],
      ),
      
      body: BlocBuilder<WallpapersCubit, WallpapersState>(
        builder: (context, state) {
          if (state is WallpapersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is WallpapersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WallpapersCubit>().loadWallpapers();
                    },
                    child: const Text('Повторить'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      context.read<WallpapersCubit>().loadMockWallpapers();
                    },
                    child: const Text('Тестовые данные'),
                  ),
                ],
              ),
            );
          }
          
          if (state is WallpapersLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WallpapersCubit>().loadWallpapers();
              },
              child: ListView.builder(
                itemCount: state.wallpapers.length,
                itemBuilder: (context, index) {
                  return WallpaperItem(wallpaper: state.wallpapers[index]);
                },
              ),
            );
          }
          
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<WallpapersCubit>().loadWallpapers();
              },
              child: const Text('Загрузить обои'),
            ),
          );
        },
      ),
    );
  }
}