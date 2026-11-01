class Item {
  final String name;
  final int price;
  final String photo;
  final int stock;
  final double rating;
  final String transmission;
  final int capacity;
  final String fuel;
  final String description;

  Item({
    required this.name,
    required this.price,
    required this.photo,
    required this.stock,
    required this.rating,
    required this.transmission,
    required this.capacity,
    this.fuel = 'Bensin',
    this.description = '',
  });
}
