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

  // --- Search / Filter / Sort state ---
  String _searchQuery = '';
  String _selectedArtist = 'All';
  String _selectedYear = 'All'; // use 'All' as sentinel
  String _sortBy = 'title'; // 'title', 'artist', 'year'

  // Utility: compute available artists and years from the library
  List<String> get _allArtists {
    final artists = _musicLibrary.map((m) => m.artist).toSet().toList();
    artists.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return artists;
  }

  List<String> get _allYears {
    final years = _musicLibrary.map((m) => m.year.toString()).toSet().toList();
    years.sort((a, b) => int.parse(a).compareTo(int.parse(b))); // ascending
    return years;
  }

  // Applies search, filters and sorting to the base music list
  List<Music> get _filteredAndSortedMusic {
    final query = _searchQuery.trim().toLowerCase();

    var list = _musicLibrary.where((m) {
      // Apply search on title, artist, or album
      final matchesQuery = query.isEmpty ||
          m.title.toLowerCase().contains(query) ||
          m.artist.toLowerCase().contains(query) ||
          m.album.toLowerCase().contains(query);

      // Apply artist filter
      final matchesArtist = _selectedArtist == 'All' || m.artist == _selectedArtist;

      // Apply year filter
      final matchesYear = _selectedYear == 'All' || m.year.toString() == _selectedYear;

      return matchesQuery && matchesArtist && matchesYear;
    }).toList();

    // Sorting
    list.sort((a, b) {
      switch (_sortBy) {
        case 'artist':
          return a.artist.toLowerCase().compareTo(b.artist.toLowerCase());
        case 'year':
          return a.year.compareTo(b.year);
        case 'title':
        default:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });

    return list;
  }

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

  /// Shows the dialog to edit an existing music entry at the given index
  void _showEditMusicDialog(int index) {
    final music = _musicLibrary[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMusicDialog(
          music: music,
          onEditMusic: (title, artist, album, year) {
            setState(() {
              _musicLibrary[index] = Music(
                title: title,
                artist: artist,
                album: album,
                year: year,
              );
            });
          },
        );
      },
    );
  }

  // Delete track at the given index and update UI
  void _deleteMusic(int index){
    setState(() {
      _musicLibrary.removeAt(index);
    });
  }

  // Shows confirmation dialog before deleting a track
  // this returns true if user confirmed the deletion
  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete song'),
          content: Text('Are you sure you want to delete "${_musicLibrary[index].title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteMusic(index);
    }
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
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by title, artist, or album',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (value) => setState(() {
                _searchQuery = value;
              }),
            ),
          ),

          // Filters and Sort controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                // Artist filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedArtist,
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All artists')),
                      ..._allArtists.map((a) => DropdownMenuItem(value: a, child: Text(a))),
                    ],
                    onChanged: (v) => setState(() {
                      _selectedArtist = v ?? 'All';
                    }),
                    decoration: const InputDecoration(labelText: 'Artist'),
                  ),
                ),
                const SizedBox(width: 8),

                // Year filter
                SizedBox(
                  width: 130,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedYear,
                    items: [
                      const DropdownMenuItem(value: 'All', child: Text('All years')),
                      ..._allYears.map((y) => DropdownMenuItem(value: y, child: Text(y))),
                    ],
                    onChanged: (v) => setState(() {
                      _selectedYear = v ?? 'All';
                    }),
                    decoration: const InputDecoration(labelText: 'Year'),
                  ),
                ),
                const SizedBox(width: 8),

                // Sort selector
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'title', child: Text('Title')),
                    DropdownMenuItem(value: 'artist', child: Text('Artist')),
                    DropdownMenuItem(value: 'year', child: Text('Year')),
                  ],
                  onChanged: (v) => setState(() {
                    _sortBy = v ?? 'title';
                  }),
                ),
              ],
            ),
          ),

          // Header container displaying the total number of songs
          Container(
            width: double.infinity, 
            padding: const EdgeInsets.all(16.0), 
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Column(
                children: [
                  // Display total count of songs in the library
                  Text('${_musicLibrary.length}', style: Theme.of(context).textTheme.headlineMedium),
                  const Text('Total Songs'),
                ],
              ),
            ),
          ),
         
          // Scrollable list of filtered & sorted music tracks
          Expanded(
            child: ListView.builder(              
              itemCount: _filteredAndSortedMusic.length,
              itemBuilder: (context, index) {                
                final music = _filteredAndSortedMusic[index];
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
                    // Edit and Delete buttons on the right
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Need to map filtered index back to original index for edit/delete
                            final original = _filteredAndSortedMusic[index];
                            final originalIndex = _musicLibrary.indexOf(original);
                            if (originalIndex != -1) {
                              _showEditMusicDialog(originalIndex);
                            }
                          },
                          icon: const Icon(Icons.edit),
                          color: Theme.of(context).colorScheme.primary,
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          onPressed: () {
                            final original = _filteredAndSortedMusic[index];
                            final originalIndex = _musicLibrary.indexOf(original);
                            if (originalIndex != -1) {
                              _confirmDelete(originalIndex);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                          tooltip: 'Delete',
                        ),
                      ],
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