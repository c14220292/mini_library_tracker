import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  String filterStatus = 'Semua';
  final List<String> statusOptions = [
    'Semua',
    'Belum Dibaca',
    'Sedang Dibaca',
    'Selesai'
  ];

  Stream<QuerySnapshot> getFilteredBooks() {
    final user = FirebaseAuth.instance.currentUser;
    final books = FirebaseFirestore.instance
        .collection('books')
        .where('userId', isEqualTo: user?.uid);
    if (filterStatus == 'Semua') return books.snapshots();
    return books.where('status', isEqualTo: filterStatus).snapshots();
  }

  Future<void> updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('books').doc(docId).update({
      'status': newStatus,
    });
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
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
          DropdownButton<String>(
            value: filterStatus,
            onChanged: (value) {
              setState(() {
                filterStatus = value!;
              });
            },
            items: statusOptions.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getFilteredBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final books = snapshot.data!.docs;

          if (books.isEmpty) return const Center(child: Text("Belum ada buku"));

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final doc = books[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['judul'] ?? ''),
                subtitle: Text("Penulis: ${data['penulis'] ?? ''}"),
                trailing: DropdownButton<String>(
                  value: data['status'],
                  onChanged: (value) {
                    if (value != null) {
                      updateStatus(doc.id, value);
                    }
                  },
                  items: ['Belum Dibaca', 'Sedang Dibaca', 'Selesai']
                      .map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
