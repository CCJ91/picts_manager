import 'package:flutter/material.dart';
import 'package:picts_manager/providers/navigationProvider.dart';
import 'package:provider/provider.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationProvider navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    return Selector<NavigationProvider, int>(
      selector: (context, provider) => provider.index,
      builder: (context, index, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 5,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xff3FA7D6),
            unselectedItemColor: Colors.white,
            selectedItemColor: Color(0xff85144B),
            currentIndex: index,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: "Mes Albums",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: "Photo",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Recherche",
              ),
            ],
            onTap: (value) {
              navigationProvider.index = value;
            },
          ),
        );
      },
    );
  }
}
