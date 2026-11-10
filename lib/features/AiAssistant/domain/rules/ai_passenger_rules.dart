import '../entities/ai_assistant_entity.dart';

abstract final class AiPassengerRules {
  static const adult = 'ADT';
  static const child = 'CHD';
  static const infant = 'INF';

  static const infantMaxAgeYears = 2; // infant: under 2
  static const childMaxAgeYears = 12; // child: 2 to under 12; adult: 12+

  static const titles = ['Mr.', 'Mrs.', 'Ms.', 'Mstr.', 'Miss'];

  static final _name = RegExp(r"^\p{L}[\p{L} .'\-]{0,59}$", unicode: true);
  static final _phone = RegExp(r'^\+?[0-9]{8,15}$');
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _nationality = RegExp(r'^[A-Za-z]{2,3}$');

  static List<String> typesFor(AiPassengerSummaryEntity p) => [
    for (var i = 0; i < p.adults; i++) adult,
    for (var i = 0; i < p.children; i++) child,
    for (var i = 0; i < p.infants; i++) infant,
  ];

  static String typeLabel(String type) => switch (type) {
    adult => 'Dewasa',
    child => 'Anak',
    _ => 'Bayi',
  };

  static String? name(String? v, {required String label, bool required = true}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return required ? '$label wajib diisi' : null;
    return _name.hasMatch(s) ? null : '$label hanya boleh berisi huruf (maks. 60 karakter)';
  }

  static String? email(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty || s.length > 120 || !_email.hasMatch(s)) {
      return 'Email tidak valid (dibutuhkan untuk pembayaran)';
    }
    return null;
  }

  static String? phone(String? v) {
    final s = (v ?? '').replaceAll(' ', '').trim();
    return _phone.hasMatch(s) ? null : 'Nomor telepon tidak valid (8-15 digit)';
  }

  static String? nationality(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    return _nationality.hasMatch(s) ? null : 'Gunakan kode negara 2-3 huruf, mis. ID';
  }

  static int ageOn(DateTime birth, DateTime on) {
    var y = on.year - birth.year;
    if (on.month < birth.month || (on.month == birth.month && on.day < birth.day)) y--;
    return y;
  }

  static String? birthDate({
    required String type,
    required DateTime? birth,
    required DateTime firstTravel,
    required DateTime lastTravel,
  }) {
    if (birth == null) return type == adult ? null : 'Tanggal lahir wajib untuk anak dan bayi';
    if (birth.isAfter(firstTravel)) return 'Tanggal lahir setelah tanggal keberangkatan';
    final first = ageOn(birth, firstTravel);
    final last = ageOn(birth, lastTravel);
    switch (type) {
      case adult:
        if (first < childMaxAgeYears) return 'Dewasa harus berusia minimal 12 tahun';
      case child:
        if (first < infantMaxAgeYears || last >= childMaxAgeYears) {
          return 'Anak harus berusia 2 sampai di bawah 12 tahun selama seluruh perjalanan';
        }
      case infant:
        if (last >= infantMaxAgeYears) {
          return 'Bayi harus berusia di bawah 2 tahun selama seluruh perjalanan';
        }
    }
    return null;
  }

  static (DateTime, DateTime, DateTime) birthPickerRange({
    required String type,
    required DateTime firstTravel,
    required DateTime lastTravel,
  }) {
    DateTime years(DateTime d, int n) => DateTime(d.year - n, d.month, d.day);
    late DateTime first;
    late DateTime last;
    late DateTime initial;
    switch (type) {
      case adult:
        first = DateTime(1900);
        last = years(firstTravel, childMaxAgeYears);
        initial = years(firstTravel, 30);
      case child:
        first = years(lastTravel, childMaxAgeYears).add(const Duration(days: 1));
        last = years(firstTravel, infantMaxAgeYears);
        initial = last;
      default:
        first = years(lastTravel, infantMaxAgeYears).add(const Duration(days: 1));
        last = firstTravel;
        initial = last;
    }
    if (last.isBefore(first)) first = last;
    if (initial.isBefore(first) || initial.isAfter(last)) initial = last;
    return (first, last, initial);
  }

  static String isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String displayDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year.toString().padLeft(4, '0')}';
}
