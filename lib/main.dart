import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StepCountingScreen(),
    );
  }
}

class StepCountingScreen extends StatefulWidget {
  const StepCountingScreen({super.key});

  @override
  State<StepCountingScreen> createState() => _StepCountingScreenState();
}

class _StepCountingScreenState extends State<StepCountingScreen> {
  late Stream<StepCount> _stepCountStream;

  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();

    _stepCountStream = Pedometer.stepCountStream;

    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.activityRecognition.request();

    setState(() {
      _permissionGranted = status == PermissionStatus.granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
      body: Center(
        child: _permissionGranted
            ? StreamBuilder<StepCount>(
                stream: _stepCountStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    );
                  }

                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final stepCount = snapshot.data!.steps;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Steps Today:',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '$stepCount',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              )
            : Text(
                'Permission required to count steps.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
      ),
    );
  }
}
