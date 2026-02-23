import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cart = [];

  final List<Map<String, dynamic>> products = [
    {"emoji": "👕", "name": "Classic T-Shirt", "price": 30.0},
    {"emoji": "👟", "name": "Running Shoes", "price": 80.0},
    {"emoji": "⌚", "name": "Smart Watch", "price": 120.0},
    {"emoji": "🎧", "name": "Headphones", "price": 150.0},
  ];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product["name"]} added to cart"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.length.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product["emoji"], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                Text(product["name"]),
                Text("\$${product["price"]}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => addToCart(product),
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
