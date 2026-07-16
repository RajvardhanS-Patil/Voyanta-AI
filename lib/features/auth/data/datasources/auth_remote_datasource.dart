import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(
    String email,
    String password, {
    String? name,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user) : null;
    });
  }

  @override
  UserModel? get currentUser {
    final user = _supabaseClient.auth.currentUser;
    return user != null ? UserModel.fromSupabaseUser(user) : null;
  }

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Login failed: No user returned.');
    }
    return UserModel.fromSupabaseUser(response.user!);
  }

  @override
  Future<UserModel> registerWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
    if (response.user == null) {
      throw Exception('Registration failed: No user returned.');
    }
    return UserModel.fromSupabaseUser(response.user!);
  }

  @override
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }
}
