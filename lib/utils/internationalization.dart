import 'package:mwc/utils/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class SetLocalizations {
  SetLocalizations(this.locale);

  final Locale locale;

  static SetLocalizations of(BuildContext context) => Localizations.of<SetLocalizations>(context, SetLocalizations)!;

  static List<String> languages() => ['ko', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async => _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) => _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String _replacePlaceholders(String text, Map<String, String> values) {
    values.forEach((key, value) {
      text = text.replaceAll('{$key}', value);
    });
    return text;
  }

  String get languageCode => locale.toString();
  int get languageIndex => languages().contains(languageCode) ? languages().indexOf(languageCode) : 0;
  String getText(String key, {Map<String, String>? values}) {
    String text = (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';
    if (values != null && values.isNotEmpty) {
      text = _replacePlaceholders(text, values);
    }
    return text;
  }
}

class SetLocalizationsDelegate extends LocalizationsDelegate<SetLocalizations> {
  const SetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return SetLocalizations.languages().contains(
      language.endsWith('_') ? language.substring(0, language.length - 1) : language,
    );
  }

  @override
  Future<SetLocalizations> load(Locale locale) => SynchronousFuture<SetLocalizations>(SetLocalizations(locale));

  @override
  bool shouldReload(SetLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);
