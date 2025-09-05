import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lol_client/flutter_lol_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoL Client Test',
      theme: ThemeData(useMaterial3: true),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  bool isLoading = false;

  Future<void> testConnectionOnly() async {
    setState(() {
      isLoading = true;
      result = 'Testing connection...';
    });

    try {
      final connection = await LcuScanner.scanForClient();

      setState(() {
        result =
            'Connection successful!\n'
            'Host: ${connection.host}\n'
            'Port: ${connection.port}\n'
            'Protocol: ${connection.protocol}\n'
            'Base URL: ${connection.baseUrl}';
      });
    } catch (e) {
      setState(() {
        result = 'Connection failed:\n${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void copyResult() {
    if (result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Result copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoL Client Test')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : testConnectionOnly,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Test Connection Only'),
            ),
            SizedBox(height: 20),
            if (result.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Result:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: copyResult,
                    icon: Icon(Icons.copy),
                    tooltip: 'Copy result',
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    result,
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
