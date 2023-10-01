// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:business/additem.dart';
import 'package:business/item_out.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:business/item_in.dart';

class ItemInfoScreen extends StatelessWidget {
  final InventoryItem inventoryItem;
  final List<Contact> suppliers;

  ItemInfoScreen({required this.inventoryItem, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Item Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 14,
          ),
          Center(
            child: Container(
              width: 400,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(
                left: 24,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '10 (pcs)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 205, 126, 7),
                    ),
                  ),
                  SizedBox(
                      height: 4), // Add spacing between the two Text widgets
                  Text(
                    'Stock In Hand',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          const Text(
            '__________________________________________________________________________',
            style: TextStyle(color: Color.fromARGB(255, 220, 208, 208)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Add horizontal padding
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search), // Use the Icon widget
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 8), // Add space below the search bar
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Text(
                'Entries',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 240), // Add space between the text widgets
              Text(
                'In',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 60), // Add space between the text widgets
              Text(
                'Out',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Row(
            children: [
              Text(
                '__________________________________________________________________________',
                style: TextStyle(color: Color.fromARGB(255, 220, 208, 208)),
              ),
            ],
          ),
          const SizedBox(
            height: 530,
          ),
          const Row(
            children: [
              Text(
                '__________________________________________________________________________',
                style: TextStyle(color: Color.fromARGB(255, 220, 208, 208)),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemInScreen(suppliers: suppliers),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'IN/BUY',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemOutScreen(suppliers: suppliers),
                  ),
                );
              },
              icon: const Icon(Icons.remove, color: Colors.white),
              label: const Text(
                'OUT/SELL',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
