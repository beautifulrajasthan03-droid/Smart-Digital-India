import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const SmartDigitalIndiaApp());
}

class SmartDigitalIndiaApp extends StatelessWidget {
  const SmartDigitalIndiaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Digital India Pro (GKB)',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFEB3B),
      ),
      home: const SecurityAuthScreen(),
    );
  }
}

class SecurityAuthScreen extends StatefulWidget {
  const SecurityAuthScreen({Key? key}) : super(key: key);

  @override
  State<SecurityAuthScreen> createState() => _SecurityAuthScreenState();
}

class _SecurityAuthScreenState extends State<SecurityAuthScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  String _statusText = 'System Secure. Tap below to initiate handshake';

  Future<void> _executeBiometricAuth() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access Smart Digital India Pro',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      authenticated = false;
    }

    setState(() {
      _statusText = authenticated ? 'Access Granted: Welcome GKB' : 'Authentication Failed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Digital India Pro - Secure Auth'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _executeBiometricAuth,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Authenticate with Biometrics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

