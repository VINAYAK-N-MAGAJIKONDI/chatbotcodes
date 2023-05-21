import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        secondaryHeaderColor: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Widget> _chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatty Bard '),
        leading: Icon(Icons.adb),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: _chatMessages[index],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),

                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    String message = _usernameController.text;
    if (message.isEmpty) return;

    setState(() {
      _chatMessages.add(_buildChatMessage("Vinayak", message));
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/get_answer'), // Use the same URL as your Python backend
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        _chatMessages.add(_buildChatMessage("AI:", result['content']));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    _usernameController.clear();
  }

  Widget _buildChatMessage(String sender, String message) {
    return Align(
      alignment: sender == "Vinayak" ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: sender == "Vinayak" ? Colors.teal : Colors.deepOrange,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          "$message",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
