import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getPrefs();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  late SharedPreferences prefs;

  final ipAddressController = TextEditingController(text: "192.168.4.1");
  final portController = TextEditingController(text: '5003');
  final maxSteeringLeftController = TextEditingController(text: '255');
  final steeringCenterController = TextEditingController(text: '128');
  final maxSteeringRightController = TextEditingController(text: '0');
  final maxForwardSpeedController = TextEditingController(text: '255');
  final minForwardSpeedController = TextEditingController(text: '0');
  final maxReverseSpeedController = TextEditingController(text: '255');
  final minReverseSpeedController = TextEditingController(text: '0');

  final EdgeInsets paddingValue = const EdgeInsets.symmetric(
    horizontal: 0,
    vertical: 4,
  );

  final SizedBox spacer = const SizedBox(width: 8);

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    restorePrefs();
  }

  void restorePrefs() {
    setState(() {
      ipAddressController.text = prefs.getString("ipAddress") ?? "192.168.4.1";
      portController.text = prefs.getString("port") ?? "5003";
      maxSteeringLeftController.text =
          prefs.getString("maxSteeringLeft") ?? "255";
      steeringCenterController.text =
          prefs.getString("steeringCenter") ?? "128";
      maxSteeringRightController.text =
          prefs.getString("maxSteeringRight") ?? "0";
      maxForwardSpeedController.text =
          prefs.getString("maxForwardSpeed") ?? "255";
      minForwardSpeedController.text =
          prefs.getString("minForwardSpeed") ?? "0";
      maxReverseSpeedController.text =
          prefs.getString("maxReverseSpeed") ?? "255";
      minReverseSpeedController.text =
          prefs.getString("minReverseSpeed") ?? "0";
    });
  }

  void onClickContinue() async {
    if (!isValidIPv4(ipAddressController.text)) {
      Toast.show(
        "Invalid IP address",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
      return;
    }

    if (portController.text.isEmpty) {
      Toast.show(
        "Invalid IP address",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
      return;
    }

    try {
      final String ipAddress = ipAddressController.text;
      final int port = int.parse(portController.text);
      final int maxSteeringLeft = int.parse(maxSteeringLeftController.text);
      final int steeringCenter = int.parse(steeringCenterController.text);
      final int maxSteeringRight = int.parse(maxSteeringRightController.text);
      final int maxForwardSpeed = int.parse(maxForwardSpeedController.text);
      final int minForwardSpeed = int.parse(minForwardSpeedController.text);
      final int maxReverseSpeed = int.parse(maxReverseSpeedController.text);
      final int minReverseSpeed = int.parse(minReverseSpeedController.text);

      prefs.setString("ipAddress", ipAddress);
      prefs.setString("port", portController.text);
      prefs.setString("maxSteeringLeft", maxSteeringLeftController.text);
      prefs.setString("steeringCenter", steeringCenterController.text);
      prefs.setString("maxSteeringRight", maxSteeringRightController.text);
      prefs.setString("maxForwardSpeed", maxForwardSpeedController.text);
      prefs.setString("minForwardSpeed", minForwardSpeedController.text);
      prefs.setString("maxReverseSpeed", maxReverseSpeedController.text);
      prefs.setString("minReverseSpeed", minReverseSpeedController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Controller(
            ipAddress: ipAddress,
            port: port,
            maxSteeringLeft: maxSteeringLeft,
            steeringCenter: steeringCenter,
            maxSteeringRight: maxSteeringRight,
            maxForwardSpeed: maxForwardSpeed,
            minForwardSpeed: minForwardSpeed,
            maxReverseSpeed: maxReverseSpeed,
            minReverseSpeed: minReverseSpeed,
          ),
        ),
      );
    } catch (e) {
      Toast.show(
        "Fuckin' errors. Check your inputs, you stupid fuck.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MobotController"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: paddingValue,
                child: Row(
                  children: <Widget>[
                    label('IP address:Port'),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: ipAddressController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          spacer,
                          Expanded(
                            child: buildTextField(controller: portController),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    label('Steering'),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: maxSteeringLeftController,
                            ),
                          ),
                          spacer,
                          Expanded(
                            child: buildTextField(
                              controller: steeringCenterController,
                            ),
                          ),
                          spacer,
                          Expanded(
                            child: buildTextField(
                              controller: maxSteeringRightController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    label('Forward Speed'),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: maxForwardSpeedController,
                            ),
                          ),
                          spacer,
                          Expanded(
                            child: buildTextField(
                              controller: minForwardSpeedController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingValue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    label("Reverse Speed"),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: maxReverseSpeedController,
                            ),
                          ),
                          spacer,
                          Expanded(
                            child: buildTextField(
                              controller: minReverseSpeedController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingValue,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: onClickContinue,
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isValidIPv4(String input) {
  // Regular expression to match an IPv4 address
  final ipv4Regex = RegExp(r'^([0-9]{1,3}\.){3}[0-9]{1,3}$');

  // Check if the input matches the IPv4 format
  if (!ipv4Regex.hasMatch(input)) {
    return false;
  }

  // Split the input string into four numbers
  final numbers = input.split('.').map(int.tryParse);

  // Check if all four numbers are valid (between 0 and 255)
  return numbers.every((n) => n != null && n >= 0 && n <= 255);
}

SizedBox label(String text) {
  return SizedBox(
    width: 120,
    child: Text(text),
  );
}

TextFormField buildTextField({
  required TextEditingController controller,
  String? label,
  TextInputType? keyboardType = TextInputType.number,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      border: const OutlineInputBorder(),
    ),
  );
}
