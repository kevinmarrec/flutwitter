import 'package:flutter/material.dart';
import 'package:flutwitter/l10n/l10n.dart';
import 'package:flutwitter/screens/registration/details_screen.dart';
import 'package:flutwitter/widgets/svg_icon.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgIcon.twitter(),
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
              children: [
                const Spacer(flex: 6),
                Text(
                  l10n.welcomeScreenMessage,
                  style: theme.textTheme.headline4,
                ),
                const Spacer(flex: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RegistrationDetailsScreen.routeName,
                        );
                      },
                      child: Text(l10n.welcomeScreenButtonText),
                    )
                  ],
                ),
                const Spacer(flex: 2),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.caption,
                    children: [
                      TextSpan(text: l10n.welcomeScreenAgreementText1),
                      TextSpan(
                        text: l10n.welcomeScreenAgreementTextTerms,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      TextSpan(text: l10n.welcomeScreenAgreementText2),
                      TextSpan(
                        text: l10n.welcomeScreenAgreementTextPrivacyPolicy,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      TextSpan(text: l10n.welcomeScreenAgreementText3),
                      TextSpan(
                        text: l10n.welcomeScreenAgreementTextCookieUse,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(l10n.welcomeScreenQuestion),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.welcomeScreenAnswer),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
