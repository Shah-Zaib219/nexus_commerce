import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();
  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  const ProductDetailLoaded(this.product);
  @override
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);
  @override
  List<Object> get props => [message];
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository _productRepository;

  ProductDetailCubit(this._productRepository) : super(ProductDetailInitial());

  Future<void> loadProduct(int id) async {
    emit(ProductDetailLoading());
    try {
      final product = await _productRepository.getProductById(id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
