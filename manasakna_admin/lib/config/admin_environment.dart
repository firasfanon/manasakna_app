class AdminEnvironment {
  const AdminEnvironment._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static const productNameAr = 'مناسكنا — الإدارة والعمليات';
  static const productNameEn = 'Manasakna Admin & Operations';
  static const environmentLabel = 'V1 / SYNTHETIC DATA ONLY';

  static const realPilgrimDataEnabled = false;
  static const productionEnabled = false;
  static const nusukIntegrationEnabled = false;
}
