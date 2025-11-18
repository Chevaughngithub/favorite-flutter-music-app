import 'package:flutter/material.dart';

/// AddMusicDialog - A dialog widget for adding new music to the library
/// This is a StatelessWidget because it doesn't manage its own state
/// It receives a callback function to send the new music data back to the parent
class AddMusicDialog extends StatelessWidget {

  // Callback function that will be called when user adds a new music
  // Takes title, artist, album, and year as parameters
  final Function(String title, String artist, String album, int year) onAddMusic;

  const AddMusicDialog({
    super.key,
    required this.onAddMusic,
  });

  /// Builds the dialog UI with input fields for music information
  @override
  Widget build(BuildContext context) {
    // Controllers to capture and manage user input from text fields
    final titleContoller = TextEditingController();
    final artistContoller = TextEditingController();
    final albumContoller = TextEditingController();
    final yearContoller = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Music'),
      // SingleChildScrollView allows scrolling if content is too tall
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text field for song title
            TextField(
              controller: titleContoller,
              decoration: InputDecoration(labelText: 'Title', hintText: 'Enter song title'),
            ),
            const SizedBox(height: 8.0),
            // Text field for artist name
            TextField(
              controller: artistContoller,
              decoration: InputDecoration(labelText: 'Artist', hintText: 'Enter artist name'),
            ),
            const SizedBox(height: 8.0),
            // Text field for album name
            TextField(
              controller: albumContoller,
              decoration: InputDecoration(labelText: 'Album', hintText: 'Enter album name'),
            ),
            const SizedBox(height: 8.0),
            // Text field for release year (numeric keyboard)
            TextField(
              controller: yearContoller,
              decoration: InputDecoration(labelText: 'Year', hintText: 'Enter year of release'),
              keyboardType: TextInputType.number,
            ),            
          ],
        ),
      ),
      // Action buttons at the bottom of the dialog
      actions:[
        // Cancel button - closes the dialog without saving
        TextButton(
          onPressed: (){ 
            Navigator.of(context).pop();
          }, 
          child: const Text('Cancel')),
        // Add button - validates and saves the new music
        TextButton(
          onPressed: (){ 
            // Validate that all fields have been filled in
            if(titleContoller.text.isNotEmpty &&
               artistContoller.text.isNotEmpty &&
               albumContoller.text.isNotEmpty &&
               yearContoller.text.isNotEmpty &&
               yearContoller.text.isNotEmpty) {
              // Call the onAddMusic callback with user input
              onAddMusic(
                titleContoller.text,
                artistContoller.text,
                albumContoller.text,
                int.parse(yearContoller.text),
              );
              // Close the dialog after adding music
              Navigator.of(context).pop();
            }
            
          }, 
          child: const Text('Add')),
      ]
    );
  }
}