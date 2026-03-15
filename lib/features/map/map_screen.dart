import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import 'market_detail_screen.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Centre : N'Djaména
  static const LatLng _ndjamena = LatLng(12.1048, 15.0445);

  // Données fictives — à remplacer par l'API
  final List<_MarketMarker> _markets = [
    _MarketMarker(
      name: 'Marché central',
      city: 'N\'Djaména',
      position: const LatLng(12.1048, 15.0445),
      level: MarkerLevel.alert,
      topProduct: 'Riz importé',
      topPrice: 1200,
      topUnit: 'kg',
      variation: 0.38,
    ),
    _MarketMarker(
      name: 'Marché Dembé',
      city: 'N\'Djaména',
      position: const LatLng(12.1180, 15.0521),
      level: MarkerLevel.high,
      topProduct: 'Huile de palme',
      topPrice: 1500,
      topUnit: 'litre',
      variation: 0.22,
    ),
    _MarketMarker(
      name: 'Marché Moursal',
      city: 'N\'Djaména',
      position: const LatLng(12.0950, 15.0380),
      level: MarkerLevel.normal,
      topProduct: 'Mil en grain',
      topPrice: 850,
      topUnit: 'kg',
      variation: 0.02,
    ),
    _MarketMarker(
      name: 'Marché central',
      city: 'Moundou',
      position: const LatLng(8.5667, 16.0833),
      level: MarkerLevel.normal,
      topProduct: 'Sorgho',
      topPrice: 700,
      topUnit: 'kg',
      variation: -0.05,
    ),
    _MarketMarker(
      name: 'Marché central',
      city: 'Sarh',
      position: const LatLng(9.1500, 18.3833),
      level: MarkerLevel.high,
      topProduct: 'Bœuf',
      topPrice: 3500,
      topUnit: 'kg',
      variation: 0.15,
    ),
  ];

  _MarketMarker? _selectedMarket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des prix'),
        actions: [
          // Légende
          Padding(
            padding: const EdgeInsets.only(right: GataaSpacing.lg),
            child: Row(
              children: [
                _LegendDot(color: GataaColors.markerNormal, label: 'Normal'),
                const SizedBox(width: GataaSpacing.md),
                _LegendDot(color: GataaColors.markerHigh, label: 'Hausse'),
                const SizedBox(width: GataaSpacing.md),
                _LegendDot(color: GataaColors.markerAlert, label: 'Alerte'),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _ndjamena,
              initialZoom: 6.5,
              onTap: (_, __) => setState(() => _selectedMarket = null),
            ),
            children: [
              // Tuiles OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gataa_mobile',
              ),
              // Marqueurs
              MarkerLayer(
                markers: _markets.map((m) => Marker(
                  point: m.position,
                  width: 36,
                  height: 36,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMarket = m),
                    child: _MapPin(level: m.level),
                  ),
                )).toList(),
              ),
            ],
          ),

          // Fiche marché sélectionné
          if (_selectedMarket != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _MarketCard(
                market: _selectedMarket!,
                onClose: () => setState(() => _selectedMarket = null),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Modèle interne ───────────────────────────────────────────────────────────

class _MarketMarker {
  final String name;
  final String city;
  final LatLng position;
  final MarkerLevel level;
  final String topProduct;
  final double topPrice;
  final String topUnit;
  final double variation;

  const _MarketMarker({
    required this.name,
    required this.city,
    required this.position,
    required this.level,
    required this.topProduct,
    required this.topPrice,
    required this.topUnit,
    required this.variation,
  });
}

// ─── Pin marqueur ─────────────────────────────────────────────────────────────

class _MapPin extends StatelessWidget {
  const _MapPin({required this.level});
  final MarkerLevel level;

  @override
  Widget build(BuildContext context) {
    final color = markerColor(level);
    return CustomPaint(
      size: const Size(36, 36),
      painter: _PinPainter(color: color),
    );
  }
}

class _PinPainter extends CustomPainter {
  const _PinPainter({required this.color});
  final Color color;

 @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height * 0.35);
    final radius = size.width * 0.35;

    // Cercle principal
    canvas.drawCircle(center, radius, paint);

    // Pointe vers le bas
    final ui.Path path = ui.Path()
      ..moveTo(center.dx - radius * 0.6, center.dy + radius * 0.5)
      ..lineTo(center.dx, size.height)
      ..lineTo(center.dx + radius * 0.6, center.dy + radius * 0.5)
      ..close();
    canvas.drawPath(path, paint);

    // Cercle blanc intérieur
    canvas.drawCircle(center, radius * 0.45, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PinPainter old) => old.color != color;
}

// ─── Fiche marché ─────────────────────────────────────────────────────────────

class _MarketCard extends StatelessWidget {
  const _MarketCard({required this.market, required this.onClose});
  final _MarketMarker market;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GataaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(market.city.toUpperCase(), style: GataaTypo.labelSmall),
                    const SizedBox(height: GataaSpacing.xs),
                    Text(market.name, style: GataaTypo.titleMedium),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 18, color: GataaColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: GataaSpacing.md),
          const Divider(),
          const SizedBox(height: GataaSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PRODUIT LE PLUS SUIVI', style: GataaTypo.labelSmall),
                    const SizedBox(height: GataaSpacing.xs),
                    Text(market.topProduct, style: GataaTypo.bodyMedium),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: market.topPrice.toStringAsFixed(0),
                          style: GataaTypo.priceDisplay.copyWith(fontSize: 22),
                        ),
                        TextSpan(text: ' FCFA', style: GataaTypo.labelMedium),
                      ],
                    ),
                  ),
                  Text('/ ${market.topUnit}', style: GataaTypo.labelMedium),
                  const SizedBox(height: GataaSpacing.xs),
                  PriceBadge(variation: market.variation),
                ],
              ),
            ],
          ),
          const SizedBox(height: GataaSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MarketDetailScreen(
                      marketName: market.name,
                      city: market.city,
                      prices: MarketDetailScreen.mockPricesForMarket(market.name),
                    ),
                  ),
                );
              },
              child: const Text('Voir tous les prix'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Légende ──────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: GataaTypo.labelMedium.copyWith(color: Colors.white70)),
      ],
    );
  }
}