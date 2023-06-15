import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTopAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff3FA7D6),
      title: Row(
        children: [
          Expanded(
            child: Text(
              "PictsManager",
              style: GoogleFonts.bethEllen(fontSize: 22, color: Colors.white),
            ),
          ),
          Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
            height: 40,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(47);
}
