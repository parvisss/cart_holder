import 'package:card_holder/models/user_model.dart';
import 'package:card_holder/services/firebase/user_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final authServise = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await authServise.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    try {
      await authServise.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserFirestoreService().addNewUser(
        UserModel(
            id: authServise.currentUser!.uid.toString(),
            fullName: fullName,
            cards: [],
            email: email,
            password: password),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await authServise.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUserId() async {
    return authServise.currentUser!.uid.toString();
  }
}
