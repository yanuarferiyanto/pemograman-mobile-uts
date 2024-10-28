import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData.light(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _habitController = TextEditingController();
  List<Habit> _habits = [];
  int _currentIndex = 0;
  bool _isDarkMode = false;

  String _selectedMood = 'Senang'; // Default mood

  void _addHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        _habits.add(Habit(name: _habitController.text, date: DateTime.now()));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kebiasaan "${_habitController.text}" ditambahkan!')),
      );
      _habitController.clear();
    }
  }

  void _toggleHabitStatus(int index) {
    setState(() {
      _habits[index].isCompleted = !_habits[index].isCompleted;
    });
  }

  void _removeHabit(int index) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kebiasaan "${_habits[index].name}" dihapus!')),
      );
      _habits.removeAt(index);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: Colors.orange,
      ),
      drawer: _buildDrawer(),
      body: _currentIndex == 0 ? _buildHome() : _buildSettings(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _addHabit,
              child: const Icon(Icons.add),
              backgroundColor: Colors.orange,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        onTap: _onPageChanged,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://raw.githubusercontent.com/yanuarferiyanto/gambar-aset/refs/heads/main/IMG_20201120_093357.jpg',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yanuar Feriyanto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () {
              Navigator.pop(context);
              _onPageChanged(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat'),
            onTap: () {
              Navigator.pop(context);
              // Implementasikan navigasi ke riwayat jika diperlukan
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagaimana perasaanmu hari ini?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildMoodDropdown(),
          const SizedBox(height: 20),
          Text(
            'Total Kebiasaan: ${_habits.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Kebiasaan Selesai: ${_habits.where((habit) => habit.isCompleted).length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      _habits[index].name,
                      style: TextStyle(
                        decoration: _habits[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Ditambahkan pada: ${_habits[index].date.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _habits[index].isCompleted
                                ? Icons.check_circle
                                : Icons.circle,
                            color: _habits[index].isCompleted
                                ? Colors.green
                                : Colors.grey,
                          ),
                          onPressed: () => _toggleHabitStatus(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeHabit(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _habitController,
              decoration: InputDecoration(
                labelText: 'Tambahkan kebiasaan baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDropdown() {
    return DropdownButton<String>(
      value: _selectedMood,
      items: ['Senang', 'Sedih', 'Biasa Saja', 'Cemas', 'lainya']
          .map((mood) => DropdownMenuItem(
                value: mood,
                child: Text(mood),
              ))
          .toList(),
      onChanged: (String? newMood) {
        setState(() {
          _selectedMood = newMood!;
        });
      },
    );
  }

  Widget _buildSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class Habit {
  String name;
  DateTime date;
  bool isCompleted;

  Habit({required this.name, required this.date, this.isCompleted = false});
}
