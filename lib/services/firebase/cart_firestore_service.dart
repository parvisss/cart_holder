import 'package:card_holder/models/cart_model.dart';
import 'package:card_holder/services/firebase/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartFirestoreService {
  final firestore = FirebaseFirestore.instance;

  Future<void> addNewCartForUser(CartModel cart) async {
    String userID = await FirebaseAuthService().getUserId();

    await firestore
        .collection("users")
        .doc(userID.toString())
        .collection("carts")
        .doc(cart.id)
        .set({
      "cartType": cart.cartType,
      "balance": cart.balance,
      "expiryDate": cart.expiryDate,
      "fullName": cart.fullName,
      "id": cart.id,
      'ownerId': cart.ownerId,
    });
    _addNewCartForData(cart);
  }

  Future<void> _addNewCartForData(CartModel cart) async {
    await firestore.collection("carts").doc(cart.id).set(
      {
        "cartType": cart.cartType,
        "expiryDate": cart.expiryDate,
        "fullName": cart.fullName,
        "id": cart.id,
        'ownerId': cart.ownerId,
      },
    );
  }

  Stream<QuerySnapshot> getUserCarts() async* {
    String userID = await FirebaseAuthService().getUserId();

    yield* firestore
        .collection("users")
        .doc(userID)
        .collection("carts")
        .snapshots();
  }

  Stream<QuerySnapshot> getAllCarts() async* {
    yield* firestore.collection("carts").snapshots();
  }

  Future<String> getCardNameByNumber(String cardNumber) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection("carts").doc(cardNumber).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        return data['fullName'] ?? 'Unknown Owner';
      } else {
        return "No matching card found";
      }
    } catch (e) {
      return "Error occurred";
    }
  }

  Future<String> getOwnerIdByNumber(String cardNumber) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection("carts").doc(cardNumber).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        return data['ownerId'] ?? 'Unknown Owner';
      } else {
        return "No matching card found";
      }
    } catch (e) {
      return "Error occurred";
    }
  }

  Future<bool> checkIsAvailible(String cardNumber) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection("carts").doc(cardNumber).get();
      if (docSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
