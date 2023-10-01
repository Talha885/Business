import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String businessName;
  final String phoneNumber;
  final String address;
  final File? profileImage;

  ProfilePage({
    required this.businessName,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: profileImage != null
                  ? CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(profileImage!),
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(height: 20),
            Text(
              'Business Name:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              businessName,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              'Phone Number:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              'Address:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              address,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
