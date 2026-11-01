import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_world/provider/product_provider.dart';

void main() {
  test('ProductsNotifier mengembalikan 3 produk saat sukses awal', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(productsProvider), const AsyncLoading<List<String>>());

    final products = await container.read(productsProvider.future);
    expect(products, ['Keyboard', 'Mouse', 'Monitor']);
  });

  test('ProductsNotifier refresh menambahkan item ke-4 menggunakan AsyncValue.guard', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(productsProvider.future);
    await container.read(productsProvider.notifier).refresh();

    final refreshed = container.read(productsProvider).value;
    expect(refreshed, ['Keyboard', 'Mouse', 'Monitor', 'Headset']);
  });

  test('ProductsNotifier menangani simulasi galat (Error State)', () async {
    final container = ProviderContainer(
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);

    final sub = container.listen(productsProvider, (_, _) {});
    addTearDown(sub.close);

    container.read(productsProvider.notifier).toggleErrorSimulation(true);
    addTearDown(() {
      container.read(productsProvider.notifier).toggleErrorSimulation(false);
    });

    container.invalidate(productsProvider);

    await expectLater(
      container.read(productsProvider.future),
      throwsA(isA<Exception>()),
    );
  });
}
