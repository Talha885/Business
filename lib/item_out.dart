import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ItemOutScreen extends StatefulWidget {
  final List<Contact> suppliers;

  ItemOutScreen({Key? key, required this.suppliers}) : super(key: key);

  @override
  _ItemOutScreenState createState() => _ItemOutScreenState();
}

class _ItemOutScreenState extends State<ItemOutScreen> {
  TextEditingController searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _pickedImages = [];
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void updateAmount() {
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    double amount = quantity * rate;
    _amountController.text = amount.toStringAsFixed(2);
  }

  Widget _buildPartySelectionPopup() {
    return AlertDialog(
      title: const Text('Select Party'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search party...',
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.suppliers.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = widget.suppliers[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(contact.displayName ?? ''),
                  subtitle: Text(contact.phones?.first.value ?? ''),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle the selected contact here
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        _pickedImages.add(File(pickedImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Item IN/BUY'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Rate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: Colors.white,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _quantityController,
                        onChanged: (value) {
                          updateAmount(); // Update the amount when quantity changes
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter quantity',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                    height: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: Colors.white,
                      ),
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: _rateController,
                        onChanged: (value) {
                          setState(() {
                            updateAmount(); // Update the amount when rate changes
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter rate',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        readOnly: true, // Make the amount field read-only
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: Colors.white,
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                      onPressed: _takePicture,
                      icon: const Icon(Icons.camera_alt)),
                  const SizedBox(width: 8),
                  for (File image in _pickedImages)
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.file(image),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 0.5),
                        color: Colors.white,
                      ),
                      child: const TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter bill no.',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 390,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 0.5),
                      color: Colors.white,
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildPartySelectionPopup();
                          },
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text('Select party'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 450),
              ElevatedButton(
                onPressed: () {
                  // Add your logic to save the data here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Set the background color of the button
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
