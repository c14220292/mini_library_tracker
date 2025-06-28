import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  String status = 'Belum Dibaca';

  Future<void> addBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('books').add({
        'judul': titleController.text.trim(),
        'penulis': authorController.text.trim(),
        'status': status,
        'userId': user.uid,
      });

      Navigator.pop(context); // kembali ke list setelah tambah
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Gagal Menambahkan Buku"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final box = await Hive.openBox('session');
    await box.put('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Penulis'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: status,
              onChanged: (val) => setState(() => status = val!),
              items: ['Belum Dibaca', 'Sedang Dibaca', 'Selesai'].map((s) {
                return DropdownMenuItem(value: s, child: Text(s));
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addBook,
              child: const Text("Simpan Buku"),
            ),
          ],
        ),
      ),
    );
  }
}
