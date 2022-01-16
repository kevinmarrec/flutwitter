import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/screens/registration/verification_screen.dart';
import 'package:flutwitter/shared/dio.dart';
import 'package:flutwitter/shared/registration.dart';
import 'package:flutwitter/widgets/svg_icon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegistrationDetailsScreen extends StatelessWidget {
  static const routeName = '/registration/details';

  const RegistrationDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: SvgIcon.twitter(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.05,
              horizontal: constraints.maxWidth * 0.125,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    l10n.registrationDetailsScreenTitle,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: const CreateAccountForm(),
                ),
                const Spacer(flex: 2),
                Consumer(
                  builder: (context, ref, _) {
                    final registration = ref.watch(registrationProvider);

                    return ElevatedButton(
                      onPressed: registration.isValid
                          ? () {
                              registration.sendVerificationEmail(
                                context: context,
                                onSuccess: () {
                                  Navigator.pushNamed(context, RegistrationVerificationScreen.routeName);
                                },
                              );
                            }
                          : null,
                      child: Text(l10n.next),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAccountForm extends HookWidget {
  const CreateAccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        NameField(),
        Spacer(flex: 2),
        EmailField(),
        Spacer(flex: 4),
        DateField(),
      ],
    );
  }
}

class NameField extends HookConsumerWidget {
  const NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(registrationProvider.select((r) => r.name));

    return TextField(
      controller: useTextEditingController(
        text: name,
      ),
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.name],
      autofocus: true,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.registrationDetailsScreenNameFieldPlaceholder,
        suffixIcon: name.isNotEmpty ? SvgIcon.checkboxMarkedCircleOutline() : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      maxLength: 50,
      textInputAction: TextInputAction.next,
      onChanged: (newValue) {
        ref.read(registrationProvider.notifier).state = ref.read(registrationProvider).copyWith(name: newValue);
      },
    );
  }
}

class EmailField extends HookConsumerWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailFieldErrorText = useState<String?>(null);
    final emailFieldValid = useState(false);

    return TextField(
      controller: useTextEditingController(
        text: ref.read(registrationProvider).email,
      ),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: l10n.registrationDetailsScreenEmailFieldPlaceholder,
        errorText: emailFieldErrorText.value,
        suffixIcon: emailFieldValid.value ? SvgIcon.checkboxMarkedCircleOutline() : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        )
      ],
      textInputAction: TextInputAction.next,
      onChanged: (newValue) async {
        emailFieldErrorText.value = null;
        emailFieldValid.value = false;

        ref.read(registrationProvider.notifier).state = ref.read(registrationProvider).copyWith(email: '');

        EasyDebounce.debounce(
          'emailValidation',
          const Duration(milliseconds: 500),
          () async {
            if (!RegExp(
              r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
            ).hasMatch(newValue)) {
              emailFieldErrorText.value = l10n.registrationDetailsScreenEmailErrorInvalid;
              return;
            }

            final checkEmailResponse = await ref.read(dioProvider).get<bool>(
              '/users/check_email_availability',
              queryParameters: {'email': newValue},
            );

            if (checkEmailResponse.data != true) {
              emailFieldErrorText.value = l10n.registrationDetailsScreenEmailErrorTaken;
              return;
            }

            ref.read(registrationProvider.notifier).state = ref.read(registrationProvider).copyWith(email: newValue);

            emailFieldValid.value = true;
          },
        );
      },
    );
  }
}

class DateField extends HookConsumerWidget {
  const DateField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final birthDate = ref.watch(registrationProvider.select((r) => r.birthDate));

    final controller = useTextEditingController()..text = birthDate != null ? l10n.formatDate(birthDate) : '';

    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: l10n.registrationDetailsScreenBirthDateFieldPlaceholder,
        suffixIcon: birthDate != null ? SvgIcon.checkboxMarkedCircleOutline() : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      onTap: () async {
        DateTime now = DateTime.now();

        final pickedDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.input,
          initialDate: now,
          firstDate: DateTime(now.year - 100),
          lastDate: now,
        );

        if (pickedDate != null) {
          ref.read(registrationProvider.notifier).state =
              ref.read(registrationProvider).copyWith(birthDate: pickedDate);
        }
      },
    );
  }
}
