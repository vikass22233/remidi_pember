class Remidi {
  final String id;
  final String deskripsi;
  final String jenis;
  final String judul;
  final int jumlah;
  final String tanggal;

  Remidi({
    required this.id,
    required this.deskripsi,
    required this.jenis,
    required this.judul,
    required this.jumlah,
    required this.tanggal,
  });

  factory Remidi.fromJson(Map<String, dynamic> json) {
    return Remidi(
      id: json['id'] ?? '', 
      deskripsi: json['deskripsi'] ?? '',
      jenis: json['jenis'] ?? '',
      judul: json['judul'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      tanggal: json['tanggal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deskripsi': deskripsi,
      'jenis': jenis,
      'judul': judul,
      'jumlah': jumlah,
      'tanggal': tanggal,
    };
  }
}
