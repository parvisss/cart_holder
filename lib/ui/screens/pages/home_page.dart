import 'package:card_holder/models/cart_model.dart';
import 'package:card_holder/services/firebase/cart_firestore_service.dart';
import 'package:card_holder/ui/widgets/cart_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CartFirestoreService().getUserCarts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<Widget> cards = snapshot.data!.docs.map((doc) {
            final cart = CartModel.fromMap(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>);
            return CartItemWidget(
              cardNumber: '•••• ${cart.id.substring(cart.id.length - 4)}',
              amount: '£${cart.balance.toString()}',
              expiryDate: cart.expiryDate,
              cardType: cart.cartType,
            );
          }).toList();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: cards,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transactions',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          ListTile(
                            leading: Icon(Icons.settings, size: 30),
                            title: Text('Figma'),
                            subtitle: Text('15 Dec, 5:00 PM'),
                            trailing: Text('£149.50'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No cards available'));
        }
      },
    );
  }
}
