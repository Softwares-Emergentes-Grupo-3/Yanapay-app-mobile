import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  // URL base de la API de autenticación
  static const String _baseUrl = 'http://172.203.140.239:8081/api/v1/auth';

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  Future<void> verifyUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    print('User ID guardado: $userId');
  }

  // Guardar sesión
  Future<void> saveSession({
    required String email,
    required String name,
    String? token,
    int? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setBool(_isLoggedInKey, true);

    if (token != null) {
      await prefs.setString(_tokenKey, token);
    }

    if (userId != null) {
      await prefs.setInt('userId', userId);
    }
  }

  // Verificar si hay sesión activa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Obtener datos del usuario
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_userEmailKey),
      'name': prefs.getString(_userNameKey),
      'token': prefs.getString(_tokenKey),
      'userId': prefs.getString(_userIdKey),
    };
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Limpiar todos los datos
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Traducir mensajes de error del backend
  String _translateErrorMessage(String message) {
    final translations = {
      'Email is not registered or password is incorrect.':
      'El correo no está registrado o la contraseña es incorrecta.',
      'Email is not registered or password is incorrect':
      'El correo no está registrado o la contraseña es incorrecta.',
      'Invalid credentials': 'Credenciales inválidas',
      'User already exists': 'Ya existe una cuenta con este correo electrónico',
      'Email already registered': 'El correo ya está registrado',
      'Email already exists':
      'Ya existe una cuenta con este correo electrónico',
      'User with this email already exists':
      'Ya existe una cuenta con este correo electrónico',
      'Password too weak': 'La contraseña es muy débil',
      'Invalid email format': 'Formato de correo inválido',
      'Server error': 'Error del servidor',
      'Network error': 'Error de conexión',
      'Bad Request': 'Solicitud incorrecta',
      'Unauthorized': 'No autorizado',
      'Forbidden': 'Acceso denegado',
      'Not Found': 'Recurso no encontrado',
      'Internal Server Error': 'Error interno del servidor',
    };

    // Buscar traducciones exactas primero
    if (translations.containsKey(message)) {
      return translations[message]!;
    }

    // Buscar patrones específicos en el mensaje
    String lowerMessage = message.toLowerCase();

    // Manejar mensajes como "User with email xxx already exists"
    if (lowerMessage.contains('user with email') &&
        lowerMessage.contains('already exists')) {
      return 'Ya existe una cuenta con este correo electrónico';
    }

    // Buscar traducciones parciales
    if (lowerMessage.contains('email') && lowerMessage.contains('exist')) {
      return 'Ya existe una cuenta con este correo electrónico';
    } else if (lowerMessage.contains('user') &&
        lowerMessage.contains('exist')) {
      return 'Ya existe una cuenta con este correo electrónico';
    } else if (lowerMessage.contains('password') &&
        lowerMessage.contains('incorrect')) {
      return 'La contraseña es incorrecta';
    } else if (lowerMessage.contains('not registered')) {
      return 'El correo no está registrado';
    } else if (lowerMessage.contains('invalid') &&
        lowerMessage.contains('credential')) {
      return 'Credenciales inválidas';
    } else if (lowerMessage.contains('connection')) {
      return 'Error de conexión';
    } else if (lowerMessage.contains('network')) {
      return 'Error de red';
    } else if (lowerMessage.contains('timeout')) {
      return 'Tiempo de espera agotado';
    }

    return message;
  }

  // Registrar usuario con API
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro exitoso - normalizar estructura de datos

        final rawUserId = data['userId'] ?? data['id'] ?? data['user_id'];
        final userId = rawUserId is int ? rawUserId : int.tryParse(rawUserId.toString()) ?? 0;

        final normalizedData = {
          'userId': data['userId'] ?? data['id'] ?? data['user_id'],
          'email': data['email'] ?? data['userEmail'],
          'firstName': data['firstName'] ?? data['first_name'] ?? data['name'],
          'lastName': data['lastName'] ?? data['last_name'] ?? '',
        };

        // Guardar sesión
        await saveSession(
          email: normalizedData['email'],
          name: '${normalizedData['firstName']} ${normalizedData['lastName']}',
          userId: normalizedData['userId'],
        );

        return {
          'success': true,
          'data': normalizedData,
        };
      } else {
        // Error en el registro
        String errorMessage = 'Error en el registro';
        if (data['message'] != null) {
          errorMessage = _translateErrorMessage(data['message']);
        } else if (data['error'] != null) {
          errorMessage = _translateErrorMessage(data['error']);
        } else if (data['msg'] != null) {
          errorMessage = _translateErrorMessage(data['msg']);
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión. Verifica tu internet.',
      };
    }
  }

  // Iniciar sesión con API
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login exitoso - normalizar estructura de datos

        final rawUserId = data['userId'] ?? data['id'] ?? data['user_id'];
        final userId = rawUserId is int ? rawUserId : int.tryParse(rawUserId.toString()) ?? 0;

        final normalizedData = {
          'userId': data['userId'] ?? data['id'] ?? data['user_id'],
          'email': data['email'] ?? data['userEmail'],
          'firstName': data['firstName'] ?? data['first_name'] ?? data['name'],
          'lastName': data['lastName'] ?? data['last_name'] ?? '',
        };

        // Guardar sesión
        await saveSession(
          email: normalizedData['email'],
          name: '${normalizedData['firstName']} ${normalizedData['lastName']}',
          userId: normalizedData['userId'],
        );

        return {
          'success': true,
          'data': normalizedData,
        };
      } else {
        // Error en el login
        String errorMessage = 'Credenciales inválidas';
        if (data['message'] != null) {
          errorMessage = _translateErrorMessage(data['message']);
        } else if (data['error'] != null) {
          errorMessage = _translateErrorMessage(data['error']);
        } else if (data['msg'] != null) {
          errorMessage = _translateErrorMessage(data['msg']);
        }

        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión. Verifica tu internet.',
      };
    }
  }
}