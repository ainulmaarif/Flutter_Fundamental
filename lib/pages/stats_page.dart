import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier untuk mengelola state statistik asinkron (Modul 06 AI Challenge)
class StatsNotifier extends AsyncNotifier<List<String>> {
  final Random _random;
  final Duration _networkDelay;

  StatsNotifier({Random? random, Duration? networkDelay})
      : _random = random ?? Random(),
        _networkDelay = networkDelay ?? const Duration(seconds: 2);

  Future<List<String>> _fetchStats() async {
    if (_networkDelay > Duration.zero) {
      await Future.delayed(_networkDelay);
    }

    if (_random.nextDouble() < 0.3) {
      throw Exception('Koneksi terputus (Simulasi gagal 30%)');
    }

    return const [
      'Total Tugas Selesai: 18 Tugas',
      'Tingkat Produktivitas: 92%',
      'Waktu Fokus Mingguan: 24 Jam',
    ];
  }

  @override
  Future<List<String>> build() async {
    return _fetchStats();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchStats());
  }
}

/// Provider global untuk statistik
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(StatsNotifier.new);

/// Halaman visualisasi statistik
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik - Ainul (23520010)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Muat ulang statistik',
            onPressed: () => ref.read(statsProvider.notifier).retry(),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Memuat data statistik...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6),
              Text(
                'Simulasi jeda 2 detik',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 54,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Gagal Memuat Statistik',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$err',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => ref.read(statsProvider.notifier).retry(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        data: (stats) => RefreshIndicator(
          onRefresh: () => ref.read(statsProvider.notifier).retry(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stats.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = stats[index];
              IconData icon = Icons.analytics_rounded;
              if (index == 0) icon = Icons.task_alt_rounded;
              if (index == 1) icon = Icons.trending_up_rounded;
              if (index == 2) icon = Icons.timer_outlined;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
