import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:proof_biometric_autofill/services/local_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: PageApp(),
    );
  }
}

class PageApp extends StatefulWidget {
  const PageApp({super.key});

  @override
  State<PageApp> createState() => _PageAppState();
}

class _PageAppState extends State<PageApp> {
  TextEditingController name = TextEditingController(text: '');
  TextEditingController pass = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    bool authenticated = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Id y Autofill'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print('se autentico $authenticated');
                  final authenticate = await LocalAuth.authenticate();

                  setState(() {
                    authenticated = authenticate!;
                    print('se autentico $authenticated');

                    if (authenticated) {
                      String? a = prefs.getString('name');
                      name.text = a!;
                      //pass.text = prefs.getString('password');

                      print(a);
                      show(context, authenticated);
                    }
                  });
                },
                child: const Text('Vamo a usar la autenticación')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AutofillGroup(
                      child: Column(
                    children: [
                      TextField(
                        controller: name,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(hintText: "Username"),
                      ),
                      TextField(
                        controller: pass,
                        obscureText: true,
                        autofillHints: [AutofillHints.password],
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            //--- trigger Password Save
                            TextInput.finishAutofillContext();

                            //--- OR ----
                          },
                          child: Text("Log In")),
                      ElevatedButton(
                          onPressed: () async {
                            //--- trigger Password Save
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('name', name.text);
                            prefs.setString('password', pass.text);

                            //--- OR ----
                          },
                          child: Text("Save"))
                    ],
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

show(BuildContext context, bool authenticated) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Estado de la Operacion'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.height * .6,
                  height: MediaQuery.of(context).size.height * .32,
                  child: Lottie.network(
                      'https://assets5.lottiefiles.com/private_files/lf30_nsqfzxxx.json'),
                ),
                ElevatedButton(
                    onPressed: () {
                      authenticated = false;
                      Navigator.pop(context);
                    },
                    child: Text('Cerrar Sesion'))
              ],
            ),
          ),
        );
      });
}
