class AppStrings {
  AppStrings._();
  static const Map<String, Map<String, String>> _all = {
    'en': {
      // ── General ───────────
      'next':           'Next',
      'continue_btn':   'Continue',
      'done':           'Done',
      'skip':           'Skip for now',
      'yes':            'Yes',
      'no':             'No',
      'or':             'or',
      'confirm':        'Confirm',
      'repeat':         'Repeat',
      'cancel':         'Cancel',
      'save':           'Save',
      'none':           'None',

      // ── Accessibility Mode ───
      'acc_title':      'How would you like\nto use Lumos?',
      'acc_subtitle':   'Choose how you\'d like to interact\nwith your assistant.',
      'acc_manual':     'Manual',
      'acc_manual_sub': 'Navigate using touch and visual interface.',
      'acc_voice':      'Voice Assistant',
      'acc_voice_sub':  'Let Lumos guide you with voice and audio feedback.',
      // Confirmation hint shown after first tap on a card
      'acc_confirm_hint':
      'Tap the highlighted card again to confirm  ·  Tap here to cancel',
      // TTS — read aloud when screen loads
      'tts_screen_acc': 'You are now on the accessibility mode screen.',
      'tts_acc_welcome':
      'Welcome to Lumos. '
          'The top card is Manual mode. '
          'The bottom card is Voice Assistant mode. '
          'Tap a card once to select it, then tap it again to confirm.',
      // TTS — after first card tap
      'tts_acc_selected':
      'You selected {mode}. Tap the same card once more to confirm.',

      // ── Choose Language ──────────────────────────────────
      'choose_language':  'Choose Language',
      'lang_subtitle':    'Select your preferred language.',
      'search_langs':     'Search languages...',
      'default_lang':     'Default system language',
      // TTS
      'tts_screen_lang':       'You are now on the language selection screen.',
      'tts_lang_intro':
      'Your device language is {lang}. '
          'Tap once to keep it. '
          'Tap twice to browse other languages.',
      'tts_lang_browse':
      'Browsing languages. I will read each one. Tap once to select.',
      'tts_lang_selected':
      'Language set to {lang}. Tap once to confirm and continue.',

      // ── Choose Voice ─────────────────────────────────────
      'choose_voice':       'Choose A Voice\nFor Your Assistant',
      'male_voice':         'Male Voice',
      'female_voice':       'Female Voice',
      // Hint shown on screen in voice mode
      'voice_hint_voice_screen':
      'Tap left for Female voice  ·  Tap right for Male voice  ·  Tap center to confirm',
      // TTS
      'tts_screen_voice':      'You are now on the voice selection screen.',
      'tts_voice_intro':
      'Choose a voice for your assistant. '
          'Tap the left side of the screen to hear the female voice. '
          'Tap the right side to hear the male voice. '
          'When you like what you hear, tap the center to confirm.',
      // Sample phrase played when previewing a voice (as per requirements)
      'tts_voice_female_sample': 'See beyond limits.',
      'tts_voice_male_sample':   'See beyond limits.',
      // After sample played, remind how to confirm
      'tts_voice_confirm_hint':
      'If you like this voice, tap the center of the screen to confirm.',
      // Confirmation messages
      'tts_voice_chosen':    'You chose {gender}.',
      'tts_voice_confirmed': 'Voice confirmed. Proceeding.',

      // ── Get Started ──────────────────────────────────────
      'create_account':   'Create A New Account',
      'already_account':  'Already Have An Account',
      // TTS
      'tts_screen_getstarted': 'You are now on the get started screen.',
      'tts_getstarted_intro':
      'If you do not have an account, tap the top half of the screen. '
          'If you already have an account, tap the bottom half.',

      // ── Sign Up ──────────────────────────────────────────
      'sign_up':              'Sign up',
      'create_acc_title':     'Create account',
      'full_name':            'Full name',
      'enter_name':           'Enter your full name',
      'email':                'Email address',
      'enter_email':          'Enter your email',
      'password':             'Password',
      'create_password':      'Create a password',
      'repeat_password':      'Repeat password',
      'confirm_password':     'Confirm your password',
      // TTS
      'tts_screen_signup':     'You are now on the account creation screen.',
      'tts_signup_intro':
      'Let\'s create your account. I will guide you step by step.',
      'tts_signup_name':
      'Please say your full name.',
      'tts_signup_name_confirm':
      'I heard: {value}. Tap once to confirm. Tap twice to repeat.',
      'tts_signup_email':
      'Please say your email address.',
      'tts_signup_email_confirm':
      'Email: {value}. Tap once to confirm. Tap twice to repeat.',
      'tts_signup_password':
      'Please say your password. Speak clearly.',
      'tts_signup_password_confirm':
      'Password received. Tap once to confirm. Tap twice to repeat.',
      'tts_signup_confirm_password':
      'Please repeat your password to confirm.',
      'tts_signup_done':
      'Account created successfully. Moving to your medical profile.',
      'tts_listening':  'Listening...',
      'tts_heard':      'I heard: {value}',

      // ── Sign In ──────────────────────────────────────────
      'sign_in':            'Sign in',
      'welcome_back':       'Welcome back',
      'signin_subtitle':    'Please enter your details to sign in',
      'forgot_password':    'Forgot password?',
      // TTS
      'tts_screen_signin':     'You are now on the sign in screen.',
      'tts_signin_intro':
      'Welcome back. Please say your email address.',
      'tts_signin_email_confirm':
      'Email: {value}. Tap once to confirm. Tap twice to repeat.',
      'tts_signin_password':
      'Please say your password.',
      'tts_signin_password_confirm':
      'Password received. Tap once to sign in. Tap twice to repeat.',
      'tts_signin_success':
      'Signed in successfully. Welcome back, {name}.',
      'tts_signin_fail':
      'Incorrect email or password. Please try again.',

      // ── Medical Profile ──────────────────────────────────
      'medical_profile':  'Medical Profile',
      'sex':              'Sex',
      'male':             'Male',
      'female':           'Female',
      'blood_type':       'Blood Type',
      'allergies':        'Allergies',
      'medications':      'Medications',
      'diseases':         'Diseases',
      'add':              'Add',
      'type_here':        'Type here...',
      // TTS
      'tts_screen_medical':    'You are now on the medical profile screen.',
      'tts_medical_intro':
      'Let\'s fill in your medical profile. '
          'This information helps emergency services. '
          'Tap once to begin.',
      'tts_medical_sex':
      'What is your sex? Tap once for male. Tap twice for female.',
      'tts_medical_blood':
      'What is your blood type? '
          'Say A, B, AB, or O. Then say positive or negative.',
      'tts_medical_blood_confirm':
      'Blood type: {value}. Tap once to confirm. Tap twice to repeat.',
      'tts_medical_allergies':
      'Say each allergy then pause. Say next when done.',
      'tts_medical_allergy_added':
      'Added: {value}. Say another allergy or say next to continue.',
      'tts_medical_medications':
      'Say each medication then pause. Say next when done.',
      'tts_medical_med_added':
      'Added: {value}. Say another or say next to continue.',
      'tts_medical_diseases':
      'Say each disease or condition. Say next when done.',
      'tts_medical_disease_added':
      'Added: {value}. Say another or say next to continue.',
      'tts_medical_done':
      'Medical profile saved. Generating your QR profile card.',

      // ── QR Profile ───────────────────────────────────────
      'qr_title':     'Your Profile Card',
      'qr_subtitle':  'Share this QR with emergency responders.',
      'qr_share':     'Share QR',
      'qr_name':      'Name',
      'qr_sex':       'Sex',
      'qr_blood':     'Blood Type',
      'qr_allergies': 'Allergies',
      'qr_meds':      'Medications',
      'qr_diseases':  'Diseases',
      // TTS
      'tts_screen_qr':         'You are now on your profile card screen.',
      'tts_qr_intro':
      'Your profile QR card is ready. '
          'Tap once to share it. '
          'Tap twice to continue to biometrics setup.',
      'tts_qr_sharing': 'Opening share menu.',

      // ── Biometrics ───────────────────────────────────────
      'biometrics_title':    'Set up Biometrics',
      'biometrics_subtitle': 'Place your finger on the sensor to begin',
      'biometrics_skip':     'Skip for now',
      // TTS
      'tts_biometrics_intro':
      'Let\'s set up fingerprint login. Place your finger on the sensor.',

      // ── PIN / Email ───────────────────────────────────────
      'tts_email_intro':       'Please say your email address.',
      'tts_pin_intro':         'Please choose a 6-digit PIN. Say each digit clearly.',
      'tts_pin_confirm_intro': 'Please repeat your 6-digit PIN to confirm.',
      'tts_pin_heard':         'Digit {digit} received.',
      'tts_pin_full':          'Your PIN is {pin}. Tap once to confirm. Tap twice to redo.',
      'tts_pin_mismatch':      'PINs do not match. Let us try again.',
      'tts_email_full':        'Email: {email}. Tap once to confirm. Tap twice to redo.',

      // ── Hint banners ──────────────────────────────────────
      'hint_acc':       '1 tap = Select  ·  2nd tap = Confirm',
      'hint_lang':      '1 tap = Keep  ·  2 taps = Browse',
      'hint_voice':     'Left = Female  ·  Right = Male  ·  Center = Confirm',
      'hint_getstarted':'Top = New account  ·  Bottom = Sign in',
      'hint_signup':    '1 tap = Confirm  ·  2 taps = Repeat',
      'hint_signin':    '1 tap = Confirm  ·  2 taps = Repeat',
      'hint_medical':   'Follow voice instructions',
      'hint_qr':        '1 tap = Share  ·  2 taps = Continue',
    },

    // ══════════════════════════════════════════════════════
    'ar': {
      'next':           'التالي',
      'continue_btn':   'متابعة',
      'done':           'تم',
      'skip':           'تخطي الآن',
      'yes':            'نعم',
      'no':             'لا',
      'or':             'أو',
      'confirm':        'تأكيد',
      'repeat':         'إعادة',
      'cancel':         'إلغاء',
      'save':           'حفظ',
      'none':           'لا يوجد',

      'acc_title':      'كيف تريد استخدام\nلوموس؟',
      'acc_subtitle':   'اختر طريقة تفاعلك مع المساعد.',
      'acc_manual':     'يدوي',
      'acc_manual_sub': 'التنقل باللمس والواجهة البصرية.',
      'acc_voice':      'مساعد صوتي',
      'acc_voice_sub':  'دع لوموس يرشدك بالصوت.',
      'acc_confirm_hint':
      'اضغط الكارت المضاء مرة أخرى للتأكيد  ·  اضغط هنا للإلغاء',
      'tts_screen_acc': 'أنت الآن في شاشة اختيار وضع الوصول.',
      'tts_acc_welcome':
      'أهلاً بك في لوموس. '
          'الكارت العلوي هو الوضع اليدوي. '
          'الكارت السفلي هو المساعد الصوتي. '
          'اضغط على كارت مرة للاختيار، ثم اضغط عليه مرة أخرى للتأكيد.',
      'tts_acc_selected':
      'اخترت {mode}. اضغط على نفس الكارت مرة أخرى للتأكيد.',

      'choose_language':  'اختر اللغة',
      'lang_subtitle':    'اختر لغتك المفضلة.',
      'search_langs':     'ابحث عن لغة...',
      'default_lang':     'لغة النظام الافتراضية',
      'tts_screen_lang':       'أنت الآن في شاشة اختيار اللغة.',
      'tts_lang_intro':
      'لغة جهازك هي {lang}. '
          'اضغط مرة للاحتفاظ بها. '
          'اضغط مرتين لتصفح اللغات الأخرى.',
      'tts_lang_browse':
      'تصفح اللغات. سأقرأ كل لغة. اضغط مرة للاختيار.',
      'tts_lang_selected':
      'تم اختيار اللغة: {lang}. اضغط مرة للتأكيد والمتابعة.',

      'choose_voice':       'اختر صوتاً\nلمساعدك',
      'male_voice':         'صوت ذكر',
      'female_voice':       'صوت أنثى',
      'voice_hint_voice_screen':
      'اضغط يساراً لصوت الأنثى  ·  اضغط يميناً لصوت الذكر  ·  اضغط في المنتصف للتأكيد',
      'tts_screen_voice':      'أنت الآن في شاشة اختيار الصوت.',
      'tts_voice_intro':
      'اختر صوت المساعد. '
          'اضغط الجانب الأيسر للشاشة لسماع صوت الأنثى. '
          'اضغط الجانب الأيمن لسماع صوت الذكر. '
          'عندما يعجبك الصوت، اضغط في المنتصف للتأكيد.',
      'tts_voice_female_sample': 'أبصر ما وراء الحدود.',
      'tts_voice_male_sample':   'أبصر ما وراء الحدود.',
      'tts_voice_confirm_hint':
      'إذا أعجبك هذا الصوت، اضغط في منتصف الشاشة للتأكيد.',
      'tts_voice_chosen':    'اخترت {gender}.',
      'tts_voice_confirmed': 'تم تأكيد الصوت. جارٍ المتابعة.',

      'create_account':   'إنشاء حساب جديد',
      'already_account':  'لدي حساب بالفعل',
      'tts_screen_getstarted': 'أنت الآن في شاشة البداية.',
      'tts_getstarted_intro':
      'إذا لم يكن لديك حساب، اضغط في النصف العلوي من الشاشة. '
          'إذا كان لديك حساب، اضغط في النصف السفلي.',

      'sign_up':              'إنشاء حساب',
      'create_acc_title':     'إنشاء حساب',
      'full_name':            'الاسم الكامل',
      'enter_name':           'أدخل اسمك الكامل',
      'email':                'البريد الإلكتروني',
      'enter_email':          'أدخل بريدك الإلكتروني',
      'password':             'كلمة المرور',
      'create_password':      'أنشئ كلمة مرور',
      'repeat_password':      'تأكيد كلمة المرور',
      'confirm_password':     'أكد كلمة المرور',
      'tts_screen_signup':     'أنت الآن في شاشة إنشاء الحساب.',
      'tts_signup_intro':
      'لننشئ حسابك. سأرشدك خطوة بخطوة.',
      'tts_signup_name':      'من فضلك قل اسمك الكامل.',
      'tts_signup_name_confirm':
      'سمعت: {value}. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_signup_email':     'من فضلك قل بريدك الإلكتروني.',
      'tts_signup_email_confirm':
      'البريد: {value}. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_signup_password':  'من فضلك قل كلمة مرورك.',
      'tts_signup_password_confirm':
      'تم استلام كلمة المرور. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_signup_confirm_password': 'من فضلك أعد كلمة مرورك للتأكيد.',
      'tts_signup_done':
      'تم إنشاء الحساب. ننتقل الآن إلى ملفك الطبي.',
      'tts_listening':  'أستمع...',
      'tts_heard':      'سمعت: {value}',

      'sign_in':            'تسجيل الدخول',
      'welcome_back':       'مرحباً بعودتك',
      'signin_subtitle':    'أدخل بياناتك لتسجيل الدخول',
      'forgot_password':    'نسيت كلمة المرور؟',
      'tts_screen_signin':     'أنت الآن في شاشة تسجيل الدخول.',
      'tts_signin_intro':     'مرحباً بعودتك. من فضلك قل بريدك الإلكتروني.',
      'tts_signin_email_confirm':
      'البريد: {value}. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_signin_password':  'من فضلك قل كلمة مرورك.',
      'tts_signin_password_confirm':
      'تم استلام كلمة المرور. اضغط مرة لتسجيل الدخول. مرتين للإعادة.',
      'tts_signin_success':   'تم تسجيل الدخول. مرحباً {name}.',
      'tts_signin_fail':      'البريد أو كلمة المرور خاطئة. حاول مجدداً.',

      'medical_profile':  'الملف الطبي',
      'sex':              'الجنس',
      'male':             'ذكر',
      'female':           'أنثى',
      'blood_type':       'فصيلة الدم',
      'allergies':        'الحساسية',
      'medications':      'الأدوية',
      'diseases':         'الأمراض',
      'add':              'إضافة',
      'type_here':        'اكتب هنا...',
      'tts_screen_medical':    'أنت الآن في شاشة الملف الطبي.',
      'tts_medical_intro':
      'لنكمل ملفك الطبي. يساعد هذا خدمات الطوارئ. اضغط مرة للبدء.',
      'tts_medical_sex':
      'ما جنسك؟ اضغط مرة للذكر. مرتين للأنثى.',
      'tts_medical_blood':
      'ما فصيلة دمك؟ قل أ، ب، أب، أو أو. ثم قل موجب أو سالب.',
      'tts_medical_blood_confirm':
      'فصيلة الدم: {value}. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_medical_allergies':
      'قل كل حساسية ثم توقف. قل التالي عند الانتهاء.',
      'tts_medical_allergy_added':
      'تمت الإضافة: {value}. قل حساسية أخرى أو قل التالي.',
      'tts_medical_medications':
      'قل كل دواء ثم توقف. قل التالي عند الانتهاء.',
      'tts_medical_med_added':
      'تمت الإضافة: {value}. قل دواءً آخر أو قل التالي.',
      'tts_medical_diseases':
      'قل كل مرض أو حالة. قل التالي عند الانتهاء.',
      'tts_medical_disease_added':
      'تمت الإضافة: {value}. قل حالة أخرى أو قل التالي.',
      'tts_medical_done':
      'تم حفظ الملف الطبي. جارٍ إنشاء بطاقة QR الخاصة بك.',

      'qr_title':     'بطاقة ملفك الشخصي',
      'qr_subtitle':  'شارك هذا الرمز مع خدمات الطوارئ.',
      'qr_share':     'مشاركة QR',
      'qr_name':      'الاسم',
      'qr_sex':       'الجنس',
      'qr_blood':     'فصيلة الدم',
      'qr_allergies': 'الحساسية',
      'qr_meds':      'الأدوية',
      'qr_diseases':  'الأمراض',
      'tts_screen_qr':         'أنت الآن في شاشة بطاقة ملفك الشخصي.',
      'tts_qr_intro':
      'بطاقة QR الطبية جاهزة. '
          'اضغط مرة لمشاركتها. '
          'اضغط مرتين للمتابعة إلى إعداد البصمة.',
      'tts_qr_sharing': 'فتح قائمة المشاركة.',

      'biometrics_title':    'إعداد البصمة',
      'biometrics_subtitle': 'ضع إصبعك على المستشعر للبدء',
      'biometrics_skip':     'تخطي الآن',
      'tts_biometrics_intro':
      'لنضبط تسجيل الدخول بالبصمة. ضع إصبعك على المستشعر.',

      'tts_email_intro':       'من فضلك قل عنوان بريدك الإلكتروني.',
      'tts_pin_intro':         'اختر رمزاً مكوناً من 6 أرقام. قل كل رقم بوضوح.',
      'tts_pin_confirm_intro': 'أعد رمزك المكون من 6 أرقام للتأكيد.',
      'tts_pin_heard':         'استلمت الرقم {digit}.',
      'tts_pin_full':          'رمزك هو {pin}. اضغط مرة للتأكيد. مرتين للإعادة.',
      'tts_pin_mismatch':      'الرمزان لا يتطابقان. لنحاول مجدداً.',
      'tts_email_full':        'البريد: {email}. اضغط مرة للتأكيد. مرتين للإعادة.',

      'hint_acc':       'ضغطة = اختيار  ·  ضغطة ثانية = تأكيد',
      'hint_lang':      'ضغطة = احتفظ  ·  ضغطتان = تصفح',
      'hint_voice':     'يسار = أنثى  ·  يمين = ذكر  ·  وسط = تأكيد',
      'hint_getstarted':'فوق = حساب جديد  ·  تحت = دخول',
      'hint_signup':    'ضغطة = تأكيد  ·  ضغطتان = إعادة',
      'hint_signin':    'ضغطة = تأكيد  ·  ضغطتان = إعادة',
      'hint_medical':   'اتبع التعليمات الصوتية',
      'hint_qr':        'ضغطة = مشاركة  ·  ضغطتان = متابعة',
    },

    // ══════════════════════════════════════════════════════
    'es': {
      'next':           'Siguiente',
      'continue_btn':   'Continuar',
      'done':           'Listo',
      'skip':           'Omitir por ahora',
      'yes':            'Sí',
      'no':             'No',
      'or':             'o',
      'confirm':        'Confirmar',
      'repeat':         'Repetir',
      'cancel':         'Cancelar',
      'save':           'Guardar',
      'none':           'Ninguno',

      'acc_title':      '¿Cómo quieres usar\nLumos?',
      'acc_subtitle':   'Elige cómo interactuar con tu asistente.',
      'acc_manual':     'Manual',
      'acc_manual_sub': 'Navega con táctil e interfaz visual.',
      'acc_voice':      'Asistente de voz',
      'acc_voice_sub':  'Deja que Lumos te guíe con voz y audio.',
      'acc_confirm_hint':
      'Toca la tarjeta resaltada de nuevo para confirmar  ·  Toca aquí para cancelar',
      'tts_screen_acc': 'Estás en la pantalla de modo de accesibilidad.',
      'tts_acc_welcome':
      'Bienvenido a Lumos. '
          'La tarjeta superior es el modo Manual. '
          'La tarjeta inferior es el Asistente de Voz. '
          'Toca una tarjeta para seleccionarla y tócala de nuevo para confirmar.',
      'tts_acc_selected':
      'Seleccionaste {mode}. Toca la misma tarjeta una vez más para confirmar.',

      'choose_language':  'Elegir idioma',
      'lang_subtitle':    'Selecciona tu idioma preferido.',
      'search_langs':     'Buscar idiomas...',
      'default_lang':     'Idioma del sistema',
      'tts_screen_lang':       'Estás en la pantalla de selección de idioma.',
      'tts_lang_intro':
      'El idioma de tu dispositivo es {lang}. '
          'Toca una vez para mantenerlo. '
          'Toca dos veces para explorar otros.',
      'tts_lang_browse':
      'Explorando idiomas. Leeré cada uno. Toca una vez para seleccionar.',
      'tts_lang_selected':
      'Idioma: {lang}. Toca una vez para confirmar y continuar.',

      'choose_voice':       'Elige Una Voz\nPara Tu Asistente',
      'male_voice':         'Voz Masculina',
      'female_voice':       'Voz Femenina',
      'voice_hint_voice_screen':
      'Toca izquierda para Voz Femenina  ·  Toca derecha para Voz Masculina  ·  Toca centro para confirmar',
      'tts_screen_voice':      'Estás en la pantalla de selección de voz.',
      'tts_voice_intro':
      'Elige una voz para tu asistente. '
          'Toca el lado izquierdo para escuchar la voz femenina. '
          'Toca el lado derecho para la masculina. '
          'Cuando te guste, toca el centro para confirmar.',
      'tts_voice_female_sample': 'Ve más allá de los límites.',
      'tts_voice_male_sample':   'Ve más allá de los límites.',
      'tts_voice_confirm_hint':
      'Si te gusta esta voz, toca el centro de la pantalla para confirmar.',
      'tts_voice_chosen':    'Elegiste {gender}.',
      'tts_voice_confirmed': 'Voz confirmada. Continuando.',

      'create_account':   'Crear Una Nueva Cuenta',
      'already_account':  'Ya Tengo Una Cuenta',
      'tts_screen_getstarted': 'Estás en la pantalla de inicio.',
      'tts_getstarted_intro':
      'Si no tienes cuenta, toca la mitad superior de la pantalla. '
          'Si ya tienes cuenta, toca la mitad inferior.',

      'sign_up':              'Registrarse',
      'create_acc_title':     'Crear cuenta',
      'full_name':            'Nombre completo',
      'enter_name':           'Ingresa tu nombre',
      'email':                'Correo electrónico',
      'enter_email':          'Ingresa tu correo',
      'password':             'Contraseña',
      'create_password':      'Crea una contraseña',
      'repeat_password':      'Repetir contraseña',
      'confirm_password':     'Confirma tu contraseña',
      'tts_screen_signup':     'Estás en la pantalla de creación de cuenta.',
      'tts_signup_intro':     'Vamos a crear tu cuenta. Te guiaré paso a paso.',
      'tts_signup_name':      'Por favor di tu nombre completo.',
      'tts_signup_name_confirm':
      'Escuché: {value}. Toca una vez para confirmar. Dos para repetir.',
      'tts_signup_email':     'Por favor di tu correo electrónico.',
      'tts_signup_email_confirm':
      'Correo: {value}. Toca una vez para confirmar. Dos para repetir.',
      'tts_signup_password':  'Por favor di tu contraseña.',
      'tts_signup_password_confirm':
      'Contraseña recibida. Toca una vez para confirmar. Dos para repetir.',
      'tts_signup_confirm_password': 'Por favor repite tu contraseña para confirmar.',
      'tts_signup_done':  'Cuenta creada. Pasando a tu perfil médico.',
      'tts_listening':    'Escuchando...',
      'tts_heard':        'Escuché: {value}',

      'sign_in':          'Iniciar sesión',
      'welcome_back':     'Bienvenido de nuevo',
      'signin_subtitle':  'Ingresa tus datos para iniciar sesión',
      'forgot_password':  '¿Olvidaste tu contraseña?',
      'tts_screen_signin': 'Estás en la pantalla de inicio de sesión.',
      'tts_signin_intro': 'Bienvenido de nuevo. Por favor di tu correo.',
      'tts_signin_email_confirm':
      'Correo: {value}. Toca una vez para confirmar. Dos para repetir.',
      'tts_signin_password': 'Por favor di tu contraseña.',
      'tts_signin_password_confirm':
      'Contraseña recibida. Toca para iniciar sesión. Dos para repetir.',
      'tts_signin_success': 'Sesión iniciada. Bienvenido, {name}.',
      'tts_signin_fail':  'Correo o contraseña incorrectos. Intenta de nuevo.',

      'medical_profile':  'Perfil Médico',
      'sex':              'Sexo',
      'male':             'Masculino',
      'female':           'Femenino',
      'blood_type':       'Tipo de sangre',
      'allergies':        'Alergias',
      'medications':      'Medicamentos',
      'diseases':         'Enfermedades',
      'add':              'Agregar',
      'type_here':        'Escribe aquí...',
      'tts_screen_medical':    'Estás en la pantalla de perfil médico.',
      'tts_medical_intro':
      'Completemos tu perfil médico. Toca una vez para comenzar.',
      'tts_medical_sex':
      '¿Cuál es tu sexo? Toca una vez para masculino. Dos para femenino.',
      'tts_medical_blood':
      '¿Cuál es tu tipo de sangre? Di A, B, AB u O, luego positivo o negativo.',
      'tts_medical_blood_confirm':
      'Tipo de sangre: {value}. Toca una vez para confirmar. Dos para repetir.',
      'tts_medical_allergies':
      'Di cada alergia y pausa. Di siguiente cuando termines.',
      'tts_medical_allergy_added':
      'Agregado: {value}. Di otra alergia o siguiente.',
      'tts_medical_medications':
      'Di cada medicamento y pausa. Di siguiente cuando termines.',
      'tts_medical_med_added':  'Agregado: {value}. Di otro o siguiente.',
      'tts_medical_diseases':   'Di cada enfermedad. Di siguiente cuando termines.',
      'tts_medical_disease_added': 'Agregado: {value}. Di otro o siguiente.',
      'tts_medical_done':       'Perfil médico guardado. Generando tu tarjeta QR.',

      'qr_title':     'Tu Tarjeta de Perfil',
      'qr_subtitle':  'Comparte este QR con servicios de emergencia.',
      'qr_share':     'Compartir QR',
      'qr_name':      'Nombre',
      'qr_sex':       'Sexo',
      'qr_blood':     'Tipo de sangre',
      'qr_allergies': 'Alergias',
      'qr_meds':      'Medicamentos',
      'qr_diseases':  'Enfermedades',
      'tts_screen_qr':         'Estás en la pantalla de tu tarjeta de perfil.',
      'tts_qr_intro':
      'Tu tarjeta QR está lista. '
          'Toca una vez para compartir. '
          'Toca dos veces para continuar.',
      'tts_qr_sharing': 'Abriendo menú de compartir.',

      'biometrics_title':    'Configurar biometría',
      'biometrics_subtitle': 'Coloca tu dedo en el sensor para comenzar',
      'biometrics_skip':     'Omitir por ahora',
      'tts_biometrics_intro':
      'Configuremos el inicio de sesión con huella. Coloca tu dedo en el sensor.',

      'tts_email_intro':       'Por favor di tu correo electrónico.',
      'tts_pin_intro':         'Elige un PIN de 6 dígitos. Di cada dígito claramente.',
      'tts_pin_confirm_intro': 'Repite tu PIN de 6 dígitos para confirmar.',
      'tts_pin_heard':         'Dígito {digit} recibido.',
      'tts_pin_full':          'Tu PIN es {pin}. Toca una vez para confirmar. Dos para rehacer.',
      'tts_pin_mismatch':      'Los PINs no coinciden. Intentemos de nuevo.',
      'tts_email_full':        'Correo: {email}. Toca una vez para confirmar. Dos para rehacer.',

      'hint_acc':       '1 toque = Seleccionar  ·  2do toque = Confirmar',
      'hint_lang':      '1 toque = Mantener  ·  2 toques = Explorar',
      'hint_voice':     'Izq = Femenina  ·  Der = Masculina  ·  Centro = Confirmar',
      'hint_getstarted':'Arriba = Nueva cuenta  ·  Abajo = Iniciar sesión',
      'hint_signup':    '1 toque = Confirmar  ·  2 toques = Repetir',
      'hint_signin':    '1 toque = Confirmar  ·  2 toques = Repetir',
      'hint_medical':   'Sigue las instrucciones de voz',
      'hint_qr':        '1 toque = Compartir  ·  2 toques = Continuar',
    },

    // ══════════════════════════════════════════════════════
    'fr': {
      'next':           'Suivant',
      'continue_btn':   'Continuer',
      'done':           'Terminé',
      'skip':           'Passer pour l\'instant',
      'yes':            'Oui',
      'no':             'Non',
      'or':             'ou',
      'confirm':        'Confirmer',
      'repeat':         'Répéter',
      'cancel':         'Annuler',
      'save':           'Enregistrer',
      'none':           'Aucun',

      'acc_title':      'Comment voulez-vous\nutiliser Lumos?',
      'acc_subtitle':   'Choisissez comment interagir avec votre assistant.',
      'acc_manual':     'Manuel',
      'acc_manual_sub': 'Naviguez avec le toucher et l\'interface visuelle.',
      'acc_voice':      'Assistant vocal',
      'acc_voice_sub':  'Laissez Lumos vous guider avec voix et audio.',
      'acc_confirm_hint':
      'Appuyez à nouveau sur la carte en surbrillance pour confirmer  ·  Ici pour annuler',
      'tts_screen_acc': 'Vous êtes sur l\'écran du mode d\'accessibilité.',
      'tts_acc_welcome':
      'Bienvenue sur Lumos. '
          'La carte du haut est le mode Manuel. '
          'La carte du bas est l\'Assistant Vocal. '
          'Appuyez sur une carte pour la sélectionner, puis appuyez à nouveau pour confirmer.',
      'tts_acc_selected':
      'Vous avez sélectionné {mode}. Appuyez à nouveau sur la même carte pour confirmer.',

      'choose_language':  'Choisir la langue',
      'lang_subtitle':    'Sélectionnez votre langue préférée.',
      'search_langs':     'Rechercher des langues...',
      'default_lang':     'Langue du système',
      'tts_screen_lang':       'Vous êtes sur l\'écran de sélection de langue.',
      'tts_lang_intro':
      'La langue de votre appareil est {lang}. '
          'Appuyez une fois pour la conserver. '
          'Deux fois pour explorer.',
      'tts_lang_browse':
      'Explorer les langues. Je lirai chacune. Appuyez une fois pour sélectionner.',
      'tts_lang_selected':
      'Langue: {lang}. Appuyez une fois pour confirmer et continuer.',

      'choose_voice':       'Choisissez Une Voix\nPour Votre Assistant',
      'male_voice':         'Voix Masculine',
      'female_voice':       'Voix Féminine',
      'voice_hint_voice_screen':
      'Gauche = Voix Féminine  ·  Droite = Voix Masculine  ·  Centre = Confirmer',
      'tts_screen_voice':      'Vous êtes sur l\'écran de sélection de voix.',
      'tts_voice_intro':
      'Choisissez une voix pour votre assistant. '
          'Appuyez sur le côté gauche pour entendre la voix féminine. '
          'Le côté droit pour la masculine. '
          'Quand elle vous plaît, appuyez au centre pour confirmer.',
      'tts_voice_female_sample': 'Voyez au-delà des limites.',
      'tts_voice_male_sample':   'Voyez au-delà des limites.',
      'tts_voice_confirm_hint':
      'Si cette voix vous convient, appuyez au centre de l\'écran pour confirmer.',
      'tts_voice_chosen':    'Vous avez choisi {gender}.',
      'tts_voice_confirmed': 'Voix confirmée. On continue.',

      'create_account':   'Créer Un Nouveau Compte',
      'already_account':  'J\'ai Déjà Un Compte',
      'tts_screen_getstarted': 'Vous êtes sur l\'écran de démarrage.',
      'tts_getstarted_intro':
      'Si vous n\'avez pas de compte, appuyez sur la moitié supérieure de l\'écran. '
          'Si vous en avez un, appuyez sur la moitié inférieure.',

      'sign_up':              'S\'inscrire',
      'create_acc_title':     'Créer un compte',
      'full_name':            'Nom complet',
      'enter_name':           'Entrez votre nom',
      'email':                'Adresse e-mail',
      'enter_email':          'Entrez votre e-mail',
      'password':             'Mot de passe',
      'create_password':      'Créez un mot de passe',
      'repeat_password':      'Répéter le mot de passe',
      'confirm_password':     'Confirmez votre mot de passe',
      'tts_screen_signup':     'Vous êtes sur l\'écran de création de compte.',
      'tts_signup_intro':     'Créons votre compte. Je vous guiderai étape par étape.',
      'tts_signup_name':      'Veuillez dire votre nom complet.',
      'tts_signup_name_confirm':
      'J\'ai entendu: {value}. Appuyez une fois pour confirmer. Deux pour répéter.',
      'tts_signup_email':     'Veuillez dire votre adresse e-mail.',
      'tts_signup_email_confirm':
      'E-mail: {value}. Appuyez une fois pour confirmer. Deux pour répéter.',
      'tts_signup_password':  'Veuillez dire votre mot de passe.',
      'tts_signup_password_confirm':
      'Mot de passe reçu. Appuyez une fois pour confirmer. Deux pour répéter.',
      'tts_signup_confirm_password': 'Veuillez répéter votre mot de passe pour confirmer.',
      'tts_signup_done':  'Compte créé. Passage au profil médical.',
      'tts_listening':    'J\'écoute...',
      'tts_heard':        'J\'ai entendu: {value}',

      'sign_in':          'Se connecter',
      'welcome_back':     'Bon retour',
      'signin_subtitle':  'Entrez vos identifiants pour vous connecter',
      'forgot_password':  'Mot de passe oublié?',
      'tts_screen_signin': 'Vous êtes sur l\'écran de connexion.',
      'tts_signin_intro': 'Bon retour. Dites votre adresse e-mail.',
      'tts_signin_email_confirm':
      'E-mail: {value}. Appuyez une fois pour confirmer. Deux pour répéter.',
      'tts_signin_password': 'Veuillez dire votre mot de passe.',
      'tts_signin_password_confirm':
      'Reçu. Appuyez pour vous connecter. Deux pour répéter.',
      'tts_signin_success': 'Connecté. Bienvenue, {name}.',
      'tts_signin_fail':  'E-mail ou mot de passe incorrect. Réessayez.',

      'medical_profile':  'Profil Médical',
      'sex':              'Sexe',
      'male':             'Masculin',
      'female':           'Féminin',
      'blood_type':       'Groupe sanguin',
      'allergies':        'Allergies',
      'medications':      'Médicaments',
      'diseases':         'Maladies',
      'add':              'Ajouter',
      'type_here':        'Tapez ici...',
      'tts_screen_medical':    'Vous êtes sur l\'écran de profil médical.',
      'tts_medical_intro':     'Remplissons votre profil médical. Appuyez une fois pour commencer.',
      'tts_medical_sex':       'Quel est votre sexe? Appuyez une fois pour masculin. Deux pour féminin.',
      'tts_medical_blood':     'Quel est votre groupe sanguin? Dites A, B, AB ou O, puis positif ou négatif.',
      'tts_medical_blood_confirm': 'Groupe sanguin: {value}. Appuyez une fois pour confirmer. Deux pour répéter.',
      'tts_medical_allergies': 'Dites chaque allergie puis pausez. Dites suivant quand vous avez terminé.',
      'tts_medical_allergy_added': 'Ajouté: {value}. Dites une autre allergie ou suivant.',
      'tts_medical_medications': 'Dites chaque médicament. Dites suivant quand vous avez terminé.',
      'tts_medical_med_added':   'Ajouté: {value}. Dites un autre ou suivant.',
      'tts_medical_diseases':    'Dites chaque maladie. Dites suivant quand vous avez terminé.',
      'tts_medical_disease_added': 'Ajouté: {value}. Dites un autre ou suivant.',
      'tts_medical_done':        'Profil médical sauvegardé. Génération de votre carte QR.',

      'qr_title':     'Votre Carte de Profil',
      'qr_subtitle':  'Partagez ce QR avec les secours.',
      'qr_share':     'Partager QR',
      'qr_name':      'Nom',
      'qr_sex':       'Sexe',
      'qr_blood':     'Groupe sanguin',
      'qr_allergies': 'Allergies',
      'qr_meds':      'Médicaments',
      'qr_diseases':  'Maladies',
      'tts_screen_qr':         'Vous êtes sur l\'écran de votre carte de profil.',
      'tts_qr_intro':
      'Votre carte QR est prête. '
          'Appuyez une fois pour partager. '
          'Deux fois pour continuer.',
      'tts_qr_sharing': 'Ouverture du menu de partage.',

      'biometrics_title':    'Configurer la biométrie',
      'biometrics_subtitle': 'Placez votre doigt sur le capteur',
      'biometrics_skip':     'Passer pour l\'instant',
      'tts_biometrics_intro': 'Configurons la connexion par empreinte. Placez votre doigt sur le capteur.',

      'tts_email_intro':       'Veuillez dire votre adresse e-mail.',
      'tts_pin_intro':         'Choisissez un code PIN à 6 chiffres. Dites chaque chiffre clairement.',
      'tts_pin_confirm_intro': 'Répétez votre code PIN à 6 chiffres pour confirmer.',
      'tts_pin_heard':         'Chiffre {digit} reçu.',
      'tts_pin_full':          'Votre PIN est {pin}. Appuyez une fois pour confirmer. Deux pour refaire.',
      'tts_pin_mismatch':      'Les codes ne correspondent pas. Réessayons.',
      'tts_email_full':        'E-mail: {email}. Appuyez une fois pour confirmer. Deux pour refaire.',

      'hint_acc':       '1 tap = Sélectionner  ·  2e tap = Confirmer',
      'hint_lang':      '1 tap = Garder  ·  2 taps = Explorer',
      'hint_voice':     'Gauche = Féminine  ·  Droite = Masculine  ·  Centre = Confirmer',
      'hint_getstarted':'Haut = Nouveau compte  ·  Bas = Connexion',
      'hint_signup':    '1 tap = Confirmer  ·  2 taps = Répéter',
      'hint_signin':    '1 tap = Confirmer  ·  2 taps = Répéter',
      'hint_medical':   'Suivez les instructions vocales',
      'hint_qr':        '1 tap = Partager  ·  2 taps = Continuer',
    },

    // ══════════════════════════════════════════════════════
    'de': {
      'next':           'Weiter',
      'continue_btn':   'Weiter',
      'done':           'Fertig',
      'skip':           'Jetzt überspringen',
      'yes':            'Ja',
      'no':             'Nein',
      'or':             'oder',
      'confirm':        'Bestätigen',
      'repeat':         'Wiederholen',
      'cancel':         'Abbrechen',
      'save':           'Speichern',
      'none':           'Keine',

      'acc_title':      'Wie möchtest du\nLumos nutzen?',
      'acc_subtitle':   'Wähle, wie du mit deinem Assistenten interagierst.',
      'acc_manual':     'Manuell',
      'acc_manual_sub': 'Navigiere mit Touch und visueller Oberfläche.',
      'acc_voice':      'Sprachassistent',
      'acc_voice_sub':  'Lass Lumos dich mit Sprache führen.',
      'acc_confirm_hint':
      'Tippe die markierte Karte erneut zum Bestätigen  ·  Hier zum Abbrechen',
      'tts_screen_acc': 'Du bist auf dem Zugänglichkeitsmodus-Bildschirm.',
      'tts_acc_welcome':
      'Willkommen bei Lumos. '
          'Die obere Karte ist der manuelle Modus. '
          'Die untere Karte ist der Sprachassistent. '
          'Tippe eine Karte zum Auswählen, dann nochmals zum Bestätigen.',
      'tts_acc_selected':
      'Du hast {mode} gewählt. Tippe dieselbe Karte nochmals zum Bestätigen.',

      'choose_language':  'Sprache wählen',
      'lang_subtitle':    'Wähle deine bevorzugte Sprache.',
      'search_langs':     'Sprachen suchen...',
      'default_lang':     'Systemsprache',
      'tts_screen_lang':       'Du bist auf dem Sprachauswahlbildschirm.',
      'tts_lang_intro':
      'Die Sprache deines Geräts ist {lang}. '
          'Einmal tippen zum Beibehalten. '
          'Zweimal für andere Sprachen.',
      'tts_lang_browse':
      'Sprachen durchsuchen. Ich lese jede vor. Einmal tippen zum Auswählen.',
      'tts_lang_selected':
      'Sprache: {lang}. Einmal tippen zum Bestätigen.',

      'choose_voice':       'Wähle Eine Stimme\nFür Deinen Assistenten',
      'male_voice':         'Männliche Stimme',
      'female_voice':       'Weibliche Stimme',
      'voice_hint_voice_screen':
      'Links = Weibliche Stimme  ·  Rechts = Männliche Stimme  ·  Mitte = Bestätigen',
      'tts_screen_voice':      'Du bist auf dem Stimmauswahlbildschirm.',
      'tts_voice_intro':
      'Wähle eine Stimme für deinen Assistenten. '
          'Tippe auf die linke Seite für die weibliche Stimme. '
          'Rechts für die männliche. '
          'Wenn sie dir gefällt, tippe in die Mitte zum Bestätigen.',
      'tts_voice_female_sample': 'Sieh über Grenzen hinaus.',
      'tts_voice_male_sample':   'Sieh über Grenzen hinaus.',
      'tts_voice_confirm_hint':
      'Wenn dir diese Stimme gefällt, tippe die Mitte des Bildschirms zum Bestätigen.',
      'tts_voice_chosen':    'Du hast {gender} gewählt.',
      'tts_voice_confirmed': 'Stimme bestätigt. Weiter.',

      'create_account':   'Neues Konto Erstellen',
      'already_account':  'Ich Habe Bereits Ein Konto',
      'tts_screen_getstarted': 'Du bist auf dem Startbildschirm.',
      'tts_getstarted_intro':
      'Wenn du kein Konto hast, tippe auf die obere Hälfte des Bildschirms. '
          'Wenn du bereits eines hast, tippe auf die untere Hälfte.',

      'sign_up':              'Registrieren',
      'create_acc_title':     'Konto erstellen',
      'full_name':            'Vollständiger Name',
      'enter_name':           'Gib deinen Namen ein',
      'email':                'E-Mail-Adresse',
      'enter_email':          'Gib deine E-Mail ein',
      'password':             'Passwort',
      'create_password':      'Erstelle ein Passwort',
      'repeat_password':      'Passwort wiederholen',
      'confirm_password':     'Bestätige dein Passwort',
      'tts_screen_signup':     'Du bist auf dem Kontoerstellungsbildschirm.',
      'tts_signup_intro':     'Erstellen wir dein Konto. Ich führe dich Schritt für Schritt.',
      'tts_signup_name':      'Bitte sag deinen vollständigen Namen.',
      'tts_signup_name_confirm':
      'Ich hörte: {value}. Einmal tippen bestätigen. Zweimal wiederholen.',
      'tts_signup_email':     'Bitte sag deine E-Mail-Adresse.',
      'tts_signup_email_confirm':
      'E-Mail: {value}. Einmal bestätigen. Zweimal wiederholen.',
      'tts_signup_password':  'Bitte sag dein Passwort.',
      'tts_signup_password_confirm':
      'Passwort erhalten. Einmal bestätigen. Zweimal wiederholen.',
      'tts_signup_confirm_password': 'Bitte wiederhole dein Passwort zur Bestätigung.',
      'tts_signup_done':  'Konto erstellt. Weiter zum medizinischen Profil.',
      'tts_listening':    'Ich höre zu...',
      'tts_heard':        'Ich hörte: {value}',

      'sign_in':          'Anmelden',
      'welcome_back':     'Willkommen zurück',
      'signin_subtitle':  'Gib deine Daten zum Anmelden ein',
      'forgot_password':  'Passwort vergessen?',
      'tts_screen_signin': 'Du bist auf dem Anmeldebildschirm.',
      'tts_signin_intro': 'Willkommen zurück. Sag deine E-Mail-Adresse.',
      'tts_signin_email_confirm':
      'E-Mail: {value}. Einmal bestätigen. Zweimal wiederholen.',
      'tts_signin_password': 'Sag dein Passwort.',
      'tts_signin_password_confirm':
      'Erhalten. Einmal anmelden. Zweimal wiederholen.',
      'tts_signin_success': 'Angemeldet. Willkommen, {name}.',
      'tts_signin_fail':  'E-Mail oder Passwort falsch. Erneut versuchen.',

      'medical_profile':  'Medizinisches Profil',
      'sex':              'Geschlecht',
      'male':             'Männlich',
      'female':           'Weiblich',
      'blood_type':       'Blutgruppe',
      'allergies':        'Allergien',
      'medications':      'Medikamente',
      'diseases':         'Krankheiten',
      'add':              'Hinzufügen',
      'type_here':        'Hier eingeben...',
      'tts_screen_medical':    'Du bist auf dem medizinischen Profilbildschirm.',
      'tts_medical_intro':     'Füllen wir dein medizinisches Profil aus. Einmal tippen zum Starten.',
      'tts_medical_sex':       'Was ist dein Geschlecht? Einmal für männlich. Zweimal für weiblich.',
      'tts_medical_blood':     'Was ist deine Blutgruppe? Sag A, B, AB oder O, dann positiv oder negativ.',
      'tts_medical_blood_confirm': 'Blutgruppe: {value}. Einmal bestätigen. Zweimal wiederholen.',
      'tts_medical_allergies': 'Sag jede Allergie und pausiere. Sag weiter wenn fertig.',
      'tts_medical_allergy_added': 'Hinzugefügt: {value}. Weitere Allergie oder weiter.',
      'tts_medical_medications': 'Sag jedes Medikament. Sag weiter wenn fertig.',
      'tts_medical_med_added':   'Hinzugefügt: {value}. Weiteres oder weiter.',
      'tts_medical_diseases':    'Sag jede Krankheit. Sag weiter wenn fertig.',
      'tts_medical_disease_added': 'Hinzugefügt: {value}. Weitere oder weiter.',
      'tts_medical_done':        'Medizinisches Profil gespeichert. QR-Karte wird erstellt.',

      'qr_title':     'Deine Profilkarte',
      'qr_subtitle':  'Teile diesen QR mit Notfalldiensten.',
      'qr_share':     'QR Teilen',
      'qr_name':      'Name',
      'qr_sex':       'Geschlecht',
      'qr_blood':     'Blutgruppe',
      'qr_allergies': 'Allergien',
      'qr_meds':      'Medikamente',
      'qr_diseases':  'Krankheiten',
      'tts_screen_qr':         'Du bist auf deinem Profilkartenbildschirm.',
      'tts_qr_intro':
      'Deine QR-Karte ist fertig. '
          'Einmal tippen zum Teilen. '
          'Zweimal fortfahren.',
      'tts_qr_sharing': 'Teilen-Menü öffnen.',

      'biometrics_title':    'Biometrie einrichten',
      'biometrics_subtitle': 'Lege deinen Finger auf den Sensor',
      'biometrics_skip':     'Jetzt überspringen',
      'tts_biometrics_intro': 'Fingerabdruck-Login einrichten. Lege deinen Finger auf den Sensor.',

      'tts_email_intro':       'Bitte sag deine E-Mail-Adresse.',
      'tts_pin_intro':         'Wähle eine 6-stellige PIN. Sag jede Ziffer deutlich.',
      'tts_pin_confirm_intro': 'Wiederhole deine 6-stellige PIN zur Bestätigung.',
      'tts_pin_heard':         'Ziffer {digit} empfangen.',
      'tts_pin_full':          'Deine PIN ist {pin}. Einmal bestätigen. Zweimal wiederholen.',
      'tts_pin_mismatch':      'PINs stimmen nicht überein. Nochmals versuchen.',
      'tts_email_full':        'E-Mail: {email}. Einmal bestätigen. Zweimal wiederholen.',

      'hint_acc':       '1x tippen = Auswählen  ·  2x = Bestätigen',
      'hint_lang':      '1x = Behalten  ·  2x = Erkunden',
      'hint_voice':     'Links = Weiblich  ·  Rechts = Männlich  ·  Mitte = Bestätigen',
      'hint_getstarted':'Oben = Neues Konto  ·  Unten = Anmelden',
      'hint_signup':    '1x = Bestätigen  ·  2x = Wiederholen',
      'hint_signin':    '1x = Bestätigen  ·  2x = Wiederholen',
      'hint_medical':   'Sprachanweisungen folgen',
      'hint_qr':        '1x = Teilen  ·  2x = Weiter',
    },

    // ══════════════════════════════════════════════════════
    'ja': {
      'next':           '次へ',
      'continue_btn':   '続ける',
      'done':           '完了',
      'skip':           '今はスキップ',
      'yes':            'はい',
      'no':             'いいえ',
      'or':             'または',
      'confirm':        '確認',
      'repeat':         '繰り返す',
      'cancel':         'キャンセル',
      'save':           '保存',
      'none':           'なし',

      'acc_title':      'Lumosをどのように\n使いますか？',
      'acc_subtitle':   'アシスタントとの操作方法を選択してください。',
      'acc_manual':     '手動',
      'acc_manual_sub': 'タッチとビジュアルインターフェースで操作。',
      'acc_voice':      '音声アシスタント',
      'acc_voice_sub':  'Lumosが音声で案内します。',
      'acc_confirm_hint':
      'ハイライトされたカードをもう一度タップして確認  ·  ここでキャンセル',
      'tts_screen_acc': 'アクセシビリティモード画面です。',
      'tts_acc_welcome':
      'Lumosへようこそ。'
          '上のカードは手動モードです。'
          '下のカードは音声アシスタントです。'
          'カードをタップして選択し、もう一度タップして確認してください。',
      'tts_acc_selected':
      '{mode}を選択しました。同じカードをもう一度タップして確認してください。',

      'choose_language':  '言語を選択',
      'lang_subtitle':    'ご希望の言語を選択してください。',
      'search_langs':     '言語を検索...',
      'default_lang':     'デフォルト言語',
      'tts_screen_lang':       '言語選択画面です。',
      'tts_lang_intro':
      'デバイスの言語は{lang}です。'
          '1回タップでそのまま使用。'
          '2回タップで他の言語を選択。',
      'tts_lang_browse':
      '言語を参照中。各言語を読み上げます。1回タップで選択。',
      'tts_lang_selected':
      '言語: {lang}。1回タップで確認して続行。',

      'choose_voice':       'アシスタントの\n声を選んでください',
      'male_voice':         '男性の声',
      'female_voice':       '女性の声',
      'voice_hint_voice_screen':
      '左 = 女性の声  ·  右 = 男性の声  ·  中央 = 確認',
      'tts_screen_voice':      '声の選択画面です。',
      'tts_voice_intro':
      'アシスタントの声を選んでください。'
          '画面の左側をタップすると女性の声が聞けます。'
          '右側をタップすると男性の声が聞けます。'
          '気に入ったら中央をタップして確認してください。',
      'tts_voice_female_sample': '限界を超えて見てください。',
      'tts_voice_male_sample':   '限界を超えて見てください。',
      'tts_voice_confirm_hint':
      'この声が気に入ったら、画面の中央をタップして確認してください。',
      'tts_voice_chosen':    '{gender}を選びました。',
      'tts_voice_confirmed': '声が確定されました。続行します。',

      'create_account':   '新しいアカウントを作成',
      'already_account':  'すでにアカウントをお持ちの方',
      'tts_screen_getstarted': 'スタート画面です。',
      'tts_getstarted_intro':
      'アカウントをお持ちでない場合は、画面の上半分をタップしてください。'
          'すでにお持ちの場合は、下半分をタップしてください。',

      'sign_up':              '登録する',
      'create_acc_title':     'アカウント作成',
      'full_name':            '氏名',
      'enter_name':           '氏名を入力',
      'email':                'メールアドレス',
      'enter_email':          'メールを入力',
      'password':             'パスワード',
      'create_password':      'パスワードを作成',
      'repeat_password':      'パスワードを繰り返す',
      'confirm_password':     'パスワードを確認',
      'tts_screen_signup':     'アカウント作成画面です。',
      'tts_signup_intro':     'アカウントを作成しましょう。一歩一歩案内します。',
      'tts_signup_name':      'フルネームを言ってください。',
      'tts_signup_name_confirm':
      '聞こえました: {value}。1回タップで確認。2回で繰り返し。',
      'tts_signup_email':     'メールアドレスを言ってください。',
      'tts_signup_email_confirm':
      'メール: {value}。1回タップで確認。2回で繰り返し。',
      'tts_signup_password':  'パスワードを言ってください。',
      'tts_signup_password_confirm':
      'パスワード受信済み。1回タップで確認。2回で繰り返し。',
      'tts_signup_confirm_password': 'パスワードを再度言ってください。',
      'tts_signup_done':  'アカウントが作成されました。医療プロフィールへ。',
      'tts_listening':    '聴いています...',
      'tts_heard':        '聞こえました: {value}',

      'sign_in':          'ログイン',
      'welcome_back':     'おかえりなさい',
      'signin_subtitle':  'サインインの詳細を入力してください',
      'forgot_password':  'パスワードをお忘れですか？',
      'tts_screen_signin': 'サインイン画面です。',
      'tts_signin_intro': 'おかえりなさい。メールアドレスを言ってください。',
      'tts_signin_email_confirm':
      'メール: {value}。1回タップで確認。2回で繰り返し。',
      'tts_signin_password': 'パスワードを言ってください。',
      'tts_signin_password_confirm':
      '受信済み。1回タップでサインイン。2回で繰り返し。',
      'tts_signin_success': 'サインインしました。ようこそ、{name}。',
      'tts_signin_fail':  'メールまたはパスワードが正しくありません。',

      'medical_profile':  '医療プロフィール',
      'sex':              '性別',
      'male':             '男性',
      'female':           '女性',
      'blood_type':       '血液型',
      'allergies':        'アレルギー',
      'medications':      '薬',
      'diseases':         '病気',
      'add':              '追加',
      'type_here':        'ここに入力...',
      'tts_screen_medical':    '医療プロフィール画面です。',
      'tts_medical_intro':     '医療プロフィールを記入しましょう。1回タップで開始。',
      'tts_medical_sex':       '性別は何ですか？男性は1回タップ。女性は2回タップ。',
      'tts_medical_blood':     '血液型は何ですか？A、B、AB、またはOと言ってから陽性または陰性と言ってください。',
      'tts_medical_blood_confirm': '血液型: {value}。1回タップで確認。2回で繰り返し。',
      'tts_medical_allergies': 'アレルギーを一つずつ言ってください。終わったら次へと言ってください。',
      'tts_medical_allergy_added': '追加: {value}。別のアレルギーか次へと言ってください。',
      'tts_medical_medications': '薬を一つずつ言ってください。終わったら次へと言ってください。',
      'tts_medical_med_added':   '追加: {value}。別の薬か次へと言ってください。',
      'tts_medical_diseases':    '病気を言ってください。終わったら次へと言ってください。',
      'tts_medical_disease_added': '追加: {value}。別の病気か次へと言ってください。',
      'tts_medical_done':        '医療プロフィールが保存されました。QRカードを生成中。',

      'qr_title':     'プロフィールカード',
      'qr_subtitle':  'このQRを救急スタッフと共有してください。',
      'qr_share':     'QRを共有',
      'qr_name':      '名前',
      'qr_sex':       '性別',
      'qr_blood':     '血液型',
      'qr_allergies': 'アレルギー',
      'qr_meds':      '薬',
      'qr_diseases':  '疾患',
      'tts_screen_qr':         'プロフィールカード画面です。',
      'tts_qr_intro':
      'QRカードが準備できました。'
          '1回タップで共有。'
          '2回で生体認証設定へ。',
      'tts_qr_sharing': '共有メニューを開きます。',

      'biometrics_title':    '生体認証の設定',
      'biometrics_subtitle': 'センサーに指を置いて開始',
      'biometrics_skip':     '今はスキップ',
      'tts_biometrics_intro': '指紋ログインを設定しましょう。センサーに指を置いてください。',

      'tts_email_intro':       'メールアドレスを言ってください。',
      'tts_pin_intro':         '6桁のPINを選んでください。各数字を明確に言ってください。',
      'tts_pin_confirm_intro': '確認のため6桁のPINを繰り返してください。',
      'tts_pin_heard':         '数字{digit}を受信しました。',
      'tts_pin_full':          'PINは{pin}です。1回タップで確認。2回でやり直し。',
      'tts_pin_mismatch':      'PINが一致しません。もう一度試みましょう。',
      'tts_email_full':        'メール: {email}。1回タップで確認。2回でやり直し。',

      'hint_acc':       '1回 = 選択  ·  2回目 = 確認',
      'hint_lang':      '1回 = 保持  ·  2回 = 参照',
      'hint_voice':     '左 = 女性  ·  右 = 男性  ·  中央 = 確認',
      'hint_getstarted':'上 = 新規アカウント  ·  下 = サインイン',
      'hint_signup':    '1回 = 確認  ·  2回 = 繰り返し',
      'hint_signin':    '1回 = 確認  ·  2回 = 繰り返し',
      'hint_medical':   '音声指示に従ってください',
      'hint_qr':        '1回 = 共有  ·  2回 = 続ける',
    },
  };

  // ──────────────────────────────────────────────────────────
  //  API
  // ──────────────────────────────────────────────────────────

  static List<String> get supportedLocales => _all.keys.toList();

  static String get(String langCode, String key) =>
      _all[langCode]?[key] ?? _all['en']![key] ?? key;

  static String fill(
      String langCode,
      String key, [
        Map<String, String> args = const {},
      ]) {
    String s = get(langCode, key);
    args.forEach((k, v) => s = s.replaceAll('{$k}', v));
    return s;
  }

  static bool isRTL(String langCode) => langCode == 'ar';

  static String langName(String code) {
    const names = {
      'en': 'English (US)',
      'ar': 'العربية',
      'es': 'Español',
      'fr': 'Français',
      'de': 'Deutsch',
      'ja': '日本語',
    };
    return names[code] ?? code.toUpperCase();
  }

  static String ttsLocale(String code) {
    const locales = {
      'en': 'en-US',
      'ar': 'ar-SA',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'ja': 'ja-JP',
    };
    return locales[code] ?? 'en-US';
  }
}