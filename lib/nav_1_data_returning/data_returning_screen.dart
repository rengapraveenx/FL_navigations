import 'package:flutter/material.dart';

// The content for the "Returning Data" lesson.
class DataReturningScreen extends StatefulWidget {
  const DataReturningScreen({super.key});

  @override
  State<DataReturningScreen> createState() => _DataReturningScreenState();
}

class _DataReturningScreenState extends State<DataReturningScreen> {
  String _returnedData = 'No data yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nav 1.0: Returning Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data from second screen: $_returnedData',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const _SecondScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    _returnedData = result;
                  });
                }
              },
              child: const Text('Go to screen and get data back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondScreen extends StatefulWidget {
  const _SecondScreen();

  @override
  State<_SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<_SecondScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter data to return',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _textController.text);
              },
              child: const Text('Pop and Return Data'),
            ),
          ],
        ),
      ),
    );
  }
}