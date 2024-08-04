import 'package:card_holder/services/firebase/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionHistoryService {
  final firebase = FirebaseFirestore.instance;

  Future<void> addToHistory(
      String amount, String reciverId, senderCard, reciverCard) async {
    await firebase
        .collection("users")
        .doc(reciverId)
        .collection("history")
        .doc(DateTime.now().toString())
        .set({"amount": "+$amount", "cart": "$senderCard"});
    final userId = await FirebaseAuthService().getUserId();
    await firebase
        .collection("users")
        .doc(userId)
        .collection("history")
        .doc(DateTime.now().toString())
        .set({
      "amount": "-$amount",
      "cart": "$reciverCard",
    });
  }

  Stream<QuerySnapshot> getHistoryData() async* {
    final userId = await FirebaseAuthService().getUserId();

    yield* firebase
        .collection("users")
        .doc(userId)
        .collection("history")
        .snapshots();
  }
}
