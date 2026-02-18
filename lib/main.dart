import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MinuApp extends StatelessWidget {
  const MinuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ülesannete Äpp',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const TodoNimekiri(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MinuApp();
  }
}

class TodoNimekiri extends StatefulWidget {
  const TodoNimekiri({super.key});

  @override
  State<TodoNimekiri> createState() => _TodoNimekiriState();
}

class Ulesanne {
  String pealkiri;
  bool tehtud;

  Ulesanne({required this.pealkiri, this.tehtud = false});
}

class _TodoNimekiriState extends State<TodoNimekiri> {
  final List<Ulesanne> _ulesanded = [];
  final TextEditingController _kontroller = TextEditingController();

  void _lisaUlesanne() {
    if (_kontroller.text.isNotEmpty) {
      setState(() {
        _ulesanded.add(Ulesanne(pealkiri: _kontroller.text));
        _kontroller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minu Ülesanded'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kontroller,
                    decoration: const InputDecoration(
                      hintText: 'Lisa uus ülesanne...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _lisaUlesanne,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _ulesanded.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _ulesanded[index].tehtud,
                    onChanged: (bool? vaartus) {
                      setState(() {
                        _ulesanded[index].tehtud = vaartus!;
                      });
                    },
                  ),
                  title: Text(
                    _ulesanded[index].pealkiri,
                    style: TextStyle(
                      decoration: _ulesanded[index].tehtud
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _ulesanded[index].tehtud ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        _ulesanded.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}