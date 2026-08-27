import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.h';

void main() {
  runApp(const SmartDigitalIndiaApp());
}

class SmartDigitalIndiaApp extends StatelessWidget {
  const SmartDigitalIndiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Digital India Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MobileRegistrationScreen(),
    );
  }
}

// ==========================================
// STEP 1: MOBILE NUMBER REGISTRATION SCREEN
// ==========================================
class MobileRegistrationScreen extends StatefulWidget {
  const MobileRegistrationScreen({super.key});

  @override
  State<MobileRegistrationScreen> createState() => _MobileRegistrationScreenState();
}

class _MobileRegistrationScreenState extends State<MobileRegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _handleRegistration() {
    String phoneNumber = _phoneController.text.trim();
    
    if (phoneNumber.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulating network verification delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Navigate to Step 2 & 3: Security & Biometric Setup
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecuritySetupScreen(phoneNumber: phoneNumber),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Smart Digital India Pro - Register'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.phone_android,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome! Enter Your Mobile Number',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter your mobile number for secure banking & services.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.security),
                labelText: 'Mobile Number',
                hintText: 'Enter 10-digit number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                counterText: "",
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Continue & Verify',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// STEP 2 & 3: SECURITY & BIOMETRIC SETUP SCREEN
// ==========================================
class SecuritySetupScreen extends StatefulWidget {
  final String phoneNumber;
  const SecuritySetupScreen({super.key, required this.phoneNumber});

  @override
  State<SecuritySetupScreen> createState() => _SecuritySetupScreenState();
}

class _SecuritySetupScreenState extends State<SecuritySetupScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _statusText = "Setup Biometric Security (Fingerprint / Face / Iris)";
  bool _isSecured = false;

  Future<void> _authenticateBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please verify your face/iris or fingerprint to secure account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      setState(() {
        _statusText = "Error: ${e.message}";
      });
      return;
    }

    setState(() {
      if (authenticated) {
        _isSecured = true;
        _statusText = "Success! Account Secured & Verified for GKB";
      } else {
        _statusText = "Biometric Verification Failed. Try Again.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Security Setup (Step 2 & 3)'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isSecured ? Icons.lock_open : Icons.fingerprint,
                size: 90,
                color: _isSecured ? Colors.green : Colors.blue[800],
              ),
              const SizedBox(height: 20),
              Text(
                'Verified Number: ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _authenticateBiometrics,
                icon: const Icon(Icons.camera_front),
                label: const Text('Register Biometric / Face Lock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

