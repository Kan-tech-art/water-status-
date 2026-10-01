import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'session.dart';
import 'welcome_screen.dart';

/// Decides what to show when the app opens:
/// a saved login goes straight to the dashboard, otherwise the welcome screen.
class StartGate extends StatelessWidget {
  const StartGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AppSession.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final token = snapshot.data;
        if (token != null && token.isNotEmpty) {
          return const DashboardScreen();
        }
        return const WelcomeScreen();
      },
    );
  }
}
