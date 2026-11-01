import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/car_card.dart';
import '../widgets/footer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Item> carList = [
    Item(
      name: 'Toyota Avanza 1.5 G',
      price: 350000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/4/44/Toyota_Avanza.jpg',
      stock: 5,
      rating: 4.8,
      transmission: 'Matic',
      capacity: 7,
      fuel: 'Bensin',
      description:
          'Mobil MPV andalan keluarga Indonesia yang irit bahan bakar, tangguh, dan nyaman untuk perjalanan wisata di Malang maupun perjalanan luar kota.',
    ),
    Item(
      name: 'Mitsubishi Xpander Ultimate',
      price: 400000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/8/8c/Mitsubishi_Xpander.jpg',
      stock: 4,
      rating: 4.9,
      transmission: 'Matic',
      capacity: 7,
      fuel: 'Bensin',
      description:
          'MPV berdesain gagah dan modern dengan kabin senyap, suspensi sangat nyaman, dan fitur keselamatan komplit untuk kenyamanan keluarga Anda.',
    ),
    Item(
      name: 'Toyota Innova Zenix Hybrid',
      price: 700000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/1/15/2022_Toyota_Kijang_Innova_Zenix_V_%28Indonesia%29_front_view.jpg',
      stock: 3,
      rating: 5.0,
      transmission: 'Matic',
      capacity: 7,
      fuel: 'Hybrid',
      description:
          'Kenyamanan premium dengan mesin hybrid bertenaga tinggi dan irit bahan bakar, kabin luas, panoramic sunroof, dan fitur keselamatan aktif canggih.',
    ),
    Item(
      name: 'Honda Brio RS',
      price: 275000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/9/90/Honda-Brio.jpg',
      stock: 6,
      rating: 4.7,
      transmission: 'Manual',
      capacity: 5,
      fuel: 'Bensin',
      description:
          'City car gesit dan lincah dengan konsumsi BBM sangat efisien. Pilihan sempurna untuk bermanuver di jalanan kota Malang dan kawasan wisata Batu.',
    ),
    Item(
      name: 'Toyota Fortuner VRZ 4x4',
      price: 1100000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/5/54/Toyota_Fortuner_White.jpg',
      stock: 2,
      rating: 4.9,
      transmission: 'Matic',
      capacity: 7,
      fuel: 'Diesel',
      description:
          'SUV premium bertenaga besar dengan penggerak 4x4 tangguh, tampilan gagah, dan kenyamanan mewah untuk segala medan perjalanan wisata Malang dan Bromo.',
    ),
    Item(
      name: 'Toyota HiAce Commuter',
      price: 1250000,
      photo:
          'https://upload.wikimedia.org/wikipedia/commons/b/b5/Toyota_Hiace_%285888728970%29.jpg',
      stock: 2,
      rating: 5.0,
      transmission: 'Manual',
      capacity: 12,
      fuel: 'Diesel',
      description:
          'Microbus komersial berkapasitas besar hingga 12 penumpang dengan kabin lega dan AC merata, sangat ideal untuk rombongan wisata atau dinas di Malang Raya.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.car_rental_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rental Mobil Malang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Katalog Armada Pilihan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 1,
        shadowColor: theme.colorScheme.shadow.withAlpha(40),
      ),
      body: Column(
        children: [
          // Banner Informasi Singkat
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Liburan Seru di Malang Raya!',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sewa mobil lepas kunci / dengan supir. Unit bersih, terawat, & siap jalan.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(220),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.auto_awesome,
                  color: Colors.amberAccent,
                  size: 28,
                ),
              ],
            ),
          ),

          // Subtitle Katalog
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilihan Armada Tersedia',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${carList.length} Unit',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Grid Katalog Mobil (2 Kolom)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: carList.length,
              itemBuilder: (context, index) {
                final car = carList[index];
                return CarCard(
                  item: car,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/item',
                      arguments: car,
                    );
                  },
                );
              },
            ),
          ),

          // Footer Reusable Widget
          const FooterWidget(),
        ],
      ),
    );
  }
}
