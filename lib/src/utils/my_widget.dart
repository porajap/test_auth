import 'package:flutter/material.dart';

import 'app_theme.dart';

Widget MyScreen({required Widget child}) => Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: child,
    );

Widget InputHeight({required Widget child}) => Container(height: 40, child: child);

Widget FormVertical() => SizedBox(height: 10);

Widget FormHorizontal() => SizedBox(width: 10);

