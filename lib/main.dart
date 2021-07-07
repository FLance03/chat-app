import 'package:chat_app/authentication_service.dart';
import 'package:chat_app/screens/user_screens/MainMenuSearch.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/screens.dart';
import 'classes/classes.dart';

/*
  TO DO:
  - LINK AUTHENTICATION TO USER
  - MIGRATE USERS TO AUTHENTICATION TAB IN FIREBASE
  - IMPLEMENT CHAT SELECTION SCREEN
*/

//Screens as String Variables
// const Login = '/Login';
const Login = '/';
const Signup = '/Signup';
const Home = '/Home';
const Hotels = '/Hotels';
const HotelDetails = '/HotelDetails';
const Booking = '/Booking';
const Complete = '/Complete';
const RoomServiceMain = '/RoomServiceMain';
const RoomServiceProducts = '/RoomServiceProducts';
const RoomServiceCleaning = '/RoomServiceCleaning';
const AnnouncementDetails = '/AnnouncementDetails';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(auth.FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _routes(), //default routes is '/' which is LoginPage()
        // onGenerateRoute: AuthenticationWrapper(),
        theme: _theme(),
      )
    );
  }
}

ThemeData _theme() {
  return ThemeData(
    primaryColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

RouteFactory _routes() {
  return (settings) {
    final Map<String, dynamic> arguments = settings.arguments; //Needed for passing data between screens
    Widget screen;
    switch (settings.name) {
      // add logout button
      case '/': screen = GroupChat(); break;
      case '/signup': screen = SignUpPage(); break;
      // case Login:
      //   screen = LoginPage();
      //   break;
      // case Complete:
      //   screen = CompletePage(dateCheckin: arguments['date_checkin'], dateCheckout: arguments['date_checkout']);
      //   break;
      // case AnnouncementDetails:
      //   screen = AnnouncementDetailsPage(id: arguments['id']);
      //   break;
      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<auth.User>();

    if (firebaseUser != null) {
      return GroupChat();
    }
    return SignInPage();
  }
}