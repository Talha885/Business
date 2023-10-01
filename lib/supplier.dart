import 'package:flutter/material.dart';
import 'package:business/my_textfield.dart';
import 'package:business/additem.dart'; // Import the additem.dart file

class SupplierScreen extends StatefulWidget {
  final String supplierName;

  SupplierScreen(
      {required this.supplierName,
      required gaveAmount,
      required gotAmount,
      required customerName});

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  TextEditingController gaveController = TextEditingController();
  TextEditingController gotController = TextEditingController();

  InventoryItem? selectedInventoryItem;
  List<String> addedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplierName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(
              controller: gaveController,
              hintText: 'Purchase Rs',
              obscureText: false,
              prefixIcon: null,
              label: '',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            MyTextField(
              controller: gotController,
              hintText: 'Payment Rs',
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
                _saveSupplierDetails();
              },
              child: const Text('     SAVE      '),
            ),
          ],
        ),
      ),
    );
  }
}

class _saveSupplierDetails {}
