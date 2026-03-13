import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedProduct;
  String? _selectedMarket;
  String? _selectedUnit;
  bool _isSubmitting = false;
  bool _submitted = false;

  // Données fictives — à remplacer par l'API
  final Map<String, List<String>> _productsByCategory = {
    'Céréales': ['Mil en grain', 'Riz importé', 'Sorgho', 'Maïs', 'Farine'],
    'Huile & condiments': ['Huile de palme', 'Huile d\'arachide', 'Sel', 'Sucre'],
    'Protéines animales': ['Bœuf', 'Mouton', 'Poisson séché', 'Œufs', 'Poulet'],
    'Légumes & fruits': ['Oignons', 'Tomates', 'Gombo', 'Mangue'],
    'Carburant & énergie': ['Essence', 'Gasoil', 'Gaz butane', 'Charbon'],
  };

  final List<String> _markets = [
    'Marché central — N\'Djaména',
    'Marché Dembé — N\'Djaména',
    'Marché Moursal — N\'Djaména',
    'Marché — Moundou',
    'Marché — Sarh',
    'Marché — Abéché',
  ];

  final List<String> _units = ['kg', 'litre', 'sac 50kg', 'sac 100kg', 'unité', 'tas'];

  List<String> get _products {
    if (_selectedCategory == null) return [];
    return _productsByCategory[_selectedCategory!] ?? [];
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simuler un appel API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

  void _reset() {
    setState(() {
      _submitted = false;
      _selectedCategory = null;
      _selectedProduct = null;
      _selectedMarket = null;
      _selectedUnit = null;
      _priceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soumettre un prix')),
      body: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  // ─── Formulaire ───────────────────────────────────────────────────────────

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: GataaSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GataaSpacing.sm),

            // Intro
            Text(
              'Vous avez observé un prix au marché ? Partagez-le avec la communauté.',
              style: GataaTypo.bodyMedium.copyWith(
                color: GataaColors.textSecondary,
              ),
            ),
            const SizedBox(height: GataaSpacing.xl),

            // Catégorie
            _buildLabel('Catégorie'),
            _buildDropdown(
              hint: 'Sélectionner une catégorie',
              value: _selectedCategory,
              items: _productsByCategory.keys.toList(),
              onChanged: (val) => setState(() {
                _selectedCategory = val;
                _selectedProduct = null;
              }),
              validator: (v) => v == null ? 'Choisissez une catégorie' : null,
            ),
            const SizedBox(height: GataaSpacing.lg),

            // Produit
            _buildLabel('Produit'),
            _buildDropdown(
              hint: _selectedCategory == null
                  ? 'Choisir d\'abord une catégorie'
                  : 'Sélectionner un produit',
              value: _selectedProduct,
              items: _products,
              onChanged: _selectedCategory == null
                  ? null
                  : (val) => setState(() => _selectedProduct = val),
              validator: (v) => v == null ? 'Choisissez un produit' : null,
            ),
            const SizedBox(height: GataaSpacing.lg),

            // Marché
            _buildLabel('Marché'),
            _buildDropdown(
              hint: 'Sélectionner un marché',
              value: _selectedMarket,
              items: _markets,
              onChanged: (val) => setState(() => _selectedMarket = val),
              validator: (v) => v == null ? 'Choisissez un marché' : null,
            ),
            const SizedBox(height: GataaSpacing.lg),

            // Prix + Unité
            _buildLabel('Prix observé'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'ex: 850',
                      suffixText: 'FCFA',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Entrez un prix';
                      if (int.tryParse(v) == null) return 'Prix invalide';
                      if (int.parse(v) <= 0) return 'Prix invalide';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: GataaSpacing.md),
                Expanded(
                  child: _buildDropdown(
                    hint: 'Unité',
                    value: _selectedUnit,
                    items: _units,
                    onChanged: (val) => setState(() => _selectedUnit = val),
                    validator: (v) => v == null ? 'Unité ?' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GataaSpacing.xxl),

            // Bouton soumettre
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: GataaColors.textOnDark,
                        ),
                      )
                    : const Text('Soumettre le prix'),
              ),
            ),
            const SizedBox(height: GataaSpacing.lg),

            // Note anonymat
            Center(
              child: Text(
                'Soumission anonyme — aucun compte requis.',
                style: GataaTypo.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Succès ───────────────────────────────────────────────────────────────

  Widget _buildSuccess() {
    return Padding(
      padding: GataaSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: GataaColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: GataaColors.success,
              size: 32,
            ),
          ),
          const SizedBox(height: GataaSpacing.xl),
          Text('Prix soumis !', style: GataaTypo.titleLarge),
          const SizedBox(height: GataaSpacing.md),
          Text(
            'Merci pour votre contribution.\nVotre prix sera vérifié avant publication.',
            textAlign: TextAlign.center,
            style: GataaTypo.bodyMedium.copyWith(
              color: GataaColors.textSecondary,
            ),
          ),
          const SizedBox(height: GataaSpacing.xxl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _reset,
              child: const Text('Soumettre un autre prix'),
            ),
          ),
          const SizedBox(height: GataaSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Voir les prix du jour'),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers UI ───────────────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GataaSpacing.sm),
      child: Text(text.toUpperCase(), style: GataaTypo.labelSmall),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(),
      hint: Text(hint, style: GataaTypo.bodyMedium.copyWith(color: GataaColors.textMuted)),
      style: GataaTypo.bodyMedium,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item, style: GataaTypo.bodyMedium),
      )).toList(),
    );
  }
}