import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_screen.dart';
import 'session.dart';

const _blue = Color(0xFF0B6BDB);
const _navy = Color(0xFF0B1F4D);
const _slate = Color(0xFF5B6B8C);
const _softBlue = Color(0xFFDCEBFB);
const _panel = Color(0xFFF4F8FD);
const _border = Color(0xFFDCE8F8);

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _account = TextEditingController();
  final _phone = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _account.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await Supabase.instance.client.rpc(
        'sign_in',
        params: {
          'p_phone': _phone.text.trim(),
          'p_account_number': _account.text.trim(),
        },
      );

      await AppSession.saveToken(result['token'] as String);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    } on PostgrestException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(
        () =>
            _error = 'Something went wrong. Check your internet and try again.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboard,
    int? maxLength,
    List<TextInputFormatter>? formatters,
  }) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c, width: w),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _slate,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          maxLength: maxLength,
          inputFormatters: formatters,
          validator: validator,
          style: const TextStyle(color: _navy),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9AA8C2)),
            prefixIcon: Icon(icon, color: _slate),
            filled: true,
            fillColor: _panel,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: border(_border),
            enabledBorder: border(_border),
            focusedBorder: border(_blue, 2),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    final pictureWidth = math.min(screenWidth * 0.6, 300.0);

    return Container(
      width: double.infinity,
      height: topPadding + 190,
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
            width: pictureWidth,
            height: 130,
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                colors: [Colors.transparent, Colors.black],
                stops: [0.0, 0.4],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: Image.asset('assets/ripple.png', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: topPadding + 12,
            left: 20,
            right: 12,
            child: Row(
              children: [
                Image.asset('assets/gh_water.png', height: 52, width: 52),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          const TextSpan(
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const Text(
                        'Safe Water. Healthy Communities.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: _slate),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text('Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: _blue,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _border),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: _softBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                size: 34,
                                color: _blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Sign ',
                                    style: TextStyle(color: _navy),
                                  ),
                                  TextSpan(
                                    text: 'In',
                                    style: TextStyle(color: _blue),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Welcome back. Enter your details.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: _slate),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _field(
                            label: 'Account Number',
                            hint: 'Enter your account number',
                            icon: Icons.badge_outlined,
                            controller: _account,
                            keyboard: TextInputType.number,
                            maxLength: 12,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (v) => (v == null || v.length != 12)
                                ? 'Account number must be 12 digits'
                                : null,
                          ),
                          _field(
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            icon: Icons.phone_outlined,
                            controller: _phone,
                            keyboard: TextInputType.phone,
                            maxLength: 15,
                            formatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+]'),
                              ),
                            ],
                            validator: (v) => (v == null || v.length < 9)
                                ? 'Please enter a valid phone number'
                                : null,
                          ),
                          if (_error != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDECEC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Color(0xFFB3261E),
                                ),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              onPressed: _loading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: _blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sign In',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.arrow_forward, size: 20),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
