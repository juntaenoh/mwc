import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';
import 'package:mwc/views/webrtc/webrtc_main_view.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({Key? key}) : super(key: key);

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  bool _expertAvailable = true;
  bool _clientAvailable = true;

  @override
  void initState() {
    super.initState();
    AppStateNotifier.instance.addListener(_updateRoleAvailability);
    AppStateNotifier.instance.initController();
  }

  @override
  void dispose() {
    AppStateNotifier.instance.userListNotifier.removeListener(_updateRoleAvailability);
    super.dispose();
  }

  void _updateRoleAvailability() {
    bool expertExists = false;
    bool clientExists = false;

    for (var user in AppStateNotifier.instance.userListNotifier.value) {
      if (user['role'] == 'expert') {
        expertExists = true;
      } else if (user['role'] == 'client') {
        clientExists = true;
      }
    }

    setState(() {
      _expertAvailable = !expertExists;
      _clientAvailable = !clientExists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_expertAvailable)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    AppStateNotifier.instance.setRole("expert");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebRTCMainView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Expert'),
                ),
              ),
            if (_clientAvailable) const SizedBox(height: 20),
            if (_clientAvailable)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    AppStateNotifier.instance.setRole("client");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebRTCMainView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Client'),
                ),
              ),
            if (!_expertAvailable && !_clientAvailable)
              const Center(
                child: Text(
                  'Both roles are taken. Please wait...',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
