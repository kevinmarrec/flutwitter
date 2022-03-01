import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/shared/constants.dart';
import 'package:flutwitter/shared/registration.dart';
import 'package:flutwitter/widgets/screen.dart';
import 'package:flutwitter/widgets/svg_icon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passwordProvider = StateProvider.autoDispose((_) => '');

class RegistrationPasswordScreen extends ConsumerWidget {
  static const routeName = '/registration/password';

  const RegistrationPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Screen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.registrationPasswordScreenTitle,
            style: theme.textTheme.headline4,
          ),
          const SizedBox(height: kDefaultSpacing),
          Text(l10n.registrationPasswordScreenMessage),
          const SizedBox(height: kDefaultSpacing),
          const PasswordField(),
        ],
      ),
      bottom: ScreenBottomAppBar(
        rightChild: Consumer(
          builder: (context, ref, _) {
            final password = ref.watch(passwordProvider);

            return ScreenBottomAppBarRightButton(
              text: l10n.next,
              onPressed: password.isNotEmpty
                  ? () => ref.read(registrationProvider).complete(password, context: context)
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class PasswordField extends HookConsumerWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final errorText = useState<String?>(null);
    final valid = useState(false);
    final visible = useState(false);

    return TextField(
      obscureText: !visible.value,
      decoration: InputDecoration(
        hintText: l10n.registrationPasswordScreenFieldPlaceholder,
        errorText: errorText.value,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                visible.value = !visible.value;
              },
              icon: Icon(visible.value ? Icons.visibility : Icons.visibility_off),
            ),
            if (valid.value) SvgIcon.checkboxMarkedCircleOutline(),
          ],
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      onChanged: (newValue) {
        final notifier = ref.read(passwordProvider.notifier);

        notifier.state = '';
        errorText.value = null;
        valid.value = false;

        EasyDebounce.debounce('passwordValidation', kDefaultTypingDebounceDuration, () {
          if (newValue.length >= 8) {
            valid.value = true;
            notifier.state = newValue;
          } else {
            errorText.value = l10n.registrationPasswordScreenFieldErrorLength;
          }
        });
      },
    );
  }
}
