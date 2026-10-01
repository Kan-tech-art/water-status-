import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'session.dart';
import 'welcome_screen.dart';

const _blue = Color(0xFF0B6BDB);
const _navy = Color(0xFF0B1F4D);
const _slate = Color(0xFF5B6B8C);
const _softBlue = Color(0xFFDCEBFB);
const _panel = Color(0xFFEFF5FD);
const _border = Color(0xFFDCE8F8);
const _green = Color(0xFF1FA45B);
const _red = Color(0xFFD93025);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;
  bool _notify = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = await AppSession.getToken();
    if (token == null) {
      _goToWelcome();
      return;
    }
    try {
      final result = await Supabase.instance.client.rpc(
        'get_status',
        params: {'p_token': token},
      );
      if (!mounted) return;
      setState(() {
        _data = Map<String, dynamic>.from(result as Map);
        _error = null;
        _loading = false;
      });
    } on PostgrestException catch (e) {
      if (e.message.contains('Session expired')) {
        await AppSession.clear();
        _goToWelcome();
        return;
      }
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error =
            'Could not load. Check your internet and pull down to try again.';
        _loading = false;
      });
    }
  }

  void _goToWelcome() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  void _say(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: _border),
  );

  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDCEBFB), Color(0xFFF7FAFE)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Image.asset('assets/gh_water.png', height: 48, width: 48),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ghana ',
                            style: TextStyle(color: _navy),
                          ),
                          TextSpan(
                            text: 'Water',
                            style: TextStyle(color: _blue),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Safe Water. Healthy Communities.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: _slate),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await AppSession.clear();
                    _goToWelcome();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'logout', child: Text('Log out')),
                ],
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customerCard(Map customer) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: _softBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: _blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 12, color: _slate),
                ),
                Text(
                  '${customer['name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Account Number',
                  style: TextStyle(fontSize: 12, color: _slate),
                ),
                Text(
                  '${customer['account_number']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 18, color: _blue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${customer['walk']}, ${customer['district']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapCard(Map customer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.map_outlined, color: _blue),
              SizedBox(width: 10),
              Text(
                'Your Location',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 40, color: _blue),
                const SizedBox(height: 6),
                Text(
                  '${customer['walk']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const Text(
                  'Map coming soon',
                  style: TextStyle(fontSize: 12, color: _slate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCard(String label, Map day) {
    final isWater = day['status'] == 'water';
    final color = isWater ? _green : _red;
    final reason = (day['reason'] ?? '').toString();
    final start = day['start_time'];
    final end = day['end_time'];

    String? timeText;
    if (isWater && start != null && end != null) {
      timeText = 'Supply time: $start – $end';
    } else if (!isWater && end != null) {
      timeText = 'Expected back: $end';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isWater ? Icons.water_drop : Icons.water_drop_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isWater ? 'Water' : 'No water',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${day['date']}',
            style: const TextStyle(fontSize: 12, color: _slate),
          ),
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 12, color: _slate),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reason,
                    style: const TextStyle(fontSize: 15, color: _navy),
                  ),
                ],
              ),
            ),
          ],
          if (timeText != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _notifyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _softBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications, color: _blue),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                Text(
                  'Get updates about your water supply.',
                  style: TextStyle(fontSize: 12, color: _slate),
                ),
              ],
            ),
          ),
          Switch(
            value: _notify,
            activeThumbColor: _blue,
            onChanged: (v) => setState(() => _notify = v),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = _data;
    final children = <Widget>[];

    if (data == null) {
      children.add(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFDECEC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _error ?? 'Something went wrong.',
            style: const TextStyle(color: Color(0xFFB3261E)),
          ),
        ),
      );
    } else {
      final customer = data['customer'] as Map;
      children.addAll([
        _customerCard(customer),
        const SizedBox(height: 16),
        _mapCard(customer),
        const SizedBox(height: 16),
        _dayCard('Today', data['today'] as Map),
        const SizedBox(height: 16),
        _dayCard('Tomorrow', data['tomorrow'] as Map),
        const SizedBox(height: 16),
        _notifyCard(),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 16, color: _slate),
            SizedBox(width: 6),
            Text(
              'Please check often. Pull down to refresh.',
              style: TextStyle(fontSize: 12, color: _slate),
            ),
          ],
        ),
      ]);
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (i) {
          if (i != 0) _say('Coming soon');
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
      body: Column(
        children: [
          _header(),
          Expanded(child: _body()),
        ],
      ),
    );
  }
}
