import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  void continueToApp(BuildContext context) async {
    final box = Hive.box('session');
    await box.put('firstTime', false);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selamat Datang di Mini Library Tracker!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                "Aplikasi ini membantu Anda mencatat buku yang ingin dibaca, sedang dibaca, dan sudah selesai dibaca.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Icon(Icons.arrow_forward),
                label: Text("Mulai Sekarang"),
                onPressed: () => continueToApp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
