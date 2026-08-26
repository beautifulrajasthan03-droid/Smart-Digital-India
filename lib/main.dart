// =====================================================================
// Project: Smart Digital India Pro (GKB) - Production Ready Core
// Developer: Govind Kumar Beragi (GKB)
// Rule: "Main app dobara bana lunga, par kisi ka paisa nahi dubne dunga!"
// =====================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _statusText = 'System Secure. Tap below to initiate hardware authentication.';
  bool _isAuthorized = false;

  Future<void> _executeBiometricAuth() async {
    bool authenticated = false;
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();

      if (canAuthenticateWithBiometrics || isSupported) {
        authenticated = await _auth.authenticate(
          localizedReason: 'Verify your identity to access Smart Digital India Pro',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ),
        );
      } else {
        authenticated = true;
      }
    } on PlatformException catch (e) {
      setState(() {
        _statusText = 'Security Protocol Exception: ${e.message}';
      });
      return;
    }

    setState(() {
      _isAuthorized = authenticated;
      _statusText = authenticated
          ? 'Identity Verified Successfully. Access Granted.'
          : 'Authentication Restricted. Please Try Again Safely.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Digital India Pro (GKB)'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: const Text(
                'Jai Baba Kedarnath! | Secure Financial Core',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Icon(
              _isAuthorized ? Icons.lock_open : Icons.fingerprint,
              size: 90,
              color: _isAuthorized ? Colors.green : Colors.black87,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isAuthorized ? Colors.greenAccent : Colors.orangeAccent,
                  width: 2,
                ),
              ),
              child: Text(
                _statusText,
                style: TextStyle(
                  color: _isAuthorized ? Colors.greenAccent : Colors.amberAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.cyanAccent,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: _executeBiometricAuth,
              icon: const Icon(Icons.security, size: 24),
              label: const Text(
                'Authenticate Security Core',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

