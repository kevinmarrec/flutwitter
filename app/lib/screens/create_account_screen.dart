import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../shared/dio.dart';
import '../widgets/svg_icon.dart';

final checkEmail = FutureProvider.family<bool, String>((ref, email) async {
  final dio = ref.watch(dioProvider);
  final response = (await dio.get<bool>(
    '/register/check_email',
    queryParameters: {'email': email},
  ));
  return response.data == true;
});

class CreateAccountScreen extends HookConsumerWidget {
  static const routeName = '/register/create';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Create your account',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: const CreateAccountForm(),
                ),
                const Spacer(flex: 2),
                const ElevatedButton(
                  onPressed: null,
                  child: Text('Sign up'),
                )
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
    final nameFieldValid = useState(false);

    return TextField(
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.name],
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Name',
        suffixIcon:
            nameFieldValid.value ? SvgIcon.checkboxMarkedCircleOutline() : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      maxLength: 50,
      textInputAction: TextInputAction.next,
      onChanged: (newValue) {
        nameFieldValid.value = newValue.isNotEmpty;
      },
    );
  }
}

class EmailField extends HookConsumerWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFieldErrorText = useState<String?>(null);
    final emailFieldValid = useState(false);

    return TextField(
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: 'Email',
        errorText: emailFieldErrorText.value,
        suffixIcon: emailFieldValid.value
            ? SvgIcon.checkboxMarkedCircleOutline()
            : null,
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

        EasyDebounce.debounce(
          'emailValidation',
          const Duration(seconds: 1),
          () async {
            if (!RegExp(
              r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
            ).hasMatch(newValue)) {
              emailFieldErrorText.value = 'Please enter a valid email.';
              return;
            }

            final isAvailable = await ref.read(checkEmail(newValue).future);
            if (!isAvailable) {
              emailFieldErrorText.value = 'This email is already in use.';
              return;
            }

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
    final pickedDate = useState<DateTime?>(null);

    final dateController = useTextEditingController()
      ..text = pickedDate.value != null
          ? DateFormat('d MMMM y').format(pickedDate.value!)
          : '';

    return TextField(
      controller: dateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Date of birth',
        suffixIcon: pickedDate.value != null
            ? SvgIcon.checkboxMarkedCircleOutline()
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      onTap: () async {
        DateTime now = DateTime.now();
        pickedDate.value = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 100),
          lastDate: now,
        );
      },
    );
  }
}
