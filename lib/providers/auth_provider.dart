import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yanapay_app_mobile/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  Timer? _messageTimer;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;
  String? _errorMessage;
  String? _successMessage;
  int? _userId;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int? get userId => _userId;

  // Inicializar el provider verificando si hay sesión activa
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        final userData = await _authService.getUserData();
        _userEmail = userData['email'];
        _userName = userData['name'];
        // También puedes inicializar el userId aquí si lo necesitas
        if (userData['userId'] != null) {
          _userId = int.tryParse(userData['userId'].toString());
        }
      }
    } catch (e) {
      _isLoggedIn = false;
      _userEmail = null;
      _userName = null;
      _userId = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    _messageTimer?.cancel();
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _startMessageTimer() {
    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 5), () {
      _errorMessage = null;
      notifyListeners();
    });
  }

  // Manejar respuesta exitosa (tanto login como registro)
  void _handleSuccess(Map<String, dynamic> userData, bool isLogin) {
    _isLoggedIn = true;
    _userEmail = userData['email'];
    _userName = '${userData['firstName']} ${userData['lastName']}';
    _userId = userData['userId'] ?? userData['id'];

    if (_userId is! int && _userId != null) {
      _userId = int.tryParse(_userId.toString());
    }

    if (isLogin) {
      _successMessage = '¡Bienvenido de vuelta, ${userData['firstName']}!';
    } else {
      _successMessage =
      '¡Bienvenido a Yanapay, ${userData['firstName']}! Tu cuenta ha sido creada exitosamente.';
    }
  }

  // Manejar respuesta de error
  void _handleError(String? error) {
    _errorMessage = error ?? 'Error desconocido';
    _startMessageTimer();
  }

  // Iniciar sesión
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      _isLoading = false;

      if (result['success']) {
        _handleSuccess(result['data'], true);
        notifyListeners();
        return true;
      } else {
        _handleError(result['error']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _handleError(
          'Error de conexión. Verifica tu internet e intenta nuevamente.');
      notifyListeners();
      return false;
    }
  }

  // Registrar usuario
  Future<bool> register(
      String firstName, String lastName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      print('Respuesta del backend: ${result['data']}');

      _isLoading = false;

      if (result['success']) {
        _handleSuccess(result['data'], false);
        notifyListeners();
        return true;
      } else {
        _handleError(result['error']);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _handleError(
          'Error de conexión. Verifica tu internet e intenta nuevamente.');
      notifyListeners();
      return false;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _isLoggedIn = false;
      _userEmail = null;
      _userName = null;
      _userId = null;
    } catch (e) {
      // Error silencioso para logout
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }
}