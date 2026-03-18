import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => pb.authStore.isValid;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await pb.collection('users').authWithPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ClientException catch (e) {
      _errorMessage = "Email ou mot de passe incorrect.";
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Une erreur est survenue.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final body = <String, dynamic>{
        "email": email,
        "password": password,
        "passwordConfirm": password,
      };

      await pb.collection('users').create(body: body);
      // Auto-login after successful registration
      await login(email, password);
      
      _isLoading = false;
      return true;
    } on ClientException catch (e) {
      _errorMessage = e.response['message'] ?? "Erreur lors de l'inscription.";
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Une erreur est survenue.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    pb.authStore.clear();
    notifyListeners();
  }
}
