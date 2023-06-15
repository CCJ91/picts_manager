import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/providers/cameraProvider.dart';
import 'package:picts_manager/views/cameraPage/CameraView.dart';
import 'package:picts_manager/views/cameraPage/ImageView.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        return Selector<CameraProvider, MyImage?>(
          selector: (context, provider) => provider.image,
          builder: (context, image, child) {
            if (image == null) {
              return CameraView(listCameraDescription: snapshot.data!);
            } else {
              return ImageView(
                myImage: image,
              );
            }
          },
        );
      },
    );
  }
}
