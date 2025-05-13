import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Controller extends StatefulWidget {
  const Controller({
    super.key,
    required this.ipAddress,
    required this.port,
    required this.maxSteeringLeft,
    required this.steeringCenter,
    required this.maxSteeringRight,
    required this.maxForwardSpeed,
    required this.minForwardSpeed,
    required this.maxReverseSpeed,
    required this.minReverseSpeed,
  });

  final String ipAddress;
  final int port;
  final int maxSteeringLeft;
  final int steeringCenter;
  final int maxSteeringRight;
  final int maxForwardSpeed;
  final int minForwardSpeed;
  final int maxReverseSpeed;
  final int minReverseSpeed;

  @override
  State<StatefulWidget> createState() => _Controller();
}

class _Controller extends State<Controller> {
  late int steeringValueMapped;

  double maxSliderValue = 255;
  double minSliderValue = 0;

  double accelerationValue = 0.0;
  double steeringValue = 0;
  CarState carState = CarState.park;

  @override
  void initState() {
    steeringValueMapped = widget.steeringCenter;
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
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

  void prdPress(CarState state) {
    setState(() {
      carState = state;
      if (carState == CarState.drive) {
        maxSliderValue = widget.maxForwardSpeed.toDouble();
        accelerationValue = widget.minForwardSpeed.toDouble();
        minSliderValue = widget.minForwardSpeed.toDouble();
      } else if (carState == CarState.reverse) {
        maxSliderValue = widget.maxReverseSpeed.toDouble();
        accelerationValue = widget.minReverseSpeed.toDouble();
        minSliderValue = widget.minReverseSpeed.toDouble();
      }
    });
    sendUDP(
      'CS${state.index}',
      widget.ipAddress,
      widget.port,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('socket@${widget.ipAddress}:${widget.port}'),
      ),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Text('${accelerationValue.toInt()}'),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: Listener(
                                onPointerUp: (_) {
                                  if (carState != CarState.park) {
                                    setState(() {
                                      accelerationValue = minSliderValue;
                                    });
                                    sendUDP(
                                      'CO',
                                      widget.ipAddress,
                                      widget.port,
                                    );
                                  }
                                },
                                child: Slider(
                                  value: accelerationValue,
                                  max: maxSliderValue,
                                  min: minSliderValue,
                                  onChanged: (double value) {
                                    if (carState == CarState.park) return;
                                    setState(() {
                                      accelerationValue = value;
                                    });
                                    if (carState == CarState.drive) {
                                      sendUDP(
                                        'FW${accelerationValue.toInt()}',
                                        widget.ipAddress,
                                        widget.port,
                                      );
                                    } else if (carState == CarState.reverse) {
                                      sendUDP(
                                        'RV${accelerationValue.toInt()}',
                                        widget.ipAddress,
                                        widget.port,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapDown: (_) =>
                                  sendUDP("BR1", widget.ipAddress, widget.port),
                              onTapUp: (_) =>
                                  sendUDP("BR0", widget.ipAddress, widget.port),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Brake",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: carState == CarState.park
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () => prdPress(CarState.park),
                      child: const Text('Park'),
                    ),
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: carState == CarState.drive
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () => prdPress(CarState.drive),
                      child: const Text('Drive'),
                    ),
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: carState == CarState.reverse
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () => prdPress(CarState.reverse),
                      child: const Text('Reverse'),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTapDown: (_) => sendUDP(
                        "HO1",
                        widget.ipAddress,
                        widget.port,
                      ),
                      onTapUp: (_) => sendUDP(
                        "HO0",
                        widget.ipAddress,
                        widget.port,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Horn",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () =>
                          sendUDP("HL", widget.ipAddress, widget.port),
                      child: const Text('Headlights'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 76,
                  ),
                  child: Column(
                    children: [
                      Text('$steeringValueMapped'),
                      Expanded(
                        child: Listener(
                          onPointerUp: (_) {
                            setState(() {
                              steeringValue = 0;
                              steeringValueMapped = widget.steeringCenter;
                            });
                            sendUDP(
                              'LR${widget.steeringCenter}',
                              widget.ipAddress,
                              widget.port,
                            );
                          },
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Slider(
                              value: steeringValue,
                              max: 255,
                              min: -255,
                              onChanged: (double value) {
                                setState(() {
                                  steeringValue = value;
                                });

                                int mapped;

                                if (value > 0) {
                                  mapped = mapValue(
                                    value.toInt(),
                                    0,
                                    255,
                                    widget.steeringCenter + 1,
                                    widget.maxSteeringLeft,
                                  );
                                } else if (value < 0) {
                                  mapped = mapValue(
                                    value.toInt(),
                                    -255,
                                    0,
                                    widget.maxSteeringRight,
                                    widget.steeringCenter,
                                  );
                                } else {
                                  mapped = widget.steeringCenter;
                                }

                                steeringValueMapped = mapped;

                                sendUDP(
                                  'LR$mapped',
                                  widget.ipAddress,
                                  widget.port,
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void sendUDP(String message, String host, int port) async {
  RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    0,
  ).then((RawDatagramSocket socket) {
    socket.send(message.codeUnits, InternetAddress(host), port);
    socket.close();
  });
}

enum CarState {
  park,
  reverse,
  drive,
}

int mapValue(int x, int inMin, int inMax, int outMin, int outMax) {
  return ((x - inMin) * (outMax - outMin) ~/ (inMax - inMin)) + outMin;
}
