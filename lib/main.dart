import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigation.dart';
import 'services/user_service.dart';
import 'services/equipment_service.dart';
import 'services/setup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ReadyCheckApp());
}

class ReadyCheckApp extends StatelessWidget {
  const ReadyCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => EquipmentService()),
        ChangeNotifierProvider(create: (_) => SetupService()),
      ],
      child: MaterialApp(
        title: 'ReadyCheck',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}