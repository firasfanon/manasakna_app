import 'package:flutter/material.dart';

class BetaPageAuditItem {
  const BetaPageAuditItem({
    required this.id,
    required this.titleAr,
    required this.layerAr,
    required this.stageAr,
    required this.statusAr,
    required this.primaryUserAr,
    required this.needsNusukData,
    required this.needsScholarApproval,
    required this.risksAr,
    required this.nextActionsAr,
    required this.icon,
  });

  final String id;
  final String titleAr;
  final String layerAr;
  final String stageAr;
  final String statusAr;
  final String primaryUserAr;
  final bool needsNusukData;
  final bool needsScholarApproval;
  final List<String> risksAr;
  final List<String> nextActionsAr;
  final IconData icon;
}

class BetaTestScenario {
  const BetaTestScenario({
    required this.id,
    required this.titleAr,
    required this.personaAr,
    required this.platformsAr,
    required this.stageAr,
    required this.stepsAr,
    required this.expectedResultAr,
    required this.priorityAr,
  });

  final String id;
  final String titleAr;
  final String personaAr;
  final List<String> platformsAr;
  final String stageAr;
  final List<String> stepsAr;
  final String expectedResultAr;
  final String priorityAr;
}
