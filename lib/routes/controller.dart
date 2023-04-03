import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Controller extends StatefulWidget {
  const Controller({
    super.key,
    required this.ipAddress,
    required this.port,
  });

  final String ipAddress;
  final int port;

  @override
  State<StatefulWidget> createState() => _Controller();
}

class _Controller extends State<Controller> {
  double accelerationValue = 0.0;
  double turningValue = 0.0;
  bool mode = false;

  @override
  void initState() {
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
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Listener(
                            onPointerUp: (_) {
                              if (mode) {
                                setState(() {
                                  accelerationValue = 0.0;
                                });
                                sendUDP(
                                  'FB${accelerationValue.toInt()}',
                                  widget.ipAddress,
                                  widget.port,
                                );
                              }
                            },
                            child: Slider(
                              value: accelerationValue,
                              max: 255.0,
                              min: -255.0,
                              onChanged: (double value) {
                                if (mode) {
                                  setState(() {
                                    accelerationValue = value;
                                  });
                                  sendUDP(
                                    'FB${accelerationValue.toInt()}',
                                    widget.ipAddress,
                                    widget.port,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      Text('${turningValue.toInt()}'),
                      Expanded(
                        child: Listener(
                          onPointerUp: (_) {
                            if (mode) {
                              setState(() {
                                turningValue = 0.0;
                              });
                              sendUDP(
                                'LR${turningValue.toInt()}',
                                widget.ipAddress,
                                widget.port,
                              );
                            }
                          },
                          child: Slider(
                            value: turningValue,
                            max: 255.0,
                            min: -255.0,
                            onChanged: (double value) {
                              if (mode) {
                                setState(() {
                                  turningValue = value;
                                });
                                sendUDP(
                                  'LR${turningValue.toInt()}',
                                  widget.ipAddress,
                                  widget.port,
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Listener(
              onPointerUp: (_) {
                setState(() {
                  mode = !mode;
                });

                sendUDP(
                  'MD${mode ? 1 : 0}',
                  widget.ipAddress,
                  widget.port,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    onChanged: (value) {},
                    value: mode,
                  ),
                  const Text('Enable controls')
                ],
              ),
            ),
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
