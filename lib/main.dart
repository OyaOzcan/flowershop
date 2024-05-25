import 'package:caseapp/firebase_options.dart';
import 'package:caseapp/view/component/bottom_navbar.dart';
import 'package:caseapp/view_model/cart_view_model.dart';
import 'package:caseapp/view_model/favorites_view_model.dart';
import 'package:caseapp/view_model/products_view_model.dart';
import 'package:caseapp/view/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsViewModel()),
        ChangeNotifierProvider(create: (context) => CartViewModel()),
        ChangeNotifierProvider(create: (context) => FavoritesViewModel()),  
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: isLoggedIn ? BottomNavBar() : LoginScreen(),
      ),
    );
  }
}
