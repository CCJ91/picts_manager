import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picts_manager/views/loginPage/loginPage.dart';
import 'package:picts_manager/views/loginPage/registerPage.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Connexion'),
  Tab(text: 'Inscription'),
];

class LoginNavigator extends StatelessWidget {
  const LoginNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                "PictsManager",
                style: GoogleFonts.comfortaa(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: tabs.length,
                child: Builder(builder: (BuildContext context) {
                  final TabController tabController =
                      DefaultTabController.of(context);
                  return Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: TabBar(
                        controller: tabController,
                        tabs: tabs,
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        LoginPage(),
                        RegisterPage(
                          tabController: tabController,
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
