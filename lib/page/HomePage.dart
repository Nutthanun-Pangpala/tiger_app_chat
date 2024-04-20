import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiger_app_chat/page/Chat_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _username; // Declare _username here

  @override
  void initState() {
    super.initState();
    _fetchUsername(); // Call _fetchUsername() when widget initializes
  }

  Future<void> _fetchUsername() async {
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        _username = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    String title = _username ?? "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // เปลี่ยนสีของ AppBar เป็นสีดำ
        centerTitle: false,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // จัดตำแหน่งของ Widget ใน AppBar
          children: [
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                _auth.signOut();
              },
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
              iconSize: 40,
            ),
          ],
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final document = snapshot.data!.docs[index];
            return _buildUserListItem(document);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: CircleAvatar(
          child: Text(
            data['email'][0], // Display first letter of email as fallback
          ),
        ),
        title: Text(
          data['username'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'Offline'), // You can customize the status based on user's activity
        trailing: IconButton(
          icon: Icon(Icons.more_vert), // Add the ellipsis icon
          onPressed: () {
            // Handle onTap event for the ellipsis icon
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
                receiverUserName: null,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
