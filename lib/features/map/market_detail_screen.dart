import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../prices/price_model.dart';

class MarketDetailScreen extends StatelessWidget {
  const MarketDetailScreen({
    super.key,
    required this.marketName,
    required this.city,
    required this.prices,
  });

  final String marketName;
  final String city;
  final List<PriceModel> prices;

  // Données fictives filtrées par marché — à remplacer par l'API
  static List<PriceModel> mockPricesForMarket(String marketName) {
    const allPrices = [
      PriceModel(
        id: 1,
        productName: 'Mil en grain',
        categoryName: 'Céréales',
        price: 850,
        unit: 'kg',
        variation: 0.12,
        marketName: 'Marché central',
        updatedAt: 'Il y a 2h',
      ),
      PriceModel(
        id: 2,
        productName: 'Riz importé',
        categoryName: 'Céréales',
        price: 1200,
        unit: 'kg',
        variation: 0.38,
        marketName: 'Marché central',
        updatedAt: 'Il y a 1h',
      ),
      PriceModel(
        id: 3,
        productName: 'Huile de palme',
        categoryName: 'Huile & condiments',
        price: 1500,
        unit: 'litre',
        variation: -0.05,
        marketName: 'Marché central',
        updatedAt: 'Il y a 3h',
      ),
      PriceModel(
        id: 4,
        productName: 'Bœuf',
        categoryName: 'Protéines animales',
        price: 3500,
        unit: 'kg',
        variation: -0.08,
        marketName: 'Marché central',
        updatedAt: 'Il y a 4h',
      ),
      PriceModel(
        id: 5,
        productName: 'Oignons',
        categoryName: 'Légumes & fruits',
        price: 400,
        unit: 'kg',
        variation: 0.06,
        marketName: 'Marché Dembé',
        updatedAt: 'Il y a 2h',
      ),
      PriceModel(
        id: 6,
        productName: 'Sorgho',
        categoryName: 'Céréales',
        price: 700,
        unit: 'kg',
        variation: 0.02,
        marketName: 'Marché Moursal',
        updatedAt: 'Il y a 5h',
      ),
    ];

    return allPrices
        .where((p) => p.marketName == marketName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Grouper par catégorie
    final Map<String, List<PriceModel>> byCategory = {};
    for (final p in prices) {
      byCategory.putIfAbsent(p.categoryName, () => []).add(p);
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(marketName),
            Text(
              city,
              style: const TextStyle(
                fontFamily: 'DM Mono',
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: prices.isEmpty
          ? Center(
              child: Text(
                'Aucun prix disponible\npour ce marché.',
                textAlign: TextAlign.center,
                style: GataaTypo.bodyMedium.copyWith(
                  color: GataaColors.textMuted,
                ),
              ),
            )
          : ListView.builder(
              padding: GataaSpacing.screenPadding,
              itemCount: byCategory.length,
              itemBuilder: (_, i) {
                final category = byCategory.keys.elementAt(i);
                final categoryPrices = byCategory[category]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: GataaSpacing.lg),
                    GataaSectionLabel(category),
                    ...categoryPrices.map((p) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: GataaSpacing.sm,
                          ),
                          child: GataaCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.productName,
                                        style: GataaTypo.titleMedium,
                                      ),
                                      const SizedBox(height: GataaSpacing.xs),
                                      Text(
                                        p.updatedAt,
                                        style: GataaTypo.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: GataaSpacing.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: p.price.toStringAsFixed(0),
                                            style: GataaTypo.priceDisplay
                                                .copyWith(fontSize: 20),
                                          ),
                                          TextSpan(
                                            text: ' FCFA',
                                            style: GataaTypo.labelMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '/ ${p.unit}',
                                      style: GataaTypo.labelMedium,
                                    ),
                                    const SizedBox(height: GataaSpacing.xs),
                                    PriceBadge(variation: p.variation),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
    );
  }
}