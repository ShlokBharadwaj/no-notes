import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonotes/services/auth/bloc/auth_bloc.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';
import 'package:nonotes/services/auth/bloc/auth_state.dart';
import 'package:nonotes/utilities/dialogs/error_dialogs.dart';
import 'package:nonotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateResetPassword) {
          // ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(
          // content: Text(state.message),
          // ),
          // );
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.exception!.toString()),
              ),
            );
          }
          // if (state.exception != null) {
          //   await showErrorDialog(
          //     context,
          //     'We could not process your request. Please make sure you are registered and try again.',
          //   );
          // }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Enter your email address and we will send you a link to reset your password.',
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        AuthEventResetPassword(
                          email: _controller.text,
                        ),
                      );
                },
                child: const Text('Reset Password'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Back to Login Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
