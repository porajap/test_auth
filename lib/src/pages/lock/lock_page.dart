import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:test_auth/src/utils/app_bar.dart';
import 'package:test_auth/src/utils/my_widget.dart';

import '../home/home_page.dart';

class LockPage extends StatefulWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  @override
  void initState() {
    localAuth.isDeviceSupported().then(
          (bool isSupported) =>
              setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Lock Screen",
        context: context,
      ),
      body: MyScreen(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Local authenticate: ${_supportState.name}"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _authenticate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Authenticate'),
                      Icon(Icons.perm_device_information),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _authenticateWithBiometrics,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(_isAuthenticating ? 'Cancel' : 'Authenticate: biometrics only'),
                      Icon(Icons.fingerprint),
                    ],
                  ),
                ),
              ],
            ),
      ),
        ),),
    );
  }

  final LocalAuthentication localAuth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    print(_authorized);
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await localAuth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });

      if(authenticated){
        navigatorToHome();
        return;
      }
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await localAuth.authenticate(
        localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });

      if(authenticated){
        navigatorToHome();
        return;
      }


    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  navigatorToHome(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      ModalRoute.withName('/'),
    );
  }

}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
