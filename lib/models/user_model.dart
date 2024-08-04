import 'cart_model.dart';

class UserModel {
  String id;
  String fullName;
  String email;
  String password;
  List<CartModel> cards;
  UserModel({
    required this.id,
    required this.fullName,
    required this.cards,
    required this.email,
    required this.password,
  });
}
