class AdminPresentation {
  const AdminPresentation._();

  static String statusAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'draft': 'مسودة',
      'registration_open': 'التسجيل مفتوح',
      'registration_closed': 'التسجيل مغلق',
      'lottery': 'مرحلة القرعة',
      'operations': 'قيد التشغيل',
      'closed': 'مغلق',
      'archived': 'مؤرشف',
      'locked': 'مقفلة',
      'executed': 'نُفذت',
      'cancelled': 'ملغاة',
      'active': 'نشطة',
      'published': 'منشور',
      'scheduled': 'مجدول',
      'selected': 'مختار',
      'waitlisted': 'قائمة انتظار',
      'ineligible': 'غير مؤهل',
      'assigned': 'مُخصص',
      'activated': 'مفعّل',
      'consumed': 'مستخدم',
      'revoked': 'ملغى',
      'expired': 'منتهي',
    };
    return labels[value] ?? _humanize(value);
  }

  static String contentTypeAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'guidance': 'إرشاد',
      'fatwa': 'فتوى',
      'service': 'خدمة',
      'contact': 'جهة اتصال',
      'banner': 'إعلان',
      'faq': 'أسئلة شائعة',
    };
    return labels[value] ?? _humanize(value);
  }

  static String roleAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'super_admin': 'مدير أعلى',
      'operations_admin': 'مدير العمليات',
      'lottery_manager': 'مسؤول القرعة',
      'content_editor': 'محرر المحتوى',
      'viewer': 'مشاهد',
    };
    return labels[value] ?? _humanize(value);
  }

  static String actionAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'season_upsert': 'إنشاء أو تحديث موسم',
      'lottery_execute': 'تنفيذ جولة قرعة',
      'campaign_upsert': 'إنشاء أو تحديث حملة',
      'group_upsert': 'إنشاء أو تحديث مجموعة',
      'group_member_assign': 'تخصيص حاج لمجموعة',
      'activation_issue': 'إصدار رمز تفعيل',
      'content_upsert': 'إنشاء أو تحديث محتوى',
      'notification_upsert': 'إنشاء أو تحديث إشعار',
      'pilgrim_session_issue': 'إصدار جلسة حاج',
    };
    return labels[value] ?? _humanize(value);
  }

  static String entityAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'season': 'موسم',
      'lottery_round': 'جولة قرعة',
      'campaign': 'حملة',
      'campaign_group': 'مجموعة',
      'group_member': 'عضو مجموعة',
      'activation_token': 'رمز تفعيل',
      'content_item': 'محتوى',
      'notification': 'إشعار',
      'pilgrim_session': 'جلسة حاج',
    };
    return labels[value] ?? _humanize(value);
  }

  static String audienceAr(Object? raw) {
    if (raw is! Map) return 'الجمهور غير محدد';
    final kind = '${raw['kind'] ?? ''}'.trim();
    return switch (kind) {
      'all' => 'جميع الحجاج',
      'campaign' => 'حملة محددة',
      'group' => 'مجموعة محددة',
      'pilgrim' => 'حاج محدد',
      _ => kind.isEmpty ? 'الجمهور غير محدد' : _humanize(kind),
    };
  }

  static String dateTimeAr(Object? raw) {
    if (raw == null) return 'غير محدد';
    final value = '$raw'.trim();
    if (value.isEmpty) return 'غير محدد';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final local = parsed.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${local.year}/${two(local.month)}/${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  static String shortId(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    if (value.isEmpty) return '—';
    if (value.length <= 12) return value;
    return '${value.substring(0, 8)}…${value.substring(value.length - 4)}';
  }

  static String boolAr(Object? raw) => raw == true ? 'نعم' : 'لا';

  static String authorityLabel(Map<String, dynamic> row) {
    final metadata = row['metadata'];
    if (metadata is! Map) return 'غير مسجل في V1';
    for (final key in <String>[
      'authority_label',
      'authority',
      'approved_by',
      'source_label',
      'source',
    ]) {
      final value = '${metadata[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'غير مسجل في V1';
  }

  static String syntheticSeasonLabel(Map<String, dynamic> row) {
    final settings = row['settings'];
    if (settings is Map && settings['synthetic_only'] == true) {
      return 'بيانات تجريبية';
    }
    return 'حالة البيانات غير محددة';
  }

  static String _humanize(String value) {
    if (value.isEmpty) return 'غير محدد';
    return value.replaceAll('_', ' ');
  }
}
