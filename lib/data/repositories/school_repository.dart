import '../models/driving_school_model.dart';
import '../../services/storage_service.dart';

/// In a production build, replace the in-memory list below with real API
/// calls (fetch nearby schools, submit contribution, poll status).
/// The free/paid submission rule and moderation states live here so the
/// UI layer never has to know about pricing or backend details.
class SchoolRepository {
  SchoolRepository._();
  static final SchoolRepository instance = SchoolRepository._();

  final List<DrivingSchoolModel> _schools = [];

  Future<List<DrivingSchoolModel>> getApprovedNearby({
    required double lat,
    required double lng,
  }) async {
    return _schools.where((s) => s.status == SchoolStatus.approved).toList();
  }

  Future<List<DrivingSchoolModel>> getMyContributions(String userId) async {
    return _schools.where((s) => s.contributorId == userId).toList();
  }

  /// Returns true if this submission requires payment (i.e. the user has
  /// already used their one free contribution).
  Future<bool> requiresPayment() async {
    return StorageService.instance.hasUsedFreeSchoolSubmission();
  }

  Future<void> submit(DrivingSchoolModel school, {required bool paid}) async {
    _schools.add(school.copyWithStatus(SchoolStatus.pending, wasPaid: paid));
    if (!paid) {
      await StorageService.instance.markFreeSchoolSubmissionUsed();
    }
    // TODO: POST to backend moderation queue here.
  }

  /// Called by moderation backend/webhook in production. If a PAID
  /// submission is rejected, refund or grant a free retry token instead
  /// of silently keeping the fee — see project notes on trust.
  Future<void> updateStatus(String schoolId, SchoolStatus status, {String? reason}) async {
    final index = _schools.indexWhere((s) => s.id == schoolId);
    if (index == -1) return;
    _schools[index] = _schools[index].copyWithStatus(status, reason: reason);
  }
}

extension on DrivingSchoolModel {
  DrivingSchoolModel copyWithStatus(SchoolStatus status, {String? reason, bool? wasPaid}) {
    return DrivingSchoolModel(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      fees: fees,
      timing: timing,
      photoUrl: photoUrl,
      contributorId: contributorId,
      contributorName: contributorName,
      status: status,
      rejectionReason: reason ?? rejectionReason,
      viewCount: viewCount,
      wasPaidSubmission: wasPaid ?? wasPaidSubmission,
    );
  }
}
