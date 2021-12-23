import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/view/base/product_shimmer.dart';
import 'package:sixvalley_vendor_app/view/base/product_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/add_product_screen.dart';

class ProductView extends StatelessWidget {
  final ScrollController scrollController;
  final String sellerId;
  final Product product;
  ProductView({this.scrollController, this.sellerId, this.product});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Provider.of<ProductProvider>(context, listen: false).sellerProductList.length != 0
          && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int pageSize;

          pageSize = Provider.of<ProductProvider>(context, listen: false).sellerPageSize;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
          Provider.of<ProductProvider>(context, listen: false).initSellerProductList(sellerId, offset.toString(), context);
        }
      }
    });


    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.sellerProductList;


        return Stack(
          children: [

            SingleChildScrollView(
              child: Column(children: [

                !prodProvider.firstLoading ? productList.length != 0 ? ListView.builder(
                  itemCount: productList.length,
                  // crossAxisCount: 2,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(productModel: productList[index], );
                  },
                ) : SizedBox.shrink() : ProductShimmer(isEnabled: prodProvider.firstLoading),

                prodProvider.isLoading ? Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                )) : SizedBox.shrink(),

              ]),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AddProductScreen()));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Theme.of(context).primaryColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Center(child: Image.asset(Images.add_btn)),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

