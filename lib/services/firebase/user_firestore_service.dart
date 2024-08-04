import 'package:card_holder/models/user_model.dart';
import 'package:card_holder/services/firebase/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final firestore = FirebaseFirestore.instance;

  Future<void> addNewUser(UserModel user) async {
    await firestore.collection("users").doc(user.id.toString()).update(
      {
        "id": user.id,
        'fullName': user.fullName,
        'password': user.password,
        'email': user.email,
      },
    );
  }

  Future getCurrentUserData() async {
    try {
      String userId = await FirebaseAuthService().getUserId();
      return firestore.collection('users').doc(userId).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getUserBlance(String id, String cardNumber) async {
    try {
      final cart = await firestore
          .collection('users')
          .doc(id)
          .collection("carts")
          .doc(cardNumber.toString())
          .get();

      var balance = cart["balance"];
      if (balance is String) {
        balance = double.parse(balance); // Convert String to double if needed
      }
      return balance; // Return as double
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reciveCash(String reciverId, double reciverBalance,
      double amount, String reciverCart) async {
    double total = reciverBalance + amount;
    try {
      await firestore
          .collection('users')
          .doc(reciverId)
          .collection("carts")
          .doc(reciverCart.toString())
          .update({"balance": total}); // Ensure total is a double
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendCash(String senderId, double senderBalance, double amount,
      String senderCart) async {
    double total = senderBalance - amount;
    try {
      await firestore
          .collection('users')
          .doc(senderId)
          .collection("carts")
          .doc(senderCart.toString())
          .update({"balance": total}); // Ensure total is a double
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getCurrnetUserBalance(String senderCartNumber) async {
    String userId = await FirebaseAuthService().getUserId();
    try {
      final cart = await firestore
          .collection('users')
          .doc(userId)
          .collection("carts")
          .doc(senderCartNumber.toString())
          .get();

      // Check if the balance is already a double or needs parsing
      var balance = cart["balance"];
      if (balance is String) {
        balance = double.parse(balance); // Convert String to double if needed
      }
      return balance; // Return as double
    } catch (e) {
      rethrow;
    }
  }
}
