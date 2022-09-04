import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';
import '../../../utils/constants.dart';

class LoginTitle extends StatefulWidget {
  const LoginTitle({Key? key}) : super(key: key);

  @override
  State<LoginTitle> createState() => _LoginTitleState();
}

class _LoginTitleState extends State<LoginTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.33,
            color: AppColor.primaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: Placeholder(),
                ),
                SizedBox(height: 12),
                Text(
                  "ลงชื่อเข้าใช้บัญชีของคุณเพื่อดำเนินการต่อ",
                  style: TextStyle(
                    color: AppColor.whiteColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
