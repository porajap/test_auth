import 'package:flutter/material.dart';

MyAppBar({
  required String title,
  required BuildContext context,
  Widget? action,
  bool isShowBack = false
}) =>
    AppBar(
      title: Text(
        "$title",
      ),
      leading: isShowBack ? IconButton(
        splashRadius: 18,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_rounded),
      ) : SizedBox(),
      actions: [
        action == null
            ? SizedBox()
            : Container(
                padding: EdgeInsets.only(right: 8),
                child: action,
              )
      ],
    );

Widget AppBarAction({
  required VoidCallback onPressed,
  required Widget icon,
}) =>
    IconButton(
      onPressed: onPressed,
      icon: icon,
      splashRadius: 18,
    );
