enum HajjType {
  tamattu,
  qiran,
  ifrad,
}

enum HajjMatrixLayer {
  sharia,
  time,
  place,
  administrative,
  healthSafety,
  education,
  technical,
}

enum HajjImportance {
  rukn,
  wajib,
  sunnah,
  guidance,
  procedure,
}

enum HajjSensitivity {
  normal,
  important,
  critical,
}

enum HajjAppearanceWindow {
  beforeTravel,
  duringHajj,
  afterReturn,
}

enum HajjGenderScope {
  all,
  male,
  female,
}

enum HajjHealthScope {
  all,
  elderly,
  patient,
  disability,
}

enum HajjAppAction {
  openGuide,
  openMap,
  call,
  complaint,
  survey,
  confirmDone,
  alert,
  askAssistant,
}

class HajjTypeInfo {
  const HajjTypeInfo({
    required this.type,
    required this.title,
    required this.intention,
    required this.summary,
    required this.appBehavior,
    required this.requiresHady,
    required this.hasUmrahBeforeHajj,
    required this.hasTahallulBeforeHajj,
  });

  final HajjType type;
  final String title;
  final String intention;
  final String summary;
  final String appBehavior;
  final bool requiresHady;
  final bool hasUmrahBeforeHajj;
  final bool hasTahallulBeforeHajj;
}

class HajjGuideLayer {
  const HajjGuideLayer({
    required this.layer,
    required this.title,
    required this.summary,
    required this.interfaceTitle,
    required this.interfaceDescription,
    required this.items,
  });

  final HajjMatrixLayer layer;
  final String title;
  final String summary;
  final String interfaceTitle;
  final String interfaceDescription;
  final List<String> items;
}

class HajjRitualStageV6 {
  const HajjRitualStageV6({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.locationLabel,
    required this.summary,
    required this.actions,
    required this.layers,
    required this.importance,
    required this.sensitivity,
    required this.appearanceWindow,
    required this.appliesTo,
    required this.appActions,
    this.needsShariaApproval = true,
    this.requiresNusukData = false,
    this.requiresLocation = false,
    this.genderScope = HajjGenderScope.all,
    this.healthScopes = const [HajjHealthScope.all],
    this.warnings = const [],
  });

  final String id;
  final String title;
  final String timeLabel;
  final String locationLabel;
  final String summary;
  final List<String> actions;
  final List<String> warnings;
  final List<HajjMatrixLayer> layers;
  final HajjImportance importance;
  final HajjSensitivity sensitivity;
  final HajjAppearanceWindow appearanceWindow;
  final List<HajjType> appliesTo;
  final List<HajjAppAction> appActions;
  final bool needsShariaApproval;
  final bool requiresNusukData;
  final bool requiresLocation;
  final HajjGenderScope genderScope;
  final List<HajjHealthScope> healthScopes;

  bool appliesToType(HajjType type) => appliesTo.contains(type);
}

class IhramProhibitionGroup {
  const IhramProhibitionGroup({
    required this.title,
    required this.scope,
    required this.items,
  });

  final String title;
  final HajjGenderScope scope;
  final List<String> items;
}

class MiqatInfo {
  const MiqatInfo({
    required this.name,
    required this.forWhom,
    required this.appHint,
  });

  final String name;
  final String forWhom;
  final String appHint;
}
