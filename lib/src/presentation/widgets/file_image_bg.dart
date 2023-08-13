import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:stories_editor/src/presentation/utils/color_detection.dart';

class FileImageBG extends StatefulWidget {
  final File? filePath;
  final void Function(Color color1, Color color2) generatedGradient;
  const FileImageBG(
      {Key? key, required this.filePath, required this.generatedGradient})
      : super(key: key);
  @override
  _FileImageBGState createState() => _FileImageBGState();
}

class _FileImageBGState extends State<FileImageBG> {
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  GlobalKey? currentKey;

  final StreamController<Color> stateController = StreamController<Color>();
  Color color1 = const Color(0xFFFFFFFF);
  Color color2 = const Color(0xFFFFFFFF);
  @override
  void dispose() {
    stateController.close();
    super.dispose();
  }

  @override
  void initState() {
    currentKey = paintKey;
    Timer.periodic(const Duration(milliseconds: 500), (callback) async {
      if (imageKey.currentState?.context.size?.height == 0.0) {
      } else {
        var cd1 = await ColorDetection(
          currentKey: currentKey,
          paintKey: paintKey,
          stateController: stateController,
        ).searchPixel(
            Offset(imageKey.currentState!.context.size!.width / 2, 480));
        var cd12 = await ColorDetection(
          currentKey: currentKey,
          paintKey: paintKey,
          stateController: stateController,
        ).searchPixel(
            Offset(imageKey.currentState!.context.size!.width / 2.03, 530));
        color1 = cd1;
        color2 = cd12;
        setState(() {});
        widget.generatedGradient(color1, color2);
        callback.cancel();
        stateController.close();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();
    return SizedBox(
        height: screenUtil.screenHeight,
        width: screenUtil.screenWidth,
        child: RepaintBoundary(
            key: paintKey,
            child: Container(
              color: Colors.blue,
              child: Center(
                  child: AspectRatio(
                aspectRatio: 9 / 18.2,
                child: Image.file(
                  widget.filePath!,
                  fit: BoxFit.fill,
                  key: imageKey,
                  filterQuality: FilterQuality.high,
                ),
              )),
            )));
  }
}
