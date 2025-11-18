// Import AddMusicDialog from /widgets folder
import 'package:favorite_music_app/widgets/add_music_dialog.dart';
// Import the Flutter Material Design library which provides widgets and themes
import 'package:flutter/material.dart';
// Import the Music Model
import '../models/music.dart';

/// MusicLibraryHome - The main screen for displaying the music library
/// This is a StatefulWidget because it manages a dynamic list of music that can change
class MusicLibraryHome extends StatefulWidget {
  const MusicLibraryHome({super.key});

  @override
  State<MusicLibraryHome> createState() => _MusicLibraryHomeState();
}

class _MusicLibraryHomeState extends State<MusicLibraryHome> { 

  // List to store all music tracks in the library
  // This is mutable so we can add and remove songs
  final List<Music> _musicLibrary = [
    Music(title: "Master of Puppets", artist: "Metallica", album: "Master of Puppets", year: 1986),
    Music(title: "Enter Sandman", artist: "Metallica", album: "Metallica", year: 1991),
    Music(title: "One", artist: "Metallica", album: "...And Justice for All", year: 1988),
    Music(title: "Highway to Hell", artist: "AC/DC", album: "Highway to Hell", year: 1979),
    Music(title: "Back in Black", artist: "AC/DC", album: "Back in Black", year: 1980),
    Music(title: "Thunderstruck", artist: "AC/DC", album: "The Razors Edge", year: 1990),
    Music(title: "Paranoid", artist: "Black Sabbath", album: "Paranoid", year: 1970),
    Music(title: "Iron Man", artist: "Black Sabbath", album: "Paranoid", year: 1970),    
  ];

  /// Shows a dialog to add new music to the library
  /// Opens AddMusicDialog and passes a callback function to handle adding the new music
  void _showAddMusicDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AddMusicDialog(
          // Callback function that receives new music data from the dialog
          onAddMusic: (title, artist, album, year){
            // Update the UI by adding the new music to the library
            setState(() {
              _musicLibrary.add(
                Music(
                  title: title,
                  artist: artist,
                  album: album,
                  year: year,)
              );
            });
          });
      }
    );
  }

  /// Deletes a music track from the library at the specified index
  /// Updates the UI to reflect the removal
  void _deleteMusic(int index){
    setState(() {
      _musicLibrary.removeAt(index);
    });
  }
 
  /// Builds the UI for the music library screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top of the screen
      appBar: AppBar(
        title: const Text('My Music Library'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Column( 
        children: [
          // Header container displaying the total number of songs
          Container(
            width: double.infinity, 
            padding: const EdgeInsets.all(16.0), 
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Column(
                children: [
                  // Display the count of songs in the library
                  Text('${_musicLibrary.length}', style: Theme.of(context).textTheme.headlineMedium),
                  const Text('Total Songs'),
                ],
              ),
            ),
          ),
         
          // Scrollable list of all music tracks in the library
          Expanded(
            child: ListView.builder(              
              itemCount: _musicLibrary.length,
              itemBuilder: (context, index) {                
                final music = _musicLibrary[index];
                // Each music track is displayed as a Card with ListTile
                return Card(                  
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(                    
                    // Music note icon on the left
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                    // Song title
                    title: Text(music.title),
                    // Artist, album, and year information
                    subtitle: Text('${music.artist} • ${music.album} (${music.year})'),
                    // Delete button on the right
                    trailing: IconButton(
                      onPressed: () => _deleteMusic(index), 
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button to add new music
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMusicDialog,
        tooltip: 'Add Music',
        child: const Icon(Icons.add),
      ),
    );
  }
}