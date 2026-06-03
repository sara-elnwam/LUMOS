import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/medical_profile_screen.dart';
import 'screens/biometrics_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/verify_code_screen.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _all = {
    'en': {
      'tap_toggle_to_change': 'Tap the toggle to change status',
      'code_sent_to_email': 'Verification code sent to your email',
      'settings': 'Settings',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'devices': 'devices',
      'lh': 'Left Hand',
      'rh': 'Right Hand',
      'll': 'Left Leg',
      'rl': 'Right Leg',
      'pos_tl': 'Top left, Left Hand Sensor',
      'pos_tr': 'Top right, Right Hand Sensor',
      'pos_bl': 'Bottom left, Left Leg Sensor',
      'pos_br': 'Bottom right, Right Leg Sensor',
      'bracelets': 'Bracelets',
      'show_bracelets': 'Show {count} bracelets',
      'lumo_band': 'Lumo Band',
      'earbuds': 'Earbuds',
      'smart_cane': 'Smart Cane',
      'smart_glasses': 'Smart Glasses',
      'account': 'Account',
      'updates': 'Updates',
      'help_feedback': 'Help and Feedback',
      'about_lumos': 'About Lumos',
      'profile': 'Profile',
      'personal_info_security': 'Personal info & security',
      'health_data_records': 'Health data & records',
      'lumo_band_screen': 'Lumo Band screen',
      'earbuds_screen': 'Earbuds screen',
      'smart_cane_screen': 'Smart Cane screen',
      'smart_glasses_screen': 'Smart Glasses screen',
      'battery_36': 'Battery 36 percent',
      'time_remaining_3h': 'Estimated time remaining: 3 hours and 20 minutes',
      'device_on': 'Device is on',
      'device_off': 'Device is off',
      'lumo_band_on': 'Lumo Band on',
      'lumo_band_off': 'Lumo Band off',
      'earbuds_on': 'Earbuds on',
      'earbuds_off': 'Earbuds off',
      'smart_cane_on': 'Smart Cane on',
      'smart_cane_off': 'Smart Cane off',
      'smart_glasses_on': 'Smart Glasses on',
      'smart_glasses_off': 'Smart Glasses off',
      'settings_screen_desc': 'Settings screen. You can manage your account, medical profile, language, and more.',
      'opening': 'Opening {label}',
      'connected_devices': '{count} devices Connected',
      'listening': 'Listening...',
      'lumos_thinking': 'Lumos is thinking...',
      'speak': 'Speak...',
      'didnt_hear_anything': 'I didn\'t hear anything, please try again',
      'technical_error': 'Technical error: {error}',
      'choose_language': 'Choose Language',
      'subtitle': 'Select your preferred language to customize your experience.',
      'search': 'Search languages...',
      'next': 'Next',
      'default_lang': 'Default system language',
      'welcome': 'Welcome to Lumos',
      'choose_voice': 'Choose A Voice For Your Assistant',
      'male_voice': 'Male Voice',
      'female_voice': 'Female Voice',
      'verify_code_title': 'Verify Code',
      'verify_code_subtitle': 'Enter the 6-digit code sent to {email}',
      'verification_code': 'Verification Code',
      'enter_code': 'Enter 6-digit code',
      'verify_button': 'Verify',
      'verify_code_instruction': 'Long press to speak your verification code',
      'prompt_say_code': 'Say your 6-digit code now',
      'prompt_confirm_code': 'You said: {value}. Tap to confirm',
      'invalid_code_length': 'Code must be 6 digits',
      'create_account': 'Create A New Account',
      'already_account': 'Already Have An Account',
      'sign_in_title': 'Welcome Back',
      'voice_mode_short': 'Voice',
      'manual_mode_short': 'Manual',
      'swipe_instruction': 'Swipe up for {voice}. Swipe down for {manual}. Double tap to select.',
      'swipe_repeat': 'Swipe up for Voice. Swipe down for Manual. Double tap.',
      'selected': '{mode} selected.',
      'sign_in_welcome': 'Welcome back. Sign in to your account.',
      'invalid_credentials': 'Invalid email or password. Please try again.',
      'wrong_password': 'Incorrect password. Please try again.',
      'email_not_found': 'No account found with this email.',
      'network_error': 'Network error. Please check your connection.',
      'welcome_choice': 'Choose how you want to experience Lumos',
      'forgot_password': 'Forgot password?',
      'api_error': 'Something went wrong. Please try again.',
      'sign_up': 'Sign up',
      'sign_in': 'Sign in',
      'full_name': 'Full name',
      'enter_name': 'Enter your full name',
      'email': 'Email address',
      'reset_password_title': 'Reset Password',
      'reset_password_subtitle': 'Enter your email and new password to reset your password.',
      'reset_password': 'Reset Password',
      'reset_password_instruction': 'Let\'s reset your password. Follow the instructions.',
      'password_reset_success': 'Password reset successfully! Please sign in with your new password.',
      'invalid_reset_token': 'Invalid reset link. Please request a new one.',
      'enter_password': 'Please enter your password.',
      'password_too_short': 'Password must be at least 6 characters.',
      'passwords_do_not_match': 'Passwords do not match.',
      'new_password': 'New Password',
      'enter_email': 'Enter your email',
      'password': 'Password',
      'create_password': 'Create a password',
      'repeat_password': 'Repeat password',
      'confirm_password': 'Confirm your password',
      'create_acc_title': 'Create account',
      'medical_profile': 'Medical Profile',
      'sex': 'Sex',
      'male': 'Male',
      'female': 'Female',
      'blood_type': 'Blood Type',
      'allergies': 'Allergies',
      'medications': 'Medications',
      'diseases': 'Diseases',
      'continue': 'Continue',
      'splash_welcome': 'Welcome to Lumos. Your intelligent accessibility companion.',
      'onboard_mode_hint': 'Tap Voice Mode or Manual Mode to choose.',
      'onboard_repeat_hint': 'Choose Voice Mode or Manual Mode.',
      'lang_reading': 'Listening to languages. Tap when you hear yours.',
      'voice_preview_sentence': 'See beyond limits with Lumos.',
      'voice_hint_female': 'Swipe up to choose the female voice.',
      'voice_hint_male': 'Swipe down to choose the male voice.',
      'getstarted_swipe_hint': 'Swipe up if you already have an account. Swipe down to create a new one.',
      'gesture_login_hint': 'Draw S on screen to sign up, or L to sign in.',
      'gesture_detected_s': 'Sign up detected. Opening registration.',
      'gesture_detected_l': 'Sign in detected. Opening login.',
      'shake_help': 'You are on {screen}. {hint}',
      'screen_curtain_on': 'Screen curtain on. Display is now private.',
      'screen_curtain_off': 'Screen curtain off.',
      'home_welcome': 'Welcome back, {name}. You have 4 devices connected. Hold anywhere to speak.',
      'tts_listening': 'Listening…',
      'home_no_api_key': 'AI key not configured.',
      'home_ai_error': 'Sorry, something went wrong. Please try again.',
      'home_navigating': 'Opening {device}.',
      'forgot_password_title': 'Forgot Password',
      'forgot_password_subtitle': 'Enter your email address and we\'ll send you a link to reset your password.',
      'send_reset_link': 'Send Reset Link',
      'reset_link_sent': 'Reset link sent successfully! Please check your email.',
      'back_to_sign_in': 'Back to Sign In',
      'forgot_password_instruction': 'Long press anywhere to speak your email address.',
      'prompt_say_field_email': 'Say your email address now.',
      'prompt_confirm_entry_email': 'You said: {value}. Tap once to confirm. Double-tap to redo.',
      'invalid_email_format': 'Please enter a valid email address.',
      'lumos_word': 'Lumos',
      'mode_title': 'Choose your experience',
      'voice_mode': 'Voice Mode',
      'tts_stt_on': 'TTS + STT on',
      'manual_mode': 'Manual Mode',
      'no_voice': 'No voice at all',
      'swipe_hint': 'or swipe up / down',
      'lang_screen_hint': 'You are on the language selection screen. Your device language is {lang}. Tap once to keep it. Double-tap to browse other languages.',
      'lang_tap_hint': 'Tap anytime to select the language you hear.',
      'voice_screen_hint': 'You are in the voice assistant selection screen. Swipe up for female voice, swipe down for male voice.',
      'double_tap_confirm': 'Double tap to confirm',
      'battery_time': 'Estimated time remaining : 3h 20m',
      'toggle_on': 'On',
      'toggle_off': 'Off',
      'cane_connected': 'Cane is connected',
      'cane_disconnected': 'Cane is disconnected',
      'cane_battery': 'Battery is 36 percent',
      'cane_time': 'Estimated time remaining is 3 hours and 20 minutes',
      'prompt_enter_field': 'To enter {field}, long-press anywhere.',
      'prompt_say_field': 'Say your {field} now.',
      'prompt_heard_nothing': 'Nothing heard. Long-press to try again.',
      'prompt_password_chars': 'Password with {n} characters.',
      'prompt_confirm_entry': 'You entered: {value}. Tap once to confirm. Double-tap to redo.',
      // New keys for Wizard Mode
      'saved': 'Saved',
      'field_required': 'This field is required',
      'press_and_hold_to_speak': 'Press and hold to speak',
      'tap_to_confirm_double_to_redo': 'Tap once to confirm, double tap to redo',
      'prompt_try_again': 'Please try again',
      // Biometrics Keys
      'biometrics_title': 'Set up Biometrics',
      'biometrics_instruction': 'Let\'s set up your fingerprint. You\'ll scan your finger 4 times — it only takes a moment.',
      'biometrics_scan_start': 'Scan {current} of {total}. Place your finger gently on the sensor.',
      'biometrics_scan_reason': 'Scan {current} of {total} — place your finger',
      'biometrics_scan_1': 'Hold still — scan one',
      'biometrics_scan_2': 'Perfect! — scan two',
      'biometrics_scan_3': 'Nearly done — scan three',
      'biometrics_scan_4': 'Last one — scan four',
      'biometrics_scan_default': 'Keep your finger steady',
      'biometrics_lift_finger': 'Great! Lift your finger. {remaining} more to go.',
      'biometrics_lift_message': 'Lift your finger and place it again\n({remaining} scan(s) remaining)',
      'biometrics_success': 'Fingerprint saved!',
      'biometrics_complete': 'All done! Your fingerprint is set up.',
      'biometrics_failed': 'Didn\'t catch that. Try once more.',
      'biometrics_unavailable': 'No fingerprint found on this device. You can skip for now.',
      'biometrics_error_not_enrolled': 'No fingerprints set up.\nAdd one in your device Settings.',
      'biometrics_error_locked': 'Too many tries. Please wait a moment.',
      'biometrics_error_permanent': 'Fingerprint locked. Please use your device PIN.',
      'biometrics_error_default': 'Something went wrong. Give it another try.',
      'biometrics_status_scanning': 'Scanning...',
      'biometrics_status_lift': 'Lift finger ↑',
      'biometrics_status_success': 'Verified ✓',
      'biometrics_status_failed': 'Failed ✗',
      'biometrics_status_unavailable': 'Unavailable',
      'biometrics_status_ready': 'Ready',
      'biometrics_done_button': 'DONE',
      'biometrics_done_button_label': 'Done. All biometrics setup complete. Tap to go home',
      'biometrics_skip_button': 'Skip for now',
      'biometrics_skip_button_label': 'Skip biometrics setup for now',
      'biometrics_tryagain_button': 'Try Again',
      'biometrics_tryagain_button_label': 'Try again. Double tap to restart scan',
      'biometrics_semantics': 'Biometrics setup screen. Progress: {progress}%. Current status: {status}.',
      'biometrics_scanner_label': 'Fingerprint scanner. Progress circle shows {progress}%. {status}',
      'biometrics_scans_complete': '{completed} of {total} scans complete',
      'biometrics_percent': '{percent}% complete',
      'biometrics_place_finger': 'Place your finger on the sensor',
      'voice_tap_instruction': 'Tap right for {male}. Tap left for {female}. Double tap to confirm your choice.',
      'swipe_hint_visual': 'Swipe up for Voice · Swipe down for Manual',
    },
    'ar': {
      'bracelets': 'الأساور',
      'show_bracelets': 'عرض {count} أساور',
      'lumo_band': 'لومو باند',
      'earbuds': 'السماعات',
      'smart_cane': 'العصا الذكية',
      'smart_glasses': 'النظارة الذكية',
      'account': 'الحساب',
      'updates': 'التحديثات',
      'help_feedback': 'المساعدة والملاحظات',
      'about_lumos': 'عن لوموس',
      'profile': 'الملف الشخصي',
      'personal_info_security': 'المعلومات الشخصية\nوالأمان',
      'health_data_records': 'البيانات الصحية\nوالسجلات',
      'lumo_band_screen': 'شاشة لومو باند',
      'earbuds_screen': 'شاشة السماعات',
      'smart_cane_screen': 'شاشة العصا الذكية',
      'smart_glasses_screen': 'شاشة النظارة الذكية',
      'battery_36': 'البطارية ٣٦ بالمئة',
      'time_remaining_3h': 'الوقت المتبقي التقريبي: ٣ ساعات و ٢٠ دقيقة',
      'device_on': 'الجهاز مفعّل',
      'device_off': 'الجهاز معطّل',
      'lumo_band_on': 'لومو باند مفعّل',
      'lumo_band_off': 'لومو باند معطّل',
      'earbuds_on': 'السماعات مفعّلة',
      'earbuds_off': 'السماعات معطّلة',
      'smart_cane_on': 'العصا الذكية مفعّلة',
      'smart_cane_off': 'العصا الذكية معطّلة',
      'smart_glasses_on': 'النظارة الذكية مفعّلة',
      'smart_glasses_off': 'النظارة الذكية معطّلة',
      'settings_screen_desc': 'شاشة الإعدادات. يمكنك إدارة حسابك، ملفك الطبي، اللغة، والمزيد.',
      'opening': 'فتح {label}',
      'connected_devices': '{count} أجهزة متصلة',
      'listening': 'جاري الاستماع...',
      'lumos_thinking': 'لوموس يفكر...',
      'speak': 'تكلم...',
      'didnt_hear_anything': 'لم أسمع شيئاً، حاول مرة أخرى',
      'technical_error': 'خطأ تقني: {error}',
      'voice_tap_instruction': 'اضغط يميناً  {male}. اضغط شمالاً  {female}. اضغط مرتين للتأكيد.',
      'swipe_hint_visual': 'اسحب لأعلى للصوتي · اسحب لأسفل لليدوي',
      'choose_language': 'اختر اللغة',
      'subtitle': 'اختر لغتك المفضلة لتخصيص تجربتك.',
      'search': 'ابحث عن لغة...',
      'next': 'التالي',
      'default_lang': 'لغة النظام الافتراضية',
      'welcome': 'مرحباً بك في لوموس',
      'choose_voice': 'اختر صوتاً لمساعدك',
      'male_voice': ' ذكر',
      'welcome_choice': 'اختار كيف تريد تجربة لوموس',
      'female_voice': ' أنثى',
      'verify_code_title': 'تأكيد الرمز',
      'verify_code_subtitle': 'أدخل الرمز المكون من 6 أرقام المرسل إلى {email}',
      'verification_code': 'رمز التحقق',
      'enter_code': 'أدخل الرمز المكون من 6 أرقام',
      'verify_button': 'تحقق',
      'verify_code_instruction': 'اضغط مطولاً لتقول رمز التحقق الخاص بك',
      'prompt_say_code': 'قل رمز التحقق المكون من 6 أرقام الآن',
      'prompt_confirm_code': 'قلت: {value}. اضغط للتأكيد',
      'invalid_code_length': 'الرمز يجب أن يتكون من 6 أرقام',
      'create_account': 'إنشاء حساب جديد',
      'already_account': 'لدي حساب بالفعل',
      'sign_in_title': 'مرحباً بعودتك',
      'sign_in_welcome': 'أهلاً بعودتك. سجّل الدخول لحسابك.',
      'invalid_credentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة. حاول مرة أخرى.',
      'wrong_password': 'كلمة المرور غير صحيحة. حاول مرة أخرى.',
      'email_not_found': 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.',
      'network_error': 'خطأ في الشبكة. يرجى التحقق من الاتصال.',
      'forgot_password': 'نسيت كلمة المرور؟',
      'api_error': 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
      'sign_up': 'إنشاء حساب',
      'sign_in': 'تسجيل الدخول',
      'full_name': 'الاسم الكامل',
      'enter_name': 'أدخل اسمك الكامل',
      'voice_mode_short': 'صوتي',
      'manual_mode_short': 'يدوي',
      'swipe_instruction': 'اسحب لأعلى لـ {voice}. اسحب لأسفل لـ {manual}. اضغط مرتين للاختيار.',
      'swipe_repeat': 'اسحب لأعلى صوتي. اسحب لأسفل يدوي. اضغط مرتين.',
      'selected': 'تم اختيار {mode}.',
      'email': 'البريد الإلكتروني',
      'reset_password_title': 'إعادة تعيين كلمة المرور',
      'reset_password_subtitle': 'أدخل بريدك الإلكتروني وكلمة المرور الجديدة لإعادة تعيين كلمة المرور.',
      'reset_password': 'إعادة تعيين',
      'reset_password_instruction': 'دعنا نعيد تعيين كلمة المرور. اتبع التعليمات.',
      'password_reset_success': 'تم إعادة تعيين كلمة المرور بنجاح! يرجى تسجيل الدخول بكلمة المرور الجديدة.',
      'invalid_reset_token': 'رمز إعادة التعيين غير صالح. يرجى طلب رمز جديد.',
      'enter_password': 'يرجى إدخال كلمة المرور.',
      'password_too_short': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.',
      'passwords_do_not_match': 'كلمتا المرور غير متطابقتين.',
      'new_password': 'كلمة المرور الجديدة',
      'enter_email': 'أدخل بريدك الإلكتروني',
      'password': 'كلمة المرور',
      'create_password': 'أنشئ كلمة مرور',
      'repeat_password': 'تأكيد كلمة المرور',
      'confirm_password': 'أكد كلمة المرور',
      'create_acc_title': 'إنشاء حساب',
      'medical_profile': 'الملف الطبي',
      'sex': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'blood_type': 'فصيلة الدم',
      'allergies': 'الحساسية',
      'medications': 'الأدوية',
      'diseases': 'الأمراض',
      'continue': 'متابعة',
      'splash_welcome': 'مرحباً بك في لوموس. رفيقك الذكي لإمكانية الوصول.',
      'onboard_mode_hint': 'اضغط على وضع الصوت أو الوضع اليدوي للاختيار.',
      'onboard_repeat_hint': 'اختر وضع الصوت أو الوضع اليدوي.',
      'lang_reading': 'جارٍ قراءة اللغات. اضغط عند سماع لغتك.',
      'voice_preview_sentence': 'ابصر ما وراء الحدود مع لوموس.',
      'voice_hint_female': 'اسحب لأعلى لاختيار صوت الأنثى.',
      'voice_hint_male': 'اسحب لأسفل لاختيار صوت الذكر.',
      'getstarted_swipe_hint': 'اسحب لأعلى إذا كان لديك حساب. اسحب لأسفل لإنشاء حساب جديد.',
      'gesture_login_hint': 'ارسم حرف S للتسجيل، أو حرف L لتسجيل الدخول.',
      'gesture_detected_s': 'تم اكتشاف التسجيل. فتح صفحة الإنشاء.',
      'gesture_detected_l': 'تم اكتشاف تسجيل الدخول. فتح صفحة الدخول.',
      'shake_help': 'أنت في {screen}. {hint}',
      'screen_curtain_on': 'ستارة الشاشة مفعّلة. الشاشة الآن خاصة.',
      'screen_curtain_off': 'ستارة الشاشة معطّلة.',
      'home_welcome': 'أهلاً {name}. لديك 4 أجهزة متصلة. اضغط مطولاً في أي مكان وتحدث.',
      'tts_listening': 'جارٍ الاستماع…',
      'home_no_api_key': 'مفتاح الذكاء الاصطناعي غير مضبوط.',
      'home_ai_error': 'عذراً، حدث خطأ. حاول مرة أخرى.',
      'home_navigating': 'فتح {device}.',
      'forgot_password_title': 'نسيت كلمة المرور',
      'forgot_password_subtitle': 'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
      'send_reset_link': 'إرسال رابط إعادة التعيين',
      'reset_link_sent': 'تم إرسال رابط إعادة التعيين بنجاح! يرجى التحقق من بريدك الإلكتروني.',
      'back_to_sign_in': 'العودة إلى تسجيل الدخول',
      'forgot_password_instruction': 'اضغط مطولاً في أي مكان لتقول بريدك الإلكتروني.',
      'prompt_say_field_email': 'قل بريدك الإلكتروني الآن.',
      'prompt_confirm_entry_email': 'قلت: {value}. اضغط مرة للتأكيد. اضغط مرتين للإعادة.',
      'invalid_email_format': 'يرجى إدخال بريد إلكتروني صحيح.',
      'lumos_word': 'لوموس',
      'mode_title': 'اختر طريقة تجربتك',
      'voice_mode': 'وضع الصوت',
      'tts_stt_on': 'TTS + STT مفعّل',
      'manual_mode': 'الوضع اليدوي',
      'no_voice': 'بدون صوت نهائياً',
      'swipe_hint': 'أو اسحب لفوق / لتحت',
      'lang_screen_hint': 'أنت في شاشة اختيار اللغة. لغة جهازك هي {lang}. لتثبيت لغة جهازك اضغط ضغطة واحدة. لتصفح اللغات الأخرى اضغط ضغطتين.',
      'lang_tap_hint': 'اضغط في أي وقت لاختيار اللغة التي تسمعها.',
      'voice_screen_hint': 'أنت في شاشة اختيار مساعدك الصوتي. اسحب لأعلى لصوت الأنثى، أو اسحب لأسفل لصوت الذكر.',
      'double_tap_confirm': 'للتأكيد اضغط ضغطتين',
      'battery_time': 'الوقت المتبقي التقريبي : ٣ س ٢٠ د',
      'toggle_on': 'تشغيل',
      'toggle_off': 'إيقاف',
      'cane_connected': 'العصا متصلة',
      'cane_disconnected': 'العصا غير متصلة',
      'cane_battery': 'البطارية ٣٦ بالمئة',
      'cane_time': 'الوقت المتبقي التقريبي ثلاث ساعات وعشرون دقيقة',
      'prompt_enter_field': 'لإدخال {field}، اضغط ضغطة مطوّلة في أي مكان.',
      'prompt_say_field': 'قل {field} الآن.',
      'prompt_heard_nothing': 'لم أسمع شيئاً. اضغط مطولاً للمحاولة مرة أخرى.',
      'prompt_password_chars': 'كلمة مرور من {n} حرف.',
      'prompt_confirm_entry': 'دخلت: {value}. ضغطة للتأكيد. ضغطتين للإعادة.',
      // New keys for Wizard Mode
      'saved': 'تم الحفظ',
      'field_required': 'هذا الحقل مطلوب',
      'press_and_hold_to_speak': 'اضغط مطولاً للتحدث',
      'tap_to_confirm_double_to_redo': 'ضغطة للتأكيد، ضغطتين للإعادة',
      'prompt_try_again': 'حاول مرة أخرى',
      // Biometrics Keys
      'biometrics_title': 'إعداد البصمة',
      'biometrics_instruction': 'أهلاً بك في إعداد البصمة. ستحتاج إلى مسح إصبعك أربع مرات. سنرشدك خطوة بخطوة.',
      'biometrics_scan_start': 'بدء المسح {current} من {total}. ضع إصبعك على المستشعر.',
      'biometrics_scan_reason': 'المسح {current} من {total} — ضع إصبعك',
      'biometrics_scan_1': 'ثبّت إصبعك — المسح الأول',
      'biometrics_scan_2': 'ممتاز! استمر — المسح الثاني',
      'biometrics_scan_3': 'اقتربنا! — المسح الثالث',
      'biometrics_scan_4': 'آخر مرة! — المسح الرابع',
      'biometrics_scan_default': 'ثبّت إصبعك بشكل محكم',
      'biometrics_lift_finger': 'ارفع إصبعك. تبقى {remaining} مسح.',
      'biometrics_lift_message': 'ارفع إصبعك وضعه من جديد\n(تبقى {remaining} مسح)',
      'biometrics_success': 'تم التحقق من البصمة!',
      'biometrics_complete': 'انتهينا! تم إعداد البصمة بنجاح.',
      'biometrics_failed': 'لم نتعرف على البصمة. حاول مرة أخرى.',
      'biometrics_unavailable': 'لا توجد بصمة مسجّلة على جهازك. يمكنك تخطي هذه الخطوة.',
      'biometrics_error_not_enrolled': 'لا توجد بصمات مسجّلة.\nأضف بصمتك من إعدادات الجهاز.',
      'biometrics_error_locked': 'تجاوزت عدد المحاولات. انتظر قليلاً.',
      'biometrics_error_permanent': 'تم قفل البصمة. استخدم رقم PIN الخاص بجهازك.',
      'biometrics_error_default': 'حدث خطأ ما. حاول مرة أخرى.',
      'biometrics_status_scanning': 'جارٍ المسح...',
      'biometrics_status_lift': 'ارفع إصبعك ↑',
      'biometrics_status_success': 'تم التحقق ✓',
      'biometrics_status_failed': 'فشل المسح ✗',
      'biometrics_status_unavailable': 'غير متاح',
      'biometrics_status_ready': 'جاهز',
      'biometrics_done_button': 'تم',
      'biometrics_done_button_label': 'تم. اكتمل إعداد البصمة. اضغط للانتقال للرئيسية',
      'biometrics_skip_button': 'تخطي الآن',
      'biometrics_skip_button_label': 'تخطي إعداد البصمة الآن',
      'biometrics_tryagain_button': 'حاول مرة أخرى',
      'biometrics_tryagain_button_label': 'حاول مرة أخرى. اضغط ضغطتين لإعادة المسح',
      'biometrics_semantics': 'شاشة إعداد البصمة. التقدم: {progress}٪. الحالة الحالية: {status}.',
      'biometrics_scanner_label': 'ماسح البصمة. دائرة التقدم تُظهر {progress}٪. {status}',
      'biometrics_scans_complete': 'اكتمل {completed} من {total} مسح',
      'biometrics_percent': 'اكتمل {percent}٪',
      'biometrics_place_finger': 'ضع إصبعك على المستشعر',
      'tap_toggle_to_change': 'اضغط على التبديل لتغيير الحالة',
      'code_sent_to_email': 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
      'settings': 'الإعدادات',
      'connected': 'متصل',
      'disconnected': 'غير متصل',
      'devices': 'أجهزة',
      'lh': 'اليد اليسرى',
      'rh': 'اليد اليمنى',
      'll': 'القدم اليسرى',
      'rl': 'القدم اليمنى',
      'pos_tl': 'أعلى اليسار، حساس اليد اليسرى',
      'pos_tr': 'أعلى اليمين، حساس اليد اليمنى',
      'pos_bl': 'أسفل اليسار، حساس القدم اليسرى',
      'pos_br': 'أسفل اليمين، حساس القدم اليمنى',
    },
    'es': {
      'tap_toggle_to_change': 'Toque el interruptor para cambiar el estado',
      'code_sent_to_email': 'Código de verificación enviado a su correo electrónico',
      'settings': 'Configuración',
      'connected': 'Conectado',
      'disconnected': 'Desconectado',
      'devices': 'dispositivos',
      'lh': 'Mano Izquierda',
      'rh': 'Mano Derecha',
      'll': 'Pierna Izquierda',
      'rl': 'Pierna Derecha',
      'pos_tl': 'Arriba a la izquierda, sensor de la mano izquierda',
      'pos_tr': 'Arriba a la derecha, sensor de la mano derecha',
      'pos_bl': 'Abajo a la izquierda, sensor de la pierna izquierda',
      'pos_br': 'Abajo a la derecha, sensor de la pierna derecha',
      'bracelets': 'Pulseras',
      'show_bracelets': 'Mostrar {count} pulseras',
      'lumo_band': 'Lumo Band',
      'earbuds': 'Auriculares',
      'smart_cane': 'Bastón Inteligente',
      'smart_glasses': 'Gafas Inteligentes',
      'account': 'Cuenta',
      'updates': 'Actualizaciones',
      'help_feedback': 'Ayuda y Comentarios',
      'about_lumos': 'Acerca de Lumos',
      'profile': 'Perfil',
      'personal_info_security': 'Información personal\ny seguridad',
      'health_data_records': 'Datos de salud\ny registros',
      'lumo_band_screen': 'Pantalla de Lumo Band',
      'earbuds_screen': 'Pantalla de Auriculares',
      'smart_cane_screen': 'Pantalla de Bastón Inteligente',
      'smart_glasses_screen': 'Pantalla de Gafas Inteligentes',
      'battery_36': 'Batería al 36 por ciento',
      'time_remaining_3h': 'Tiempo restante estimado: 3 horas y 20 minutos',
      'device_on': 'Dispositivo encendido',
      'device_off': 'Dispositivo apagado',
      'lumo_band_on': 'Lumo Band encendido',
      'lumo_band_off': 'Lumo Band apagado',
      'earbuds_on': 'Auriculares encendidos',
      'earbuds_off': 'Auriculares apagados',
      'smart_cane_on': 'Bastón inteligente encendido',
      'smart_cane_off': 'Bastón inteligente apagado',
      'smart_glasses_on': 'Gafas inteligentes encendidas',
      'smart_glasses_off': 'Gafas inteligentes apagadas',
      'settings_screen_desc': 'Pantalla de configuración. Puedes gestionar tu cuenta, perfil médico, idioma y más.',
      'opening': 'Abriendo {label}',
      'connected_devices': '{count} dispositivos conectados',
      'listening': 'Escuchando...',
      'lumos_thinking': 'Lumos está pensando...',
      'speak': 'Habla...',
      'didnt_hear_anything': 'No escuché nada, por favor intenta de nuevo',
      'technical_error': 'Error técnico: {error}',
      'voice_tap_instruction': 'Toque a la derecha para {male}. Toque a la izquierda para {female}. Toque dos veces para confirmar.',
      'swipe_hint_visual': 'Desliza arriba para Voz · Desliza abajo para Manual',
      'choose_language': 'Elegir idioma',
      'voice_mode_short': 'Voz',
      'welcome_choice': 'Elige cómo quieres experimentar Lumos',
      'manual_mode_short': 'Manual',
      'swipe_instruction': 'Desliza arriba para {voice}. Desliza abajo para {manual}. Doble toque para seleccionar.',
      'swipe_repeat': 'Desliza arriba Voz. Desliza abajo Manual. Doble toque.',
      'selected': '{mode} seleccionado.',
      'subtitle': 'Selecciona tu idioma preferido.',
      'search': 'Buscar idiomas...',
      'next': 'Siguiente',
      'default_lang': 'Idioma del sistema',
      'welcome': 'Bienvenido a Lumos',
      'choose_voice': 'Elige Una Voz Para Tu Asistente',
      'male_voice': 'Voz Masculina',
      'female_voice': 'Voz Femenina',
      'verify_code_title': 'Verificar Código',
      'verify_code_subtitle': 'Ingrese el código de 6 dígitos enviado a {email}',
      'verification_code': 'Código de verificación',
      'enter_code': 'Ingrese el código de 6 dígitos',
      'verify_button': 'Verificar',
      'verify_code_instruction': 'Mantenga presionado para decir su código de verificación',
      'prompt_say_code': 'Diga su código de 6 dígitos ahora',
      'prompt_confirm_code': 'Dijo: {value}. Toque para confirmar',
      'invalid_code_length': 'El código debe tener 6 dígitos',
      'create_account': 'Crear Una Nueva Cuenta',
      'already_account': 'Ya Tengo Una Cuenta',
      'sign_in_title': 'Bienvenido de nuevo',
      'sign_in_welcome': 'Bienvenido de nuevo. Inicia sesión en tu cuenta.',
      'invalid_credentials': 'Correo o contraseña incorrectos. Intenta de nuevo.',
      'wrong_password': 'Contraseña incorrecta. Inténtalo de nuevo.',
      'email_not_found': 'No se encontró ninguna cuenta con este correo electrónico.',
      'network_error': 'Error de red. Por favor, revisa tu conexión.',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'api_error': 'Algo salió mal. Por favor, inténtalo de nuevo.',
      'sign_up': 'Registrarse',
      'sign_in': 'Iniciar sesión',
      'full_name': 'Nombre completo',
      'enter_name': 'Ingresa tu nombre',
      'email': 'Correo electrónico',
      'reset_password_title': 'Restablecer Contraseña',
      'reset_password_subtitle': 'Ingresa tu correo electrónico y nueva contraseña para restablecer tu contraseña.',
      'reset_password': 'Restablecer Contraseña',
      'reset_password_instruction': 'Vamos a restablecer tu contraseña. Sigue las instrucciones.',
      'password_reset_success': '¡Contraseña restablecida con éxito! Inicia sesión con tu nueva contraseña.',
      'invalid_reset_token': 'Enlace de restablecimiento inválido. Por favor, solicita uno nuevo.',
      'enter_password': 'Por favor, ingresa tu contraseña.',
      'password_too_short': 'La contraseña debe tener al menos 6 caracteres.',
      'passwords_do_not_match': 'Las contraseñas no coinciden.',
      'new_password': 'Nueva Contraseña',
      'enter_email': 'Ingresa tu correo',
      'password': 'Contraseña',
      'create_password': 'Crea una contraseña',
      'repeat_password': 'Repetir contraseña',
      'confirm_password': 'Confirma tu contraseña',
      'create_acc_title': 'Crear cuenta',
      'medical_profile': 'Perfil Médico',
      'sex': 'Sexo',
      'male': 'Masculino',
      'female': 'Femenino',
      'blood_type': 'Tipo de sangre',
      'allergies': 'Alergias',
      'medications': 'Medicamentos',
      'diseases': 'Enfermedades',
      'continue': 'Continuar',
      'splash_welcome': 'Bienvenido a Lumos. Tu compañero de accesibilidad.',
      'onboard_mode_hint': 'Toca Modo Voz o Modo Manual para elegir.',
      'onboard_repeat_hint': 'Elige Modo Voz o Modo Manual.',
      'lang_reading': 'Escuchando idiomas. Toca cuando escuches el tuyo.',
      'voice_preview_sentence': 'Ve más allá de los límites con Lumos.',
      'voice_hint_female': 'Para elegir voz femenina, presiona la tarjeta derecha.',
      'voice_hint_male': 'Para elegir voz masculina, presiona la tarjeta izquierda.',
      'getstarted_swipe_hint': 'Desliza arriba si tienes cuenta. Desliza abajo para crear una.',
      'gesture_login_hint': 'Dibuja S para registrarse, o L para iniciar sesión.',
      'gesture_detected_s': 'Registro detectado. Abriendo formulario.',
      'gesture_detected_l': 'Inicio de sesión detectado.',
      'shake_help': 'Estás en {screen}. {hint}',
      'screen_curtain_on': 'Cortina de pantalla activada.',
      'screen_curtain_off': 'Cortina de pantalla desactivada.',
      'home_welcome': 'Bienvenido de nuevo, {name}. Tienes 4 dispositivos conectados.',
      'tts_listening': 'Escuchando…',
      'home_no_api_key': 'Clave de IA no configurada.',
      'home_ai_error': 'Lo siento, algo salió mal.',
      'home_navigating': 'Abriendo {device}.',
      'forgot_password_title': 'Olvidé mi contraseña',
      'forgot_password_subtitle': 'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
      'send_reset_link': 'Enviar enlace de restablecimiento',
      'reset_link_sent': '¡Enlace de restablecimiento enviado con éxito! Por favor, revisa tu correo electrónico.',
      'back_to_sign_in': 'Volver a Iniciar sesión',
      'forgot_password_instruction': 'Mantén presionado en cualquier lugar para decir tu correo electrónico.',
      'prompt_say_field_email': 'Di tu correo electrónico ahora.',
      'prompt_confirm_entry_email': 'Dijiste: {value}. Toca una vez para confirmar. Doble toque para repetir.',
      'invalid_email_format': 'Por favor, ingresa un correo electrónico válido.',
      'lumos_word': 'Lumos',
      'mode_title': 'Elige tu experiencia',
      'voice_mode': 'Modo Voz',
      'tts_stt_on': 'TTS + STT activado',
      'manual_mode': 'Modo Manual',
      'no_voice': 'Sin voz',
      'swipe_hint': 'o desliza arriba / abajo',
      'lang_screen_hint': 'Estás en la pantalla de idioma. Tu idioma es {lang}. Toca una vez para mantenerlo. Doble toque para explorar.',
      'lang_tap_hint': 'Toca en cualquier momento para seleccionar el idioma que escuchas.',
      'voice_screen_hint': 'Estás en la pantalla de voz. Desliza arriba para voz femenina, abajo para masculina.',
      'double_tap_confirm': 'Doble toque para confirmar',
      'battery_time': 'Tiempo restante estimado : 3h 20m',
      'toggle_on': 'Encendido',
      'toggle_off': 'Apagado',
      'cane_connected': 'El bastón está conectado',
      'cane_disconnected': 'El bastón está desconectado',
      'cane_battery': 'Batería al 36 por ciento',
      'cane_time': 'Tiempo restante estimado: 3 horas y 20 minutos',
      'prompt_enter_field': 'Para ingresar {field}, mantén presionado.',
      'prompt_say_field': 'Di tu {field} ahora.',
      'prompt_heard_nothing': 'No escuché nada. Mantén presionado para intentar de nuevo.',
      'prompt_password_chars': 'Contraseña con {n} caracteres.',
      'prompt_confirm_entry': 'Ingresaste: {value}. Toca para confirmar. Doble toque para rehacer.',
      // New keys for Wizard Mode
      'saved': 'Guardado',
      'field_required': 'Este campo es obligatorio',
      'press_and_hold_to_speak': 'Mantén presionado para hablar',
      'tap_to_confirm_double_to_redo': 'Toca una vez para confirmar, dos veces para repetir',
      'prompt_try_again': 'Por favor, inténtalo de nuevo',
      // Biometrics Keys
      'biometrics_title': 'Configurar Biometría',
      'biometrics_instruction': 'Bienvenido a la configuración de biometría. Necesitarás escanear tu huella digital 4 veces. Sigue las instrucciones.',
      'biometrics_scan_start': 'Iniciando escaneo {current} de {total}. Coloca tu dedo en el sensor.',
      'biometrics_scan_reason': 'Escaneo {current} de {total} — coloca tu dedo',
      'biometrics_scan_1': 'Mantén firme — primer escaneo',
      'biometrics_scan_2': '¡Bien! Sigue así — segundo escaneo',
      'biometrics_scan_3': 'Casi listo — tercer escaneo',
      'biometrics_scan_4': '¡Último! — escaneo final',
      'biometrics_scan_default': 'Mantén tu dedo presionado firmemente',
      'biometrics_lift_finger': 'Levanta tu dedo. Quedan {remaining} escaneos.',
      'biometrics_lift_message': 'Levanta tu dedo y colócalo de nuevo\n({remaining} escaneo(s) restantes)',
      'biometrics_success': '¡Huella verificada!',
      'biometrics_complete': '¡Escaneos completados! Configuración biométrica exitosa.',
      'biometrics_failed': 'Autenticación fallida. Intenta de nuevo.',
      'biometrics_unavailable': 'No hay biometría registrada. Puedes omitir por ahora.',
      'biometrics_error_not_enrolled': 'No hay huellas registradas.\nAgrega una en Configuración.',
      'biometrics_error_locked': 'Demasiados intentos. Por favor espera.',
      'biometrics_error_permanent': 'Biometría bloqueada. Usa el PIN del dispositivo.',
      'biometrics_error_default': 'Algo salió mal. Intenta de nuevo.',
      'biometrics_status_scanning': 'Escaneando...',
      'biometrics_status_lift': 'Levanta el dedo ↑',
      'biometrics_status_success': 'Verificado ✓',
      'biometrics_status_failed': 'Fallido ✗',
      'biometrics_status_unavailable': 'No disponible',
      'biometrics_status_ready': 'Listo',
      'biometrics_done_button': 'LISTO',
      'biometrics_done_button_label': 'Listo. Configuración biométrica completada. Toca para ir al inicio',
      'biometrics_skip_button': 'Omitir por ahora',
      'biometrics_skip_button_label': 'Omitir configuración biométrica por ahora',
      'biometrics_tryagain_button': 'Intentar de nuevo',
      'biometrics_tryagain_button_label': 'Intentar de nuevo. Doble toque para reiniciar el escaneo',
      'biometrics_semantics': 'Pantalla de configuración biométrica. Progreso: {progress}%. Estado actual: {status}.',
      'biometrics_scanner_label': 'Escáner de huellas. El círculo de progreso muestra {progress}%. {status}',
      'biometrics_scans_complete': '{completed} de {total} escaneos completados',
      'biometrics_percent': '{percent}% completado',
    },
    'fr': {
      'tap_toggle_to_change': 'Appuyez sur le bouton pour changer l\'état',
      'code_sent_to_email': 'Code de vérification envoyé à votre email',
      'settings': 'Paramètres',
      'connected': 'Connecté',
      'disconnected': 'Déconnecté',
      'devices': 'appareils',
      'lh': 'Main Gauche',
      'rh': 'Main Droite',
      'll': 'Jambe Gauche',
      'rl': 'Jambe Droite',
      'pos_tl': 'En haut à gauche, capteur main gauche',
      'pos_tr': 'En haut à droite, capteur main droite',
      'pos_bl': 'En bas à gauche, capteur jambe gauche',
      'pos_br': 'En bas à droite, capteur jambe droite',
      'bracelets': 'Bracelets',
      'show_bracelets': 'Afficher {count} bracelets',
      'lumo_band': 'Lumo Band',
      'earbuds': 'Écouteurs',
      'smart_cane': 'Canne Intelligente',
      'smart_glasses': 'Lunettes Intelligentes',
      'account': 'Compte',
      'updates': 'Mises à jour',
      'help_feedback': 'Aide et Commentaires',
      'about_lumos': 'À propos de Lumos',
      'profile': 'Profil',
      'personal_info_security': 'Informations personnelles\net sécurité',
      'health_data_records': 'Données de santé\net dossiers',
      'lumo_band_screen': 'Écran Lumo Band',
      'earbuds_screen': 'Écran des écouteurs',
      'smart_cane_screen': 'Écran de la canne intelligente',
      'smart_glasses_screen': 'Écran des lunettes intelligentes',
      'battery_36': 'Batterie à 36 pour cent',
      'time_remaining_3h': 'Temps restant estimé: 3 heures et 20 minutes',
      'device_on': 'Appareil allumé',
      'device_off': 'Appareil éteint',
      'lumo_band_on': 'Lumo Band allumé',
      'lumo_band_off': 'Lumo Band éteint',
      'earbuds_on': 'Écouteurs allumés',
      'earbuds_off': 'Écouteurs éteints',
      'smart_cane_on': 'Canne intelligente allumée',
      'smart_cane_off': 'Canne intelligente éteinte',
      'smart_glasses_on': 'Lunettes intelligentes allumées',
      'smart_glasses_off': 'Lunettes intelligentes éteintes',
      'settings_screen_desc': 'Écran des paramètres. Vous pouvez gérer votre compte, profil médical, langue et plus.',
      'opening': 'Ouverture de {label}',
      'connected_devices': '{count} appareils connectés',
      'listening': 'Écoute...',
      'lumos_thinking': 'Lumos réfléchit...',
      'speak': 'Parlez...',
      'didnt_hear_anything': 'Je n\'ai rien entendu, veuillez réessayer',
      'technical_error': 'Erreur technique: {error}',
      'voice_tap_instruction': 'Appuyez à droite pour {male}. Appuyez à gauche pour {female}. Double-appuyez pour confirmer.',
      'swipe_hint_visual': 'Balayez vers le haut pour Vocal · Vers le bas pour Manuel',
      'welcome_choice': 'Choisissez comment vous voulez expérimenter Lumos',
      'choose_language': 'Choisir la langue',
      'subtitle': 'Sélectionnez votre langue préférée.',
      'search': 'Rechercher...',
      'next': 'Suivant',
      'default_lang': 'Langue système',
      'welcome': 'Bienvenue sur Lumos',
      'choose_voice': 'Choisissez Une Voix Pour Votre Assistant',
      'voice_mode_short': 'Vocal',
      'manual_mode_short': 'Manuel',
      'swipe_instruction': 'Balayez vers le haut pour {voice}. Balayez vers le bas pour {manual}. Double-appuyez pour sélectionner.',
      'swipe_repeat': 'Balayez haut Vocal. Balayez bas Manuel. Double-appuyez.',
      'selected': '{mode} sélectionné.',
      'female_voice': 'Voix Féminine',
      'verify_code_title': 'Vérifier le code',
      'verify_code_subtitle': 'Entrez le code à 6 chiffres envoyé à {email}',
      'verification_code': 'Code de vérification',
      'enter_code': 'Entrez le code à 6 chiffres',
      'verify_button': 'Vérifier',
      'verify_code_instruction': 'Appuyez longuement pour dire votre code de vérification',
      'prompt_say_code': 'Dites votre code à 6 chiffres maintenant',
      'prompt_confirm_code': 'Vous avez dit : {value}. Appuyez pour confirmer',
      'invalid_code_length': 'Le code doit comporter 6 chiffres',
      'create_account': 'Créer Un Nouveau Compte',
      'already_account': 'J\'ai Déjà Un Compte',
      'sign_in_title': 'Bon retour',
      'sign_in_welcome': 'Bon retour. Connectez-vous à votre compte.',
      'invalid_credentials': 'Email ou mot de passe incorrect. Veuillez réessayer.',
      'wrong_password': 'Mot de passe incorrect. Veuillez réessayer.',
      'email_not_found': 'Aucun compte trouvé avec cet email.',
      'network_error': 'Erreur réseau. Veuillez vérifier votre connexion.',
      'forgot_password': 'Mot de passe oublié ?',
      'api_error': 'Une erreur s\'est produite. Veuillez réessayer.',
      'sign_up': 'S\'inscrire',
      'sign_in': 'Se connecter',
      'full_name': 'Nom complet',
      'enter_name': 'Entrez votre nom',
      'email': 'Adresse e-mail',
      'reset_password_title': 'Réinitialiser le mot de passe',
      'reset_password_subtitle': 'Entrez votre adresse e-mail et votre nouveau mot de passe pour réinitialiser votre mot de passe.',
      'reset_password': 'Réinitialiser',
      'reset_password_instruction': 'Réinitialisons votre mot de passe. Suivez les instructions.',
      'password_reset_success': 'Mot de passe réinitialisé avec succès ! Veuillez vous connecter avec votre nouveau mot de passe.',
      'invalid_reset_token': 'Lien de réinitialisation invalide. Veuillez en demander un nouveau.',
      'enter_password': 'Veuillez entrer votre mot de passe.',
      'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères.',
      'passwords_do_not_match': 'Les mots de passe ne correspondent pas.',
      'new_password': 'Nouveau mot de passe',
      'enter_email': 'Entrez votre e-mail',
      'password': 'Mot de passe',
      'create_password': 'Créez un mot de passe',
      'repeat_password': 'Répéter le mot de passe',
      'confirm_password': 'Confirmez votre mot de passe',
      'create_acc_title': 'Créer un compte',
      'medical_profile': 'Profil Médical',
      'sex': 'Sexe',
      'male': 'Masculin',
      'female': 'Féminin',
      'blood_type': 'Groupe sanguin',
      'allergies': 'Allergies',
      'medications': 'Médicaments',
      'diseases': 'Maladies',
      'continue': 'Continuer',
      'splash_welcome': 'Bienvenue sur Lumos. Votre compagnon d\'accessibilité.',
      'onboard_mode_hint': 'Appuyez sur Mode Vocal ou Mode Manuel pour choisir.',
      'onboard_repeat_hint': 'Choisissez Mode Vocal ou Mode Manuel.',
      'lang_reading': 'Lecture des langues. Appuyez quand vous entendez la vôtre.',
      'voice_preview_sentence': 'Voyez au-delà des limites avec Lumos.',
      'voice_hint_female': 'Pour choisir la voix féminine, appuyez sur la carte droite.',
      'voice_hint_male': 'Pour choisir la voix masculine, appuyez sur la carte gauche.',
      'getstarted_swipe_hint': 'Glissez vers le haut si vous avez un compte. Vers le bas pour en créer un.',
      'gesture_login_hint': 'Dessinez S pour vous inscrire, ou L pour vous connecter.',
      'gesture_detected_s': 'Inscription détectée. Ouverture du formulaire.',
      'gesture_detected_l': 'Connexion détectée.',
      'shake_help': 'Vous êtes sur {screen}. {hint}',
      'screen_curtain_on': 'Rideau d\'écran activé.',
      'screen_curtain_off': 'Rideau d\'écran désactivé.',
      'home_welcome': 'Bon retour, {name}. Vous avez 4 appareils connectés.',
      'tts_listening': 'Écoute…',
      'home_no_api_key': 'Clé IA non configurée.',
      'home_ai_error': 'Désolé, une erreur est survenue.',
      'home_navigating': 'Ouverture de {device}.',
      'forgot_password_title': 'Mot de passe oublié',
      'forgot_password_subtitle': 'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
      'send_reset_link': 'Envoyer le lien de réinitialisation',
      'reset_link_sent': 'Lien de réinitialisation envoyé avec succès ! Veuillez vérifier votre e-mail.',
      'back_to_sign_in': 'Retour à la connexion',
      'forgot_password_instruction': 'Appuyez longuement n\'importe où pour dire votre adresse e-mail.',
      'prompt_say_field_email': 'Dites votre adresse e-mail maintenant.',
      'prompt_confirm_entry_email': 'Vous avez dit : {value}. Appuyez une fois pour confirmer. Double appui pour refaire.',
      'invalid_email_format': 'Veuillez entrer une adresse e-mail valide.',
      'lumos_word': 'Lumos',
      'mode_title': 'Choisissez votre expérience',
      'voice_mode': 'Mode Vocal',
      'tts_stt_on': 'TTS + STT activé',
      'manual_mode': 'Mode Manuel',
      'no_voice': 'Sans voix',
      'swipe_hint': 'ou glissez haut / bas',
      'lang_screen_hint': 'Vous êtes sur l\'écran de langue. Votre langue est {lang}. Appuyez une fois pour la garder. Double appui pour explorer.',
      'lang_tap_hint': 'Appuyez à tout moment pour sélectionner la langue que vous entendez.',
      'voice_screen_hint': 'Vous êtes sur l\'écran de voix. Glissez vers le haut pour voix féminine, vers le bas pour masculine.',
      'double_tap_confirm': 'Double appui pour confirmer',
      'battery_time': 'Temps restant estimé : 3h 20m',
      'toggle_on': 'Activé',
      'toggle_off': 'Désactivé',
      'cane_connected': 'La canne est connectée',
      'cane_disconnected': 'La canne est déconnectée',
      'cane_battery': 'Batterie à 36 pour cent',
      'cane_time': 'Temps restant estimé : 3 heures et 20 minutes',
      'prompt_enter_field': 'Pour entrer {field}, appuyez longuement.',
      'prompt_say_field': 'Dites votre {field} maintenant.',
      'prompt_heard_nothing': 'Rien entendu. Appuyez longuement pour réessayer.',
      'prompt_password_chars': 'Mot de passe de {n} caractères.',
      'prompt_confirm_entry': 'Vous avez dit: {value}. Appuyez pour confirmer. Double appui pour refaire.',
      // New keys for Wizard Mode
      'saved': 'Enregistré',
      'field_required': 'Ce champ est requis',
      'press_and_hold_to_speak': 'Appuyez longuement pour parler',
      'tap_to_confirm_double_to_redo': 'Appuyez une fois pour confirmer, deux fois pour refaire',
      'prompt_try_again': 'Veuillez réessayer',
      // Biometrics Keys
      'biometrics_title': 'Configurer la biométrie',
      'biometrics_instruction': 'Bienvenue dans la configuration biométrique. Vous devrez scanner votre empreinte digitale 4 fois. Suivez les instructions.',
      'biometrics_scan_start': 'Démarrage du scan {current} sur {total}. Placez votre doigt sur le capteur.',
      'biometrics_scan_reason': 'Scan {current} sur {total} — placez votre doigt',
      'biometrics_scan_1': 'Restez immobile — premier scan',
      'biometrics_scan_2': 'Bien ! Continuez — deuxième scan',
      'biometrics_scan_3': 'Presque terminé — troisième scan',
      'biometrics_scan_4': 'Dernier ! — scan final',
      'biometrics_scan_default': 'Maintenez votre doigt fermement',
      'biometrics_lift_finger': 'Soulevez votre doigt. {remaining} scans restants.',
      'biometrics_lift_message': 'Soulevez votre doigt et replacez-le\n({remaining} scan(s) restants)',
      'biometrics_success': 'Empreinte vérifiée !',
      'biometrics_complete': 'Scans terminés ! Configuration biométrique réussie.',
      'biometrics_failed': 'Échec de l\'authentification. Réessayez.',
      'biometrics_unavailable': 'Aucune biométrie enregistrée. Vous pouvez ignorer pour l\'instant.',
      'biometrics_error_not_enrolled': 'Aucune empreinte enregistrée.\nAjoutez-en une dans les paramètres.',
      'biometrics_error_locked': 'Trop de tentatives. Veuillez patienter.',
      'biometrics_error_permanent': 'Biométrie verrouillée. Utilisez le code PIN de l\'appareil.',
      'biometrics_error_default': 'Une erreur s\'est produite. Réessayez.',
      'biometrics_status_scanning': 'Scan en cours...',
      'biometrics_status_lift': 'Soulevez le doigt ↑',
      'biometrics_status_success': 'Vérifié ✓',
      'biometrics_status_failed': 'Échec ✗',
      'biometrics_status_unavailable': 'Indisponible',
      'biometrics_status_ready': 'Prêt',
      'biometrics_done_button': 'TERMINÉ',
      'biometrics_done_button_label': 'Terminé. Configuration biométrique complète. Appuyez pour aller à l\'accueil',
      'biometrics_skip_button': 'Ignorer pour l\'instant',
      'biometrics_skip_button_label': 'Ignorer la configuration biométrique pour l\'instant',
      'biometrics_tryagain_button': 'Réessayer',
      'biometrics_tryagain_button_label': 'Réessayer. Double appui pour redémarrer le scan',
      'biometrics_semantics': 'Écran de configuration biométrique. Progression : {progress}%. Statut actuel : {status}.',
      'biometrics_scanner_label': 'Scanner d\'empreintes. Le cercle de progression montre {progress}%. {status}',
      'biometrics_scans_complete': '{completed} de {total} scans terminés',
      'biometrics_percent': '{percent}% terminé',
    },
    'de': {
      'bracelets': 'Armbänder',
      'show_bracelets': '{count} Armbänder anzeigen',
      'lumo_band': 'Lumo Band',
      'earbuds': 'Ohrhörer',
      'smart_cane': 'Intelligenter Stock',
      'smart_glasses': 'Intelligente Brille',
      'account': 'Konto',
      'updates': 'Updates',
      'help_feedback': 'Hilfe und Feedback',
      'about_lumos': 'Über Lumos',
      'profile': 'Profil',
      'personal_info_security': 'Persönliche Informationen\nund Sicherheit',
      'health_data_records': 'Gesundheitsdaten\nund Aufzeichnungen',
      'lumo_band_screen': 'Lumo Band Bildschirm',
      'earbuds_screen': 'Ohrhörer Bildschirm',
      'smart_cane_screen': 'Intelligenter Stock Bildschirm',
      'smart_glasses_screen': 'Intelligente Brille Bildschirm',
      'battery_36': 'Akku bei 36 Prozent',
      'time_remaining_3h': 'Geschätzte verbleibende Zeit: 3 Stunden und 20 Minuten',
      'device_on': 'Gerät ist eingeschaltet',
      'device_off': 'Gerät ist ausgeschaltet',
      'lumo_band_on': 'Lumo Band eingeschaltet',
      'lumo_band_off': 'Lumo Band ausgeschaltet',
      'earbuds_on': 'Ohrhörer eingeschaltet',
      'earbuds_off': 'Ohrhörer ausgeschaltet',
      'smart_cane_on': 'Intelligenter Stock eingeschaltet',
      'smart_cane_off': 'Intelligenter Stock ausgeschaltet',
      'smart_glasses_on': 'Intelligente Brille eingeschaltet',
      'smart_glasses_off': 'Intelligente Brille ausgeschaltet',
      'settings_screen_desc': 'Einstellungsbildschirm. Sie können Ihr Konto, medizinisches Profil, Sprache und mehr verwalten.',
      'opening': 'Öffne {label}',
      'connected_devices': '{count} Geräte verbunden',
      'listening': 'Höre zu...',
      'lumos_thinking': 'Lumos denkt nach...',
      'speak': 'Sprechen Sie...',
      'didnt_hear_anything': 'Ich habe nichts gehört, bitte versuchen Sie es erneut',
      'technical_error': 'Technischer Fehler: {error}',
      'voice_tap_instruction': 'Tippen Sie rechts für {male}. Tippen Sie links für {female}. Doppeltippen Sie zum Bestätigen.',
      'swipe_hint_visual': 'Nach oben für Sprache · Nach unten für Manuell',
      'choose_language': 'Sprache wählen',
      'welcome_choice': 'Wähle, wie du Lumos erleben möchtest',
      'subtitle': 'Wähle deine bevorzugte Sprache.',
      'search': 'Sprachen suchen...',
      'next': 'Weiter',
      'default_lang': 'Standardsprache',
      'welcome': 'Willkommen bei Lumos',
      'choose_voice': 'Wähle Eine Stimme Für Deinen Assistenten',
      'male_voice': 'Männliche Stimme',
      'female_voice': 'Weibliche Stimme',
      'verify_code_title': 'Code bestätigen',
      'verify_code_subtitle': 'Geben Sie den 6-stelligen Code ein, der an {email} gesendet wurde',
      'verification_code': 'Bestätigungscode',
      'enter_code': 'Geben Sie den 6-stelligen Code ein',
      'verify_button': 'Bestätigen',
      'verify_code_instruction': 'Halten Sie gedrückt, um Ihren Bestätigungscode zu sagen',
      'prompt_say_code': 'Sagen Sie jetzt Ihren 6-stelligen Code',
      'prompt_confirm_code': 'Sie sagten: {value}. Tippen Sie zum Bestätigen',
      'invalid_code_length': 'Der Code muss 6 Ziffern haben',
      'create_account': 'Neues Konto Erstellen',
      'already_account': 'Ich Habe Bereits Ein Konto',
      'sign_in_title': 'Willkommen zurück',
      'sign_in_welcome': 'Willkommen zurück. Melde dich in deinem Konto an.',
      'invalid_credentials': 'Ungültige E-Mail oder Passwort. Bitte versuche es erneut.',
      'wrong_password': 'Falsches Passwort. Bitte versuche es erneut.',
      'email_not_found': 'Kein Konto mit dieser E-Mail gefunden.',
      'network_error': 'Netzwerkfehler. Bitte überprüfe deine Verbindung.',
      'forgot_password': 'Passwort vergessen?',
      'api_error': 'Etwas ist schief gelaufen. Bitte versuche es erneut.',
      'sign_up': 'Registrieren',
      'sign_in': 'Anmelden',
      'full_name': 'Vollständiger Name',
      'enter_name': 'Gib deinen Namen ein',
      'email': 'E-Mail-Adresse',
      'reset_password_title': 'Passwort zurücksetzen',
      'reset_password_subtitle': 'Gib deine E-Mail-Adresse und dein neues Passwort ein, um dein Passwort zurückzusetzen.',
      'reset_password': 'Zurücksetzen',
      'reset_password_instruction': 'Lass uns dein Passwort zurücksetzen. Folge den Anweisungen.',
      'password_reset_success': 'Passwort erfolgreich zurückgesetzt! Bitte melde dich mit deinem neuen Passwort an.',
      'invalid_reset_token': 'Ungültiger Link zum Zurücksetzen. Bitte fordere einen neuen an.',
      'enter_password': 'Bitte gib dein Passwort ein.',
      'password_too_short': 'Das Passwort muss mindestens 6 Zeichen lang sein.',
      'passwords_do_not_match': 'Die Passwörter stimmen nicht überein.',
      'new_password': 'Neues Passwort',
      'enter_email': 'Gib deine E-Mail ein',
      'password': 'Passwort',
      'create_password': 'Erstelle ein Passwort',
      'repeat_password': 'Passwort wiederholen',
      'confirm_password': 'Bestätige dein Passwort',
      'create_acc_title': 'Konto erstellen',
      'medical_profile': 'Medizinisches Profil',
      'sex': 'Geschlecht',
      'male': 'Männlich',
      'female': 'Weiblich',
      'blood_type': 'Blutgruppe',
      'allergies': 'Allergien',
      'medications': 'Medikamente',
      'diseases': 'Krankheiten',
      'continue': 'Weiter',
      'splash_welcome': 'Willkommen bei Lumos. Dein Begleiter für Barrierefreiheit.',
      'onboard_mode_hint': 'Tippe auf Sprachmodus oder Manuell um zu wählen.',
      'onboard_repeat_hint': 'Wähle Sprachmodus oder Manuell.',
      'lang_reading': 'Sprachen werden gelesen. Tippe wenn du deine hörst.',
      'voice_preview_sentence': 'Sieh über Grenzen hinaus mit Lumos.',
      'voice_hint_female': 'Für die weibliche Stimme, tippe auf die rechte Karte.',
      'voice_hint_male': 'Für die männliche Stimme, tippe auf die linke Karte.',
      'getstarted_swipe_hint': 'Wische nach oben wenn du ein Konto hast. Nach unten für ein neues.',
      'gesture_login_hint': 'Zeichne S zum Registrieren, oder L zum Anmelden.',
      'gesture_detected_s': 'Registrierung erkannt. Formular wird geöffnet.',
      'gesture_detected_l': 'Anmeldung erkannt.',
      'shake_help': 'Du bist auf {screen}. {hint}',
      'screen_curtain_on': 'Bildschirmvorhang aktiviert.',
      'screen_curtain_off': 'Bildschirmvorhang deaktiviert.',
      'home_welcome': 'Willkommen zurück, {name}. Du hast 4 Geräte verbunden.',
      'tts_listening': 'Höre zu…',
      'home_no_api_key': 'KI-Schlüssel nicht gesetzt.',
      'home_ai_error': 'Entschuldigung, ein Fehler ist aufgetreten.',
      'home_navigating': '{device} wird geöffnet.',
      'forgot_password_title': 'Passwort vergessen',
      'tap_toggle_to_change': 'Tippen Sie auf den Schalter, um den Status zu ändern',
      'code_sent_to_email': 'Bestätigungscode an Ihre E-Mail gesendet',
      'settings': 'Einstellungen',
      'connected': 'Verbunden',
      'disconnected': 'Getrennt',
      'devices': 'Geräte',
      'lh': 'Linke Hand',
      'rh': 'Rechte Hand',
      'll': 'Linkes Bein',
      'rl': 'Rechtes Bein',
      'pos_tl': 'Oben links, linker Handsensor',
      'pos_tr': 'Oben rechts, rechter Handsensor',
      'pos_bl': 'Unten links, linker Beinsensor',
      'pos_br': 'Unten rechts, rechter Beinsensor',
      'forgot_password_subtitle': 'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen deines Passworts.',
      'send_reset_link': 'Link zum Zurücksetzen senden',
      'reset_link_sent': 'Link zum Zurücksetzen erfolgreich gesendet! Bitte überprüfe deine E-Mails.',
      'back_to_sign_in': 'Zurück zur Anmeldung',
      'forgot_password_instruction': 'Halte irgendwo gedrückt, um deine E-Mail-Adresse zu sagen.',
      'prompt_say_field_email': 'Sage jetzt deine E-Mail-Adresse.',
      'prompt_confirm_entry_email': 'Du sagtest: {value}. Tippe einmal zum Bestätigen. Doppeltippen zum Wiederholen.',
      'invalid_email_format': 'Bitte gib eine gültige E-Mail-Adresse ein.',
      'lumos_word': 'Lumos',
      'mode_title': 'Wähle dein Erlebnis',
      'voice_mode': 'Sprachmodus',
      'tts_stt_on': 'TTS + STT aktiv',
      'manual_mode': 'Manueller Modus',
      'no_voice': 'Keine Stimme',
      'swipe_hint': 'oder wische hoch / runter',
      'lang_screen_hint': 'Du bist auf dem Sprachbildschirm. Deine Sprache ist {lang}. Einmal tippen zum Behalten. Doppeltippen zum Durchsuchen.',
      'lang_tap_hint': 'Tippe jederzeit um die Sprache zu wählen die du hörst.',
      'voice_screen_hint': 'Du bist auf dem Stimmbildschirm. Wische hoch für weiblich, runter für männlich.',
      'double_tap_confirm': 'Doppeltippen zum Bestätigen',
      'battery_time': 'Geschätzte verbleibende Zeit: 3h 20m',
      'toggle_on': 'An',
      'toggle_off': 'Aus',
      'cane_connected': 'Stock ist verbunden',
      'cane_disconnected': 'Stock ist nicht verbunden',
      'cane_battery': 'Akku bei 36 Prozent',
      'cane_time': 'Geschätzte verbleibende Zeit: 3 Stunden und 20 Minuten',
      'prompt_enter_field': 'Um {field} einzugeben, lange drücken.',
      'prompt_say_field': 'Sag deinen {field} jetzt.',
      'prompt_heard_nothing': 'Nichts gehört. Lange drücken um es erneut zu versuchen.',
      'prompt_password_chars': 'Passwort mit {n} Zeichen.',
      'prompt_confirm_entry': 'Eingegeben: {value}. Tippen zum Bestätigen. Doppeltippen zum Wiederholen.',
      // New keys for Wizard Mode
      'saved': 'Gespeichert',
      'field_required': 'Dieses Feld ist erforderlich',
      'press_and_hold_to_speak': 'Gedrückt halten zum Sprechen',
      'tap_to_confirm_double_to_redo': 'Einmal tippen zum Bestätigen, zweimal zum Wiederholen',
      'prompt_try_again': 'Bitte versuchen Sie es erneut',
      // Biometrics Keys
      'biometrics_title': 'Biometrie einrichten',
      'biometrics_instruction': 'Willkommen bei der Biometrie-Einrichtung. Sie müssen Ihren Fingerabdruck 4 Mal scannen. Folgen Sie den Anweisungen.',
      'biometrics_scan_start': 'Starte Scan {current} von {total}. Legen Sie Ihren Finger auf den Sensor.',
      'biometrics_scan_reason': 'Scan {current} von {total} — legen Sie Ihren Finger auf',
      'biometrics_scan_1': 'Stillhalten — erster Scan',
      'biometrics_scan_2': 'Gut! Weiter so — zweiter Scan',
      'biometrics_scan_3': 'Fast geschafft — dritter Scan',
      'biometrics_scan_4': 'Letzter! — letzter Scan',
      'biometrics_scan_default': 'Halten Sie Ihren Finger fest gedrückt',
      'biometrics_lift_finger': 'Heben Sie Ihren Finger an. {remaining} Scans verbleiben.',
      'biometrics_lift_message': 'Heben Sie Ihren Finger an und legen Sie ihn wieder auf\n({remaining} Scan(s) verbleibend)',
      'biometrics_success': 'Fingerabdruck verifiziert!',
      'biometrics_complete': 'Alle Scans abgeschlossen! Biometrie-Einrichtung erfolgreich.',
      'biometrics_failed': 'Authentifizierung fehlgeschlagen. Versuchen Sie es erneut.',
      'biometrics_unavailable': 'Keine Biometrie registriert. Sie können vorerst überspringen.',
      'biometrics_error_not_enrolled': 'Keine Fingerabdrücke registriert.\nFügen Sie einen in den Einstellungen hinzu.',
      'biometrics_error_locked': 'Zu viele Versuche. Bitte warten Sie.',
      'biometrics_error_permanent': 'Biometrie gesperrt. Verwenden Sie die Geräte-PIN.',
      'biometrics_error_default': 'Etwas ist schief gelaufen. Versuchen Sie es erneut.',
      'biometrics_status_scanning': 'Scan läuft...',
      'biometrics_status_lift': 'Finger anheben ↑',
      'biometrics_status_success': 'Verifiziert ✓',
      'voice_mode_short': 'Sprache',
      'manual_mode_short': 'Manuell',
      'swipe_instruction': 'Wische nach oben für {voice}. Wische nach unten für {manual}. Doppeltippe zum Auswählen.',
      'swipe_repeat': 'Wische oben Sprache. Wische unten Manuell. Doppeltippe.',
      'selected': '{mode} ausgewählt.',
      'biometrics_status_failed': 'Fehlgeschlagen ✗',
      'biometrics_status_unavailable': 'Nicht verfügbar',
      'biometrics_status_ready': 'Bereit',
      'biometrics_done_button': 'FERTIG',
      'biometrics_done_button_label': 'Fertig. Biometrie-Einrichtung abgeschlossen. Tippen Sie, um zur Startseite zu gelangen',
      'biometrics_skip_button': 'Vorerst überspringen',
      'biometrics_skip_button_label': 'Biometrie-Einrichtung vorerst überspringen',
      'biometrics_tryagain_button': 'Erneut versuchen',
      'biometrics_tryagain_button_label': 'Erneut versuchen. Doppeltippen, um den Scan neu zu starten',
      'biometrics_semantics': 'Biometrie-Einrichtungsbildschirm. Fortschritt: {progress}%. Aktueller Status: {status}.',
      'biometrics_scanner_label': 'Fingerabdruckscanner. Fortschrittskreis zeigt {progress}%. {status}',
      'biometrics_scans_complete': '{completed} von {total} Scans abgeschlossen',
      'biometrics_percent': '{percent}% abgeschlossen',
    },
    'ja': {
      'tap_toggle_to_change': 'トグルをタップして状態を変更',
      'code_sent_to_email': '確認コードをメールに送信しました',
      'settings': '設定',
      'connected': '接続済み',
      'disconnected': '未接続',
      'devices': 'デバイス',
      'lh': '左手',
      'rh': '右手',
      'll': '左足',
      'rl': '右足',
      'pos_tl': '左上、左手センサー',
      'pos_tr': '右上、右手センサー',
      'pos_bl': '左下、左足センサー',
      'pos_br': '右下、右足センサー',
      'bracelets': 'ブレスレット',
      'show_bracelets': '{count}個のブレスレットを表示',
      'lumo_band': 'ルモバンド',
      'earbuds': 'イヤーバッズ',
      'smart_cane': 'スマート白杖',
      'smart_glasses': 'スマートグラス',
      'account': 'アカウント',
      'updates': 'アップデート',
      'help_feedback': 'ヘルプとフィードバック',
      'about_lumos': 'Lumosについて',
      'profile': 'プロフィール',
      'personal_info_security': '個人情報\nとセキュリティ',
      'health_data_records': '健康データ\nと記録',
      'lumo_band_screen': 'ルモバンド画面',
      'earbuds_screen': 'イヤーバッズ画面',
      'smart_cane_screen': 'スマート白杖画面',
      'smart_glasses_screen': 'スマートグラス画面',
      'battery_36': 'バッテリー36パーセント',
      'time_remaining_3h': '推定残り時間：3時間20分',
      'device_on': 'デバイスがオンです',
      'device_off': 'デバイスがオフです',
      'lumo_band_on': 'ルモバンドがオン',
      'lumo_band_off': 'ルモバンドがオフ',
      'earbuds_on': 'イヤーバッズがオン',
      'earbuds_off': 'イヤーバッズがオフ',
      'smart_cane_on': 'スマート白杖がオン',
      'smart_cane_off': 'スマート白杖がオフ',
      'smart_glasses_on': 'スマートグラスがオン',
      'smart_glasses_off': 'スマートグラスがオフ',
      'settings_screen_desc': '設定画面。アカウント、医療プロフィール、言語などを管理できます。',
      'opening': '{label}を開いています',
      'connected_devices': '{count}台のデバイスが接続済み',
      'listening': '聞いています...',
      'lumos_thinking': 'Lumosは考え中...',
      'speak': '話してください...',
      'didnt_hear_anything': '聞こえませんでした。もう一度お試しください',
      'technical_error': '技術エラー: {error}',
      'voice_tap_instruction': '{male}は右をタップ。{female}は左をタップ。ダブルタップで確定。',
      'swipe_hint_visual': '上スワイプで音声 · 下スワイプで手動',
      'choose_language': '言語を選択',
      'subtitle': 'お好みの言語を選択してください。',
      'search': '言語を検索...',
      'next': '次へ',
      'voice_mode_short': '音声',
      'manual_mode_short': '手動',
      'swipe_instruction': '{voice}は上にスワイプ。{manual}は下にスワイプ。ダブルタップで選択。',
      'swipe_repeat': '上スワイプ音声。下スワイプ手動。ダブルタップ。',
      'selected': '{mode}を選択。',
      'default_lang': 'デフォルト言語',
      'welcome': 'Lumosへようこそ',
      'choose_voice': 'アシスタントの声を選んでください',
      'male_voice': '男性の声',
      'female_voice': '女性の声',
      'verify_code_title': '認証コード',
      'verify_code_subtitle': '{email} に送信された6桁のコードを入力してください',
      'verification_code': '認証コード',
      'enter_code': '6桁のコードを入力',
      'verify_button': '認証する',
      'verify_code_instruction': '長押しして認証コードを音声入力してください',
      'prompt_say_code': '6桁のコードを今すぐ言ってください',
      'prompt_confirm_code': '入力: {value}。確認はタップ',
      'invalid_code_length': 'コードは6桁である必要があります',
      'create_account': '新しいアカウントを作成',
      'already_account': 'すでにアカウントをお持ちの方',
      'sign_in_title': 'おかえりなさい',
      'sign_in_welcome': 'おかえりなさい。アカウントにサインインしてください。',
      'invalid_credentials': 'メールアドレスまたはパスワードが無効です。もう一度お試しください。',
      'wrong_password': 'パスワードが違います。もう一度お試しください。',
      'email_not_found': 'このメールアドレスのアカウントは見つかりません。',
      'network_error': 'ネットワークエラー。接続を確認してください。',
      'forgot_password': 'パスワードをお忘れですか？',
      'api_error': '問題が発生しました。もう一度お試しください。',
      'sign_up': '登録する',
      'sign_in': 'ログイン',
      'full_name': '氏名',
      'enter_name': '氏名を入力',
      'email': 'メールアドレス',
      'reset_password_title': 'パスワードをリセット',
      'reset_password_subtitle': 'メールアドレスと新しいパスワードを入力して、パスワードをリセットしてください。',
      'reset_password': 'リセット',
      'reset_password_instruction': 'パスワードをリセットしましょう。指示に従ってください。',
      'password_reset_success': 'パスワードが正常にリセットされました！新しいパスワードでサインインしてください。',
      'welcome_choice': 'Lumosの体験方法を選択してください',
      'invalid_reset_token': '無効なリセットリンクです。新しいリンクをリクエストしてください。',
      'enter_password': 'パスワードを入力してください。',
      'password_too_short': 'パスワードは6文字以上である必要があります。',
      'passwords_do_not_match': 'パスワードが一致しません。',
      'new_password': '新しいパスワード',
      'enter_email': 'メールを入力',
      'password': 'パスワード',
      'create_password': 'パスワードを作成',
      'repeat_password': 'パスワードを繰り返す',
      'confirm_password': 'パスワードを確認',
      'create_acc_title': 'アカウント作成',
      'medical_profile': '医療プロフィール',
      'sex': '性別',
      'male': '男性',
      'female': '女性',
      'blood_type': '血液型',
      'allergies': 'アレルギー',
      'medications': '薬',
      'diseases': '病気',
      'continue': '続ける',
      'splash_welcome': 'Lumosへようこそ。あなたのアクセシビリティパートナー。',
      'onboard_mode_hint': '音声モードまたは手動モードをタップして選択してください。',
      'onboard_repeat_hint': '音声モードまたは手動モードを選択してください。',
      'lang_reading': '言語を読んでいます。あなたの言語が聞こえたらタップしてください。',
      'voice_preview_sentence': 'Lumosで限界を超えて見てください。',
      'voice_hint_female': '女性の声を選ぶには、右のカードを押してください。',
      'voice_hint_male': '男性の声を選ぶには、左のカードを押してください。',
      'getstarted_swipe_hint': 'アカウントをお持ちの方は上にスワイプ。新規作成は下にスワイプ。',
      'gesture_login_hint': 'Sを描いて登録、Lを描いてログイン。',
      'gesture_detected_s': '登録が検出されました。フォームを開いています。',
      'gesture_detected_l': 'ログインが検出されました。',
      'shake_help': 'あなたは{screen}にいます。{hint}',
      'screen_curtain_on': 'スクリーンカーテンがオンになりました。',
      'screen_curtain_off': 'スクリーンカーテンがオフになりました。',
      'home_welcome': 'おかえりなさい、{name}。4つのデバイスが接続されています。',
      'tts_listening': '聞いています…',
      'home_no_api_key': 'AIキーが設定されていません。',
      'home_ai_error': '申し訳ありません、エラーが発生しました。',
      'home_navigating': '{device}を開いています。',
      'forgot_password_title': 'パスワードをお忘れですか',
      'forgot_password_subtitle': 'メールアドレスを入力してください。パスワードをリセットするためのリンクをお送りします。',
      'send_reset_link': 'リセットリンクを送信',
      'reset_link_sent': 'リセットリンクを送信しました！メールをご確認ください。',
      'back_to_sign_in': 'サインインに戻る',
      'forgot_password_instruction': 'どこでも長押しして、メールアドレスを音声で入力してください。',
      'prompt_say_field_email': '今すぐメールアドレスを言ってください。',
      'prompt_confirm_entry_email': '入力: {value}。確認はタップ。やり直しはダブルタップ。',
      'invalid_email_format': '有効なメールアドレスを入力してください。',
      'lumos_word': 'Lumos',
      'mode_title': 'エクスペリエンスを選択',
      'voice_mode': '音声モード',
      'tts_stt_on': 'TTS + STT オン',
      'manual_mode': '手動モード',
      'no_voice': '音声なし',
      'swipe_hint': 'または上下にスワイプ',
      'lang_screen_hint': '言語選択画面にいます。お使いの言語は{lang}です。そのまま使うには一度タップ。他の言語を見るにはダブルタップ。',
      'lang_tap_hint': 'いつでもタップして聞こえた言語を選択してください。',
      'voice_screen_hint': '音声選択画面にいます。女性の声は上にスワイプ、男性の声は下にスワイプ。',
      'double_tap_confirm': 'ダブルタップで確認',
      'battery_time': '推定残り時間：3時間20分',
      'toggle_on': 'オン',
      'toggle_off': 'オフ',
      'cane_connected': 'ケインが接続されています',
      'cane_disconnected': 'ケインが切断されています',
      'cane_battery': 'バッテリー残量36パーセント',
      'cane_time': '推定残り時間：3時間20分',
      'prompt_enter_field': '{field}を入力するには、長押ししてください。',
      'prompt_say_field': '今すぐ{field}を言ってください。',
      'prompt_heard_nothing': '何も聞こえませんでした。長押しして再試行してください。',
      'prompt_password_chars': '{n}文字のパスワード。',
      'prompt_confirm_entry': '入力: {value}。確認はタップ。やり直しはダブルタップ。',
      // New keys for Wizard Mode
      'saved': '保存しました',
      'field_required': 'このフィールドは必須です',
      'press_and_hold_to_speak': '長押しして話す',
      'tap_to_confirm_double_to_redo': 'タップで確定、ダブルタップでやり直し',
      'prompt_try_again': 'もう一度お試しください',
      // Biometrics Keys
      'biometrics_title': '生体認証を設定',
      'biometrics_instruction': '生体認証設定へようこそ。指紋スキャンを4回行う必要があります。指示に従ってください。',
      'biometrics_scan_start': 'スキャン {current}/{total} を開始します。センサーに指を置いてください。',
      'biometrics_scan_reason': 'スキャン {current}/{total} — 指を置いてください',
      'biometrics_scan_1': '動かないで — 最初のスキャン',
      'biometrics_scan_2': '良い調子です！続けて — 2回目のスキャン',
      'biometrics_scan_3': 'もう少し — 3回目のスキャン',
      'biometrics_scan_4': '最後です！ — 最終スキャン',
      'biometrics_scan_default': '指をしっかり押し当ててください',
      'biometrics_lift_finger': '指を離してください。残り {remaining} 回のスキャンです。',
      'biometrics_lift_message': '指を離して、もう一度置いてください\n(残り {remaining} 回のスキャン)',
      'biometrics_success': '指紋が確認されました！',
      'biometrics_complete': 'すべてのスキャンが完了しました！生体認証の設定が成功しました。',
      'biometrics_failed': '認証に失敗しました。もう一度お試しください。',
      'biometrics_unavailable': '登録された生体認証がありません。今はスキップできます。',
      'biometrics_error_not_enrolled': '指紋が登録されていません。\n設定で追加してください。',
      'biometrics_error_locked': '試行回数が多すぎます。しばらくお待ちください。',
      'biometrics_error_permanent': '生体認証がロックされました。デバイスのPINを使用してください。',
      'biometrics_error_default': '問題が発生しました。もう一度お試しください。',
      'biometrics_status_scanning': 'スキャン中...',
      'biometrics_status_lift': '指を離す ↑',
      'biometrics_status_success': '確認済み ✓',
      'biometrics_status_failed': '失敗 ✗',
      'biometrics_status_unavailable': '利用不可',
      'biometrics_status_ready': '準備完了',
      'biometrics_done_button': '完了',
      'biometrics_done_button_label': '完了。生体認証の設定が完了しました。タップしてホームに戻ります',
      'biometrics_skip_button': '今はスキップ',
      'biometrics_skip_button_label': '生体認証の設定を今はスキップする',
      'biometrics_tryagain_button': '再試行',
      'biometrics_tryagain_button_label': '再試行。ダブルタップでスキャンを再開します',
      'biometrics_semantics': '生体認証設定画面。進捗: {progress}%。現在のステータス: {status}。',
      'biometrics_scanner_label': '指紋スキャナー。進捗サークルは {progress}% を示しています。{status}',
      'biometrics_scans_complete': '{total} 回中 {completed} 回のスキャンが完了しました',
      'biometrics_percent': '{percent}% 完了',
    },
  };
  static String get(String langCode, String key) =>
      _all[langCode]?[key] ?? _all['en']![key] ?? key;

  static String fill(String langCode, String key, Map<String, String> args) {
    String s = get(langCode, key);
    args.forEach((k, v) => s = s.replaceAll('{$k}', v));
    return s;
  }

  static String fromLocale(String flutterCode) {
    const map = {
      'ar': 'ar', 'en': 'en', 'es': 'es',
      'fr': 'fr', 'de': 'de', 'ja': 'ja',
    };
    return map[flutterCode] ?? 'en';
  }
}



class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    final deviceLang = PlatformDispatcher.instance.locale.languageCode;
    _langCode = ['ar', 'en', 'es', 'fr', 'de', 'ja'].contains(deviceLang)
        ? deviceLang
        : 'en';
    _loadFromPrefs();
  }

  String _langCode        = 'en';
  String _voiceGender     = 'female';
  bool   _isVoiceMode     = false;
  bool   _voiceDisabled   = false;
  bool   _screenCurtain   = false;
  String _userName        = '';
  bool   _isFirstTime     = true;
  bool   _isLoggedIn      = false;
  bool   _hasCompletedReg = false;

  // --- Getters ---
  Locale get locale          => Locale(_langCode);
  String get langCode        => _langCode;
  String get voiceGender     => _voiceGender;
  bool   get isVoiceMode     => _isVoiceMode;
  bool   get voiceDisabled   => _voiceDisabled;
  bool   get screenCurtain   => _screenCurtain;
  String get userName        => _userName;
  bool   get isFirstTime     => _isFirstTime;
  bool   get isLoggedIn      => _isLoggedIn;
  bool   get hasCompletedReg => _hasCompletedReg;
  bool   get isRTL           => _langCode == 'ar';
  TextDirection get dir      => isRTL ? TextDirection.rtl : TextDirection.ltr;

  String tr(String key) => AppStrings.get(_langCode, key);
  String fill(String key, Map<String, String> args) =>
      AppStrings.fill(_langCode, key, args);
  Future<void> speak(String text) async {
    if (_voiceDisabled || text.isEmpty) return;
    await LumosVoiceService.instance.speak(
      text,
      lang:   _langCode,
      gender: _voiceGender,
    );
  }

  void disableVoice() {
    _voiceDisabled = true;
    LumosVoiceService.instance.stop();
    notifyListeners();
  }

  void enableVoice() {
    _voiceDisabled = false;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs      = await SharedPreferences.getInstance();
    final deviceLang = PlatformDispatcher.instance.locale.languageCode;

    _langCode        = prefs.getString('langCode') ??
        (['ar', 'en', 'es', 'fr', 'de', 'ja'].contains(deviceLang) ? deviceLang : 'en');
    _isFirstTime     = prefs.getBool('isFirstTime')     ?? true;
    _isLoggedIn      = prefs.getBool('isLoggedIn')      ?? false;
    _hasCompletedReg = prefs.getBool('hasCompletedReg') ?? false;
    _userName        = prefs.getString('userName')       ?? '';
    _voiceGender     = prefs.getString('voiceGender')   ?? 'female';
    _screenCurtain   = prefs.getBool('screenCurtain')   ?? false;
    _voiceDisabled   = prefs.getBool('voiceDisabled')   ?? false;
    _isVoiceMode     = !_voiceDisabled;

    notifyListeners();
  }


  void setLocale(String code) {
    _langCode = code;
    _saveLang(code);
    notifyListeners();
  }

  void completeFirstTime() {
    _isFirstTime = false;
    _saveFirstTime(false);
    notifyListeners();
  }

  void setLang(String code) {
    _langCode = code;
    _saveLang(code);
    notifyListeners();
  }

  void setVoiceGender(String g) {
    _voiceGender = g;
    SharedPreferences.getInstance().then((p) => p.setString('voiceGender', g));
    notifyListeners();
  }

  void setVoiceMode(bool v) {
    _isVoiceMode = v;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    SharedPreferences.getInstance().then((p) => p.setBool('isLoggedIn', value));
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  Future<void> completeRegistration(String name) async {
    _isLoggedIn      = true;
    _hasCompletedReg = true;
    _userName        = name;
    _isFirstTime     = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn',      true);
    await prefs.setBool('hasCompletedReg', true);
    await prefs.setString('userName',      name);
    await prefs.setBool('isFirstTime',     false);
    notifyListeners();
  }

  Future<void> loginSuccess(String name) async {
    _isLoggedIn = true;
    _userName   = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn',   true);
    await prefs.setString('userName',   name);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn      = false;
    _hasCompletedReg = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn',      false);
    await prefs.setBool('hasCompletedReg', false);
    notifyListeners();
  }

  void toggleScreenCurtain() async {
    _screenCurtain = !_screenCurtain;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('screenCurtain', _screenCurtain);
    notifyListeners();
  }

  Future<void> _saveLang(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langCode', code);
  }

  Future<void> _saveFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
  }

  Future<void> _saveVoiceDisabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voiceDisabled', value);
    notifyListeners();
  }
}
class LumosVoiceService {
  LumosVoiceService._();
  static final LumosVoiceService instance = LumosVoiceService._();

  final FlutterTts  _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  bool _sttInitialized = false;
  Completer<String>? _listenCompleter;
  String _currentPartialText = '';
  Timer? _silenceTimer;
  bool _isListening = false;

  Future<void> speak(String text, {
    String lang   = 'en',
    String gender = 'female',
    double volume = 0.9,
  }) async {
    if (text.isEmpty) return;
    try {
      final bcp47 = _toBCP47(lang);
      await _tts.stop();
      await _tts.setLanguage(bcp47);
      await _tts.setVolume(volume);
      await _tts.setSpeechRate(gender == 'male' ? 0.44 : 0.48);
      await _tts.setPitch(gender == 'female' ? 1.15 : 0.60);

      final completer = Completer<void>();
      _tts.setCompletionHandler(() {
        if (!completer.isCompleted) completer.complete();
      });
      _tts.setCancelHandler(() {
        if (!completer.isCompleted) completer.complete();
      });
      _tts.setErrorHandler((msg) {
        if (!completer.isCompleted) completer.complete();
      });

      await _tts.speak(text);
      await completer.future;
    } catch (e) {
      debugPrint('[TTS] error: $e');
    }
  }

  Future<void> stop() async {
    try { await _tts.stop(); } catch (e) { debugPrint('[TTS] stop: $e'); }
    try { await _stt.stop(); } catch (e) { debugPrint('[STT] stop: $e'); }
    _isListening = false;
    _silenceTimer?.cancel();
  }
  Future<void> startListening({
    String lang = 'en',
    void Function(String partial)? onPartial,
    void Function(String finalText)? onFinal,
  }) async {
    try {
      await stop();

      if (!_sttInitialized) {
        _sttInitialized = await _stt.initialize(
          onError: (e) => debugPrint('[STT] error: $e'),
        );
      }
      if (!_sttInitialized) return;

      _currentPartialText = '';
      _listenCompleter = Completer<String>();
      _isListening = true;

      await _stt.listen(
        localeId: _toBCP47(lang),
        onResult: (result) {
          if (!_isListening) return;

          if (result.recognizedWords.isNotEmpty) {
            _currentPartialText = result.recognizedWords;
            if (onPartial != null) {
              onPartial(result.recognizedWords);
            }
          }
          if (result.finalResult && _listenCompleter != null && !_listenCompleter!.isCompleted) {
            _silenceTimer?.cancel();
            _silenceTimer = Timer(const Duration(milliseconds: 1500), () {
              if (_listenCompleter != null && !_listenCompleter!.isCompleted) {
                _listenCompleter!.complete(result.recognizedWords);
                if (onFinal != null) {
                  onFinal(result.recognizedWords);
                }
                _isListening = false;
              }
            });
          }
        },
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 5),
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('[STT] startListening error: $e');
      _listenCompleter?.complete('');
      _isListening = false;
    }
  }

  Future<String> stopListening() async {
    _silenceTimer?.cancel();
    await _stt.stop();
    _isListening = false;

    final result = _currentPartialText;
    _currentPartialText = '';

    if (_listenCompleter != null && !_listenCompleter!.isCompleted) {
      _listenCompleter!.complete(result);
    }
    _listenCompleter = null;

    return result;
  }

  Future<String> listen({
    String lang = 'en',
    void Function(String partial)? onPartial,
  }) async {
    final completer = Completer<String>();

    await startListening(
      lang: lang,
      onPartial: onPartial,
      onFinal: (finalText) {
        if (!completer.isCompleted) {
          completer.complete(finalText);
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        stopListening();
        return '';
      },
    );
  }

  static String _toBCP47(String code) {
    const map = {
      'ar': 'ar-SA', 'en': 'en-US', 'es': 'es-ES',
      'fr': 'fr-FR', 'de': 'de-DE', 'ja': 'ja-JP',
    };
    return map[code] ?? 'en-US';
  }
}



class LumosHaptics {
  LumosHaptics._();
  static Future<void> tick() async { await HapticFeedback.selectionClick(); }
  static Future<void> scrollEnd() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.heavyImpact();
  }
  static Future<void> heartbeat() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.mediumImpact();
  }
  static Future<void> longConfirm() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
  }
}

class ShakeDetector {
  final VoidCallback onShake;
  static const double _threshold = 15.0;
  static const int    _cooldown  = 1200;
  DateTime _lastShake = DateTime(2000);
  StreamSubscription<UserAccelerometerEvent>? _sub;
  ShakeDetector({required this.onShake});
  void start() {
    _sub = userAccelerometerEventStream().listen((event) {
      final total = event.x.abs() + event.y.abs() + event.z.abs();
      if (total > _threshold) {
        final now = DateTime.now();
        if (now.difference(_lastShake).inMilliseconds > _cooldown) {
          _lastShake = now;
          onShake();
        }
      }
    }, onError: (e) => debugPrint('[Shake] error: $e'));
  }
  void stop() { _sub?.cancel(); _sub = null; }
}

bool userLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const LumosApp(),
    ),
  );
}

class LumosApp extends StatelessWidget {
  const LumosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'Lumos',
      debugShowCheckedModeBanner: false,
      locale: p.locale,
      supportedLocales: const [
        Locale('en'), Locale('ar'), Locale('es'),
        Locale('fr'), Locale('de'), Locale('ja'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: p.langCode == 'ar'
            ? 'Cairo'
            : p.langCode == 'ja'
            ? 'NotoSansJP'
            : 'Roboto',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: p.dir,
          child: Stack(
            children: [
              child!,
              if (p.screenCurtain)
                Positioned.fill(
                  child: GestureDetector(
                    onDoubleTap: () {
                      p.toggleScreenCurtain();
                      p.speak(AppStrings.get(p.langCode, 'screen_curtain_off'));
                    },
                    child: Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text('🔒', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      initialRoute: '/',
      routes: {
        '/':               (context) => const SplashScreen(),
        '/mode-select':    (_) => const ModeSelectScreen(),
        '/choose-language':(_) => const ChooseLanguageScreen(),
        '/choose-voice':   (_) => const ChooseVoiceScreen(),
        '/get-started':    (_) => const GetStartedScreen(),
        '/sign-up':        (_) => const SignUpScreen(),
        '/sign-in':        (_) => const SignInScreen(),
        '/forgot-password':(_) => const ForgotPasswordScreen(),
        '/verify-code':    (_) => const VerifyCodeScreen(email: ''),
        '/reset-password': (_) => const ResetPasswordScreen(),
        '/medical-profile':(_) => const MedicalProfileScreen(),
        '/biometrics':     (_) => const BiometricsScreen(),
        '/home':           (_) => const HomeScreen(),
      },
    );
  }
}

const _bg       = Color(0xFF1E110A);
const _card     = Color(0xFF2C1A0E);
const _selCard  = Color(0xFF3D2410);
const _orange   = Color(0xFFF27F0D);
const _border   = Color(0xFF5C360F);
const _txtW     = Color(0xFFF1F5F9);
const _txtGray  = Color(0xFF94A3B8);
const _fieldBg  = Color(0xFF140F0A);

class _BottomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BottomButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _orange, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _orange, foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Text(label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _fc, _sc;
  late final Animation<double>   _f,  _s;

  @override
  void initState() {
    super.initState();
    _fc = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _sc = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _f  = CurvedAnimation(parent: _fc, curve: Curves.easeIn);
    _s  = Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _sc, curve: Curves.easeInOut));
    _run();
  }

  Future<void> _run() async {
    await LumosHaptics.longConfirm();
    _fc.forward();
    _sc.forward();

    final p = context.read<LocaleProvider>();
    // Wait for prefs to load so langCode reflects saved choice
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    final lumosWord = AppStrings.get(p.langCode, 'lumos_word');
    await p.speak(lumosWord);

    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    if (p.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (p.isFirstTime) {
      Navigator.pushReplacementNamed(context, '/mode-select');
    } else {
      Navigator.pushReplacementNamed(context, '/get-started');
    }
  }

  @override
  void dispose() { _fc.dispose(); _sc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _f,
          child: AnimatedBuilder(
            animation: _s,
            builder: (_, child) => Transform.scale(scale: _s.value, child: child),
            child: Image.asset(
              'assets/images/splash.png',
              width: 800, height: 800,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _LumosLogoFallback(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LumosLogoFallback extends StatelessWidget {
  const _LumosLogoFallback();
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.remove_red_eye_outlined, color: _orange, size: 80),
        SizedBox(height: 16),
        Text('LUMOS',
            style: TextStyle(
              color: _orange, fontSize: 48,
              fontWeight: FontWeight.w900, letterSpacing: 8,
            )),
      ],
    );
  }
}

class ModeSelectScreen extends StatefulWidget {
  const ModeSelectScreen({super.key});

  @override
  State<ModeSelectScreen> createState() => _ModeSelectScreenState();
}

class _ModeSelectScreenState extends State<ModeSelectScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double>   _fade;

  bool   _hasInteracted = false;
  Timer? _timeout;
  bool   _isSpeakingInstructions = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakInstructions());
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    final p = context.read<LocaleProvider>();
    if (p.voiceDisabled) return;

    _isSpeakingInstructions = true;

    final String voiceMode = p.tr('voice_mode_short');
    final String manualMode = p.tr('manual_mode_short');

    await LumosVoiceService.instance.speak(
      p.tr('welcome_choice') + ' ' +
          p.fill('swipe_instruction', {'voice': voiceMode, 'manual': manualMode}),
      lang: p.langCode,
      gender: p.voiceGender,
    );

    _isSpeakingInstructions = false;
    _startRepeatTimer();
  }

  void _startRepeatTimer() {
    if (_timeout?.isActive == true) _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 10), () {
      if (mounted && !_hasInteracted && !_isSpeakingInstructions) {
        _speakRepeatHint();
      }
    });
  }

  Future<void> _speakRepeatHint() async {
    final p = context.read<LocaleProvider>();
    if (p.voiceDisabled) return;

    await LumosVoiceService.instance.speak(
      p.tr('swipe_repeat'),
      lang: p.langCode,
      gender: p.voiceGender,
    );
    _startRepeatTimer();
  }

  void _selectMode(bool voiceMode) {
    if (_hasInteracted) return;
    _hasInteracted = true;
    _timeout?.cancel();

    LumosHaptics.success();

    final p = context.read<LocaleProvider>();
    p.setVoiceMode(voiceMode);
    if (voiceMode) {
      p.enableVoice();
      p.speak(p.fill('selected', {'mode': p.tr('voice_mode_short')}));
    } else {
      p.disableVoice();
      p.speak(p.fill('selected', {'mode': p.tr('manual_mode_short')}));
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/choose-language');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final isVoiceSelected = !p.voiceDisabled;

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onVerticalDragEnd: (d) {
              if (d.primaryVelocity == null) return;
              if (d.primaryVelocity! < -200) {
                LumosHaptics.tick();
                _selectMode(true);
              }
              if (d.primaryVelocity! > 200) {
                LumosHaptics.tick();
                _selectMode(false);
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/lumos_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF0D0A07)),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.black.withOpacity(0.50),
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Logo
                      Semantics(
                        label: 'Lumos',
                        child: Image.asset(
                          'assets/images/eye_icon.png',
                          width: 60,
                          height: 60,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.remove_red_eye_outlined,
                            color: _orange,
                            size: 48,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // LUMOS text
                      const Text(
                        'LUMOS',
                        style: TextStyle(
                          color: _orange,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 5,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        p.tr('welcome_choice'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _txtGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 28),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectMode(true),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isVoiceSelected
                                          ? _orange.withOpacity(0.12)
                                          : _card,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isVoiceSelected ? _orange : _border,
                                        width: isVoiceSelected ? 2.5 : 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.mic_rounded,
                                          color: isVoiceSelected ? _orange : _txtGray,
                                          size: 52,
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          p.tr('voice_mode_short'),
                                          style: TextStyle(
                                            color: isVoiceSelected ? _orange : _txtW,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectMode(false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: !isVoiceSelected
                                          ? _orange.withOpacity(0.12)
                                          : _cardDark,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: !isVoiceSelected ? _orange : _border,
                                        width: !isVoiceSelected ? 2.5 : 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.touch_app_rounded,
                                          color: !isVoiceSelected ? _orange : _txtGray,
                                          size: 52,
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          p.tr('manual_mode_short'),
                                          style: TextStyle(
                                            color: !isVoiceSelected ? _orange : _txtW,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.swap_vert_rounded,
                                color: _txtGray, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              p.tr('swipe_hint_visual'),
                              style: const TextStyle(
                                color: _txtGray,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _Lang {
  final String name, code;
  final bool isDefault;
  const _Lang(this.name, this.code, {this.isDefault = false});
}

const _langs = [
  _Lang('English (US)', 'en', isDefault: true),
  _Lang('العربية',      'ar'),
  _Lang('Español',      'es'),
  _Lang('Français',     'fr'),
  _Lang('Deutsch',      'de'),
  _Lang('日本語',        'ja'),
];
class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});
  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen>
    with SingleTickerProviderStateMixin {
  late String  _sel;
  String       _currentReadingCode = '';
  String       _search = '';
  final _ctrl  = TextEditingController();
  late final AnimationController _anim;
  late final Animation<double>   _fade;
  Timer?  _timeout;
  bool    _isReadingLangs = false;
  bool    _awaitingChoice = false;

  @override
  void initState() {
    super.initState();
    _sel = context.read<LocaleProvider>().langCode;
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakIntro());
  }

  @override
  void dispose() { _timeout?.cancel(); _anim.dispose(); _ctrl.dispose(); super.dispose(); }

  List<_Lang> get _filtered => _search.isEmpty
      ? _langs
      : _langs.where((l) => l.name.toLowerCase().contains(_search.toLowerCase())).toList();

  Future<void> _speakIntro() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;
    final deviceLangName = _langs
        .firstWhere((l) => l.code == p.langCode, orElse: () => _langs.first)
        .name;
    final introMsg = AppStrings.fill(p.langCode, 'lang_screen_hint', {'lang': deviceLangName});

    setState(() => _awaitingChoice = true);
    await LumosVoiceService.instance.speak(introMsg, lang: p.langCode, gender: p.voiceGender);
  }
  Future<void> _onSingleTap() async {
    if (_isReadingLangs) {
      await _selectLang(_currentReadingCode.isNotEmpty ? _currentReadingCode : _sel);
      return;
    }
    if (_awaitingChoice) {
      setState(() => _awaitingChoice = false);
      await _selectLang(_sel);
    }
  }

  Future<void> _onDoubleTap() async {
    if (_isReadingLangs) return;
    if (_awaitingChoice) {
      setState(() { _awaitingChoice = false; _isReadingLangs = true; });
      await _startReadingLangs();
    }
  }

  Future<void> _startReadingLangs() async {
    final p = context.read<LocaleProvider>();
    if (!p.isVoiceMode || p.voiceDisabled) return;

    await LumosVoiceService.instance.speak(
      AppStrings.get(p.langCode, 'lang_tap_hint'),
      lang: p.langCode,
      gender: p.voiceGender,
    );

    for (final lang in _langs) {
      if (!mounted || !_isReadingLangs) break;
      setState(() {
        _sel = lang.code;
        _currentReadingCode = lang.code;
      });
      await LumosVoiceService.instance.speak(
        lang.name,
        lang: lang.code,
        gender: p.voiceGender,
      );
      if (mounted && _isReadingLangs) {
        await Future.delayed(const Duration(milliseconds: 600));
      }
    }

    if (mounted && _isReadingLangs) {
      setState(() { _isReadingLangs = false; _awaitingChoice = true; });
      await _speakIntro();
    }
  }
  Future<void> _selectLang(String code) async {
    if (!mounted) return;
    _timeout?.cancel();
    setState(() {
      _sel = code;
      _isReadingLangs = false;
      _awaitingChoice = false;
      _currentReadingCode = '';
    });
    LumosHaptics.success();
    await LumosVoiceService.instance.stop();
    final lp = context.read<LocaleProvider>();
    lp.setLang(code);
    if (!lp.voiceDisabled) {
      final langName = _langs.firstWhere((l) => l.code == code).name;
      await LumosVoiceService.instance.speak(langName, lang: code);
    }
    final route = lp.isVoiceMode ? '/choose-voice' : '/get-started';
    if (mounted) Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E110A),
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onTap:       p.isVoiceMode && !p.voiceDisabled ? _onSingleTap : null,
            onDoubleTap: p.isVoiceMode && !p.voiceDisabled ? _onDoubleTap : null,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (_) { LumosHaptics.scrollEnd(); return false; },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.tr('choose_language'),
                                style: const TextStyle(
                                  color: Color(0xFFF1F5F9),
                                  fontSize: 28, fontWeight: FontWeight.w800,
                                )),
                            const SizedBox(height: 6),
                            Text(p.tr('subtitle'),
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14, height: 1.5,
                                )),
                            const SizedBox(height: 20),
                            // Search bar
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A1A08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFF27F0D).withOpacity(0.25),
                                  width: 1,
                                ),
                              ),
                              child: Row(children: [
                                const SizedBox(width: 14),
                                const Icon(Icons.search,
                                    color: Color(0xFF94A3B8), size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _ctrl,
                                    onChanged: (v) => setState(() => _search = v),
                                    style: const TextStyle(
                                        color: Color(0xFFF1F5F9), fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: p.tr('search'),
                                      hintStyle: const TextStyle(
                                          color: Color(0xFF94A3B8), fontSize: 14),
                                      border: InputBorder.none, isDense: true,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 16),
                            ..._filtered.map((lang) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _LangTile(
                                lang: lang,
                                isSelected: _sel == lang.code,
                                isReading:  _isReadingLangs &&
                                    _currentReadingCode == lang.code,
                                onTap: () => _selectLang(lang.code),
                              ),
                            )),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _BottomButton(
                    label: p.tr('next'),
                    onTap: () {
                      final lp = context.read<LocaleProvider>();
                      lp.setLang(_sel);
                      final route = lp.isVoiceMode ? '/choose-voice' : '/get-started';
                      Navigator.of(context).pushReplacementNamed(route);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final _Lang lang;
  final bool isSelected;
  final bool isReading;
  final VoidCallback onTap;
  const _LangTile({
    required this.lang,
    required this.isSelected,
    required this.onTap,
    this.isReading = false,
  });
  @override
  Widget build(BuildContext context) {
    final highlight = isSelected || isReading;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: highlight ? _selCard : _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlight ? _orange : _border,
            width: highlight ? 1.5 : 1,
          ),
          boxShadow: isReading
              ? [BoxShadow(
              color: _orange.withOpacity(0.25),
              blurRadius: 12, spreadRadius: 1)]
              : [],
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight ? _orange : Colors.transparent,
              border: Border.all(
                  color: _orange, width: highlight ? 0 : 2),
            ),
            child: highlight
                ? const Icon(Icons.circle, color: Colors.white, size: 10)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(lang.name,
                style: TextStyle(
                    color: _txtW,
                    fontSize: 16,
                    fontWeight: highlight ? FontWeight.w700 : FontWeight.w500)),
          ),
          if (isReading) const _PulsingDot(color: _orange),
          if (isSelected && !isReading)
            Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _orange, width: 1.5),
              ),
              child: const Icon(Icons.check, color: _orange, size: 16),
            ),
        ]),
      ),
    );
  }
}

class ChooseVoiceScreen extends StatefulWidget {
  const ChooseVoiceScreen({super.key});

  @override
  State<ChooseVoiceScreen> createState() => _ChooseVoiceScreenState();
}

class _ChooseVoiceScreenState extends State<ChooseVoiceScreen>
    with SingleTickerProviderStateMixin {
  String _sel        = 'female';
  bool _isPlaying    = false;
  bool _navigating   = false;
  bool _awaitingConfirm = false;
  late final AnimationController _anim;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakInstructions());
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  Future<void> _speakInstructions() async {
    final p = context.read<LocaleProvider>();
    if (p.voiceDisabled) return;

    final String maleVoice = p.tr('male_voice');
    final String femaleVoice = p.tr('female_voice');

    await LumosVoiceService.instance.speak(
      p.fill('voice_tap_instruction', {
        'male': maleVoice,
        'female': femaleVoice,
      }),
      lang: p.langCode,
      gender: p.voiceGender,
    );
  }

  Future<void> _selectVoice(String gender) async {
    if (_navigating) return;
    final p = context.read<LocaleProvider>();

    if (_awaitingConfirm && _sel == gender) {
      _navigating = true;
      setState(() => _awaitingConfirm = false);
      await LumosHaptics.success();
      p.setVoiceGender(gender);
      if (mounted) Navigator.of(context).pushReplacementNamed('/get-started');
      return;
    }

    setState(() {
      _sel = gender;
      _isPlaying = true;
      _awaitingConfirm = false;
    });

    await LumosHaptics.tick();

    if (!p.voiceDisabled) {
      final word = AppStrings.get(p.langCode, 'lumos_word');
      await LumosVoiceService.instance.speak(word, lang: p.langCode, gender: gender);

      final confirmMsg = AppStrings.get(p.langCode, 'double_tap_confirm');
      await LumosVoiceService.instance.speak(confirmMsg, lang: p.langCode);
    }

    if (!mounted) return;
    setState(() { _isPlaying = false; _awaitingConfirm = true; });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final isRTL = p.isRTL;
    final maleAtRight = !isRTL;
    final femaleAtRight = isRTL;

    return Scaffold(
      backgroundColor: const Color(0xFF1E110A),
      body: FadeTransition(
        opacity: _fade,
        child: GestureDetector(
          onHorizontalDragEnd: (d) {
            if (d.primaryVelocity == null) return;
            if (isRTL) {
              if (d.primaryVelocity! < -200) _selectVoice('female');
              if (d.primaryVelocity! > 200) _selectVoice('male');
            } else {
              if (d.primaryVelocity! < -200) _selectVoice('male');
              if (d.primaryVelocity! > 200) _selectVoice('female');
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                  child: Text(
                    p.tr('choose_voice'),
                    style: const TextStyle(
                      color: Color(0xFFF27F0D),
                      fontSize: 26, fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 350,
                        child: Row(
                          children: [
                            Expanded(
                              child: _VoiceCard(
                                label: isRTL ? p.tr('male_voice') : p.tr('female_voice'),
                                imagePath: isRTL
                                    ? 'assets/images/male_3d_icon.png'
                                    : 'assets/images/female_3d_icon.png',
                                isSelected: isRTL ? _sel == 'male' : _sel == 'female',
                                isPlaying: isRTL
                                    ? (_isPlaying && _sel == 'male')
                                    : (_isPlaying && _sel == 'female'),
                                onTap: () => _selectVoice(isRTL ? 'male' : 'female'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _VoiceCard(
                                label: isRTL ? p.tr('female_voice') : p.tr('male_voice'),
                                imagePath: isRTL
                                    ? 'assets/images/female_3d_icon.png'
                                    : 'assets/images/male_3d_icon.png',
                                isSelected: isRTL ? _sel == 'female' : _sel == 'male',
                                isPlaying: isRTL
                                    ? (_isPlaying && _sel == 'female')
                                    : (_isPlaying && _sel == 'male'),
                                onTap: () => _selectVoice(isRTL ? 'female' : 'male'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _BottomButton(
                  label: p.tr('next').toUpperCase(),
                  onTap: () {
                    p.setVoiceGender(_sel);
                    Navigator.of(context).pushReplacementNamed('/get-started');
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceCard extends StatelessWidget {
  final String label, imagePath;
  final bool isSelected, isPlaying;
  final VoidCallback onTap;

  const _VoiceCard({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color orangeMain = Color(0xFFF27F0D);
    const Color orangeLow  = Color(0x66F27F0D);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? orangeMain : const Color(0xFF1A0E06),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFA629)
                : orangeMain.withOpacity(0.2),
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned.fill(
                bottom: -20,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
              // أيقونة الصح
              Positioned(
                top: 16, right: 16,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.black : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.black : orangeLow,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check, size: 16,
                    color: isSelected ? orangeMain : orangeLow,
                  ),
                ),
              ),
              Positioned(
                bottom: 60, left: 12, right: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17, fontWeight: FontWeight.bold,
                        shadows: [Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 10, offset: const Offset(0, 2),
                        )],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.graphic_eq,
                            color: isSelected ? Colors.black : orangeLow,
                            size: 20),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.black.withOpacity(0.15)
                                : Colors.transparent,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 20,
                            color: isSelected ? Colors.black : orangeLow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


const Color _lumosOrange       = Color(0xFFC56C16);
const Color _lumosOrangeBorder = Color(0xFFFF6A00);
const Color _cardDark          = Color(0xFF140F0A);
const Color _bgBlack           = Color(0xFF0D0905);

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});
  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double>   _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    Future.delayed(const Duration(milliseconds: 900), _speakHint);
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  Future<void> _speakHint() async {
    if (!mounted) return;
    final p = context.read<LocaleProvider>();
    // ✅ p.speak تتجاهل لو voiceDisabled
    await p.speak(AppStrings.get(p.langCode, 'getstarted_swipe_hint'));
  }

  void _goSignUp() {
    LumosVoiceService.instance.stop();
    LumosHaptics.success();
    Navigator.of(context).pushReplacementNamed('/sign-up');
  }

  void _goSignIn() {
    LumosVoiceService.instance.stop();
    LumosHaptics.success();
    Navigator.of(context).pushReplacementNamed('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final p           = context.watch<LocaleProvider>();
    final createLabel = AppStrings.get(p.langCode, 'create_account');
    final alreadyLabel= AppStrings.get(p.langCode, 'already_account');

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bgBlack,
        body: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragEnd: (details) {

              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < -200) {
                _goSignUp();
              } else if (details.primaryVelocity! > 200) {
                _goSignIn();
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1C1108), Color(0xFF0D0905)],
                    ),
                  ),
                ),

                Positioned(
                  top: 0, left: 0, right: 0,
                  bottom: MediaQuery.of(context).size.height / 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _goSignUp,
                    child: const SizedBox.expand(),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  left: 0, right: 0, bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _goSignIn,
                    child: const SizedBox.expand(),
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GetStartedButton(
                        label:     createLabel,
                        isPrimary: true,
                        onTap:     _goSignUp,
                      ),
                      const SizedBox(height: 16),
                      _GetStartedButton(
                        label:     alreadyLabel,
                        isPrimary: false,
                        onTap:     _goSignIn,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final String       label;
  final bool         isPrimary;
  final VoidCallback onTap;
  const _GetStartedButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 318, height: 94,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? _lumosOrange : _cardDark,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: _lumosOrangeBorder, width: 1),
          boxShadow: isPrimary
              ? [BoxShadow(
              color: _lumosOrange.withOpacity(0.4),
              blurRadius: 20, offset: const Offset(0, 6))]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white, fontSize: 18,
            fontWeight: FontWeight.w800, fontFamily: 'Inter',
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withOpacity(_anim.value),
        ),
      ),
    );
  }
}

enum _ArrowDirection { up, down }

Widget _buildActionButton({
  required String label,
  required bool isPrimary,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 318, height: 94,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPrimary ? _lumosOrange : _cardDark,
        borderRadius: BorderRadius.circular(5),
        border: !isPrimary ? Border.all(color: _lumosOrange, width: 1.5) : null,
        boxShadow: isPrimary
            ? [BoxShadow(
            color: _lumosOrange.withOpacity(0.2),
            blurRadius: 15, offset: const Offset(0, 4))]
            : [],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white, fontSize: 18,
          fontWeight: FontWeight.w800, fontFamily: 'Inter',
          letterSpacing: 0.9,
        ),
      ),
    ),
  );
}