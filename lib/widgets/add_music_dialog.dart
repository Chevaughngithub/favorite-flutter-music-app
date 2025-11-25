import 'package:flutter/material.dart';

/// AddMusicDialog - A dialog widget for adding new music to the library
/// This is a StatelessWidget because it doesn't manage its own state
/// It receives a callback function to send the new music data back to the parent
class AddMusicDialog extends StatefulWidget {
  // Optional callback for adding new music
  final Function(String title, String artist, String album, int year)? onAddMusic;
  // Optional callback for editing existing music
  final Function(String title, String artist, String album, int year)? onEditMusic;
  // If provided, dialog will be in edit mode and fields will be pre-populated
  final dynamic music; // Using dynamic to avoid import cycles; expects a Music-like object with fields

  const AddMusicDialog({
    super.key,
    this.onAddMusic,
    this.onEditMusic,
    this.music,
  });

  @override
  State<AddMusicDialog> createState() => _AddMusicDialogState();
}

class _AddMusicDialogState extends State<AddMusicDialog> {
  late final TextEditingController titleContoller;
  late final TextEditingController artistContoller;
  late final TextEditingController albumContoller;
  late final TextEditingController yearContoller;

  @override
  void initState() {
    super.initState();
    titleContoller = TextEditingController(text: widget.music != null ? widget.music.title : '');
    artistContoller = TextEditingController(text: widget.music != null ? widget.music.artist : '');
    albumContoller = TextEditingController(text: widget.music != null ? widget.music.album : '');
    yearContoller = TextEditingController(text: widget.music != null ? widget.music.year.toString() : '');
  }

  @override
  void dispose() {
    titleContoller.dispose();
    artistContoller.dispose();
    albumContoller.dispose();
    yearContoller.dispose();
    super.dispose();
  }

  bool _validateFields() {
    return titleContoller.text.isNotEmpty &&
        artistContoller.text.isNotEmpty &&
        albumContoller.text.isNotEmpty &&
        yearContoller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.music != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Music' : 'Add New Music'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleContoller,
              decoration:
                  InputDecoration(labelText: 'Title', hintText: 'Enter song title'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: artistContoller,
              decoration:
                  InputDecoration(labelText: 'Artist', hintText: 'Enter artist name'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: albumContoller,
              decoration:
                  InputDecoration(labelText: 'Album', hintText: 'Enter album name'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: yearContoller,
              decoration:
                  InputDecoration(labelText: 'Year', hintText: 'Enter year of release'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (!_validateFields()) return;

              final title = titleContoller.text;
              final artist = artistContoller.text;
              final album = albumContoller.text;
              final year = int.tryParse(yearContoller.text) ?? 0;

              if (isEdit) {
                if (widget.onEditMusic != null) {
                  widget.onEditMusic!(title, artist, album, year);
                }
              } else {
                if (widget.onAddMusic != null) {
                  widget.onAddMusic!(title, artist, album, year);
                }
              }

              Navigator.of(context).pop();
            },
            child: Text(isEdit ? 'Save' : 'Add')),
      ],
    );
  }
}