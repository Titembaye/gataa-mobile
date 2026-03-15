import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (!auth.isAuthenticated) {
      return _buildUnauthenticated(context);
    }

    return _buildProfile(context, auth);
  }

  // ─── Non connecté ─────────────────────────────────────────────────────────

  Widget _buildUnauthenticated(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Padding(
        padding: GataaSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: GataaColors.navySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 36,
                color: GataaColors.navy,
              ),
            ),
            const SizedBox(height: GataaSpacing.xl),
            Text('Pas encore connecté', style: GataaTypo.titleMedium),
            const SizedBox(height: GataaSpacing.sm),
            Text(
              'Connectez-vous pour suivre vos soumissions\net gagner en réputation.',
              textAlign: TextAlign.center,
              style: GataaTypo.bodyMedium.copyWith(
                color: GataaColors.textSecondary,
              ),
            ),
            const SizedBox(height: GataaSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: GataaSpacing.md),
            Text(
              'Vous pouvez aussi soumettre des prix sans compte.',
              textAlign: TextAlign.center,
              style: GataaTypo.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Connecté ─────────────────────────────────────────────────────────────

  Widget _buildProfile(BuildContext context, AuthService auth) {
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          TextButton(
            onPressed: () async {
              await auth.logout();
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: GataaSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GataaSpacing.xl),

            // Avatar + infos
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: GataaColors.navySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?',
                      style: GataaTypo.titleLarge.copyWith(
                        color: GataaColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: GataaSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: GataaTypo.titleMedium),
                      const SizedBox(height: GataaSpacing.xs),
                      Text(user.email, style: GataaTypo.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: GataaSpacing.xxl),

            // Stats
            GataaSectionLabel('Statistiques'),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Soumissions',
                    value: user.totalSubmissions.toString(),
                  ),
                ),
                const SizedBox(width: GataaSpacing.md),
                Expanded(
                  child: _StatCard(
                    label: 'Validées',
                    value: user.validatedCount.toString(),
                  ),
                ),
                const SizedBox(width: GataaSpacing.md),
                Expanded(
                  child: _StatCard(
                    label: 'Réputation',
                    value: user.reputationScore.toStringAsFixed(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: GataaSpacing.xxl),

            // Historique soumissions (placeholder)
            GataaSectionLabel('Mes dernières soumissions'),
            GataaCard(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: GataaSpacing.xl,
                  ),
                  child: Text(
                    'Vos soumissions apparaîtront ici\naprès connexion à l\'API.',
                    textAlign: TextAlign.center,
                    style: GataaTypo.bodyMedium.copyWith(
                      color: GataaColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Carte stat ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GataaCard(
      child: Column(
        children: [
          Text(
            value,
            style: GataaTypo.titleLarge.copyWith(color: GataaColors.navy),
          ),
          const SizedBox(height: GataaSpacing.xs),
          Text(
            label.toUpperCase(),
            style: GataaTypo.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}