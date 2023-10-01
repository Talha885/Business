// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:business/additem.dart';
import 'package:business/customers.dart';
import 'package:business/iteminfo.dart';
import 'package:business/supplier.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:business/profile.dart';
// Import other required pages as well

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final String businessName;
  final String phoneNumber;
  final String address;
  final File? profileImage;

  HomePage({
    required this.businessName,
    required this.phoneNumber,
    required this.address,
    required this.profileImage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalItems = 0;
  TextEditingController searchController = TextEditingController();
  String? selectedItem;
  List<InventoryItem> inventoryItems = [];
  Map<String, List<Contact>?> selectedContacts = {
    'Customers': [],
    'Suppliers': [],
  };

  void addItem(InventoryItem newItem) {
    setState(() {
      inventoryItems.add(newItem);
    });
  }

  void removeItem(int index) {
    setState(() {
      inventoryItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.businessName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(widget.profileImage!),
                          )
                        : const Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.white,
                          ),
                    const SizedBox(height: 10),
                    Text(
                      widget.businessName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        businessName: widget.businessName,
                        phoneNumber: widget.phoneNumber,
                        address: widget.address,
                        profileImage: widget.profileImage,
                      ),
                    ),
                  );
                },
              ),
              // ... Other drawer items ...
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 73, 203, 199),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Customers'),
                  Tab(text: 'Suppliers'),
                  Tab(text: 'Inventory'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromARGB(135, 20, 1, 1),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCustomersTab(context),
                  _buildSuppliersTab(context),
                  _buildInventoryTab(context, inventoryItems)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addContact(String tabName, BuildContext context) async {
    if (await _requestContactPermission()) {
      Iterable<Contact>? contacts = await ContactsService.getContacts();
      List<Contact>? selectedContactsList =
          await _selectContacts(context, contacts);
      if (selectedContactsList != null && selectedContactsList.isNotEmpty) {
        setState(() {
          selectedContacts[tabName]?.addAll(selectedContactsList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${selectedContactsList.length} contacts added as $tabName'),
          ),
        );
      }
    } else {
      // Handle permission not granted
    }
  }

  Future<List<Contact>?> _selectContacts(
      BuildContext context, Iterable<Contact> contacts) async {
    TextEditingController searchController = TextEditingController();
    List<Contact> filteredContacts = List.from(contacts);

    return showModalBottomSheet<List<Contact>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select Contacts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredContacts = contacts
                              .where((contact) =>
                                  contact.displayName
                                      ?.toLowerCase()
                                      .contains(value.toLowerCase()) ==
                                  true)
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(filteredContacts[index].displayName ?? ''),
                          onTap: () {
                            Navigator.pop(context, [filteredContacts[index]]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _requestContactPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    return permissionStatus.isGranted;
  }

  Future<Contact?> _selectContact(
      BuildContext context, Iterable<Contact> contacts) async {
    TextEditingController searchController = TextEditingController();
    List<Contact> filteredContacts = List.from(contacts);

    return showModalBottomSheet<Contact>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select a Contact',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredContacts = contacts
                              .where((contact) =>
                                  contact.displayName
                                      ?.toLowerCase()
                                      .contains(value.toLowerCase()) ==
                                  true)
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(filteredContacts[index].displayName ?? ''),
                          onTap: () {
                            Navigator.pop(context, filteredContacts[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomersTab(BuildContext context) {
    final customers = selectedContacts['Customers'];

    List<Contact>? filteredCustomers = customers
        ?.where((contact) =>
            contact.displayName?.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ==
            true)
        .toList();

    return Column(
      // Changed from Row to Column
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Ensure widgets expand horizontally
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search by name...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          // Changed from Expanded to allow flexible space for the ListView
          child: Stack(
            children: [
              ListView.builder(
                itemCount: filteredCustomers?.length ?? 0,
                itemBuilder: (context, index) {
                  final selectedContact = filteredCustomers?[index];
                  return Dismissible(
                    key: Key(selectedContact?.displayName ?? ''),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        customers?.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact removed'),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(selectedContact?.displayName ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomersScreen(
                                customerName:
                                    selectedContact?.displayName ?? '',
                                gaveAmount: null,
                                gotAmount: null,
                              ),
                            ),
                          );
                        },
                        trailing: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Customer'),
                                content: const Text(
                                    'Are you sure you want to delete this customer?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        customers?.removeAt(index);
                                      });
                                      Navigator.pop(
                                          context); // Close the dialog
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Customer removed'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        subtitle: const Text('Added as a Customer'),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 60,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    await _addContact('Customers', context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Customize the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    ' ADD CUSTOMER ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuppliersTab(BuildContext context) {
    final suppliers = selectedContacts['Suppliers'];

    List<Contact>? filteredSuppliers = suppliers
        ?.where((contact) =>
            contact.displayName?.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ==
            true)
        .toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search by name...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: filteredSuppliers?.length ?? 0,
                itemBuilder: (context, index) {
                  final selectedSupplier = filteredSuppliers?[index];
                  return Builder(
                    builder: (context) => Dismissible(
                      key: Key(selectedSupplier?.displayName ?? ''),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          suppliers?.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Supplier removed'),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(selectedSupplier?.displayName ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplierScreen(
                                  supplierName:
                                      selectedSupplier?.displayName ?? '',
                                  gaveAmount: null,
                                  gotAmount: null,
                                  customerName: null,
                                ),
                              ),
                            );
                          },
                          trailing: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Supplier'),
                                  content: const Text(
                                      'Are you sure you want to delete this supplier?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          suppliers?.removeAt(index);
                                        });
                                        Navigator.pop(
                                            context); // Close the dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Supplier removed'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          subtitle: const Text('Added as a Supplier'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 60,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    await _addContact('Suppliers', context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Customize the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    ' ADD SUPPLIER ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTab(BuildContext context, suppliers) {
    List<InventoryItem> filteredInventoryItems = inventoryItems
        .where((item) => item.itemName.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ))
        .toList();
    totalItems = filteredInventoryItems.length;

    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
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
          padding:
              const EdgeInsets.only(left: 24, right: 20, top: 25, bottom: 10),
          child: Text(
            totalItems == 0 ? 'Total Items: 0 ' : 'Total Items: $totalItems',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search by item name...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: filteredInventoryItems.length,
                itemBuilder: (context, index) {
                  final inventoryItem = filteredInventoryItems[index];
                  return Builder(
                    builder: (context) => Dismissible(
                      key: Key(inventoryItem.itemName),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          inventoryItems.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item deleted'),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            inventoryItem.itemName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'Unit Rate (Sale): \$${inventoryItem.unitRateSale.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Rate (Purchase): \$${inventoryItem.ratePurchase.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemInfoScreen(
                                  inventoryItem: inventoryItem,
                                  suppliers: [],
                                ),
                              ),
                            );
                          },
                          trailing: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Item'),
                                  content: const Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          inventoryItems.removeAt(index);
                                        });
                                        Navigator.pop(
                                            context); // Close the dialog
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Item deleted'),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 60,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    InventoryItem newItem = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddItemScreen(),
                      ),
                    );

                    setState(() {
                      inventoryItems.add(newItem);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    ' ADD ITEM ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
