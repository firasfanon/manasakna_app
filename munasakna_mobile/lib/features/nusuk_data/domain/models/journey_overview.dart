class JourneyOverview {
  const JourneyOverview({
    required this.titleAr,
    required this.subtitleAr,
    required this.currentStatusAr,
    required this.nextMilestoneAr,
    required this.travelWindowAr,
    required this.readinessLabelAr,
    required this.progress,
  });

  final String titleAr;
  final String subtitleAr;
  final String currentStatusAr;
  final String nextMilestoneAr;
  final String travelWindowAr;
  final String readinessLabelAr;
  final double progress;
}
