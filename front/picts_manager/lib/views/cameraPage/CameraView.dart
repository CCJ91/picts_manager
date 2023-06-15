import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/providers/cameraProvider.dart';
import 'package:provider/provider.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key, required this.listCameraDescription});

  final List<CameraDescription> listCameraDescription;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraProvider cameraProvider;
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  late double interval;

  bool isFront = false;

  @override
  void initState() {
    super.initState();
    cameraProvider = Provider.of<CameraProvider>(context, listen: false);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    try {
      await initializeControllerFuture;
      controller.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = CameraController(
      widget.listCameraDescription[!isFront ? 0 : 1],
      ResolutionPreset.ultraHigh,
    );
    initializeControllerFuture = controller.initialize();
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          double size = MediaQuery.of(context).size.width;
          return FutureBuilder<double>(
              future: controller.getMaxZoomLevel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                interval = snapshot.data! - 1;
                return Stack(
                  children: [
                    CameraPreview(
                      controller,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: size,
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey.shade900,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Selector<CameraProvider, double>(
                                    selector: (context, provider) =>
                                        provider.zoom,
                                    builder: (context, data, child) {
                                      return Slider(
                                        value: data,
                                        onChanged: (value) async {
                                          cameraProvider.zoom = value;
                                          value = (value * interval) + 1;
                                          controller.setZoomLevel(value);
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: FloatingActionButton.large(
                                onPressed: () async {
                                  try {
                                    XFile file = await controller.takePicture();
                                    String path = await resizePhoto(file.path);
                                    cameraProvider.image = MyImage(
                                      id: "",
                                      name: "",
                                      link: path,
                                      imageIsPublic: "",
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: const Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    isFront = !isFront;
                                  });
                                },
                                child: Icon(
                                  Icons.flip_camera_android,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<String> resizePhoto(String filePath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(filePath);

    int width = min(properties.height ?? 2160, properties.width ?? 2160);
    File croppedFile =
        await FlutterNativeImage.cropImage(filePath, 0, 0, width, width);
    return croppedFile.path;
  }
}
