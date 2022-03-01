import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/shared/constants.dart';
import 'package:flutwitter/widgets/screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginFormScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Screen(
      padding: const EdgeInsets.all(kDefaultPadding * 1.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              l10n.loginFormScreenTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          const Expanded(
            flex: 1,
            child: LoginForm(),
          ),
          const Spacer(flex: 1),
        ],
      ),
      bottom: ScreenBottomAppBar(
        leftChild: ScreenBottomAppBarLeftButton(
          text: 'Forgot password ?',
          onPressed: () {},
        ),
        rightChild: ScreenBottomAppBarRightButton(
          text: 'Log In',
          onPressed: () {},
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Spacer(flex: 2),
        EmailField(),
        Spacer(flex: 2),
        PasswordField(),
        Spacer(flex: 2),
      ],
    );
  }
}

class EmailField extends HookConsumerWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: l10n.loginFormScreenIdentifierFieldPlaceholder,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        )
      ],
      textInputAction: TextInputAction.next,
    );
  }
}

class PasswordField extends HookConsumerWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visible = useState(false);

    return TextField(
      obscureText: !visible.value,
      decoration: InputDecoration(
        hintText: l10n.loginFormScreenPasswordFieldPlaceholder,
        suffixIcon: IconButton(
          onPressed: () {
            visible.value = !visible.value;
          },
          icon: Icon(visible.value ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
