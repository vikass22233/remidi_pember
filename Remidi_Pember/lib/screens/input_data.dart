import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/remidi.dart';
import '../service/service.dart';

class TambahDataPage extends StatefulWidget {
  @override
  _TambahDataPageState createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? selectedDate;
  String selectedJenis = 'Pengeluaran';

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _webImageBytes;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _imageFile = pickedFile;
        });
      } else {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Kamera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Galeri'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.teal[200],
        ),
        child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: kIsWeb
            ? Image.memory(_webImageBytes!, width: 120, height: 120, fit: BoxFit.cover)
            : Image.file(File(_imageFile!.path), width: 120, height: 120, fit: BoxFit.cover),
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tanggal tidak boleh kosong')),
        );
        return;
      }

      final remidi = Remidi(
        id: '', // ID bisa di-generate oleh backend
        judul: _judulController.text,
        jenis: selectedJenis,
        tanggal: selectedDate!.toIso8601String(),
        jumlah: int.tryParse(_jumlahController.text) ?? 0,
        deskripsi: _deskripsiController.text,
        // Tambahkan field image jika model mendukung
      );

      try {
        await RemidiService.addRemidi(remidi);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );
        Navigator.pop(context, remidi); // kirim data kembali ke HomePage
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Tambah Data",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel("Judul :"),
                _buildTextField(
                  controller: _judulController,
                  hint: "Masukkan judul yang diinginkan",
                  validator: (val) => val == null || val.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                _buildLabel("Jenis :"),
                _buildDropdown(),
                const SizedBox(height: 12),
                _buildLabel("Tanggal :"),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _buildTextField(
                      hint: selectedDate != null
                          ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                          : 'Pilih tanggal',
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildLabel("Jumlah :"),
                _buildTextField(
                  controller: _jumlahController,
                  hint: "Masukkan jumlah nominal",
                  validator: (val) => val == null || val.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                _buildLabel("Deskripsi :"),
                _buildTextField(
                  controller: _deskripsiController,
                  hint: "Masukkan deskripsi tambahan",
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitData,
                    child: Text("Simpan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? hint,
    int maxLines = 1,
    bool readOnly = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.teal[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: selectedJenis,
        underline: SizedBox(),
        isExpanded: true,
        items: ['Pengeluaran', 'Pemasukan']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              selectedJenis = val;
            });
          }
        },
      ),
    );
  }
}
