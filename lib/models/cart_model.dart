import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String id;
  String fullName;
  double balance;
  String expiryDate;
  String cartType;
  String ownerId;
  CartModel({
    required this.ownerId,
    required this.cartType,
    required this.balance,
    required this.expiryDate,
    required this.fullName,
    required this.id,
  });

  factory CartModel.fromMap(QueryDocumentSnapshot query) {
    return CartModel(
      ownerId: query["ownerId"],
      cartType: query['cartType'],
      balance: query['balance'],
      expiryDate: query['expiryDate'],
      fullName: query['fullName'],
      id: query['id'],
    );
  }
}
