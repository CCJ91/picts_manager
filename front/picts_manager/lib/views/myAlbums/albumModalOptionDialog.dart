import 'package:flutter/material.dart';

class AlbumModalOptionDialog extends StatelessWidget {
  final String title;
  final String message;

  const AlbumModalOptionDialog(
      {Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Valider'),
        ),
      ],
    );
  }
}
