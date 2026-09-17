import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/admin_environment.dart';
import 'data/admin_repository.dart';
import 'presentation/dashboard_page.dart';
import 'presentation/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdminEnvironment.isConfigured) {
    await Supabase.initialize(
      url: AdminEnvironment.supabaseUrl,
      publishableKey: AdminEnvironment.clientKey,
    );
  }
  runApp(const ManasaknaAdminApp());
}

class ManasaknaAdminApp extends StatelessWidget {
  const ManasaknaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AdminEnvironment.productNameAr,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B51)),
        useMaterial3: true,
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: AdminEnvironment.isConfigured
          ? const _AuthGate()
          : const _ConfigurationRequiredPage(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = client.auth.currentSession;
        if (session == null) return const LoginPage();
        return _AdminAuthorizationGate(
          repository: AdminRepository(
            client,
            syntheticToolsEnabled: AdminEnvironment.syntheticToolsEnabled,
          ),
        );
      },
    );
  }
}

class _AdminAuthorizationGate extends StatefulWidget {
  const _AdminAuthorizationGate({required this.repository});
  final AdminRepository repository;

  @override
  State<_AdminAuthorizationGate> createState() =>
      _AdminAuthorizationGateState();
}

class _AdminAuthorizationGateState extends State<_AdminAuthorizationGate> {
  late Future<Map<String, dynamic>> _context;

  @override
  void initState() {
    super.initState();
    _context = widget.repository.adminContext();
  }

  void _retry() {
    setState(() => _context = widget.repository.adminContext());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _context,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return _AuthorizationFailure(
            message: snapshot.error.toString(),
            onRetry: _retry,
          );
        }
        return DashboardPage(
          repository: widget.repository,
          adminContext: snapshot.data ?? const {},
        );
      },
    );
  }
}

class _AuthorizationFailure extends StatelessWidget {
  const _AuthorizationFailure({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_person_outlined, size: 58),
                const SizedBox(height: 16),
                Text(
                  'لا توجد صلاحية إدارية لمناسكنا',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: [
                    OutlinedButton(
                      onPressed: onRetry,
                      child: const Text('إعادة المحاولة'),
                    ),
                    FilledButton(
                      onPressed: () => Supabase.instance.client.auth.signOut(),
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfigurationRequiredPage extends StatelessWidget {
  const _ConfigurationRequiredPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'لوحة مناسكنا تعمل Fail-Closed. شغّلها فقط مع SUPABASE_URL وSUPABASE_PUBLISHABLE_KEY (أو SUPABASE_ANON_KEY مؤقتًا) عبر --dart-define.\nلا توجد بيانات حقيقية أو Production في V1.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
