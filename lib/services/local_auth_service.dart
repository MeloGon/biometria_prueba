import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool?> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
          authMessages: [
            AndroidAuthMessages(
                signInTitle: 'Sign In', cancelButton: 'No thanks'),
            IOSAuthMessages(cancelButton: 'No thanks')
          ],
          localizedReason: 'Use face id to authenticate',
          options:
              AuthenticationOptions(useErrorDialogs: true, stickyAuth: true));
    } catch (e) {
      print('error ${e.toString()}');
    }
  }
}
