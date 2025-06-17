import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/remidi.dart';

class RemidiService {
  static const String baseUrl = 'https://remidi-49bde-default-rtdb.firebaseio.com/remidi.json';

  // Ambil semua data remidi dari Firebase
  static Future<List<Remidi>> fetchRemidi() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data == null) return [];

        return data.entries.map((entry) {
          return Remidi.fromJson({
            'id': entry.key, // key dari Firebase dijadikan id
            ...entry.value,
          });
        }).toList();
      } else {
        throw Exception('Gagal memuat data remidi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat memuat data: $e');
    }
  }

  // Tambah data remidi ke Firebase
  static Future<void> addRemidi(Remidi remidi) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: json.encode(remidi.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal menyimpan data remidi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat menyimpan: $e');
    }
  }
}
