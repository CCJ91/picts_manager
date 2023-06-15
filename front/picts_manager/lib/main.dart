import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:picts_manager/providers/cameraProvider.dart';
import 'package:picts_manager/providers/myImageProvider.dart';
import 'package:picts_manager/providers/navigationProvider.dart';
import 'package:picts_manager/providers/searchPageProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';
import 'package:picts_manager/utils/Styles.dart';
import 'package:picts_manager/views/splashScreen/splashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (_) => NavigationProvider()),
        ListenableProvider(create: (_) => CameraProvider()),
        ListenableProvider(create: (_) => AuthenticationProvider()),
        ListenableProvider(create: (_) => TagProvider()),
        ListenableProvider(create: (_) => AlbumProvider()),
        ListenableProvider(create: (_) => MyImageProvider()),
        ListenableProvider(create: (_) => AlbumPageProvider()),
        ListenableProvider(create: (_) => SearchPageProvider()),
      ],
      child: MaterialApp(
        theme: Styles.myThemeData,
        home: SplashScreen(),
      ),
    );
  }
}
