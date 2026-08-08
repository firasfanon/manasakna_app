enum JourneyStepStatus {
  completed,
  current,
  upcoming,
  attention,
}

class JourneyStep {
  const JourneyStep({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.status,
    required this.stageLabelAr,
    required this.dateLabelAr,
    required this.checklistItemsAr,
    required this.tipsAr,
    this.actionLabelAr,
  });

  final String id;
  final String titleAr;
  final String descriptionAr;
  final JourneyStepStatus status;
  final String stageLabelAr;
  final String dateLabelAr;
  final List<String> checklistItemsAr;
  final List<String> tipsAr;
  final String? actionLabelAr;

  bool get isDone => status == JourneyStepStatus.completed;
  bool get isCurrent => status == JourneyStepStatus.current || status == JourneyStepStatus.attention;
  bool get needsAttention => status == JourneyStepStatus.attention;
}
