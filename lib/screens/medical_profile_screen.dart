// lib/screens/medical_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart' show LocaleProvider, AppStrings;
import '../services/medical_api_service.dart';

const _bg      = Color(0xFF0D0A07);
const _card    = Color(0xFF1A1008);
const _orange  = Color(0xFFF27F0D);
const _txtW    = Color(0xFFF1F5F9);
const _txtGray = Color(0xFF94A3B8);
const _chipBg  = Color(0x33F27F0D);
const _chipBdr = Color(0x4DF27F0D);



class _TopNav extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TopNav({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
            child: const Icon(Icons.arrow_back, color: _txtW, size: 20),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(title,
                style: const TextStyle(
                  color: _txtW, fontSize: 18,
                  fontWeight: FontWeight.w600, letterSpacing: -0.3,
                )),
          ),
        ),
        const SizedBox(width: 40),
      ]),
    );
  }
}

class _DoneButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DoneButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _orange,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text('Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _txtGray, fontSize: 11,
      fontWeight: FontWeight.w700, letterSpacing: 0.8,
    ),
  );
}


class _EmptyIllustration extends StatelessWidget {
  final bool isDisease;
  const _EmptyIllustration({this.isDisease = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220, height: 220,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: 220, height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _orange.withOpacity(0.03),
            border: Border.all(color: _orange.withOpacity(0.10), width: 1),
          ),
        ),
        Container(
          width: 165, height: 165,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [_orange.withOpacity(0.40), _orange.withOpacity(0.12)],
              stops: const [0.3, 1.0],
            ),
            border: Border.all(color: _orange.withOpacity(0.20), width: 1),
          ),
          child: const Icon(Icons.medication_outlined, color: _orange, size: 54),
        ),
        if (isDisease) ...[
          Positioned(
            top: 16, right: 16,
            child: Transform.rotate(
              angle: -12 * 3.14159 / 180,
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: _orange.withOpacity(0.05),
                  border: Border.all(color: _orange.withOpacity(0.10), width: 1),
                ),
                child: Icon(Icons.medical_services_outlined,
                    color: _orange.withOpacity(0.65), size: 22),
              ),
            ),
          ),
          Positioned(
            bottom: 20, left: 20,
            child: Transform.rotate(
              angle: 12 * 3.14159 / 180,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: _orange.withOpacity(0.05),
                  border: Border.all(color: _orange.withOpacity(0.10), width: 1),
                ),
                child: Icon(Icons.monitor_heart_outlined,
                    color: _orange.withOpacity(0.65), size: 18),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}


class MedicalProfileScreen extends StatefulWidget {
  const MedicalProfileScreen({super.key});
  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  String? _sex;
  String? _bloodType;
  List<String> _allergies   = [];
  List<String> _medications = [];
  List<String> _diseases    = [];

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _loadMedicalData();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }


  Future<void> _loadMedicalData() async {
    setState(() => _isLoading = true);

    final profile = await MedicalAPIService.getMedicalProfile();
    if (profile != null && mounted) {
      setState(() {
        _sex = MedicalAPIService.genderFromInt(profile['gender']);
        _bloodType = MedicalAPIService.bloodTypeFromInt(profile['bloodType']);
      });
    }

    final allergies = await MedicalAPIService.getAllergies();
    if (mounted) setState(() => _allergies = allergies);
    final medications = await MedicalAPIService.getMedications();
    if (mounted) setState(() => _medications = medications);
    final diseases = await MedicalAPIService.getChronicDiseases();
    if (mounted) setState(() => _diseases = diseases);
    setState(() => _isLoading = false);
  }

  Future<void> _saveMedicalProfile() async {
    setState(() => _isSaving = true);
    final success = await MedicalAPIService.updateMedicalProfile(
      gender: MedicalAPIService.genderToInt(_sex),
      bloodType: MedicalAPIService.bloodTypeToInt(_bloodType),
    );
    setState(() => _isSaving = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getSaveSuccessMessage())),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getSaveErrorMessage())),
      );
    }
  }

  String _getSaveSuccessMessage() {
    final p = context.read<LocaleProvider>();
    switch (p.langCode) {
      case 'ar': return 'تم حفظ الملف الطبي بنجاح';
      case 'es': return 'Perfil médico guardado con éxito';
      case 'fr': return 'Profil médical enregistré avec succès';
      case 'de': return 'Medizinisches Profil erfolgreich gespeichert';
      case 'ja': return '医療プロフィールを保存しました';
      default: return 'Medical profile saved successfully';
    }
  }

  String _getSaveErrorMessage() {
    final p = context.read<LocaleProvider>();
    switch (p.langCode) {
      case 'ar': return 'حدث خطأ أثناء حفظ الملف الطبي';
      case 'es': return 'Error al guardar el perfil médico';
      case 'fr': return 'Erreur lors de l\'enregistrement du profil médical';
      case 'de': return 'Fehler beim Speichern des medizinischen Profils';
      case 'ja': return '医療プロフィールの保存中にエラーが発生しました';
      default: return 'Error saving medical profile';
    }
  }

  String _sub(String? val, List<String> list) {
    if (val != null && val.isNotEmpty) return val;
    if (list.isNotEmpty) return list.join(', ');
    return '';
  }

  PageRoute<T> _slide<T>(Widget page) => PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );

  Future<void> _goSex(BuildContext ctx, LocaleProvider p) async {
    final r = await Navigator.of(ctx).push<String>(_slide(SexScreen(current: _sex)));
    if (r != null) {
      setState(() => _sex = r);
      _saveMedicalProfile();
    }
  }

  Future<void> _goBlood(BuildContext ctx) async {
    final r = await Navigator.of(ctx).push<String>(_slide(BloodTypeScreen(current: _bloodType)));
    if (r != null) {
      setState(() => _bloodType = r);
      _saveMedicalProfile();
    }
  }

  Future<void> _goAllergies(BuildContext ctx) async {
    final r = await Navigator.of(ctx).push<List<String>>(_slide(AllergiesScreen(current: _allergies)));
    if (r != null) setState(() => _allergies = r);
  }

  Future<void> _goMedications(BuildContext ctx) async {
    final r = await Navigator.of(ctx).push<List<String>>(_slide(MedicationsScreen(current: _medications)));
    if (r != null) setState(() => _medications = r);
  }

  Future<void> _goDiseases(BuildContext ctx) async {
    final r = await Navigator.of(ctx).push<List<String>>(_slide(DiseasesScreen(current: _diseases)));
    if (r != null) setState(() => _diseases = r);
  }

  void _shareProfile(String userId) {
    Share.share(
      'Check out my Lumos Medical Profile:\nhttps://lumos-app.com/profile/$userId',
      subject: 'Lumos Medical Profile',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final items = [
      _MI(Icons.person_outline,             p.tr('sex'),         _sub(_sex, []),           () => _goSex(context, p)),
      _MI(Icons.water_drop_outlined,        p.tr('blood_type'),  _sub(_bloodType, []),     () => _goBlood(context)),
      _MI(Icons.warning_amber_rounded,      p.tr('allergies'),   _sub(null, _allergies),   () => _goAllergies(context)),
      _MI(Icons.medication_outlined,        p.tr('medications'), _sub(null, _medications), () => _goMedications(context)),
      _MI(Icons.health_and_safety_outlined, p.tr('diseases'),    _sub(null, _diseases),    () => _goDiseases(context)),
    ];

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _card,
        body: FadeTransition(
          opacity: _fade,
          child: SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: _orange))
                : Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.tr('medical_profile'),
                          style: const TextStyle(
                            color: _orange, fontSize: 42,
                            fontWeight: FontWeight.w800, height: 1.1,
                          )),
                      const SizedBox(height: 40),
                      ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _Tile(item: item),
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(children: [
                  Expanded(
                    child: SizedBox(height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () => _shareProfile('lumos_user_001'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _orange,
                          side: const BorderSide(color: _orange, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 20),
                        label: const Text('Share',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pushReplacementNamed('/biometrics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange, foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2.5,
                          ),
                        )
                            : Text(p.tr('continue'),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MI {
  final IconData icon; final String label, subtitle; final VoidCallback onTap;
  const _MI(this.icon, this.label, this.subtitle, this.onTap);
}

class _Tile extends StatelessWidget {
  final _MI item;
  const _Tile({required this.item});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(item.icon, color: _orange.withOpacity(0.7), size: 22),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.label,
                style: const TextStyle(color: _txtW, fontSize: 16, fontWeight: FontWeight.w500)),
            if (item.subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(item.subtitle,
                  style: TextStyle(color: _orange.withOpacity(0.8), fontSize: 13)),
            ],
          ])),
          Icon(Icons.chevron_right, color: _orange.withOpacity(0.6), size: 20),
        ]),
      ),
    );
  }
}

class SexScreen extends StatefulWidget {
  final String? current;
  const SexScreen({super.key, this.current});
  @override State<SexScreen> createState() => _SexScreenState();
}
class _SexScreenState extends State<SexScreen> {
  String? _sel;
  bool _isSaving = false;

  @override void initState() {
    super.initState();
    _sel = widget.current;
  }

  void _saveAndClose() {
    Navigator.pop(context, _sel);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    final opts = [
      {'label': p.tr('male'),   'icon': Icons.male},
      {'label': p.tr('female'), 'icon': Icons.female},
    ];

    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: Column(children: [
          _TopNav(title: p.tr('sex').toUpperCase(), onBack: () => Navigator.pop(context)),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
            child: Column(children: [
              ...opts.map((opt) {
                final label = opt['label'] as String;
                final icon  = opt['icon'] as IconData;
                final isSel = _sel == label;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _sel = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? _orange : Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _orange.withOpacity(0.15),
                          ),
                          child: Icon(icon, color: _orange, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Text(label,
                            style: TextStyle(
                              color: _txtW, fontSize: 16,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            ))),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSel ? _orange : Colors.transparent,
                            border: Border.all(
                              color: isSel ? _orange : _txtGray, width: 2,
                            ),
                          ),
                          child: isSel
                              ? const Icon(Icons.circle, color: Colors.white, size: 10)
                              : null,
                        ),
                      ]),
                    ),
                  ),
                );
              }),
            ]),
          )),
          _DoneButton(onTap: _saveAndClose),
        ])),
      ),
    );
  }
}

class BloodTypeScreen extends StatefulWidget {
  final String? current;
  const BloodTypeScreen({super.key, this.current});
  @override State<BloodTypeScreen> createState() => _BloodTypeScreenState();
}

class _BloodTypeScreenState extends State<BloodTypeScreen> {
  String? _sel;
  bool _isSaving = false;
  static const _types = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];

  @override void initState() {
    super.initState();
    _sel = widget.current;
  }

  void _saveAndClose() {
    Navigator.pop(context, _sel);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: Column(children: [
          _TopNav(title: p.tr('blood_type'), onBack: () => Navigator.pop(context)),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(text: TextSpan(
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.3),
                children: [
                  const TextSpan(text: 'Select your ', style: TextStyle(color: _txtW)),
                  TextSpan(text: 'blood type', style: TextStyle(color: _orange)),
                ],
              )),
              const SizedBox(height: 8),
              const Text(
                'Knowing your blood type is essential for\nemergency situations and medical history.',
                style: TextStyle(color: _txtGray, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 28),
              Expanded(child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12,
                  mainAxisSpacing: 12, childAspectRatio: 1.45,
                ),
                itemCount: _types.length,
                itemBuilder: (_, i) {
                  final t = _types[i];
                  final isSel = _sel == t;
                  return GestureDetector(
                    onTap: () => setState(() => _sel = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? _orange : Colors.white.withOpacity(0.10),
                          width: 1,
                        ),
                      ),
                      child: Center(child: Text(t,
                          style: TextStyle(
                            color: isSel ? _orange : _txtW,
                            fontSize: 24, fontWeight: FontWeight.w700,
                          ))),
                    ),
                  );
                },
              )),
            ]),
          )),
          _DoneButton(onTap: _saveAndClose),
        ])),
      ),
    );
  }
}

class AllergiesScreen extends StatefulWidget {
  final List<String> current;
  const AllergiesScreen({super.key, required this.current});
  @override State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  late List<String> _sel;
  final _ctrl = TextEditingController();
  bool _isLoading = false;

  static const _cats = {
    'FOOD ALLERGENS':               ['Peanuts', 'Milk / Dairy', 'Shellfish', 'Wheat', 'Eggs', 'Soy', 'Tree Nuts'],
    'ANIMAL / PET ALLERGENS':       ['Cat Dander', 'Dog Dander', 'Horse Dander'],
    'MEDICATION / VENOM ALLERGENS': ['Penicillin', 'Bee Stings', 'Wasp Stings', 'Latex'],
    'ENVIRONMENTAL ALLERGENS':      ['Ragweed', 'Grass Pollen', 'Dust Mites', 'Mold'],
  };

  @override void initState() {
    super.initState();
    _sel = List.from(widget.current);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle(String item) => setState(() =>
  _sel.contains(item) ? _sel.remove(item) : _sel.add(item));

  Future<void> _addCustomAllergen(String name) async {
    setState(() => _isLoading = true);
    final success = await MedicalAPIService.addAllergy(name);
    if (success && mounted) {
      final newAllergies = await MedicalAPIService.getAllergies();
      setState(() => _sel = newAllergies);
    }
    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: Column(children: [
          _TopNav(title: p.tr('allergies'), onBack: () => Navigator.pop(context, _sel)),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ..._cats.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SectionLabel(e.key),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8,
                      children: e.value.map((item) {
                        final isSel = _sel.contains(item);
                        return GestureDetector(
                          onTap: () => _toggle(item),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? _orange.withOpacity(0.20) : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSel ? _orange.withOpacity(0.60) : Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: Text(item,
                                style: TextStyle(
                                  color: isSel ? _orange : _txtW,
                                  fontSize: 13,
                                  fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                                )),
                          ),
                        );
                      }).toList()),
                ]),
              )),
              _SectionLabel('OTHER ALLERGENS'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showAddSheet(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _orange.withOpacity(0.30)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add, color: _orange, size: 18),
                    const SizedBox(width: 6),
                    Text('Add Custom Allergen',
                        style: TextStyle(color: _orange, fontSize: 14, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          )),
          _DoneButton(onTap: () => Navigator.pop(context, _sel)),
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: _orange),
              ),
            ),
        ])),
      ),
    );
  }

  void _showAddSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1008),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _SheetHandle(),
          const SizedBox(height: 16),
          const Text('Add Custom Allergen',
              style: TextStyle(color: _orange, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _SheetInput(controller: _ctrl, hint: 'Type allergen name...'),
          const SizedBox(height: 16),
          _SheetAddBtn(onTap: () {
            final v = _ctrl.text.trim();
            if (v.isNotEmpty) {
              _addCustomAllergen(v);
              _ctrl.clear();
            }
          }),
        ]),
      ),
    );
  }
}


class MedicationsScreen extends StatefulWidget {
  final List<String> current;
  const MedicationsScreen({super.key, required this.current});
  @override State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  late List<String> _items;
  final _searchCtrl = TextEditingController();
  final _manualCtrl = TextEditingController();
  bool _isLoading = false;

  @override void initState() {
    super.initState();
    _items = List.from(widget.current);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _manualCtrl.dispose();
    super.dispose();
  }

  Future<void> _addMedication(String name) async {
    setState(() => _isLoading = true);
    final success = await MedicalAPIService.addMedication(name);
    if (success && mounted) {
      final newMedications = await MedicalAPIService.getMedications();
      setState(() => _items = newMedications);
    }
    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: Column(children: [
          _TopNav(title: p.tr('medications'), onBack: () => Navigator.pop(context, _items)),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(children: [
              if (_items.isNotEmpty) ...[
                Wrap(spacing: 8, runSpacing: 8,
                    children: _items.map((m) => _ItemChip(
                      label: m, onDelete: () => setState(() => _items.remove(m)),
                    )).toList()),
                const SizedBox(height: 24),
              ] else ...[
                const SizedBox(height: 20),
                const _EmptyIllustration(isDisease: false),
                const SizedBox(height: 20),
                const Text('Your medicine cabinet is\nempty',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _txtW, fontSize: 22,
                        fontWeight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 10),
                const Text(
                  'Start tracking your health journey by adding\nyour first medication. We\'ll help you stay on\nschedule.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _txtGray, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 28),
              ],
              _SearchBar(controller: _searchCtrl),
              const SizedBox(height: 16),
              _OrDivider(),
              const SizedBox(height: 16),
              _ManualBtn(label: 'Enter Medication Manually', onTap: () => _showSheet(context)),
              const SizedBox(height: 24),
            ]),
          )),
          _DoneButton(onTap: () => Navigator.pop(context, _items)),
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: _orange),
              ),
            ),
        ])),
      ),
    );
  }

  void _showSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1008),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _SheetHandle(),
          const SizedBox(height: 16),
          const Text('Enter Medication',
              style: TextStyle(color: _orange, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _SheetInput(controller: _manualCtrl, hint: 'Medication name...'),
          const SizedBox(height: 16),
          _SheetAddBtn(onTap: () {
            final v = _manualCtrl.text.trim();
            if (v.isNotEmpty) {
              _addMedication(v);
              _manualCtrl.clear();
            }
          }),
        ]),
      ),
    );
  }
}

class DiseasesScreen extends StatefulWidget {
  final List<String> current;
  const DiseasesScreen({super.key, required this.current});
  @override State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  late List<String> _items;
  final _searchCtrl = TextEditingController();
  final _manualCtrl = TextEditingController();
  bool _isLoading = false;

  @override void initState() {
    super.initState();
    _items = List.from(widget.current);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _manualCtrl.dispose();
    super.dispose();
  }

  Future<void> _addDisease(String name) async {
    setState(() => _isLoading = true);
    final success = await MedicalAPIService.addChronicDisease(name);
    if (success && mounted) {
      final newDiseases = await MedicalAPIService.getChronicDiseases();
      setState(() => _items = newDiseases);
    }
    setState(() => _isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocaleProvider>();
    return Directionality(
      textDirection: p.dir,
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: Column(children: [
          _TopNav(title: p.tr('diseases'), onBack: () => Navigator.pop(context, _items)),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(children: [
              if (_items.isNotEmpty) ...[
                Wrap(spacing: 8, runSpacing: 8,
                    children: _items.map((d) => _ItemChip(
                      label: d, onDelete: () => setState(() => _items.remove(d)),
                    )).toList()),
                const SizedBox(height: 24),
              ] else ...[
                const SizedBox(height: 20),
                const _EmptyIllustration(isDisease: true),
                const SizedBox(height: 20),
                const Text('Your disease list is\nempty',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _txtW, fontSize: 22,
                        fontWeight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 10),
                const Text(
                  'Keep track of your medical conditions by adding\nthem to your profile for better health monitoring.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _txtGray, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 28),
              ],
              _SearchBar(controller: _searchCtrl),
              const SizedBox(height: 16),
              _OrDivider(),
              const SizedBox(height: 16),
              _ManualBtn(label: 'Enter Disease Manually', onTap: () => _showSheet(context)),
              const SizedBox(height: 24),
            ]),
          )),
          _DoneButton(onTap: () => Navigator.pop(context, _items)),
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: _orange),
              ),
            ),
        ])),
      ),
    );
  }

  void _showSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1008),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _SheetHandle(),
          const SizedBox(height: 16),
          const Text('Enter Disease',
              style: TextStyle(color: _orange, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _SheetInput(controller: _manualCtrl, hint: 'Disease name...'),
          const SizedBox(height: 16),
          _SheetAddBtn(onTap: () {
            final v = _manualCtrl.text.trim();
            if (v.isNotEmpty) {
              _addDisease(v);
              _manualCtrl.clear();
            }
          }),
        ]),
      ),
    );
  }
}


class _ItemChip extends StatelessWidget {
  final String label; final VoidCallback onDelete;
  const _ItemChip({required this.label, required this.onDelete});
  @override
  Widget build(BuildContext context) => Chip(
    label: Text(label, style: const TextStyle(color: _txtW, fontSize: 13)),
    backgroundColor: _chipBg,
    side: const BorderSide(color: _chipBdr, width: 1),
    deleteIcon: const Icon(Icons.close, size: 14, color: _orange),
    onDeleted: onDelete,
  );
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _orange.withOpacity(0.20)),
      ),
      child: Row(children: [
        const SizedBox(width: 16),
        Icon(Icons.search, color: _txtGray, size: 20),
        const SizedBox(width: 10),
        Expanded(child: TextField(
          controller: controller,
          style: const TextStyle(color: _txtW, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Type or use voice...',
            hintStyle: TextStyle(color: _txtGray),
            border: InputBorder.none,
          ),
        )),
        Icon(Icons.mic_outlined, color: _txtGray, size: 20),
        const SizedBox(width: 16),
      ]),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Divider(color: Colors.white.withOpacity(0.10))),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text('OR',
          style: TextStyle(color: _txtGray, fontSize: 12,
              fontWeight: FontWeight.w500, letterSpacing: 1.2)),
    ),
    Expanded(child: Divider(color: Colors.white.withOpacity(0.10))),
  ]);
}

class _ManualBtn extends StatelessWidget {
  final String label; final VoidCallback onTap;
  const _ManualBtn({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.list_alt_outlined, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _orange, foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 40, height: 4,
    decoration: BoxDecoration(
      color: _orange.withOpacity(0.4),
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _SheetInput extends StatelessWidget {
  final TextEditingController controller; final String hint;
  const _SheetInput({required this.controller, required this.hint});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _orange.withOpacity(0.4)),
      ),
      child: TextField(
        controller: controller, autofocus: true,
        style: const TextStyle(color: _txtW),
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: _txtGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        ),
      ),
    );
  }
}

class _SheetAddBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _SheetAddBtn({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _orange, foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Text('Add',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ),
    );
  }
}