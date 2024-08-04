import 'package:card_holder/ui/widgets/add_cart.dart';
import 'package:flutter/material.dart';
import 'package:card_holder/ui/screens/pages/history_page.dart';
import 'package:card_holder/ui/screens/pages/home_page.dart';
import 'package:card_holder/ui/screens/pages/transaction_screen.dart';
import 'package:card_holder/services/firebase/firebase_auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final typeController = TextEditingController();
  final numberController = TextEditingController();

  final List<Widget> _screens = [
    const HomePage(),
    const TransactionScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCardDialog(
          numberController: numberController,
          nameController: nameController,
          typeController: typeController,
          dateController: dateController,
          onCardAdded: () {
            // Refresh the UI or perform any other necessary actions
            print('Card added successfully!');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Carts"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCardDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await FirebaseAuthService().logout();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.orange.shade800,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: const IconThemeData(size: 40),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
    );
  }
}
