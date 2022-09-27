import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nonotes/helpers/loading/loading_screen_dialog.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (
      context,
    ) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
              maxHeight: size.height * 0.8,
              minWidth: size.width * 0.5,
              minHeight: size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: StreamBuilder<String>(
                stream: _text.stream,
                builder: (context, snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        snapshot.data as String,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
    state?.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}
