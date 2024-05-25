import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName =
            userData.data()?['username'] ?? user.displayName ?? 'Kullanıcı Adı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xff220135),
                        child: Icon(Icons.edit, size: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('$_userName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Adres'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Security'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Privacy Policy'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Invite Friends'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Wallet'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('Order'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
