// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "changePasswordButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "changePasswordButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "changePasswordCheckPasswordError":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "changePasswordCheckPasswordHint":
            MessageLookupByLibrary.simpleMessage("password"),
        "changePasswordCheckPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "changePasswordCheckPasswordSuccess":
            MessageLookupByLibrary.simpleMessage("Passwords match"),
        "changePasswordInputPasswordError": MessageLookupByLibrary.simpleMessage(
            "Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters"),
        "changePasswordInputPasswordHint":
            MessageLookupByLibrary.simpleMessage("password"),
        "changePasswordInputPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "changePasswordLabel":
            MessageLookupByLibrary.simpleMessage("Please enter a new password"),
        "changePhoneButtonNextLabel":
            MessageLookupByLibrary.simpleMessage("Next"),
        "changePhoneButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Change phone number"),
        "changePhoneCertifyButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Verify"),
        "changePhoneCertifyButtonRetryLabel":
            MessageLookupByLibrary.simpleMessage("Resend verification number"),
        "changePhoneCertifyButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Enter verification number"),
        "changePhoneCertifyDescription": MessageLookupByLibrary.simpleMessage(
            "If you do not receive the verification number, please check if the information you entered is correct. \nThe verification number is valid for 5 minutes from the time you receive it. \nYou can resend the verification number up to 5 times a day."),
        "changePhoneCertifyInputNumberHint":
            MessageLookupByLibrary.simpleMessage("Verification Number"),
        "changePhoneCertifyInputNumberLabel":
            MessageLookupByLibrary.simpleMessage("Verification number"),
        "changePhoneInputPhoneError":
            MessageLookupByLibrary.simpleMessage("Please enter numbers only"),
        "changePhoneInputPhoneHint": MessageLookupByLibrary.simpleMessage(""),
        "changePhoneInputPhoneLabel":
            MessageLookupByLibrary.simpleMessage("Phone number"),
        "changePhoneLabel": MessageLookupByLibrary.simpleMessage(
            "Please re-enter the changed phone number"),
        "completeLoginButtonFindPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Find password"),
        "completeLoginButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Log in"),
        "completeLoginInputPasswordHint":
            MessageLookupByLibrary.simpleMessage("password"),
        "completeLoginInputPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "completeLoginLabel": MessageLookupByLibrary.simpleMessage(
            "Please enter \nyour password"),
        "findPasswordButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "findPasswordDescription": MessageLookupByLibrary.simpleMessage(
            "We can recover your account via the E-mail address"),
        "findPasswordInputEmailError": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email including @"),
        "findPasswordInputEmailHint":
            MessageLookupByLibrary.simpleMessage("Please enter your E-mail"),
        "findPasswordInputEmailLabel":
            MessageLookupByLibrary.simpleMessage("E-mail"),
        "findPasswordLabel": MessageLookupByLibrary.simpleMessage(
            "Please enter the registered E-mail"),
        "loginHomeButtonFindPasswordLabel":
            MessageLookupByLibrary.simpleMessage(
                "Did you change your phone number?"),
        "loginHomeButtonLoginLabel":
            MessageLookupByLibrary.simpleMessage("Log in"),
        "loginHomeButtonSignupLabel":
            MessageLookupByLibrary.simpleMessage("Sign up"),
        "loginHomeDescription": MessageLookupByLibrary.simpleMessage(
            "You need to log in to get started"),
        "loginHomeDividerLabel": MessageLookupByLibrary.simpleMessage("OR"),
        "loginHomeInputEmailError": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email including @"),
        "loginHomeInputEmailHint": MessageLookupByLibrary.simpleMessage(
            "Please enter your phone number or E-mail"),
        "loginHomeInputEmailLabel":
            MessageLookupByLibrary.simpleMessage("Phone number or E-mail"),
        "loginHomeInputPhoneError":
            MessageLookupByLibrary.simpleMessage("Please enter numbers only"),
        "loginHomeInputPhoneHint": MessageLookupByLibrary.simpleMessage(""),
        "loginHomeInputPhoneLabel":
            MessageLookupByLibrary.simpleMessage("Phone number"),
        "loginHomeLabel":
            MessageLookupByLibrary.simpleMessage("Nice to meet you!"),
        "loginHomeSelectLanguageLabel":
            MessageLookupByLibrary.simpleMessage("Language"),
        "loginHomeSelectPhoneLabel":
            MessageLookupByLibrary.simpleMessage("Country Code"),
        "popupCompleteCertifyEmailButtonResendLabel":
            MessageLookupByLibrary.simpleMessage("Resend"),
        "popupCompleteCertifyEmailButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to start"),
        "popupCompleteCertifyEmailDescription":
            MessageLookupByLibrary.simpleMessage(
                "A verification link has been sent to the account’s \nE-mail to change the phone number. \nPlease verify yourself and change the phone number!"),
        "popupCompleteCertifyEmailLabel": MessageLookupByLibrary.simpleMessage(
            "Verification link sent \nto account E-mail"),
        "popupDecideChangePasswordButtonContinueLabel":
            MessageLookupByLibrary.simpleMessage("Continue changing"),
        "popupDecideChangePasswordButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to start"),
        "popupDecideChangePasswordDescription":
            MessageLookupByLibrary.simpleMessage(
                "Cancel the password change and \nreturn to the login screen"),
        "popupDecideChangePasswordLabel":
            MessageLookupByLibrary.simpleMessage("Cancel password change"),
        "popupDecideSignupButtonContinueLabel":
            MessageLookupByLibrary.simpleMessage("Continue"),
        "popupDecideSignupButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Cancel sign up"),
        "popupDecideSignupDescription": MessageLookupByLibrary.simpleMessage(
            "If you cancel, all data will be deleted and \nyou will need to sign up again to use Fisica."),
        "popupDecideSignupLabel":
            MessageLookupByLibrary.simpleMessage("Cancel sign up?"),
        "popupErrorAppLabel":
            MessageLookupByLibrary.simpleMessage("Application error"),
        "popupErrorAppSignupButtonContinueLabel":
            MessageLookupByLibrary.simpleMessage("Continue"),
        "popupErrorAppSignupButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to start"),
        "popupErrorAppSignupDescription": MessageLookupByLibrary.simpleMessage(
            "Fisica has been forcibly closed. \nWould you like to continue with the sign up?"),
        "popupErrorAppSignupSuggestionLabel":
            MessageLookupByLibrary.simpleMessage(
                "To continue with the sign up"),
        "popupErrorCertifyInvalidButtonResendLabel":
            MessageLookupByLibrary.simpleMessage("Resend"),
        "popupErrorCertifyInvalidButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to start"),
        "popupErrorCertifyInvalidDescription":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the 6-digit verification number sent"),
        "popupErrorCertifyInvalidLabel":
            MessageLookupByLibrary.simpleMessage("Verification number error"),
        "popupErrorCertifyInvalidSuggestion":
            MessageLookupByLibrary.simpleMessage(
                "To re-enter the phone number"),
        "popupErrorCertifyOverTryButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "popupErrorCertifyOverTryDescription": MessageLookupByLibrary.simpleMessage(
            "You have exceeded the SMS verification request limit \nfor this phone number. \nPlease try again after 24 hours."),
        "popupErrorCertifyOverTryLabel": MessageLookupByLibrary.simpleMessage(
            "Verification number attempt exceeded"),
        "popupErrorLoginButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "popupErrorLoginButtonSignupLabel":
            MessageLookupByLibrary.simpleMessage("Sign up"),
        "popupErrorLoginEmailDescription":
            MessageLookupByLibrary.simpleMessage("Cannot verify E-mail"),
        "popupErrorLoginLabel":
            MessageLookupByLibrary.simpleMessage("Cannot log in"),
        "popupErrorLoginPasswordDescription":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "popupErrorLoginPhoneDescription":
            MessageLookupByLibrary.simpleMessage("Cannot verify phone number"),
        "popupErrorLoginSuggestionLabel":
            MessageLookupByLibrary.simpleMessage("If you are not a member yet"),
        "popupErrorNetworkButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "popupErrorNetworkLabel":
            MessageLookupByLibrary.simpleMessage("Network error"),
        "popupErrorNetworkResponseDescription":
            MessageLookupByLibrary.simpleMessage(
                "Failed to receive server response. \nPlease check your network status. \nIf the problem persists, please wait a moment and \ntry again!"),
        "popupErrorSignupEmailDuplicatedButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "popupErrorSignupEmailDuplicatedButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to log in"),
        "popupErrorSignupEmailDuplicatedDescription":
            MessageLookupByLibrary.simpleMessage(
                "Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail."),
        "popupErrorSignupEmailDuplicatedLabel":
            MessageLookupByLibrary.simpleMessage("E-mail already in use."),
        "popupErrorSignupPhoneDuplicatedButtonConfirmLabel":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "popupErrorSignupPhoneDuplicatedButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Return to log in"),
        "popupErrorSignupPhoneDuplicatedDescription":
            MessageLookupByLibrary.simpleMessage(
                "Please log in with an existing account or \nproceed with sign up using a different phone number or E-mail."),
        "popupErrorSignupPhoneDuplicatedLabel":
            MessageLookupByLibrary.simpleMessage(
                "Phone number already in use."),
        "popupInfoTermsServiceButtonAgreeLabel":
            MessageLookupByLibrary.simpleMessage("Agree"),
        "popupInfoTermsServiceLabel":
            MessageLookupByLibrary.simpleMessage("Terms of Service"),
        "popupResendCertifyButtonModifyLabel":
            MessageLookupByLibrary.simpleMessage("Modify phone number"),
        "popupResendCertifyButtonResendLabel":
            MessageLookupByLibrary.simpleMessage("Resend"),
        "popupResendCertifyDescription": MessageLookupByLibrary.simpleMessage(
            "Please check the phone number you entered again"),
        "popupResendCertifyInfoDescription":
            MessageLookupByLibrary.simpleMessage("010 - 1234 - 5678"),
        "popupResendCertifyInfoLabel": MessageLookupByLibrary.simpleMessage(
            "The phone number you entered is as follows."),
        "popupResendCertifyLabel":
            MessageLookupByLibrary.simpleMessage("Resend verification number"),
        "signupHomeButtonNextLabel":
            MessageLookupByLibrary.simpleMessage("Next"),
        "signupHomeButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Agree to terms"),
        "signupHomeCheckboxAcceptAllLabel":
            MessageLookupByLibrary.simpleMessage("Agree to all terms"),
        "signupHomeCheckboxPrivacyLabel": MessageLookupByLibrary.simpleMessage(
            "Agree to collection and use of personal information"),
        "signupHomeCheckboxTermsLabel":
            MessageLookupByLibrary.simpleMessage("Agree to terms of use"),
        "signupHomeDescription": MessageLookupByLibrary.simpleMessage(
            "Start using Care&Co services \nafter a simple agreement"),
        "signupHomeLabel": MessageLookupByLibrary.simpleMessage("Welcome!"),
        "signupIdButtonNextLabel": MessageLookupByLibrary.simpleMessage("Next"),
        "signupIdButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Create account"),
        "signupIdInputEmailError": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email including @"),
        "signupIdInputEmailHint":
            MessageLookupByLibrary.simpleMessage("Please enter your E-mail"),
        "signupIdInputEmailLabel":
            MessageLookupByLibrary.simpleMessage("E-mail"),
        "signupIdInputPhoneError":
            MessageLookupByLibrary.simpleMessage("Please enter numbers only"),
        "signupIdInputPhoneHint": MessageLookupByLibrary.simpleMessage(""),
        "signupIdInputPhoneLabel":
            MessageLookupByLibrary.simpleMessage("Phone number"),
        "signupIdLabel": MessageLookupByLibrary.simpleMessage(
            "Please enter the phone number or E-mail \nto use as your Fisica ID"),
        "signupIdSelectPhoneLabel":
            MessageLookupByLibrary.simpleMessage("Country Code"),
        "signupPasswordButtonNextLabel":
            MessageLookupByLibrary.simpleMessage("Next"),
        "signupPasswordButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Enter password"),
        "signupPasswordCheckPasswordError":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "signupPasswordCheckPasswordHint":
            MessageLookupByLibrary.simpleMessage("password"),
        "signupPasswordCheckPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "signupPasswordCheckPasswordSuccess":
            MessageLookupByLibrary.simpleMessage("Passwords match"),
        "signupPasswordInputPasswordError": MessageLookupByLibrary.simpleMessage(
            "Please use 8 - 24 characters including uppercase/lowercase letters, numbers, and special characters"),
        "signupPasswordInputPasswordHint":
            MessageLookupByLibrary.simpleMessage("password"),
        "signupPasswordInputPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Password"),
        "signupPasswordLabel": MessageLookupByLibrary.simpleMessage(
            "Please enter the password to use when logging in"),
        "signupUserInfoButtonCompleteLabel":
            MessageLookupByLibrary.simpleMessage("Complete"),
        "signupUserInfoButtonGenderFemaleLabel":
            MessageLookupByLibrary.simpleMessage("Female"),
        "signupUserInfoButtonGenderLabel":
            MessageLookupByLibrary.simpleMessage("Gender"),
        "signupUserInfoButtonGenderMaleLabel":
            MessageLookupByLibrary.simpleMessage("Male"),
        "signupUserInfoButtonReturnLabel":
            MessageLookupByLibrary.simpleMessage("Enter user information"),
        "signupUserInfoInputBirthHint":
            MessageLookupByLibrary.simpleMessage("00/00/00"),
        "signupUserInfoInputBirthLabel":
            MessageLookupByLibrary.simpleMessage("Date of birth"),
        "signupUserInfoInputFirstNameHint":
            MessageLookupByLibrary.simpleMessage("000"),
        "signupUserInfoInputFirstNameLabel":
            MessageLookupByLibrary.simpleMessage("First name"),
        "signupUserInfoInputHeightHint":
            MessageLookupByLibrary.simpleMessage("000"),
        "signupUserInfoInputHeightLabel":
            MessageLookupByLibrary.simpleMessage("Height"),
        "signupUserInfoInputLastNameHint":
            MessageLookupByLibrary.simpleMessage("000"),
        "signupUserInfoInputLastNameLabel":
            MessageLookupByLibrary.simpleMessage("Last name"),
        "signupUserInfoInputWeightHint":
            MessageLookupByLibrary.simpleMessage("000"),
        "signupUserInfoInputWeightLabel":
            MessageLookupByLibrary.simpleMessage("Weight"),
        "signupUserInfoLabel": MessageLookupByLibrary.simpleMessage(
            "Please enter user information"),
        "signupUserInfoSelectCountryLabel":
            MessageLookupByLibrary.simpleMessage("Country")
      };
}
