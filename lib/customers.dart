// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:business/my_textfield.dart';
import 'package:business/additem.dart';

class CustomersScreen extends StatefulWidget {
  final String customerName;

  CustomersScreen(
      {required this.customerName, required gaveAmount, required gotAmount});

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  TextEditingController gaveController = TextEditingController();
  TextEditingController gotController = TextEditingController();

  InventoryItem? selectedInventoryItem;
  List<String> addedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(
              controller: gaveController,
              hintText: 'You Gave Rs',
              obscureText: false,
              prefixIcon: null,
              label: '',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: gotController,
              hintText: 'You Got Rs',
              obscureText: false,
              prefixIcon: null,
              label: '',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                InventoryItem? newItem = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(),
                  ),
                );


            

                if (newItem != null) {
                  setState(() {
                    selectedInventoryItem = newItem;
                  });
                }
              },
              child: const Text('ADD ITEM'),
            ),
            if (selectedInventoryItem != null)
              ListTile(
                title: Text(selectedInventoryItem!.itemName),
                subtitle: Text(
                  'Unit Rate (Sale): \$${selectedInventoryItem!.unitRateSale.toStringAsFixed(2)}',
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: addedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addedItems[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveCustomerDetails(); // Call the new save method
              },
              child: const Text('     SAVE      '),
            ),
          ],
        ),
      ),
    );
  }
}

class _saveCustomerDetails {}
