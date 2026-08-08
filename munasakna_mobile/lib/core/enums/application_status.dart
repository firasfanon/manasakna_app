enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  accepted,
  rejected,
  needsUpdate,
  confirmed,
  paid,
  readyToTravel,
  departed,
  completed,
  cancelled,
}

extension ApplicationStatusLabel on ApplicationStatus {
  String get labelAr {
    return switch (this) {
      ApplicationStatus.draft => 'مسودة',
      ApplicationStatus.submitted => 'مقدم',
      ApplicationStatus.underReview => 'قيد المراجعة',
      ApplicationStatus.accepted => 'مقبول',
      ApplicationStatus.rejected => 'مرفوض',
      ApplicationStatus.needsUpdate => 'بحاجة لتحديث',
      ApplicationStatus.confirmed => 'تم التأكيد',
      ApplicationStatus.paid => 'تم الدفع',
      ApplicationStatus.readyToTravel => 'جاهز للسفر',
      ApplicationStatus.departed => 'مغادر',
      ApplicationStatus.completed => 'مكتمل',
      ApplicationStatus.cancelled => 'ملغى',
    };
  }
}
