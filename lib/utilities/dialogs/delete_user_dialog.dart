import 'package:flutter/material.dart';
import 'package:nonotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteUserDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete User",
    content: "Are you sure you want to delete your user?",
    optionsBuilder: () => {
      'Cancel': false,
      'Delete User': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
