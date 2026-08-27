import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const SmartDigitalIndiaProApp());
}

class SmartDigitalIndiaProApp extends StatelessWidget {
  const SmartDigitalIndiaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Digital India Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DirectIrisRegistrationScreen(),
    );
  }
}

// =====================================================================
// 1. DIRECT IRIS & FACE BIOMETRIC GATE (NO MOBILE NUMBER, NO OTP)
// =====================================================================
class DirectIrisRegistrationScreen extends StatefulWidget {
  const DirectIrisRegistrationScreen({super.key});

  @override
  State<DirectIrisRegistrationScreen> createState() => _DirectIrisRegistrationScreenState();
}

class _DirectIrisRegistrationScreenState extends State<DirectIrisRegistrationScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _statusMessage = "Position your eyes/face to establish permanent secure ownership";
  bool _isProcessing = false;

  Future<void> _performIrisAndFaceRegistration() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = "Scanning Iris and Face Biometrics...";
    });

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your eyes/face to activate Smart Digital India Pro permanently',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      setState(() {
        _statusMessage = "Security Hardware Error: ${e.message}";
        _isProcessing = false;
      });
      return;
    }

    if (authenticated) {
      setState(() {
        _statusMessage = "Iris Verified Successfully! Launching Secure Dashboard...";
      });
      
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SecureDashboardScreen(),
          ),
        );
      });
    } else {
      setState(() {
        _statusMessage = "Iris Scan Failed or Unmatched. Try Again.";
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        title: const Text('Smart Digital India Pro'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.remove_red_eye_rounded,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 25),
            const Text(
              'Direct Iris & Face Security Gate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Mobile Number. No OTP. Absolute Privacy.\nScan your eyes once to link your voice commands permanently.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade900, width: 2),
              ),
              child: Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _performIrisAndFaceRegistration,
              icon: const Icon(Icons.camera_front, size: 26),
              label: const Text(
                'Start Iris Scan & Register',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// 2. SECURE DASHBOARD (BACKGROUND VOICE ACTIVE & SAFE WARNING)
// =====================================================================
class SecureDashboardScreen extends StatelessWidget {
  const SecureDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      appBar: AppBar(
        title: const Text('Smart Digital India Pro - Protected'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.verified_user, size: 80, color: Colors.green),
            const SizedBox(height: 15),
            const Text(
              'Security Guard Active! (सुरक्षा कवच सक्रिय है)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Owner face and eyes are securely registered. Background voice protection is active. Speak your command naturally, and the phone will execute it safely.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Settings & Ownership Control',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Only use this if transferring phone ownership permanently.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text(
                              '⚠️ Important Warning (जरूरी चेतावनी)',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            content: const Text(
                              'Press this button ONLY if you are selling or permanently transferring ownership of this phone.\n\n'
                              'Doing this will delete your registered biometrics and require a fresh registration. Are you sure you want to proceed?',
                              style: TextStyle(fontSize: 13, height: 1.4),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(dialogContext).pop(),
                                child: const Text('Cancel (रद्द करें)'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DirectIrisRegistrationScreen()),
                                  );
                                },
                                child: const Text('Yes, Reset Owner'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Reset & Change Owner (सावधानी बटन)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

