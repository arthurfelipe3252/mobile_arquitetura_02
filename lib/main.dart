import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/core/network/http_client.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';

void main() {
  final client = HttpClient();
  final datasource = ProductRemoteDatasource(client);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);
  final viewModel = ProductViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProductPage(viewModel: viewModel),
    );
  }
}
