import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override

  /// Build the main application widget.
  ///
  /// This widget contains a [MaterialApp] that, in turn, contains a
  /// [StepCountingScreen].
  ///
  /// The [MaterialApp] is the root widget of the application. It's used
  /// to configure the top-level routing, theming, and many other options.
  ///
  /// The [StepCountingScreen] is the home screen of the application. It
  /// displays the current step count and allows the user to request
  /// permissions to access the step counter.
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

  /// Initializes the state of the step counting screen.
  ///
  /// Sets up the step count stream from the pedometer and requests
  /// the necessary activity recognition permission.

  void initState() {
    super.initState();

    _stepCountStream = Pedometer.stepCountStream;

    _requestPermission();
  }

  /// Requests the activity recognition permission.
  ///
  /// This function is called when the state is initialized. It requests
  /// the permission and updates the state with the result.
  Future<void> _requestPermission() async {
    final status = await Permission.activityRecognition.request();

    setState(() {
      _permissionGranted = status == PermissionStatus.granted;
    });
  }

  @override

  /// Builds the widget tree for the step counting screen.
  ///
  /// This widget displays the title "Step Counter" in the app bar and
  /// displays the current step count in the body of the screen. If the
  /// permission to count steps has not been granted, it displays a message
  /// asking for the permission instead.
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
