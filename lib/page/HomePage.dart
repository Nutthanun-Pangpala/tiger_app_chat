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
    // Retrieve current user
    final User? user = _auth.currentUser;

    // Determine title based on user's email
    String title = _username ?? "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // Keep title alignment to the left
        title: Row(
          // Wrap title with Row
          children: [
            SizedBox(width: 8), // Add space between leading icon and title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            // Sign out
            _auth.signOut();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
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
          // You can set the user's profile image here
          // Example: backgroundImage: NetworkImage(data['profileImageUrl']),
          child: Text(
              data['email'][0]), // Display first letter of email as fallback
        ),
        title: Text(
          data['email'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'ofline'), // You can customize the status based on user's activity
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
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
