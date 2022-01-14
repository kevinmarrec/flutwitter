import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Helpers on AppLocalizations {
  formatDate(DateTime date, {String? format}) {
    return DateFormat(format ?? 'd MMMM y', localeName)
        .format(date)
        .split(' ')
        .map((x) => toBeginningOfSentenceCase(x))
        .join(' ');
  }
}
