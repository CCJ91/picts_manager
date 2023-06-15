import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;

  CustomDialog({required this.title});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: 'Saisissez votre texte'),
      ),
      actions: [
        TextButton(
          child: Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Valider'),
          onPressed: () {
            Navigator.of(context).pop(_textEditingController.text);
          },
        )
      ],
    );
  }
}
