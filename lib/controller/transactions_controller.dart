import 'package:card_holder/services/firebase/firebase_auth_service.dart';
import 'package:card_holder/services/firebase/transaction_history_service.dart';
import 'package:card_holder/services/firebase/user_firestore_service.dart';

class TransactionsController {
  Future<bool> check(double selectedamount, String senderCardNumber) async {
    double currentBalance =
        await UserFirestoreService().getCurrnetUserBalance(senderCardNumber);
    if (selectedamount <= currentBalance) {
      return true;
    }
    return false;
  }

  Future<void> send(String reciverId, double amountToRecive, String reciverCart,
      String senderCart) async {
    double reciverBalance =
        await UserFirestoreService().getUserBlance(reciverId, reciverCart);
    //reciver current balance
    //
    await UserFirestoreService()
        .reciveCash(reciverId, reciverBalance, amountToRecive, reciverCart);
    //changing recivers balance
    //
    final userId = await FirebaseAuthService().getUserId();
    //current user id
    //
    double senderBalance =
        await UserFirestoreService().getUserBlance(userId, senderCart);
    // sender current balance
    //
    await UserFirestoreService()
        .sendCash(userId, senderBalance, amountToRecive, senderCart);
    //
    // sending
    await TransactionHistoryService().addToHistory(
        amountToRecive.toString(), reciverId, senderCart, reciverCart);
  }
}
