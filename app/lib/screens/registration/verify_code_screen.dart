import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/shared/constants.dart';
import 'package:flutwitter/shared/registration.dart';
import 'package:flutwitter/widgets/svg_icon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final verificationCodeProvider = StateProvider.autoDispose((_) => '');

class VerifyCodeScreen extends ConsumerWidget {
  static const routeName = '/registration/verify_code';

  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final registration = ref.read(registrationProvider);

    return Scaffold(
      appBar: AppBar(
        title: SvgIcon.twitter(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                l10n.verifyCodeScreenTitle,
                style: theme.textTheme.headline4,
              ),
              const SizedBox(height: kDefaultSpacing),
              Text(l10n.verifyCodeScreenMessage(registration.email)),
              const SizedBox(height: kDefaultSpacing),
              const CodeField(),
              const SizedBox(height: kDefaultSpacing),
              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(kDefaultPadding),
                              child: Text(
                                l10n.verifyCodeScreenReceivedQuestion,
                                style: theme.textTheme.headline6?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                registration.sendVerificationEmail(
                                  context: context,
                                  onSuccess: () {
                                    context.showToast(
                                      l10n.verifyCodeScreenToastCodeSent,
                                      backgroundColor: Colors.white,
                                      textStyle: const TextStyle(color: Colors.black),
                                    );
                                  },
                                );
                              },
                              title: Text(l10n.verifyCodeScreenResend),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.verifyCodeScreenReceivedQuestion),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final code = ref.watch(verificationCodeProvider);

                  return ElevatedButton(
                    onPressed: code.isNotEmpty
                        ? () {
                            registration.verifyCode(
                              code,
                              context: context,
                              onSuccess: () {
                                print(registration.verificationToken);
                              },
                            );
                          }
                        : null,
                    child: Text(l10n.next),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CodeField extends ConsumerWidget {
  const CodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.verifyCodeScreenFieldPlaceholder,
      ),
      onChanged: (newValue) {
        ref.read(verificationCodeProvider.notifier).state = newValue;
      },
    );
  }
}
