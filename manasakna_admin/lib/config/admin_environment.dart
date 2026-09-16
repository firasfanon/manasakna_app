import 'dart:convert';

class AdminEnvironment {
  const AdminEnvironment._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  static const legacySupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );
  static const clientKey = supabasePublishableKey != ''
      ? supabasePublishableKey
      : legacySupabaseAnonKey;

  static const syntheticToolsEnabled = bool.fromEnvironment(
    'MANASAKNA_ENABLE_SYNTHETIC_TOOLS',
  );

  static bool get isConfigured =>
      supabaseUrl.trim().isNotEmpty && isSafeClientKey(clientKey);

  static bool isSafeClientKey(String rawKey) {
    final key = rawKey.trim();
    if (key.isEmpty || key.startsWith('sb_secret_')) return false;
    if (key.startsWith('sb_publishable_')) return true;
    if (key.toLowerCase().contains('service_role')) return false;

    final parts = key.split('.');
    if (parts.length == 3) {
      try {
        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        if (payload is Map && payload['role'] == 'service_role') return false;
      } catch (_) {
        // Legacy publishable/anon keys may not be JWTs. Non-secret values remain
        // eligible for the compatibility path.
      }
    }
    return true;
  }

  static const productNameAr = 'مناسكنا — الإدارة والعمليات';
  static const productNameEn = 'Manasakna Admin & Operations';
  static const environmentLabel = syntheticToolsEnabled
      ? 'V1 / SYNTHETIC TOOLS ENABLED'
      : 'V1 / HARDENED / SYNTHETIC TOOLS OFF';

  static const realPilgrimDataEnabled = false;
  static const productionEnabled = false;
  static const nusukIntegrationEnabled = false;
}
