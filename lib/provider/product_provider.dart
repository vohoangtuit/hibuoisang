import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/data/repository/product_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({@required this.productRepo});

  bool _isLoading = false;
  bool _firstLoading = true;
  int _latestPageSize;
  List<String> _offsetList = [];

  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;
  int get latestPageSize => _latestPageSize;

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  // Seller products
  List<Product> _sellerAllProductList = [];
  List<Product> _sellerProductList = [];
  int _sellerPageSize;
  List<Product> get sellerProductList => _sellerProductList;
  int get sellerPageSize => _sellerPageSize;

  void initSellerProductList(String sellerId, String offset, BuildContext context, {bool reload = false}) async {
    if(reload) {
          _offsetList = [];
          _sellerProductList = [];
        }
    if(!_offsetList.contains(offset)){
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getSellerProductList(sellerId, offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _sellerProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _sellerAllProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _sellerPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();

    }else{
      if(_isLoading) {
        _isLoading = false;
      }

    }



  }
  Future<int> getLatestOffset(String sellerId,String languageCode) async {
    ApiResponse apiResponse = await productRepo.getSellerProductList(sellerId, '1');
    return ProductModel.fromJson(apiResponse.response.data).totalSize;
  }

  void filterData(String newText) {
    _sellerProductList.clear();
    if(newText.isNotEmpty) {
      _sellerAllProductList.forEach((product) {
        if (product.name.toLowerCase().contains(newText.toLowerCase())) {
          _sellerProductList.add(product);
        }
      });
    }else {
      _sellerProductList.clear();
      _sellerProductList.addAll(_sellerAllProductList);
    }
    notifyListeners();
  }

  void clearSellerData() {
    _sellerProductList = [];
    notifyListeners();
  }




}
