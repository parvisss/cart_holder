import 'package:flutter/material.dart';
import 'package:card_holder/models/cart_model.dart';
import 'package:card_holder/services/firebase/cart_firestore_service.dart';
import 'package:card_holder/services/firebase/firebase_auth_service.dart';

class AddCardDialog extends StatelessWidget {
  final TextEditingController numberController;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController dateController;
  final Function onCardAdded;

  const AddCardDialog({
    Key? key,
    required this.numberController,
    required this.nameController,
    required this.typeController,
    required this.dateController,
    required this.onCardAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Card'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Card Type'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Expiry Date'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final userId = await FirebaseAuthService().getUserId();
              await CartFirestoreService().addNewCartForUser(
                CartModel(
                  ownerId: userId,
                  cartType: typeController.text,
                  balance: 10000,
                  expiryDate: dateController.text,
                  fullName: nameController.text,
                  id: numberController.text,
                ),
              );

              // Call the callback function on successful card addition
              onCardAdded();

              // Show snackbar on success
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Card added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              // Show snackbar on failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to add card: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('Add Card'),
        ),
      ],
    );
  }
}
