import 'package:flutter/material.dart';
import 'package:nonotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        'We have sent you a email with password reset link. Please check your email.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
