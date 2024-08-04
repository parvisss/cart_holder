import 'package:card_holder/services/firebase/transaction_history_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: TransactionHistoryService().getHistoryData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final history = snapshot.data!.docs;
          if (history.isEmpty) {
            return const Center(
              child: Text('No transactions found.'),
            );
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (ctx, index) {
              final transaction = history[index];

              final amount = double.tryParse(transaction["amount"]) ?? 0.0;
              final cart = transaction["cart"];

              final date = DateTime.parse(transaction.id);
              final formattedDate = DateFormat.yMMMd().add_jm().format(date);

              return Card(
                color: amount >= 0 ? Colors.green[50] : Colors.red[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    'Cart: $cart',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          amount >= 0
                              ? "+\$${amount.toStringAsFixed(2)}"
                              : "-\$${amount.abs().toStringAsFixed(2)}",
                          style: TextStyle(
                            color: amount >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Date: $formattedDate',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: amount >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
