import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';

class ProductViewModel {
  final ProductRepository repository;
  final ValueNotifier<List<Product>> products = ValueNotifier([]);
  ProductViewModel(this.repository);
  Future<void> loadProducts() async {
    final result = await repository.getProducts();
    products.value = result;
  }
}
