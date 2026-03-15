import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'price_model.dart';

// ─── Données de test (à remplacer par l'API plus tard) ───────────────────────

final List<PriceModel> _mockPrices = [
  const PriceModel(
    id: 1,
    productName: 'Mil en grain',
    categoryName: 'Céréales',
    price: 850,
    unit: 'kg',
    variation: 0.12,
    marketName: 'Marché central',
    updatedAt: 'Il y a 2h',
  ),
  const PriceModel(
    id: 2,
    productName: 'Riz importé',
    categoryName: 'Céréales',
    price: 1200,
    unit: 'kg',
    variation: 0.38,
    marketName: 'Marché Dembé',
    updatedAt: 'Il y a 1h',
  ),
  const PriceModel(
    id: 3,
    productName: 'Huile de palme',
    categoryName: 'Huile & condiments',
    price: 1500,
    unit: 'litre',
    variation: -0.05,
    marketName: 'Marché central',
    updatedAt: 'Il y a 3h',
  ),
  const PriceModel(
    id: 4,
    productName: 'Sorgho',
    categoryName: 'Céréales',
    price: 700,
    unit: 'kg',
    variation: 0.02,
    marketName: 'Marché Moursal',
    updatedAt: 'Il y a 5h',
  ),
  const PriceModel(
    id: 5,
    productName: 'Bœuf',
    categoryName: 'Protéines animales',
    price: 3500,
    unit: 'kg',
    variation: -0.08,
    marketName: 'Marché central',
    updatedAt: 'Il y a 4h',
  ),
  const PriceModel(
    id: 6,
    productName: 'Oignons',
    categoryName: 'Légumes & fruits',
    price: 400,
    unit: 'kg',
    variation: 0.06,
    marketName: 'Marché Dembé',
    updatedAt: 'Il y a 2h',
  ),
];

// ─── Écran principal ──────────────────────────────────────────────────────────

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  String _selectedCategory = 'Tous';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<String> get _categories {
    final cats = _mockPrices.map((p) => p.categoryName).toSet().toList();
    cats.sort();
    return ['Tous', ...cats];
  }

  List<PriceModel> get _filtered {
    List<PriceModel> result = _selectedCategory == 'Tous'
        ? _mockPrices
        : _mockPrices.where((p) => p.categoryName == _selectedCategory).toList();

    if (_searchQuery.isNotEmpty) {
      result = result.where((p) =>
        p.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.marketName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return result;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prix du jour'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(child: _buildPriceList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: GataaColors.white,
      padding: const EdgeInsets.fromLTRB(
        GataaSpacing.lg,
        GataaSpacing.md,
        GataaSpacing.lg,
        0,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Rechercher un produit ou marché…',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: GataaColors.textMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () => setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  }),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: GataaColors.textMuted,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  // ─── Filtres catégories ───────────────────────────────────────────────────

  Widget _buildCategoryFilter() {
    return Container(
      color: GataaColors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: GataaSpacing.lg),
        child: Row(
          children: _categories.map((cat) {
            final isActive = cat == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: GataaSpacing.sm),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? GataaColors.navy : GataaColors.sand,
                    borderRadius: GataaRadius.pillAll,
                    border: Border.all(
                      color: isActive
                          ? GataaColors.navy
                          : GataaColors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: GataaTypo.labelMedium.copyWith(
                      color: isActive
                          ? GataaColors.textOnDark
                          : GataaColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── Liste des prix ───────────────────────────────────────────────────────

  Widget _buildPriceList() {
    final prices = _filtered;

    if (prices.isEmpty) {
      return Center(
        child: Text(
          'Aucun prix disponible.',
          style: GataaTypo.bodyMedium.copyWith(color: GataaColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(GataaSpacing.lg),
      itemCount: prices.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: GataaSpacing.sm),
      itemBuilder: (_, i) => _PriceCard(price: prices[i]),
    );
  }
}

// ─── Carte prix ───────────────────────────────────────────────────────────────

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.price});
  final PriceModel price;

  @override
  Widget build(BuildContext context) {
    return GataaCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Infos produit
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.categoryName.toUpperCase(),
                  style: GataaTypo.labelSmall,
                ),
                const SizedBox(height: GataaSpacing.xs),
                Text(price.productName, style: GataaTypo.titleMedium),
                const SizedBox(height: GataaSpacing.xs),
                Text(
                  '${price.marketName} · ${price.updatedAt}',
                  style: GataaTypo.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: GataaSpacing.md),
          // Prix + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price.price.toStringAsFixed(0),
                      style: GataaTypo.priceDisplay,
                    ),
                    TextSpan(
                      text: ' FCFA',
                      style: GataaTypo.labelMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '/ ${price.unit}',
                style: GataaTypo.labelMedium,
              ),
              const SizedBox(height: GataaSpacing.sm),
              PriceBadge(variation: price.variation),
            ],
          ),
        ],
      ),
    );
  }
}