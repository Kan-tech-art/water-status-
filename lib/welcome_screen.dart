import 'package:flutter/material.dart';
import 'sign_up_screen.dart';

const _blue = Color(0xFF0B6BDB);
const _navy = Color(0xFF0B1F4D);
const _slate = Color(0xFF5B6B8C);
const _softBlue = Color(0xFFDCEBFB);
const _panel = Color(0xFFEFF5FD);
const _border = Color(0xFFDCE8F8);

/// The first screen, shown before the person has signed up.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _say(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
void _signUp(BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (i) {
          if (i != 0) _say(context, 'Sign up to use this');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: _blue),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + hero text, with the water-drop photo on the right
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFDCEBFB), Color(0xFFF7FAFE)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        stops: [0.0, 0.4],
                      ).createShader(rect),
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/ripple.png',
                        width: width * 0.68,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/gh_water.png',
                                height: 56,
                                width: 56,
                              ),
                              FilledButton.icon(
                                onPressed: () => _signUp(context),
                                icon: const Icon(Icons.person, size: 20),
                                label: const Text('Sign Up'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: _blue,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 32, 20, 56),
                          child: _Hero(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Card 1: the status card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => _signUp(context),
                child: const _StatusCard(),
              ),
            ),
            // Card 2: describes what the app does
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: _AboutCard(),
            ),
          ],
        ),
      ),
    );
  }
}

/// The title at the top (font a little smaller than before).
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ghana Water',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: _navy,
          ),
        ),
        Text(
          'Status Checker',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: _blue,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Know if water is coming\nto your area.',
          style: TextStyle(fontSize: 14, color: _slate, height: 1.4),
        ),
      ],
    );
  }
}

/// The card that describes the app.
class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this app',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ghana Water Status Checker tells you whether water will come to your '
            'exact area today and tomorrow, and why.',
            style: TextStyle(fontSize: 14, color: _slate, height: 1.4),
          ),
          SizedBox(height: 16),
          _AboutPoint(
            icon: Icons.person_add_alt_1,
            text: 'Sign up once with your name, phone and account number.',
          ),
          _AboutPoint(
            icon: Icons.location_on,
            text: 'We find your district and area from your account number.',
          ),
          _AboutPoint(
            icon: Icons.water_drop,
            text: 'See if water is coming today and tomorrow.',
          ),
          _AboutPoint(
            icon: Icons.info,
            text: 'Know the reason and when supply is expected back.',
          ),
          _AboutPoint(
            icon: Icons.notifications_active,
            text: 'Get a message when your area is closed (coming soon).',
          ),
        ],
      ),
    );
  }
}

class _AboutPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AboutPoint({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: _panel,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: _blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: _navy, height: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final double size;
  const _IconCircle({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: _softBlue, shape: BoxShape.circle),
      child: Center(
        child: Container(
          width: size * 0.72,
          height: size * 0.72,
          decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: size * 0.4),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: _IconCircle(icon: Icons.water_drop, size: 56),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water status',
                        style: TextStyle(fontSize: 14, color: _slate),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Sign up to check',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 24, color: _border),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _panel,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: _blue),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Location',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: _slate),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '—',
                            style: TextStyle(color: _slate),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, size: 34, color: _blue),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason',
                        style: TextStyle(fontSize: 14, color: _slate),
                      ),
                      SizedBox(height: 2),
                      Text('—', style: TextStyle(fontSize: 16, color: _navy)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
