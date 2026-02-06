import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

// States
abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categories;
  const ProductLoaded(this.products, this.categories);
  @override
  List<Object> get props => [products, categories];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await _repository.getAllProducts();
      final categories = products
          .map((e) => e.category)
          .where((e) => e != null)
          .cast<String>()
          .toSet()
          .toList();
      emit(ProductLoaded(products, categories));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
