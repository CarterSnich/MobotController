import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String ipAddress = '192.168.4.1';
  String port = '5003';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 160,
                    child: Text(
                      'IP address',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 16,
                      ),
                      child: TextFormField(
                        initialValue: ipAddress,
                        onChanged: (text) {
                          setState(() {
                            ipAddress = text;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    width: 160,
                    child: Text(
                      'Port',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 16,
                      ),
                      child: TextFormField(
                        initialValue: port.toString(),
                        onChanged: (text) {
                          setState(() {
                            port = text;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (!isValidIPv4(ipAddress)) {
                          Toast.show(
                            "Invalid IP address",
                            duration: Toast.lengthShort,
                            gravity: Toast.bottom,
                          );
                          return;
                        }

                        if (port.isEmpty) {
                          Toast.show(
                            "Invalid IP address",
                            duration: Toast.lengthShort,
                            gravity: Toast.bottom,
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Controller(
                              ipAddress: ipAddress,
                              port: int.parse(port),
                            ),
                          ),
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              )
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
