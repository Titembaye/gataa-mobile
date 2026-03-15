import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
// ─── Modèle utilisateur ───────────────────────────────────────────────────────

class UserModel {
  final int id;
  final String email;
  final String name;
  final String? avatar;
  final int totalSubmissions;
  final int validatedCount;
  final double reputationScore;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.totalSubmissions = 0,
    this.validatedCount = 0,
    this.reputationScore = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      totalSubmissions: json['total_submissions'] ?? 0,
      validatedCount: json['validated_count'] ?? 0,
      reputationScore: (json['reputation_score'] as num?)?.toDouble() ?? 0,
    );
  }
}

// ─── Service Auth ─────────────────────────────────────────────────────────────

class AuthService extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user_email';
  static const String _userNameKey = 'auth_user_name';
  
  final gsi.GoogleSignIn _googleSignIn = gsi.GoogleSignIn.instance;


  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null && _currentUser != null;

  // Initialiser depuis le stockage local
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    final email = prefs.getString(_userKey);
    final name = prefs.getString(_userNameKey);

    if (_token != null && email != null && name != null) {
      _currentUser = UserModel(
        id: 0,
        email: email,
        name: name,
      );
    }
    notifyListeners();
  }

  // ─── Inscription email ────────────────────────────────────────────────────

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO : remplacer par appel API réel
      // POST /api/v1/mobile/auth/register/
      await Future.delayed(const Duration(seconds: 1));

      // Simuler réponse API
      const fakeToken = 'fake_jwt_token_register';
      final user = UserModel(id: 1, email: email, name: name);

      await _saveSession(token: fakeToken, user: user);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.error('Erreur lors de l\'inscription.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Connexion email ──────────────────────────────────────────────────────

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO : remplacer par appel API réel
      // POST /api/v1/mobile/auth/login/
      await Future.delayed(const Duration(seconds: 1));

      const fakeToken = 'fake_jwt_token_login';
      final user = UserModel(id: 1, email: email, name: email.split('@')[0]);

      await _saveSession(token: fakeToken, user: user);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.error('Email ou mot de passe incorrect.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────

  Future<AuthResult> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      await gsi.GoogleSignIn.instance.initialize();
      final googleUser = await gsi.GoogleSignIn.instance.authenticate();

      // TODO : envoyer googleUser.authentication.idToken à l'API
      await Future.delayed(const Duration(milliseconds: 500));

      const fakeToken = 'fake_jwt_token_google';
      final user = UserModel(
        id: 2,
        email: googleUser.email,
        name: googleUser.displayName ?? googleUser.email,
        avatar: googleUser.photoUrl,
      );

      await _saveSession(token: fakeToken, user: user);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.error('Erreur Google Sign-In.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Déconnexion ──────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_userNameKey);
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  // ─── Helpers privés ───────────────────────────────────────────────────────

  Future<void> _saveSession({
    required String token,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, user.email);
    await prefs.setString(_userNameKey, user.name);
    _token = token;
    _currentUser = user;
  }
}

// ─── Résultat Auth ────────────────────────────────────────────────────────────

class AuthResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;

  const AuthResult._({
    required this.isSuccess,
    required this.isCancelled,
    this.errorMessage,
  });

  static const AuthResult success = AuthResult._(
    isSuccess: true,
    isCancelled: false,
  );

  static const AuthResult cancelled = AuthResult._(
    isSuccess: false,
    isCancelled: true,
  );

  static AuthResult error(String message) => AuthResult._(
    isSuccess: false,
    isCancelled: false,
    errorMessage: message,
  );
}