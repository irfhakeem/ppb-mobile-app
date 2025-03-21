import 'package:flutter/material.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.cyan[200],
              child: SizedBox(
                height: 400,
                width: 400,
                child: Image(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1741487431784-fd2a1db916bb?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.pink[100],
              child: SizedBox(width: 400, child: Text("What image is that?")),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.yellow[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.house, size: 30),
                        Text("Food", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.umbrella, size: 30),
                        Text("Scenery", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.people, size: 30),
                        Text("People", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
