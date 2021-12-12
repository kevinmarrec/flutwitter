import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../widgets/twitter_icon.dart';

class CreateAccountScreen extends HookWidget {
  static const routeName = '/register/create';

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailFieldKey = useMemoized(() => GlobalKey<FormFieldState>());
    final emailFieldValid = useState(false);
    bool debouncing = false;

    return Scaffold(
      appBar: AppBar(
        title: const TwitterIcon(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.05,
              horizontal: constraints.maxWidth * 0.125,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const Spacer(),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        maxLength: 50,
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        key: emailFieldKey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          suffixIcon: emailFieldValid.value
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                        ),
                        autofillHints: const ['email'],
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(r'\s'),
                          )
                        ],
                        textInputAction: TextInputAction.next,
                        onChanged: (_) async {
                          debouncing = true;
                          emailFieldKey.currentState!.validate();

                          EasyDebounce.debounce(
                            'validation',
                            const Duration(seconds: 1),
                            () {
                              debouncing = false;
                              emailFieldKey.currentState!.validate();
                            },
                          );
                        },
                        validator: (input) {
                          emailFieldValid.value = false;

                          if (debouncing || input == null || input.isEmpty) {
                            return null;
                          }

                          emailFieldValid.value = RegExp(
                                  r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                              .hasMatch(input);

                          return emailFieldValid.value
                              ? null
                              : 'Please enter a valid email.';
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Sign up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
