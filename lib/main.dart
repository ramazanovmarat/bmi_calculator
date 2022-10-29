import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/fire_page.dart';

  initNotify() async {
    try {
      await OneSignal.shared.promptUserForPushNotificationPermission();
      await OneSignal.shared.setAppId('9964c88b-0f2f-4ced-9874-896ac0967eff');
    } catch (e) {
      print(e);
    }
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initNotify();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мелбет',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.yellow,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  void navPush() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FirePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/melbet.png'))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 60,
                width: 250,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(1.0),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      final path = sharedPreferences.getString('key');
                      path == null ? navPush() : launch(path);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(20),
                          ),
                      ),
                    ),
                      child: const Text('START',
                        style: TextStyle(color: Colors.black, fontSize: 40),
                      ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


