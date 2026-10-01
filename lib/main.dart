import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'start_gate.dart';

const supabaseUrl = 'https://giwterevohazsactuywa.supabase.co';
const supabasePublishableKey = 'sb_publishable_BBHs2Vz4Gvm7V14B4mbMJA_5osbxcgI';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  runApp(const WaterApp());
}

final supabase = Supabase.instance.client;

class WaterApp extends StatelessWidget {
  const WaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghana Water',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0B6BDB), useMaterial3: true),
      home: const StartGate(),
    );
  }
}