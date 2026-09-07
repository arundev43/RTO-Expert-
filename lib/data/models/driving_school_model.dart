enum SchoolStatus { pending, approved, rejected, flagged }

class DrivingSchoolModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? fees;
  final String? timing;
  final String? photoUrl;
  final String contributorId;
  final String contributorName;
  final SchoolStatus status;
  final String? rejectionReason;
  final int viewCount;
  final bool wasPaidSubmission;

  const DrivingSchoolModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.fees,
    this.timing,
    this.photoUrl,
    required this.contributorId,
    required this.contributorName,
    this.status = SchoolStatus.pending,
    this.rejectionReason,
    this.viewCount = 0,
    this.wasPaidSubmission = false,
  });

  factory DrivingSchoolModel.fromJson(Map<String, dynamic> json) => DrivingSchoolModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        phone: json['phone'] as String,
        fees: json['fees'] as String?,
        timing: json['timing'] as String?,
        photoUrl: json['photoUrl'] as String?,
        contributorId: json['contributorId'] as String,
        contributorName: json['contributorName'] as String,
        status: SchoolStatus.values.byName(json['status'] as String? ?? 'pending'),
        rejectionReason: json['rejectionReason'] as String?,
        viewCount: json['viewCount'] as int? ?? 0,
        wasPaidSubmission: json['wasPaidSubmission'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'fees': fees,
        'timing': timing,
        'photoUrl': photoUrl,
        'contributorId': contributorId,
        'contributorName': contributorName,
        'status': status.name,
        'rejectionReason': rejectionReason,
        'viewCount': viewCount,
        'wasPaidSubmission': wasPaidSubmission,
      };
}
