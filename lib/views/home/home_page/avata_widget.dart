import 'package:mwc/index.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/utils/TypeManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Avata extends StatefulWidget {
  final double height;
  const Avata({Key? key, required this.height}) : super(key: key);

  @override
  _AvataState createState() => _AvataState();
}

class _AvataState extends State<Avata> {
  late List<FootData>? foot;
  double _currentRotation = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      final TypeManager typeManager = TypeManager();
      typeManager.setType(context, appStateNotifier.footdata?.first.classType);
      return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              child: Container(
                height: widget.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/footsheet.png',
                ),
              ),
            ),
            if (typeManager.typeOk)
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    height: widget.height,
                    width: MediaQuery.of(context).size.width,
                    child: ModelViewer(
                      backgroundColor: Colors.transparent,
                      src: typeManager.typeAvt,
                      alt: 'A 3D model of an astronaut',
                      autoRotate: false,
                      cameraControls: true,
                      disableZoom: true,
                      disablePan: true,
                      disableTap: true,
                      cameraOrbit: "30deg 90deg auto",
                      minCameraOrbit: "auto 90deg auto",
                      maxCameraOrbit: "auto 90deg auto",
                    ),
                  ),
                ),
              ),
            if (!typeManager.typeOk)
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Container(
                    height: 460,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/noavt.png',
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
