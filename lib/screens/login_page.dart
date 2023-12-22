import 'package:enter_video_storage_app/main.dart';
import 'package:enter_video_storage_app/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String? moNum;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    schight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Your Company Logo
                Container(
                  height: schight / 2.5,
                  alignment: Alignment.topLeft,
                  color: Colors.black,
                  child: Image.asset(
                    'lib/assets/logo.png', // Replace with your logo asset

                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 50),

                Text(
                  "LOGIN 🎥",
                  style: GoogleFonts.atkinsonHyperlegible(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                // Mobile Number TextFormField
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value)! < 1000000000 ||
                          int.tryParse(value)! > 9999999999) {
                        return 'Please enter a valid mobile number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      labelStyle:
                          GoogleFonts.atkinsonHyperlegible(color: Colors.black),
                      prefixText: '+91 ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "by logging in you are accpecting to our terms*",
                  style: GoogleFonts.atkinsonHyperlegible(
                      fontSize: 16, color: const Color.fromARGB(98, 0, 0, 0)),
                ),
                const SizedBox(height: 20.0),
                // Button to Request OTP
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });

                      try {
                        await firebaseAuth.verifyPhoneNumber(
                          phoneNumber:
                              "+91${_mobileController.value.text.trim()}",
                          verificationCompleted: (cred) {},
                          verificationFailed: (e) {
                            print(e);
                            SnackBar snackBar = SnackBar(
                              content: Text("$e"),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {
                              loading = false;
                            });
                          },
                          codeSent: (id, token) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => OtpScreen(
                                        varificationID: id,
                                      )),
                            );
                            loading = false;
                          },
                          codeAutoRetrievalTimeout: (e) {
                            SnackBar snackBar = const SnackBar(
                              content: Text("Server timeout! "),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                        moNum = "+91${_mobileController.value.text.trim()}";
                      } catch (e) {
                        print("Error: $e");
                        // Handle other potential errors here
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  child: loading
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : Text(
                          'Request OTP',
                          style: GoogleFonts.atkinsonHyperlegible(
                              color: Colors.black),
                        ),
                ),
                const SizedBox(height: 20.0),
                // OTP TextFormField

                const SizedBox(height: 20.0),
                // Button to Verify OTP
              ],
            ),
          ),
        ),
      ),
    );
  }
}
