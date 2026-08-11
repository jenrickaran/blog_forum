import 'package:flutter/material.dart';
import 'package:flutter_app/services/profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileServices = ProfileService();

  Map<String, dynamic>? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _profileServices.getProfile();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
