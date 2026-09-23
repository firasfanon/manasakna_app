import '../../journey_contract/domain/journey_context.dart';

class UnifiedJourneyCandidate {
  const UnifiedJourneyCandidate(this.context);

  final JourneyContext context;

  String get id => context.journeyId;
  JourneyType get type => context.journeyType;
  JourneyFreshness get freshness => context.freshness;

  String get modeLabelAr => type == JourneyType.hajj ? 'الحج' : 'العمرة';

  String get sourceLabelAr {
    if (type == JourneyType.hajj &&
        context.sourceAuthority == AuthorityKind.government &&
        context.authorityProvenance.isAuthoritative) {
      return 'معلومة رسمية من الجهة الحكومية';
    }
    if (type == JourneyType.umrah &&
        context.sourceAuthority == AuthorityKind.commercialCompany) {
      return 'بيانات تشغيلية من الشركة المنظمة';
    }
    if (context.sourceAuthority == AuthorityKind.externalProvider &&
        context.authorityProvenance.isAuthoritative) {
      return 'مصدر خارجي موثّق';
    }
    return 'مصدر رحلة موثّق';
  }

  String get authorityBadgeAr {
    switch (context.sourceAuthority) {
      case AuthorityKind.government:
        return 'حكومي';
      case AuthorityKind.delegatedCompany:
        return 'تشغيل مفوّض';
      case AuthorityKind.commercialCompany:
        return 'شركة عمرة';
      case AuthorityKind.commonTraveler:
        return 'خدمة مشتركة';
      case AuthorityKind.externalProvider:
        return 'مزود خارجي';
    }
  }

  String get freshnessLabelAr {
    switch (freshness) {
      case JourneyFreshness.fresh:
        return 'محدّث';
      case JourneyFreshness.stale:
        return 'بحاجة إلى تحديث';
      case JourneyFreshness.offlineSnapshot:
        return 'نسخة محفوظة للعمل دون اتصال';
      case JourneyFreshness.unknown:
        return 'حالة غير معروفة';
    }
  }

  bool get isOfficialHajj =>
      type == JourneyType.hajj &&
      context.sourceAuthority == AuthorityKind.government &&
      context.authorityProvenance.isAuthoritative;

  bool get isCommercialUmrah =>
      type == JourneyType.umrah &&
      context.sourceAuthority == AuthorityKind.commercialCompany;
}

class UnifiedJourneyResolution {
  const UnifiedJourneyResolution({
    required this.candidates,
    required this.selected,
  });

  final List<UnifiedJourneyCandidate> candidates;
  final UnifiedJourneyCandidate? selected;

  bool get hasMultipleJourneys => candidates.length > 1;
  bool get requiresExplicitSelection => hasMultipleJourneys && selected == null;

  UnifiedJourneyCandidate candidateFor(JourneyType type) {
    return candidates.firstWhere((candidate) => candidate.type == type);
  }
}

class UnifiedJourneyResolver {
  const UnifiedJourneyResolver();

  UnifiedJourneyResolution resolve(
    List<JourneyContext> contexts, {
    JourneyType? preferredType,
  }) {
    if (contexts.isEmpty) {
      throw const FormatException('NO_ELIGIBLE_JOURNEY');
    }

    final seen = <String, JourneyContext>{};
    for (final context in contexts) {
      context.validate();
      final existing = seen[context.journeyId];
      if (existing != null &&
          (existing.journeyType != context.journeyType ||
              existing.sourceAuthority != context.sourceAuthority ||
              existing.authorityProvenance.sourceId !=
                  context.authorityProvenance.sourceId)) {
        throw const FormatException('AMBIGUOUS_JOURNEY_AUTHORITY');
      }
      seen[context.journeyId] = context;
    }

    final candidates = seen.values
        .map(UnifiedJourneyCandidate.new)
        .toList(growable: false)
      ..sort((a, b) => a.type.index.compareTo(b.type.index));

    UnifiedJourneyCandidate? selected;
    if (preferredType != null) {
      for (final candidate in candidates) {
        if (candidate.type == preferredType) {
          selected = candidate;
          break;
        }
      }
    } else if (candidates.length == 1) {
      selected = candidates.single;
    }

    return UnifiedJourneyResolution(
      candidates: candidates,
      selected: selected,
    );
  }
}
