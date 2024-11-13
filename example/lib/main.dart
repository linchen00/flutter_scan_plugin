import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_scan_plugin/flutter_scan_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterScanPlugin = FlutterScanPlugin();

  final List<String> list = <String>[];

  StreamSubscription<String>? streamSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterScanPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () async {
                  list.clear();
                  final startDeviceScanStream = _flutterScanPlugin.startDeviceScanStream();
                  streamSubscription = startDeviceScanStream.listen((event) {
                    setState(() {
                      list.add(event);
                    });
                  }, onDone: () {
                    print("startScanningStream onDone");
                  });
                },
                child: const Text('start Scanning'),
              ),
              ElevatedButton(
                onPressed: () async {
                  streamSubscription?.cancel();
                  streamSubscription = null;
                },
                child: const Text('stop Scanning'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => ListTile(title: Text(list[index])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
