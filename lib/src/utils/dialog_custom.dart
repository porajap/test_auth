import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'constants.dart';

void dialogCustom({
  required BuildContext context,
  required String title,
  required String msg,
  String? cancelText,
}) {


  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$title",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 10),
            Text(
              '$msg',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(primary: AppColor.grayColor, elevation: 0),
                child: Text(
                  "${cancelText ?? Constants.textClose}",
                  style: TextStyle(color: AppColor.textPrimaryColor.withOpacity(0.7)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}