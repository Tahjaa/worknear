import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
import 'client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  bool codeSent = false;
  bool obscurePassword = true;
  dynamic accountRequestId;
  // UuidValue? accountRequestId;
  // String? accountRequestId;
  String? registrationToken;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> startRegistration() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final requestId =
          await client.emailIdp.startRegistration(
        email: email,
      );

      if (!mounted) return;

      setState(() {
       accountRequestId = requestId;
        // accountRequestId = requestId.toString();
        codeSent = true;
      });

      _showMessage(
        'Verification code sent to your email.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Could not start registration: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> verifyCode() async {
    final code = _codeController.text.trim();

    if (accountRequestId == null) {
      _showMessage(
        'Please request a verification code first.',
      );
      return;
    }

    if (code.isEmpty) {
      _showMessage(
        'Please enter the verification code.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token =
          await client.emailIdp.verifyRegistrationCode(
        accountRequestId: accountRequestId!,
        verificationCode: code,
      );

      if (!mounted) return;

      setState(() {
        registrationToken = token;
      });

      _showMessage(
        'Email verified. Now create your password.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Verification failed: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> finishRegistration() async {
    final password = _passwordController.text;

    if (registrationToken == null) {
      _showMessage(
        'Please verify your email first.',
      );
      return;
    }

    if (password.length < 8) {
      _showMessage(
        'Password must be at least 8 characters.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await client.emailIdp.finishRegistration(
        registrationToken: registrationToken!,
        password: password,
      );

      if (!mounted) return;

      _showMessage(
        'Registration successful! You can now log in.',
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Registration failed: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: CircleAvatar(
                radius: 42,
                child: Icon(
                  Icons.person_add_outlined,
                  size: 42,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                'Join WorkNear',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'Create an account to find nearby jobs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: _emailController,
              enabled: !codeSent,
              keyboardType:
                  TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (!codeSent)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : startRegistration,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send Verification Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),

            if (codeSent) ...[
              const Text(
                'Enter the verification code sent to your email.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _codeController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  hintText: 'Enter code',
                  prefixIcon: Icon(
                    Icons.verified_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              if (registrationToken == null)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : verifyCode,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Verify Email',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),

              if (registrationToken != null) ...[
                const SizedBox(height: 8),

                const Text(
                  'Email verified! Create a password for your account.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                      _passwordController,
                  obscureText:
                      obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText:
                        'At least 8 characters',
                    prefixIcon:
                        const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                    ),
                    border:
                        const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : finishRegistration,
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}