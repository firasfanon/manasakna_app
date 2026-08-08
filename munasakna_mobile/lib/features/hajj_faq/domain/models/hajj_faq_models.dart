import '../../../hajj_matrix/domain/models/hajj_matrix_models.dart';

enum HajjFaqPhase {
  beforeTravel,
  beforeMiqat,
  ihram,
  makkah,
  minaTarwiyah,
  arafah,
  muzdalifah,
  nahr,
  tashreeq,
  farewell,
  afterReturn,
  urgent,
}

enum HajjFaqCategory {
  sharia,
  administrative,
  health,
  field,
  education,
  technical,
}

enum HajjFaqPriority {
  normal,
  important,
  critical,
}

enum HajjFaqAnswerStyle {
  brief,
  detailed,
  referToScholar,
}

class HajjFaqItem {
  const HajjFaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.phase,
    required this.timeWindow,
    required this.placeContext,
    required this.category,
    required this.priority,
    required this.answerStyle,
    required this.appActionLabel,
    this.hajjTypes = const [HajjType.tamattu, HajjType.qiran, HajjType.ifrad],
    this.genderScope = HajjGenderScope.all,
    this.healthScopes = const [HajjHealthScope.all],
    this.needsScholarApproval = true,
    this.keywords = const [],
  });

  final String id;
  final String question;
  final String answer;
  final HajjFaqPhase phase;
  final String timeWindow;
  final String placeContext;
  final HajjFaqCategory category;
  final HajjFaqPriority priority;
  final HajjFaqAnswerStyle answerStyle;
  final String appActionLabel;
  final List<HajjType> hajjTypes;
  final HajjGenderScope genderScope;
  final List<HajjHealthScope> healthScopes;
  final bool needsScholarApproval;
  final List<String> keywords;

  bool appliesToType(HajjType type) => hajjTypes.contains(type);
}
