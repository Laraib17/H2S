import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/UI/welcomePage.dart';
import 'package:myapp/blocks /user/placeListBloc.dart';
import 'package:myapp/blocks /user/tripBloc.dart';
import 'package:myapp/blocks /user/userBloc.dart';
import 'package:myapp/Network_controller.dart';

Future<void> checkLoggedIn() async {
  FirebaseAuth.instance.currentUser?.reload();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      if (user.emailVerified != false) {
        runApp(const MyApp(initialRoute: '/home'));
      } else {
        runApp(const MyApp(initialRoute: '/emailVerification'));
      }
    } else {
      runApp(const MyApp(initialRoute: '/login'));
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  Get.put<NetworkController>(NetworkController(), permanent: true);
  checkLoggedIn();
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<placeListBloc>(
          create: (BuildContext context) => placeListBloc(),
        ),
        BlocProvider<userBloc>(create: (context) => userBloc()),
        BlocProvider(create: (context) => tripBloc()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const welcomePage(),
          '/home':
              (context) => navigationPage(
                isBackButtonClick: false,
                autoSelectedIndex: 0,
              ),
          '/emailVerification': (context) => const emailVerificationPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("HS")));
  }
}
