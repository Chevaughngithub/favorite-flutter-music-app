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
  final _formKey = GlobalKey<FormState>();

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

  // Use Form validators for input validation
  bool _validateFields() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.music != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Music' : 'Add New Music'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleContoller,
                decoration: const InputDecoration(labelText: 'Title', hintText: 'Enter song title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: artistContoller,
                decoration: const InputDecoration(labelText: 'Artist', hintText: 'Enter artist name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: albumContoller,
                decoration: const InputDecoration(labelText: 'Album', hintText: 'Enter album name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an album';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: yearContoller,
                decoration: const InputDecoration(labelText: 'Year', hintText: 'Enter year of release'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a year';
                  }

                  final parsed = int.tryParse(value.trim());
                  if (parsed == null) {
                    return 'Year must be a number';
                  }

                  if (parsed < 1900 || parsed > 2025) {
                    return 'Year must be between 1900 and 2025';
                  }

                  return null;
                },
              ),
            ],
          ),
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
              // Validate and submit the form
              if (!_validateFields()) return;

              final title = titleContoller.text.trim();
              final artist = artistContoller.text.trim();
              final album = albumContoller.text.trim();
              final yearParsed = int.tryParse(yearContoller.text.trim());
              if (yearParsed == null) return;
              final year = yearParsed;

              if (isEdit) {
                widget.onEditMusic?.call(title, artist, album, year);
              } else {
                widget.onAddMusic?.call(title, artist, album, year);
              }

              Navigator.of(context).pop();
            },
            child: Text(isEdit ? 'Save' : 'Add')),
      ],
    );
  }
}