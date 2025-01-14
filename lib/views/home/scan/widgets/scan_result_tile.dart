import 'package:mwc/index.dart';
import 'package:flutter/material.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(List<List<int>> data) {
    return data.map((val) => '${getNiceHexArray(val)}').join(', ').toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries.map((v) => '${v.key}: ${getNiceHexArray(v.value)}').join(', ').toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
            style: AppFont.s18.overrides(fontSize: 12, color: AppColors.primaryBackground),
          ),
        ],
      );
    } else {
      return Text(
        widget.result.device.remoteId.str,
        style: AppFont.s18.overrides(fontSize: 12, color: AppColors.primaryBackground),
      );
    }
  }

  Text connectext(BuildContext context) {
    return (isConnected || widget.result.advertisementData.connectable)
        ? Text(
            SetLocalizations.of(context).getText('settingAddDeviceConnectableLabel'),
            style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 12),
          )
        : Text(
            SetLocalizations.of(context).getText('settingAddDeviceUnConnectableLabel'),
            style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 12),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: InkWell(
        onTap: (widget.result.advertisementData.connectable) ? widget.onTap : null,
        child: Container(
          height: 80,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFAEB2B8).withOpacity(0.30), // 시작 색상
                Color(0xFFFCFDFF).withOpacity(0.02), // 끝 색상
              ],
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0, color: Color(0x33FBFCFF)),
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0xB2121212),
                blurRadius: 8,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 19, 20, 19),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: AppColors.primaryBackground,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTitle(context),
                        connectext(context),
                      ],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.primaryBackground,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
