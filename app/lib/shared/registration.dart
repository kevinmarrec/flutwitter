import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/shared/dio.dart';
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

  String? verificationToken;

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

  void sendVerificationEmail({required BuildContext context, Function? onSuccess}) async {
    FocusScope.of(context).unfocus();
    try {
      await _read(dioProvider).post(
        '/email_verifications',
        data: {'email': email},
      );
      onSuccess?.call();
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      final tooManyRequests = e is DioError && e.response!.statusCode == 429;
      context.showToast(
        tooManyRequests ? l10n.registrationToastTooManyAttempts : l10n.registrationToastError,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
      );
    }
  }

  void verifyCode(String code, {required BuildContext context, Function? onSuccess}) async {
    try {
      final response = await _read(dioProvider).post(
        '/email_verifications/verify',
        data: {
          'email': email,
          'code': int.parse(code),
        },
      );

      verificationToken = response.data['token'];

      onSuccess?.call();
    } catch (e) {
      context.showToast(
        AppLocalizations.of(context)!.registrationToastIncorrectCode,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
      );
    }
  }
}

final registrationProvider = StateProvider.autoDispose(
  (ref) => Registration(ref.read, name: '', email: '', birthDate: null),
);
