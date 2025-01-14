// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Nice to meet you!`
  String get loginHomeLabel {
    return Intl.message(
      'Nice to meet you!',
      name: 'loginHomeLabel',
      desc: 'Label on the login home screen',
      args: [],
    );
  }

  /// `You need to log in to get started`
  String get loginHomeDescription {
    return Intl.message(
      'You need to log in to get started',
      name: 'loginHomeDescription',
      desc: 'Description on the login home screen',
      args: [],
    );
  }

  /// `Language`
  String get loginHomeSelectLanguageLabel {
    return Intl.message(
      'Language',
      name: 'loginHomeSelectLanguageLabel',
      desc: 'Label for language selection',
      args: [],
    );
  }

  /// `Country Code`
  String get loginHomeSelectPhoneLabel {
    return Intl.message(
      'Country Code',
      name: 'loginHomeSelectPhoneLabel',
      desc: 'Label for country code selection',
      args: [],
    );
  }

  /// `Phone number or E-mail`
  String get loginHomeInputEmailLabel {
    return Intl.message(
      'Phone number or E-mail',
      name: 'loginHomeInputEmailLabel',
      desc: 'Label for email or phone input',
      args: [],
    );
  }

  /// `Please enter your phone number or E-mail`
  String get loginHomeInputEmailHint {
    return Intl.message(
      'Please enter your phone number or E-mail',
      name: 'loginHomeInputEmailHint',
      desc: 'Hint for email or phone input',
      args: [],
    );
  }

  /// `Please enter a valid email including @`
  String get loginHomeInputEmailError {
    return Intl.message(
      'Please enter a valid email including @',
      name: 'loginHomeInputEmailError',
      desc: 'Error message for invalid email',
      args: [],
    );
  }

  /// `Phone number`
  String get loginHomeInputPhoneLabel {
    return Intl.message(
      'Phone number',
      name: 'loginHomeInputPhoneLabel',
      desc: 'Label for phone input',
      args: [],
    );
  }

  /// ``
  String get loginHomeInputPhoneHint {
    return Intl.message(
      '',
      name: 'loginHomeInputPhoneHint',
      desc: 'Hint for phone input',
      args: [],
    );
  }

  /// `Please enter numbers only`
  String get loginHomeInputPhoneError {
    return Intl.message(
      'Please enter numbers only',
      name: 'loginHomeInputPhoneError',
      desc: 'Error message for invalid phone number',
      args: [],
    );
  }

  /// `Log in`
  String get loginHomeButtonLoginLabel {
    return Intl.message(
      'Log in',
      name: 'loginHomeButtonLoginLabel',
      desc: 'Label for login button',
      args: [],
    );
  }

  /// `Sign up`
  String get loginHomeButtonSignupLabel {
    return Intl.message(
      'Sign up',
      name: 'loginHomeButtonSignupLabel',
      desc: 'Label for signup button',
      args: [],
    );
  }

  /// `Did you change your phone number?`
  String get loginHomeButtonFindPasswordLabel {
    return Intl.message(
      'Did you change your phone number?',
      name: 'loginHomeButtonFindPasswordLabel',
      desc: 'Label for find password button',
      args: [],
    );
  }

  /// `OR`
  String get loginHomeDividerLabel {
    return Intl.message(
      'OR',
      name: 'loginHomeDividerLabel',
      desc: 'Label for divider',
      args: [],
    );
  }

  /// `Please enter \nyour password`
  String get completeLoginLabel {
    return Intl.message(
      'Please enter \nyour password',
      name: 'completeLoginLabel',
      desc: 'Label for complete login screen',
      args: [],
    );
  }

  /// `Password`
  String get completeLoginInputPasswordLabel {
    return Intl.message(
      'Password',
      name: 'completeLoginInputPasswordLabel',
      desc: 'Label for password input',
      args: [],
    );
  }

  /// `password`
  String get completeLoginInputPasswordHint {
    return Intl.message(
      'password',
      name: 'completeLoginInputPasswordHint',
      desc: 'Hint for password input',
      args: [],
    );
  }

  /// `Log in`
  String get completeLoginButtonReturnLabel {
    return Intl.message(
      'Log in',
      name: 'completeLoginButtonReturnLabel',
      desc: 'Label for return button',
      args: [],
    );
  }

  /// `Find password`
  String get completeLoginButtonFindPasswordLabel {
    return Intl.message(
      'Find password',
      name: 'completeLoginButtonFindPasswordLabel',
      desc: 'Label for find password button',
      args: [],
    );
  }

  /// `Please enter the registered E-mail`
  String get findPasswordLabel {
    return Intl.message(
      'Please enter the registered E-mail',
      name: 'findPasswordLabel',
      desc: 'Label for find password screen',
      args: [],
    );
  }

  /// `We can recover your account via the E-mail address`
  String get findPasswordDescription {
    return Intl.message(
      'We can recover your account via the E-mail address',
      name: 'findPasswordDescription',
      desc: 'Description for find password screen',
      args: [],
    );
  }

  /// `E-mail`
  String get findPasswordInputEmailLabel {
    return Intl.message(
      'E-mail',
      name: 'findPasswordInputEmailLabel',
      desc: 'Label for email input',
      args: [],
    );
  }

  /// `Please enter your E-mail`
  String get findPasswordInputEmailHint {
    return Intl.message(
      'Please enter your E-mail',
      name: 'findPasswordInputEmailHint',
      desc: 'Hint for email input',
      args: [],
    );
  }

  /// `Please enter a valid email including @`
  String get findPasswordInputEmailError {
    return Intl.message(
      'Please enter a valid email including @',
      name: 'findPasswordInputEmailError',
      desc: 'Error message for invalid email',
      args: [],
    );
  }

  /// `Confirm`
  String get findPasswordButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'findPasswordButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get changePasswordLabel {
    return Intl.message(
      'Please enter a new password',
      name: 'changePasswordLabel',
      desc: 'Label for change password screen',
      args: [],
    );
  }

  /// `Password`
  String get changePasswordInputPasswordLabel {
    return Intl.message(
      'Password',
      name: 'changePasswordInputPasswordLabel',
      desc: 'Label for password input',
      args: [],
    );
  }

  /// `password`
  String get changePasswordInputPasswordHint {
    return Intl.message(
      'password',
      name: 'changePasswordInputPasswordHint',
      desc: 'Hint for password input',
      args: [],
    );
  }

  /// `Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters`
  String get changePasswordInputPasswordError {
    return Intl.message(
      'Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters',
      name: 'changePasswordInputPasswordError',
      desc: 'Error message for invalid password',
      args: [],
    );
  }

  /// `Confirm password`
  String get changePasswordCheckPasswordLabel {
    return Intl.message(
      'Confirm password',
      name: 'changePasswordCheckPasswordLabel',
      desc: 'Label for confirm password input',
      args: [],
    );
  }

  /// `password`
  String get changePasswordCheckPasswordHint {
    return Intl.message(
      'password',
      name: 'changePasswordCheckPasswordHint',
      desc: 'Hint for confirm password input',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get changePasswordCheckPasswordError {
    return Intl.message(
      'Passwords do not match',
      name: 'changePasswordCheckPasswordError',
      desc: 'Error message for mismatched passwords',
      args: [],
    );
  }

  /// `Passwords match`
  String get changePasswordCheckPasswordSuccess {
    return Intl.message(
      'Passwords match',
      name: 'changePasswordCheckPasswordSuccess',
      desc: 'Success message for matched passwords',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordButtonReturnLabel {
    return Intl.message(
      'Change password',
      name: 'changePasswordButtonReturnLabel',
      desc: 'Label for change password button',
      args: [],
    );
  }

  /// `Confirm`
  String get changePasswordButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'changePasswordButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Please re-enter the changed phone number`
  String get changePhoneLabel {
    return Intl.message(
      'Please re-enter the changed phone number',
      name: 'changePhoneLabel',
      desc: 'Label for change phone screen',
      args: [],
    );
  }

  /// `Phone number`
  String get changePhoneInputPhoneLabel {
    return Intl.message(
      'Phone number',
      name: 'changePhoneInputPhoneLabel',
      desc: 'Label for phone number input',
      args: [],
    );
  }

  /// ``
  String get changePhoneInputPhoneHint {
    return Intl.message(
      '',
      name: 'changePhoneInputPhoneHint',
      desc: 'Hint for phone number input',
      args: [],
    );
  }

  /// `Please enter numbers only`
  String get changePhoneInputPhoneError {
    return Intl.message(
      'Please enter numbers only',
      name: 'changePhoneInputPhoneError',
      desc: 'Error message for invalid phone number',
      args: [],
    );
  }

  /// `Change phone number`
  String get changePhoneButtonReturnLabel {
    return Intl.message(
      'Change phone number',
      name: 'changePhoneButtonReturnLabel',
      desc: 'Label for change phone number button',
      args: [],
    );
  }

  /// `Next`
  String get changePhoneButtonNextLabel {
    return Intl.message(
      'Next',
      name: 'changePhoneButtonNextLabel',
      desc: 'Label for next button',
      args: [],
    );
  }

  /// `If you do not receive the verification number, please check if the information you entered is correct. \nThe verification number is valid for 5 minutes from the time you receive it. \nYou can resend the verification number up to 5 times a day.`
  String get changePhoneCertifyDescription {
    return Intl.message(
      'If you do not receive the verification number, please check if the information you entered is correct. \nThe verification number is valid for 5 minutes from the time you receive it. \nYou can resend the verification number up to 5 times a day.',
      name: 'changePhoneCertifyDescription',
      desc: 'Description for phone number certification',
      args: [],
    );
  }

  /// `Verification number`
  String get changePhoneCertifyInputNumberLabel {
    return Intl.message(
      'Verification number',
      name: 'changePhoneCertifyInputNumberLabel',
      desc: 'Label for verification number input',
      args: [],
    );
  }

  /// `Verification Number`
  String get changePhoneCertifyInputNumberHint {
    return Intl.message(
      'Verification Number',
      name: 'changePhoneCertifyInputNumberHint',
      desc: 'Hint for verification number input',
      args: [],
    );
  }

  /// `Enter verification number`
  String get changePhoneCertifyButtonReturnLabel {
    return Intl.message(
      'Enter verification number',
      name: 'changePhoneCertifyButtonReturnLabel',
      desc: 'Label for enter verification number button',
      args: [],
    );
  }

  /// `Verify`
  String get changePhoneCertifyButtonConfirmLabel {
    return Intl.message(
      'Verify',
      name: 'changePhoneCertifyButtonConfirmLabel',
      desc: 'Label for verify button',
      args: [],
    );
  }

  /// `Resend verification number`
  String get changePhoneCertifyButtonRetryLabel {
    return Intl.message(
      'Resend verification number',
      name: 'changePhoneCertifyButtonRetryLabel',
      desc: 'Label for resend verification number button',
      args: [],
    );
  }

  /// `Welcome!`
  String get signupHomeLabel {
    return Intl.message(
      'Welcome!',
      name: 'signupHomeLabel',
      desc: 'Label for signup home screen',
      args: [],
    );
  }

  /// `Start using Care&Co services \nafter a simple agreement`
  String get signupHomeDescription {
    return Intl.message(
      'Start using Care&Co services \nafter a simple agreement',
      name: 'signupHomeDescription',
      desc: 'Description for signup home screen',
      args: [],
    );
  }

  /// `Agree to all terms`
  String get signupHomeCheckboxAcceptAllLabel {
    return Intl.message(
      'Agree to all terms',
      name: 'signupHomeCheckboxAcceptAllLabel',
      desc: 'Label for accept all terms checkbox',
      args: [],
    );
  }

  /// `Agree to terms of use`
  String get signupHomeCheckboxTermsLabel {
    return Intl.message(
      'Agree to terms of use',
      name: 'signupHomeCheckboxTermsLabel',
      desc: 'Label for terms of use checkbox',
      args: [],
    );
  }

  /// `Agree to collection and use of personal information`
  String get signupHomeCheckboxPrivacyLabel {
    return Intl.message(
      'Agree to collection and use of personal information',
      name: 'signupHomeCheckboxPrivacyLabel',
      desc: 'Label for privacy checkbox',
      args: [],
    );
  }

  /// `Agree to terms`
  String get signupHomeButtonReturnLabel {
    return Intl.message(
      'Agree to terms',
      name: 'signupHomeButtonReturnLabel',
      desc: 'Label for agree to terms button',
      args: [],
    );
  }

  /// `Next`
  String get signupHomeButtonNextLabel {
    return Intl.message(
      'Next',
      name: 'signupHomeButtonNextLabel',
      desc: 'Label for next button',
      args: [],
    );
  }

  /// `Please enter the phone number or E-mail \nto use as your Fisica ID`
  String get signupIdLabel {
    return Intl.message(
      'Please enter the phone number or E-mail \nto use as your Fisica ID',
      name: 'signupIdLabel',
      desc: 'Label for signup ID screen',
      args: [],
    );
  }

  /// `E-mail`
  String get signupIdInputEmailLabel {
    return Intl.message(
      'E-mail',
      name: 'signupIdInputEmailLabel',
      desc: 'Label for email input',
      args: [],
    );
  }

  /// `Please enter your E-mail`
  String get signupIdInputEmailHint {
    return Intl.message(
      'Please enter your E-mail',
      name: 'signupIdInputEmailHint',
      desc: 'Hint for email input',
      args: [],
    );
  }

  /// `Please enter a valid email including @`
  String get signupIdInputEmailError {
    return Intl.message(
      'Please enter a valid email including @',
      name: 'signupIdInputEmailError',
      desc: 'Error message for invalid email',
      args: [],
    );
  }

  /// `Phone number`
  String get signupIdInputPhoneLabel {
    return Intl.message(
      'Phone number',
      name: 'signupIdInputPhoneLabel',
      desc: 'Label for phone number input',
      args: [],
    );
  }

  /// ``
  String get signupIdInputPhoneHint {
    return Intl.message(
      '',
      name: 'signupIdInputPhoneHint',
      desc: 'Hint for phone number input',
      args: [],
    );
  }

  /// `Please enter numbers only`
  String get signupIdInputPhoneError {
    return Intl.message(
      'Please enter numbers only',
      name: 'signupIdInputPhoneError',
      desc: 'Error message for invalid phone number',
      args: [],
    );
  }

  /// `Country Code`
  String get signupIdSelectPhoneLabel {
    return Intl.message(
      'Country Code',
      name: 'signupIdSelectPhoneLabel',
      desc: 'Label for country code selection',
      args: [],
    );
  }

  /// `Create account`
  String get signupIdButtonReturnLabel {
    return Intl.message(
      'Create account',
      name: 'signupIdButtonReturnLabel',
      desc: 'Label for create account button',
      args: [],
    );
  }

  /// `Next`
  String get signupIdButtonNextLabel {
    return Intl.message(
      'Next',
      name: 'signupIdButtonNextLabel',
      desc: 'Label for next button',
      args: [],
    );
  }

  /// `Please enter the password to use when logging in`
  String get signupPasswordLabel {
    return Intl.message(
      'Please enter the password to use when logging in',
      name: 'signupPasswordLabel',
      desc: 'Label for signup password screen',
      args: [],
    );
  }

  /// `Password`
  String get signupPasswordInputPasswordLabel {
    return Intl.message(
      'Password',
      name: 'signupPasswordInputPasswordLabel',
      desc: 'Label for password input',
      args: [],
    );
  }

  /// `password`
  String get signupPasswordInputPasswordHint {
    return Intl.message(
      'password',
      name: 'signupPasswordInputPasswordHint',
      desc: 'Hint for password input',
      args: [],
    );
  }

  /// `Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters`
  String get signupPasswordInputPasswordError {
    return Intl.message(
      'Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters',
      name: 'signupPasswordInputPasswordError',
      desc: 'Error message for invalid password',
      args: [],
    );
  }

  /// `Confirm password`
  String get signupPasswordCheckPasswordLabel {
    return Intl.message(
      'Confirm password',
      name: 'signupPasswordCheckPasswordLabel',
      desc: 'Label for confirm password input',
      args: [],
    );
  }

  /// `password`
  String get signupPasswordCheckPasswordHint {
    return Intl.message(
      'password',
      name: 'signupPasswordCheckPasswordHint',
      desc: 'Hint for confirm password input',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get signupPasswordCheckPasswordError {
    return Intl.message(
      'Passwords do not match',
      name: 'signupPasswordCheckPasswordError',
      desc: 'Error message for mismatched passwords',
      args: [],
    );
  }

  /// `Passwords match`
  String get signupPasswordCheckPasswordSuccess {
    return Intl.message(
      'Passwords match',
      name: 'signupPasswordCheckPasswordSuccess',
      desc: 'Success message for matched passwords',
      args: [],
    );
  }

  /// `Enter password`
  String get signupPasswordButtonReturnLabel {
    return Intl.message(
      'Enter password',
      name: 'signupPasswordButtonReturnLabel',
      desc: 'Label for enter password button',
      args: [],
    );
  }

  /// `Next`
  String get signupPasswordButtonNextLabel {
    return Intl.message(
      'Next',
      name: 'signupPasswordButtonNextLabel',
      desc: 'Label for next button',
      args: [],
    );
  }

  /// `Please enter user information`
  String get signupUserInfoLabel {
    return Intl.message(
      'Please enter user information',
      name: 'signupUserInfoLabel',
      desc: 'Label for user information screen',
      args: [],
    );
  }

  /// `Last name`
  String get signupUserInfoInputLastNameLabel {
    return Intl.message(
      'Last name',
      name: 'signupUserInfoInputLastNameLabel',
      desc: 'Label for last name input',
      args: [],
    );
  }

  /// `000`
  String get signupUserInfoInputLastNameHint {
    return Intl.message(
      '000',
      name: 'signupUserInfoInputLastNameHint',
      desc: 'Hint for last name input',
      args: [],
    );
  }

  /// `First name`
  String get signupUserInfoInputFirstNameLabel {
    return Intl.message(
      'First name',
      name: 'signupUserInfoInputFirstNameLabel',
      desc: 'Label for first name input',
      args: [],
    );
  }

  /// `000`
  String get signupUserInfoInputFirstNameHint {
    return Intl.message(
      '000',
      name: 'signupUserInfoInputFirstNameHint',
      desc: 'Hint for first name input',
      args: [],
    );
  }

  /// `Date of birth`
  String get signupUserInfoInputBirthLabel {
    return Intl.message(
      'Date of birth',
      name: 'signupUserInfoInputBirthLabel',
      desc: 'Label for birth date input',
      args: [],
    );
  }

  /// `00/00/00`
  String get signupUserInfoInputBirthHint {
    return Intl.message(
      '00/00/00',
      name: 'signupUserInfoInputBirthHint',
      desc: 'Hint for birth date input',
      args: [],
    );
  }

  /// `Height`
  String get signupUserInfoInputHeightLabel {
    return Intl.message(
      'Height',
      name: 'signupUserInfoInputHeightLabel',
      desc: 'Label for height input',
      args: [],
    );
  }

  /// `000`
  String get signupUserInfoInputHeightHint {
    return Intl.message(
      '000',
      name: 'signupUserInfoInputHeightHint',
      desc: 'Hint for height input',
      args: [],
    );
  }

  /// `Weight`
  String get signupUserInfoInputWeightLabel {
    return Intl.message(
      'Weight',
      name: 'signupUserInfoInputWeightLabel',
      desc: 'Label for weight input',
      args: [],
    );
  }

  /// `000`
  String get signupUserInfoInputWeightHint {
    return Intl.message(
      '000',
      name: 'signupUserInfoInputWeightHint',
      desc: 'Hint for weight input',
      args: [],
    );
  }

  /// `Enter user information`
  String get signupUserInfoButtonReturnLabel {
    return Intl.message(
      'Enter user information',
      name: 'signupUserInfoButtonReturnLabel',
      desc: 'Label for enter user information button',
      args: [],
    );
  }

  /// `Complete`
  String get signupUserInfoButtonCompleteLabel {
    return Intl.message(
      'Complete',
      name: 'signupUserInfoButtonCompleteLabel',
      desc: 'Label for complete button',
      args: [],
    );
  }

  /// `Country`
  String get signupUserInfoSelectCountryLabel {
    return Intl.message(
      'Country',
      name: 'signupUserInfoSelectCountryLabel',
      desc: 'Label for country selection',
      args: [],
    );
  }

  /// `Gender`
  String get signupUserInfoButtonGenderLabel {
    return Intl.message(
      'Gender',
      name: 'signupUserInfoButtonGenderLabel',
      desc: 'Label for gender selection',
      args: [],
    );
  }

  /// `Male`
  String get signupUserInfoButtonGenderMaleLabel {
    return Intl.message(
      'Male',
      name: 'signupUserInfoButtonGenderMaleLabel',
      desc: 'Label for male gender selection',
      args: [],
    );
  }

  /// `Female`
  String get signupUserInfoButtonGenderFemaleLabel {
    return Intl.message(
      'Female',
      name: 'signupUserInfoButtonGenderFemaleLabel',
      desc: 'Label for female gender selection',
      args: [],
    );
  }

  /// `Cannot log in`
  String get popupErrorLoginLabel {
    return Intl.message(
      'Cannot log in',
      name: 'popupErrorLoginLabel',
      desc: 'Label for login error',
      args: [],
    );
  }

  /// `Cannot verify phone number`
  String get popupErrorLoginPhoneDescription {
    return Intl.message(
      'Cannot verify phone number',
      name: 'popupErrorLoginPhoneDescription',
      desc: 'Description for phone verification error',
      args: [],
    );
  }

  /// `Cannot verify E-mail`
  String get popupErrorLoginEmailDescription {
    return Intl.message(
      'Cannot verify E-mail',
      name: 'popupErrorLoginEmailDescription',
      desc: 'Description for email verification error',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get popupErrorLoginPasswordDescription {
    return Intl.message(
      'Passwords do not match',
      name: 'popupErrorLoginPasswordDescription',
      desc: 'Description for password mismatch error',
      args: [],
    );
  }

  /// `If you are not a member yet`
  String get popupErrorLoginSuggestionLabel {
    return Intl.message(
      'If you are not a member yet',
      name: 'popupErrorLoginSuggestionLabel',
      desc: 'Suggestion for non-members',
      args: [],
    );
  }

  /// `Sign up`
  String get popupErrorLoginButtonSignupLabel {
    return Intl.message(
      'Sign up',
      name: 'popupErrorLoginButtonSignupLabel',
      desc: 'Label for signup button',
      args: [],
    );
  }

  /// `Confirm`
  String get popupErrorLoginButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'popupErrorLoginButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Phone number already in use.`
  String get popupErrorSignupPhoneDuplicatedLabel {
    return Intl.message(
      'Phone number already in use.',
      name: 'popupErrorSignupPhoneDuplicatedLabel',
      desc: 'Label for phone duplication error',
      args: [],
    );
  }

  /// `Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail.`
  String get popupErrorSignupPhoneDuplicatedDescription {
    return Intl.message(
      'Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail.',
      name: 'popupErrorSignupPhoneDuplicatedDescription',
      desc: 'Description for phone duplication error',
      args: [],
    );
  }

  /// `Return to log in`
  String get popupErrorSignupPhoneDuplicatedButtonReturnLabel {
    return Intl.message(
      'Return to log in',
      name: 'popupErrorSignupPhoneDuplicatedButtonReturnLabel',
      desc: 'Label for return to login button',
      args: [],
    );
  }

  /// `Confirm`
  String get popupErrorSignupPhoneDuplicatedButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'popupErrorSignupPhoneDuplicatedButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `E-mail already in use.`
  String get popupErrorSignupEmailDuplicatedLabel {
    return Intl.message(
      'E-mail already in use.',
      name: 'popupErrorSignupEmailDuplicatedLabel',
      desc: 'Label for email duplication error',
      args: [],
    );
  }

  /// `Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail.`
  String get popupErrorSignupEmailDuplicatedDescription {
    return Intl.message(
      'Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail.',
      name: 'popupErrorSignupEmailDuplicatedDescription',
      desc: 'Description for email duplication error',
      args: [],
    );
  }

  /// `Return to log in`
  String get popupErrorSignupEmailDuplicatedButtonReturnLabel {
    return Intl.message(
      'Return to log in',
      name: 'popupErrorSignupEmailDuplicatedButtonReturnLabel',
      desc: 'Label for return to login button',
      args: [],
    );
  }

  /// `Confirm`
  String get popupErrorSignupEmailDuplicatedButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'popupErrorSignupEmailDuplicatedButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Verification number error`
  String get popupErrorCertifyInvalidLabel {
    return Intl.message(
      'Verification number error',
      name: 'popupErrorCertifyInvalidLabel',
      desc: 'Label for verification number error',
      args: [],
    );
  }

  /// `Please enter the 6-digit verification number sent`
  String get popupErrorCertifyInvalidDescription {
    return Intl.message(
      'Please enter the 6-digit verification number sent',
      name: 'popupErrorCertifyInvalidDescription',
      desc: 'Description for invalid verification number',
      args: [],
    );
  }

  /// `To re-enter the phone number`
  String get popupErrorCertifyInvalidSuggestion {
    return Intl.message(
      'To re-enter the phone number',
      name: 'popupErrorCertifyInvalidSuggestion',
      desc: 'Suggestion for invalid verification number',
      args: [],
    );
  }

  /// `Return to start`
  String get popupErrorCertifyInvalidButtonReturnLabel {
    return Intl.message(
      'Return to start',
      name: 'popupErrorCertifyInvalidButtonReturnLabel',
      desc: 'Label for return to start button',
      args: [],
    );
  }

  /// `Resend`
  String get popupErrorCertifyInvalidButtonResendLabel {
    return Intl.message(
      'Resend',
      name: 'popupErrorCertifyInvalidButtonResendLabel',
      desc: 'Label for resend button',
      args: [],
    );
  }

  /// `Verification number attempt exceeded`
  String get popupErrorCertifyOverTryLabel {
    return Intl.message(
      'Verification number attempt exceeded',
      name: 'popupErrorCertifyOverTryLabel',
      desc: 'Label for exceeded verification attempts',
      args: [],
    );
  }

  /// `You have exceeded the SMS verification request limit \nfor this phone number. \nPlease try again after 24 hours.`
  String get popupErrorCertifyOverTryDescription {
    return Intl.message(
      'You have exceeded the SMS verification request limit \nfor this phone number. \nPlease try again after 24 hours.',
      name: 'popupErrorCertifyOverTryDescription',
      desc: 'Description for exceeded verification attempts',
      args: [],
    );
  }

  /// `Confirm`
  String get popupErrorCertifyOverTryButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'popupErrorCertifyOverTryButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Network error`
  String get popupErrorNetworkLabel {
    return Intl.message(
      'Network error',
      name: 'popupErrorNetworkLabel',
      desc: 'Label for network error',
      args: [],
    );
  }

  /// `Failed to receive server response. \nPlease check your network status. \nIf the problem persists, please wait a moment and \ntry again!`
  String get popupErrorNetworkResponseDescription {
    return Intl.message(
      'Failed to receive server response. \nPlease check your network status. \nIf the problem persists, please wait a moment and \ntry again!',
      name: 'popupErrorNetworkResponseDescription',
      desc: 'Description for network error',
      args: [],
    );
  }

  /// `Confirm`
  String get popupErrorNetworkButtonConfirmLabel {
    return Intl.message(
      'Confirm',
      name: 'popupErrorNetworkButtonConfirmLabel',
      desc: 'Label for confirm button',
      args: [],
    );
  }

  /// `Application error`
  String get popupErrorAppLabel {
    return Intl.message(
      'Application error',
      name: 'popupErrorAppLabel',
      desc: 'Label for application error',
      args: [],
    );
  }

  /// `Fisica has been forcibly closed. \nWould you like to continue with the sign up?`
  String get popupErrorAppSignupDescription {
    return Intl.message(
      'Fisica has been forcibly closed. \nWould you like to continue with the sign up?',
      name: 'popupErrorAppSignupDescription',
      desc: 'Description for application signup error',
      args: [],
    );
  }

  /// `To continue with the sign up`
  String get popupErrorAppSignupSuggestionLabel {
    return Intl.message(
      'To continue with the sign up',
      name: 'popupErrorAppSignupSuggestionLabel',
      desc: 'Suggestion for continuing signup',
      args: [],
    );
  }

  /// `Continue`
  String get popupErrorAppSignupButtonContinueLabel {
    return Intl.message(
      'Continue',
      name: 'popupErrorAppSignupButtonContinueLabel',
      desc: 'Label for continue button',
      args: [],
    );
  }

  /// `Return to start`
  String get popupErrorAppSignupButtonReturnLabel {
    return Intl.message(
      'Return to start',
      name: 'popupErrorAppSignupButtonReturnLabel',
      desc: 'Label for return to start button',
      args: [],
    );
  }

  /// `Verification link sent \nto account E-mail`
  String get popupCompleteCertifyEmailLabel {
    return Intl.message(
      'Verification link sent \nto account E-mail',
      name: 'popupCompleteCertifyEmailLabel',
      desc: 'Label for email certification',
      args: [],
    );
  }

  /// `A verification link has been sent to the account’s \nE-mail to change the phone number. \nPlease verify yourself and change the phone number!`
  String get popupCompleteCertifyEmailDescription {
    return Intl.message(
      'A verification link has been sent to the account’s \nE-mail to change the phone number. \nPlease verify yourself and change the phone number!',
      name: 'popupCompleteCertifyEmailDescription',
      desc: 'Description for email certification',
      args: [],
    );
  }

  /// `Resend`
  String get popupCompleteCertifyEmailButtonResendLabel {
    return Intl.message(
      'Resend',
      name: 'popupCompleteCertifyEmailButtonResendLabel',
      desc: 'Label for resend button',
      args: [],
    );
  }

  /// `Return to start`
  String get popupCompleteCertifyEmailButtonReturnLabel {
    return Intl.message(
      'Return to start',
      name: 'popupCompleteCertifyEmailButtonReturnLabel',
      desc: 'Label for return to start button',
      args: [],
    );
  }

  /// `Resend verification number`
  String get popupResendCertifyLabel {
    return Intl.message(
      'Resend verification number',
      name: 'popupResendCertifyLabel',
      desc: 'Label for resend verification number',
      args: [],
    );
  }

  /// `Please check the phone number you entered again`
  String get popupResendCertifyDescription {
    return Intl.message(
      'Please check the phone number you entered again',
      name: 'popupResendCertifyDescription',
      desc: 'Description for resend verification number',
      args: [],
    );
  }

  /// `The phone number you entered is as follows.`
  String get popupResendCertifyInfoLabel {
    return Intl.message(
      'The phone number you entered is as follows.',
      name: 'popupResendCertifyInfoLabel',
      desc: 'Label for phone number info',
      args: [],
    );
  }

  /// `010 - 1234 - 5678`
  String get popupResendCertifyInfoDescription {
    return Intl.message(
      '010 - 1234 - 5678',
      name: 'popupResendCertifyInfoDescription',
      desc: 'Description for phone number info',
      args: [],
    );
  }

  /// `Resend`
  String get popupResendCertifyButtonResendLabel {
    return Intl.message(
      'Resend',
      name: 'popupResendCertifyButtonResendLabel',
      desc: 'Label for resend button',
      args: [],
    );
  }

  /// `Modify phone number`
  String get popupResendCertifyButtonModifyLabel {
    return Intl.message(
      'Modify phone number',
      name: 'popupResendCertifyButtonModifyLabel',
      desc: 'Label for modify phone number button',
      args: [],
    );
  }

  /// `Terms of Service`
  String get popupInfoTermsServiceLabel {
    return Intl.message(
      'Terms of Service',
      name: 'popupInfoTermsServiceLabel',
      desc: 'Label for terms of service',
      args: [],
    );
  }

  /// `Agree`
  String get popupInfoTermsServiceButtonAgreeLabel {
    return Intl.message(
      'Agree',
      name: 'popupInfoTermsServiceButtonAgreeLabel',
      desc: 'Label for agree button',
      args: [],
    );
  }

  /// `Cancel password change`
  String get popupDecideChangePasswordLabel {
    return Intl.message(
      'Cancel password change',
      name: 'popupDecideChangePasswordLabel',
      desc: 'Label for cancel password change',
      args: [],
    );
  }

  /// `Cancel the password change and \nreturn to the login screen`
  String get popupDecideChangePasswordDescription {
    return Intl.message(
      'Cancel the password change and \nreturn to the login screen',
      name: 'popupDecideChangePasswordDescription',
      desc: 'Description for cancel password change',
      args: [],
    );
  }

  /// `Continue changing`
  String get popupDecideChangePasswordButtonContinueLabel {
    return Intl.message(
      'Continue changing',
      name: 'popupDecideChangePasswordButtonContinueLabel',
      desc: 'Label for continue changing button',
      args: [],
    );
  }

  /// `Return to start`
  String get popupDecideChangePasswordButtonReturnLabel {
    return Intl.message(
      'Return to start',
      name: 'popupDecideChangePasswordButtonReturnLabel',
      desc: 'Label for return to start button',
      args: [],
    );
  }

  /// `Cancel sign up?`
  String get popupDecideSignupLabel {
    return Intl.message(
      'Cancel sign up?',
      name: 'popupDecideSignupLabel',
      desc: 'Label for cancel signup',
      args: [],
    );
  }

  /// `If you cancel, all data will be deleted and \nyou will need to sign up again to use Fisica.`
  String get popupDecideSignupDescription {
    return Intl.message(
      'If you cancel, all data will be deleted and \nyou will need to sign up again to use Fisica.',
      name: 'popupDecideSignupDescription',
      desc: 'Description for cancel signup',
      args: [],
    );
  }

  /// `Continue`
  String get popupDecideSignupButtonContinueLabel {
    return Intl.message(
      'Continue',
      name: 'popupDecideSignupButtonContinueLabel',
      desc: 'Label for continue button',
      args: [],
    );
  }

  /// `Cancel sign up`
  String get popupDecideSignupButtonReturnLabel {
    return Intl.message(
      'Cancel sign up',
      name: 'popupDecideSignupButtonReturnLabel',
      desc: 'Label for cancel signup button',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
