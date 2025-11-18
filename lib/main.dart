// Import the Flutter Material Design library which provides widgets and themes
import 'package:flutter/material.dart';
//Import the Music Library Home Screen
import 'screens/music_library_home.dart';

void main() {
  runApp(const FavoriteMusicApp());
} 

class FavoriteMusicApp extends StatelessWidget {
 
  const FavoriteMusicApp({super.key}); 
 
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: 'Music Library App', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, 
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: const MusicLibraryHome(), 
    );
  }
}
 
