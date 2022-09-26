import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonotes/constants/routes.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/services/auth/bloc/auth_bloc.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                  'We\'ve sent you an email verification. Please click on the link in email to verify your account'),
              const Text(
                  "If you haven't received a verification email yet, press the button below:"),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text("Send Verification Email Again"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text("Restart"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
