import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String imageUrl;
  final String userName;

  const StoryCircle({
    Key? key,
    required this.imageUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add navigation or action when the circle is tapped
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4), // Spacer between avatar and name
          Text(
            userName,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
