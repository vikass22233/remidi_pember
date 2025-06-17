import 'package:flutter/material.dart';
import 'input_data.dart';
import '../models/remidi.dart'; // Pastikan ini sesuai path

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Remidi> transaksiList = [];

  void _navigateAndAddData() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahDataPage()),
    );

    // Pastikan yang dikembalikan adalah objek Remidi
    if (result != null && result is Remidi) {
      setState(() {
        transaksiList.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo : 50.000',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: transaksiList.isEmpty
                    ? Center(child: Text('Belum ada transaksi.'))
                    : ListView.builder(
                        itemCount: transaksiList.length,
                        itemBuilder: (context, index) {
                          final item = transaksiList[index];
                          return Card(
                            child: ListTile(
                              title: Text(item.judul),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Jenis: ${item.jenis}'),
                                  Text('Jumlah: ${item.jumlah}'),
                                  Text('Tanggal: ${item.tanggal.split("T")[0]}'),
                                  if (item.deskripsi.isNotEmpty)
                                    Text('Deskripsi: ${item.deskripsi}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddData,
        backgroundColor: Colors.indigo[900],
        child: Icon(Icons.add),
      ),
    );
  }
}
