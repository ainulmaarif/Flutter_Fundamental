import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

/// Notifier modern Riverpod 3.x untuk mengelola produk yang dipilih pengguna
class SelectedProductNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? product) {
    state = product;
  }

  void clear() {
    state = null;
  }
}

/// Provider untuk menyimpan item produk yang sedang aktif dipilih pengguna
final selectedProductProvider =
    NotifierProvider<SelectedProductNotifier, String?>(
        SelectedProductNotifier.new);

/// Halaman Katalog Produk untuk menguji tiga state Riverpod (Loading, Error, Success).
/// Diimplementasikan sebagai [ConsumerWidget] sesuai panduan Modul 06 Halaman 29–31.
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  /// Mengembalikan ikon perangkat komputer yang sesuai untuk setiap nama produk
  IconData _getProductIcon(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('keyboard')) {
      return Icons.keyboard_rounded;
    } else if (lower.contains('mouse')) {
      return Icons.mouse_rounded;
    } else if (lower.contains('monitor')) {
      return Icons.desktop_windows_rounded;
    } else if (lower.contains('headset')) {
      return Icons.headset_rounded;
    }
    return Icons.devices_other_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mengamati state katalog produk dari productsProvider
    final productsAsync = ref.watch(productsProvider);
    final isErrorSimulated = ref.read(productsProvider.notifier).isErrorSimulated;
    final selectedProduct = ref.watch(selectedProductProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Produk - Ainul (23520010)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // 1. Tombol sakelar simulasi galat (ikon awan/peringatan)
          IconButton(
            icon: Icon(
              isErrorSimulated
                  ? Icons.cloud_off_rounded
                  : Icons.cloud_queue_rounded,
              color: isErrorSimulated ? Colors.redAccent : null,
            ),
            tooltip: isErrorSimulated
                ? 'Simulasi Galat Aktif (Ketuk untuk matikan)'
                : 'Simulasi Galat Nonaktif (Ketuk untuk aktifkan)',
            onPressed: () {
              final notifier = ref.read(productsProvider.notifier);
              final nextVal = !notifier.isErrorSimulated;
              notifier.toggleErrorSimulation(nextVal);

              // Invalidate memicu build() ulang untuk menguji State Error atau Recovery
              ref.invalidate(productsProvider);
            },
          ),
          // 2. Tombol refresh manual (memanggil ref.read(...).refresh())
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data (AsyncValue.guard)',
            onPressed: () {
              ref.read(productsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      bottomNavigationBar: selectedProduct != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Item $selectedProduct dipilih dan berfungsi dengan baik',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Tutup status',
                    onPressed: () =>
                        ref.read(selectedProductProvider.notifier).clear(),
                  ),
                ],
              ),
            )
          : null,
      // Penanganan 3 state secara elegan menggunakan .when()
      body: productsAsync.when(
        // STATE 1: LOADING
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3.5,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Memuat data produk... (Jeda 2 detik)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Memuat data... (2 detik)',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // STATE 2: ERROR
        error: (err, stack) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              color:
                  Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.35),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Terjadi Kesalahan Jaringan',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$err',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        // Mengembalikan simulasi galat ke false untuk pemulihan (Recovery)
                        ref
                            .read(productsProvider.notifier)
                            .toggleErrorSimulation(false);
                        ref.invalidate(productsProvider);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text(
                        'Coba lagi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // STATE 3: SUCCESS (DATA)
        data: (products) => RefreshIndicator(
          onRefresh: () => ref.read(productsProvider.notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              final iconData = _getProductIcon(product);

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withValues(alpha: 0.8),
                    width: 1.2,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    ref.read(selectedProductProvider.notifier).select(product);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            iconData,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tersedia • Stok Siap Kirim',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Item #${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
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
