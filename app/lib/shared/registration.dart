import 'package:riverpod/riverpod.dart';

class Registration {
  Registration(
    this._read, {
    required this.name,
    required this.email,
    required this.birthDate,
  });

  final Reader _read;

  final String name;
  final String email;
  final DateTime? birthDate;

  bool get isNameValid => name.isNotEmpty;
  bool get isEmailValid => email.isNotEmpty;
  bool get isBirthDateValid => birthDate != null;

  bool get isValid => isNameValid && isEmailValid && isBirthDateValid;

  Registration copyWith({
    String? name,
    String? email,
    DateTime? birthDate,
  }) {
    return Registration(
      _read,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}

final registrationProvider = StateProvider.autoDispose<Registration>(
  (ref) => Registration(ref.read, name: '', email: '', birthDate: null),
);
