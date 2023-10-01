import 'package:flutter/material.dart';
import 'package:business/homepage.dart';
import 'package:business/my_textfield.dart';

class AddItemScreen extends StatelessWidget {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController unitRateSaleController = TextEditingController();
  final TextEditingController ratePurchaseController = TextEditingController();

  AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Item',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: itemNameController,
              hintText: 'Item Name',
              obscureText: false,
              prefixIcon: null,
              label: 'Item Name',
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: unitRateSaleController,
              hintText: 'Unit Rate (Sale)',
              obscureText: false,
              prefixIcon: null,
              label: 'Unit Rate (Sale)',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: ratePurchaseController,
              hintText: 'Rate (Purchase)',
              obscureText: false,
              prefixIcon: null,
              label: 'Rate (Purchase)',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String itemName = itemNameController.text;
                itemName = itemName[0].toUpperCase() +
                    itemName.substring(1); // Capitalize the first letter
                double unitRateSale =
                    double.tryParse(unitRateSaleController.text) ?? 0.0;
                double ratePurchase =
                    double.tryParse(ratePurchaseController.text) ?? 0.0;

                InventoryItem newItem = InventoryItem(
                  itemName: itemName,
                  unitRateSale: unitRateSale,
                  ratePurchase: ratePurchase,
                );

                Navigator.pop(context, newItem);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 160, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ADD ITEM',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryItem {
  final String itemName;
  final double unitRateSale;
  final double ratePurchase;

  InventoryItem({
    required this.itemName,
    required this.unitRateSale,
    required this.ratePurchase,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Business App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        businessName: 'My Business',
        phoneNumber: '123-456-7890',
        address: '123 Main St, City',
        profileImage: null,
      ),
    );
  }
}
