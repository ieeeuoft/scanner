import 'package:flutter/material.dart';
import 'package:scanner/scan.dart';

class UsernameEntryScreen extends StatefulWidget {
  const UsernameEntryScreen({super.key});

  @override
  _UsernameEntryScreenState createState() => _UsernameEntryScreenState();
}

class _UsernameEntryScreenState extends State<UsernameEntryScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Mobile Scanner')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text("Instructions",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                            "Welcome to the Mobile Scanner App! Point the camera at any QR code to scan its content. Once a QR code is scanned, tap on it to confirm and proceed."),
                      ],
                    )),
                const SizedBox(width: 20),
                Expanded(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          child: const Text('Start Scanning'),
                          onPressed: () {
                            if (_usernameController.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScanPage(
                                    title: 'Scanner Page',
                                    username: _usernameController.text,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a username!')),
                              );
                            }
                          },
                        ),
                      ],
                    ))
              ],
            )));
  }
}
