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
      'eligibility_rule_upsert': 'إنشاء أو تحديث قاعدة أهلية',
      'lottery_round_upsert': 'إنشاء أو تحديث جولة قرعة',
      'lottery_entry_upsert': 'إضافة أو تحديث طلب في القرعة',
      'eligibility_check_set': 'تسجيل نتيجة تحقق أهلية',
      'lottery_execute': 'تنفيذ جولة قرعة',
      'synthetic_fixture_create': 'إنشاء عينة اختبار للقرعة',
      'campaign_upsert': 'إنشاء أو تحديث حملة',
      'group_upsert': 'إنشاء أو تحديث مجموعة',
      'group_member_assign': 'تخصيص حاج لمجموعة',
      'operational_pack_upsert': 'إنشاء أو تحديث حزمة تشغيل',
      'activation_issue': 'إصدار رمز تفعيل',
      'activation_revoke': 'إلغاء رمز تفعيل',
      'activation_consume': 'استهلاك رمز تفعيل',
      'pilgrim_session_issue': 'إصدار جلسة حاج',
      'pilgrim_session_activate': 'تفعيل جلسة حاج',
      'pilgrim_session_revoke': 'إلغاء جلسة حاج',
      'pilgrim_backend_fixture_create': 'إنشاء بيانات حاج تجريبية',
      'admin_role_set': 'تحديث صلاحية إدارية',
      'content_upsert': 'إنشاء أو تحديث محتوى',
      'notification_upsert': 'إنشاء أو تحديث إشعار',
      'synthetic_e2e': 'تشغيل اختبار تكاملي تجريبي',
    };
    return labels[value] ?? _humanize(value);
  }

  static String entityAr(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    const labels = <String, String>{
      'season': 'موسم',
      'eligibility_rule': 'قاعدة أهلية',
      'eligibility_check': 'تحقق أهلية',
      'lottery_entry': 'طلب قرعة',
      'lottery_round': 'جولة قرعة',
      'campaign': 'حملة',
      'campaign_group': 'مجموعة',
      'group_member': 'عضو مجموعة',
      'campaign_operational_pack': 'حزمة تشغيل',
      'activation_token': 'رمز تفعيل',
      'content_item': 'محتوى',
      'notification': 'إشعار',
      'pilgrim_session': 'جلسة حاج',
      'admin_role_binding': 'صلاحية إدارية',
      'synthetic_e2e': 'اختبار تكاملي تجريبي',
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

  static bool isSyntheticReference(Object? raw) {
    final value = '${raw ?? ''}'.trim().toUpperCase();
    return value.startsWith('SYNTH-') ||
        value.contains('SYNTHETIC') ||
        value.startsWith('TEST-');
  }

  static String referenceForDisplay(Object? raw) {
    final value = '${raw ?? ''}'.trim();
    if (value.isEmpty) return '—';
    if (isSyntheticReference(value)) return 'مرجع تجريبي ${shortId(value)}';
    return shortId(value);
  }

  static String semanticContentTypeAr(Map<String, dynamic> row) {
    final rawType = '${row['content_type'] ?? ''}'.trim();
    final text = '${row['title_ar'] ?? ''} ${row['body_ar'] ?? ''}'.trim();
    if (rawType == 'fatwa') return 'فتوى';
    if (rawType == 'guidance') return 'إرشاد';
    if (rawType == 'service') {
      if (text.contains('شرعي') || text.contains('فتوى')) return 'محتوى شرعي';
      if (text.contains('إشعار') || text.contains('تنبيه')) {
        return 'تنبيهات وإشعارات';
      }
      if (text.contains('رحلتي') || text.contains('رحلة')) return 'خدمة الرحلة';
    }
    return contentTypeAr(rawType);
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
