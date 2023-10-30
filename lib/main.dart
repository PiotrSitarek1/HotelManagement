import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hotel_manager/screens/user_screen.dart';
import 'package:hotel_manager/screens/user_settings_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_choice_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/userScreen': (context) => const UserScreen(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateCounterInDatabase(_counter);
    });
  }

  void _updateCounterInDatabase(int counter) {
    _database.child('counter').set(counter);
  }


  void _navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginView(),
    ));
  }

  void _navigateToRegister() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  void _navigateToUserSettings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserSettingsView(),
    ));
  }

  void _navigateToUserScreen() {
    Navigator.pushNamed(context, '/userScreen');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _navigateToLogin,
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: _navigateToRegister,
              child: const Text('Register'),
            ),
            ElevatedButton(
              onPressed: _navigateToUserSettings,
              child: const Text('User settings'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'userScreenNav',
            onPressed: _navigateToUserScreen,
            tooltip: 'Navigate to User Screen',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'counterUpdate',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add_alert),
          ),
        ],
      ),
    );
  }
}
