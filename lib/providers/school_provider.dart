import 'package:flutter/material.dart';
import '../data/models/driving_school_model.dart';
import '../data/repositories/school_repository.dart';

class SchoolProvider extends ChangeNotifier {
  List<DrivingSchoolModel> nearbySchools = [];
  List<DrivingSchoolModel> myContributions = [];
  bool isLoading = false;

  Future<void> loadNearby({required double lat, required double lng}) async {
    isLoading = true;
    notifyListeners();
    nearbySchools = await SchoolRepository.instance.getApprovedNearby(lat: lat, lng: lng);
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMyContributions(String userId) async {
    myContributions = await SchoolRepository.instance.getMyContributions(userId);
    notifyListeners();
  }

  Future<bool> nextSubmissionRequiresPayment() =>
      SchoolRepository.instance.requiresPayment();

  Future<void> submit(DrivingSchoolModel school, {required bool paid}) async {
    await SchoolRepository.instance.submit(school, paid: paid);
    notifyListeners();
  }
}
