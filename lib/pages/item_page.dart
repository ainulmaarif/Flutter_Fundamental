import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/footer_widget.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    // Ekstraksi data yang dikirim melalui Navigator.pushNamed arguments
    final item = ModalRoute.of(context)!.settings.arguments as Item;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tautan rental ${item.name} disalin!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Simpan Favorit',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} ditambahkan ke favorit.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Animation Gambar Detail Mobil
                  Hero(
                    tag: item.name,
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Image.network(
                        item.photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 250,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: theme.colorScheme.primaryContainer.withAlpha(70),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_car_filled_outlined,
                                    size: 64,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Mobil & Badge Status Stok
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: item.stock > 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: item.stock > 0
                                      ? Colors.green.shade400
                                      : Colors.red.shade400,
                                ),
                              ),
                              child: Text(
                                item.stock > 0
                                    ? 'Tersedia (${item.stock} Unit)'
                                    : 'Stok Habis',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: item.stock > 0
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Rating Bintang & Review
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 22,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(Review Pelanggan Terverifikasi)',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Harga Sewa Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withAlpha(90),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withAlpha(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tarif Sewa Harian',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatPrice(item.price),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Per 24 Jam',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Spesifikasi Kendaraan
                        Text(
                          'Spesifikasi Kendaraan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSpecTile(
                                context,
                                icon: Icons.airline_seat_recline_normal_rounded,
                                label: 'Kapasitas',
                                value: '${item.capacity} Kursi',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSpecTile(
                                context,
                                icon: Icons.settings_rounded,
                                label: 'Transmisi',
                                value: item.transmission,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSpecTile(
                                context,
                                icon: Icons.local_gas_station_rounded,
                                label: 'Bahan Bakar',
                                value: item.fuel,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildSpecTile(
                                context,
                                icon: Icons.inventory_2_rounded,
                                label: 'Stok Unit',
                                value: '${item.stock} Unit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Deskripsi Mobil
                        Text(
                          'Tentang Armada Ini',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description.isNotEmpty
                              ? item.description
                              : 'Armada prima yang selalu mendapatkan perawatan berkala di bengkel resmi untuk menjamin keselamatan dan kenyamanan perjalanan Anda.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Fasilitas Tambahan
                        Text(
                          'Fasilitas Termasuk',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildFacilityItem(
                          context,
                          icon: Icons.shield_outlined,
                          text: 'Asuransi Kendaraan All-Risk',
                        ),
                        _buildFacilityItem(
                          context,
                          icon: Icons.cleaning_services_outlined,
                          text: 'Unit Dicuci Bersih & Disinfeksi',
                        ),
                        _buildFacilityItem(
                          context,
                          icon: Icons.support_agent_rounded,
                          text: 'Bantuan Darurat 24 Jam di Jalan',
                        ),
                        _buildFacilityItem(
                          context,
                          icon: Icons.location_on_outlined,
                          text: 'Free Antar/Jemput di Bandara & Stasiun Malang',
                        ),
                        const SizedBox(height: 24),

                        // Tombol Sewa Sekarang
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.key_rounded),
                            label: const Text(
                              'Sewa Sekarang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: item.stock > 0
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        icon: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 48,
                                        ),
                                        title: const Text('Konfirmasi Sewa'),
                                        content: Text(
                                          'Anda akan menyewa ${item.name} dengan tarif ${_formatPrice(item.price)}/hari.\n\nLanjutkan pemesanan ke WhatsApp Customer Service?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx),
                                            child: const Text('Batal'),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Pesanan untuk ${item.name} berhasil diproses!',
                                                  ),
                                                  backgroundColor:
                                                      Colors.green.shade700,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            child: const Text('Lanjutkan'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer Reusable Widget
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildSpecTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
