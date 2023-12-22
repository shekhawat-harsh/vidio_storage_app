import 'package:enter_video_storage_app/main.dart';
import 'package:enter_video_storage_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

PhoneAuthCredential? credential;

class OtpScreen extends StatefulWidget {
  final String varificationID;
  const OtpScreen({super.key, required this.varificationID});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  String currentText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: schight / 2.5,
              alignment: Alignment.topLeft,
              color: Colors.black,
              child: Image.asset(
                'lib/assets/logo.png', // Replace with your logo asset

                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter OTP",
                    style: GoogleFonts.atkinsonHyperlegible(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      controller: otpController,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                        selectedColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      credential = PhoneAuthProvider.credential(
                          verificationId: widget.varificationID,
                          smsCode: otpController.text);

                      try {
                        FirebaseAuth.instance.signInWithCredential(credential!);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const HomeScreen()));
                      } catch (e) {
                        SnackBar snackBar = const SnackBar(
                          content: Text("wrong OTP try again ☠️ "),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text("Submit"),
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
