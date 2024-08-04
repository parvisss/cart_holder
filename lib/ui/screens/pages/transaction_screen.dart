import 'package:card_holder/controller/transactions_controller.dart';
import 'package:card_holder/services/firebase/cart_firestore_service.dart';
import 'package:card_holder/ui/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final toCart = TextEditingController();
  final fromCart = TextEditingController();
  final amountController = TextEditingController();
  String? searchedName;
  String? searchedName2;

  bool canSend = false;

  @override
  void dispose() {
    toCart.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> fetchOwnerName(String cardNumber) async {
    if (cardNumber.length == 16) {
      String ownerName =
          await CartFirestoreService().getCardNameByNumber(cardNumber);
      setState(() {
        searchedName = ownerName;
      });
    } else {
      setState(() {
        searchedName = null;
      });
    }
  }

  Future<void> fetchOwnerName2(String cardNumber) async {
    if (cardNumber.length == 16) {
      String ownerName =
          await CartFirestoreService().getCardNameByNumber(cardNumber);
      setState(() {
        searchedName2 = ownerName;
      });
    } else {
      setState(() {
        searchedName2 = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: fromCart,
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              onChanged: (value) {
                fetchOwnerName2(value);
              },
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: searchedName2 != null
                  ? Text(
                      'Owner: $searchedName2',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox(
                      height: 15,
                    ),
            ),
            TextField(
              controller: toCart,
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              onChanged: (value) {
                fetchOwnerName(value);
              },
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: searchedName != null
                  ? Text(
                      'Owner: $searchedName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox(
                      height: 15,
                    ),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.orange.shade800,
        ),
        onPressed: () async {
          try {
            if (await CartFirestoreService().checkIsAvailible(toCart.text)) {
              if (await TransactionsController().check(
                double.parse(amountController.text),
                fromCart.text,
              )) {
                final ownerId = await CartFirestoreService()
                    .getOwnerIdByNumber(toCart.text);
                await TransactionsController().send(
                  ownerId,
                  double.parse(amountController.text),
                  toCart.text,
                  fromCart.text,
                );

                // Show success dialog
                showCustomDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  title: 'Transaction Successful',
                  content: 'Your transaction was completed successfully.',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              } else {
                // Show dialog for insufficient funds
                showCustomDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  title: 'Transaction Failed',
                  content:
                      'You do not have enough cash to complete this transaction.',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }
            } else {
              // Show dialog for unavailable card
              showCustomDialog(
                // ignore: use_build_context_synchronously
                context: context,
                title: 'Card Not Available',
                content: 'The card number you entered is not available.',
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              );
            }
          } catch (e) {
            // Handle error, possibly with a dialog or another method
            showCustomDialog(
              // ignore: use_build_context_synchronously
              context: context,
              title: 'Error',
              content: 'An unexpected error occurred: $e',
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 15.0),
          child: const Text("Send"),
        ),
      ),
    );
  }
}
