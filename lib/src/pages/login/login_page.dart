import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_auth/src/pages/home/home_page.dart';
import 'package:test_auth/src/utils/dialog_custom.dart';

import '../../utils/my_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController(text: "999999999");
  TextEditingController smsController = TextEditingController();

  String _verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Phone verification", style: TextStyle(color: Colors.white)),
      ),
      body: MyScreen(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: buildTextFieldPhoneNumber()),
                FormHorizontal(),
                buildButtonSendSms(),
              ],
            ),
            FormVertical(),
            buildTextFieldSmsVerification(),
            FormVertical(),
            buildButtonVerify(),
          ],
        ),
      ),
    );
  }

  Widget buildButtonVerify() {
    return Container(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () => verifyPhone(),
        child: Text("Sign in with Phone number"),
      ),
    );
  }

  Widget buildButtonSendSms() {
    return OutlinedButton(
      onPressed: () => requestVerifyCode(),
      child: Text("Send"),
    );
  }

  Container buildTextFieldPhoneNumber() {
    return Container(
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixText: "+66",
        ),
      ),
    );
  }

  Container buildTextFieldSmsVerification() {
    return Container(
      child: TextFormField(
        controller: smsController,
        decoration: InputDecoration(hintText: "SMS verify"),
      ),
    );
  }

  requestVerifyCode() async {
    _auth.verifyPhoneNumber(
      phoneNumber: '+66${phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');

          dialogCustom(context: context, title: "Phone number invalid", msg: "Please check your phone");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verificationId = verificationId;
          smsController.text = "123456";
        });
        print(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyPhone() async {
    if (_verificationId == "") {
      dialogCustom(context: context, title: "Verification id invalid", msg: "Please send your phone");
      return;
    }

    if (smsController.text == "") {
      dialogCustom(context: context, title: "SMS code invalid", msg: "Please check your SMS code");
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsController.text,
    );

    await _auth.signInWithCredential(credential);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      ModalRoute.withName('/'),
    );
  }
}
