import 'package:a_connect/Quotes.dart';
import 'package:a_connect/pagingProduct.dart';

import 'Quotes.dart';

List<PagingProduct> populateData(pagingProductRepository) {
  final List<PagingProduct> pagingProducts = [];
  var index = 0;
  print("populating");

  for (int i = 0; i < pagingProductRepository.id.length; i++) {
    if (index == 5) index = 0;
    var p = new PagingProduct(
      id: pagingProductRepository.id[i],
      locationDescription: pagingProductRepository.locationDescription[i],
      customerName: pagingProductRepository.customerName[i],
      itemDescription: pagingProductRepository.itemDescription[i],
      createdDateFormat: pagingProductRepository.createdDateFormat[i],
      flag: pagingProductRepository.flag[i],

      // ibCategoryMaster: pagingProductRepository.ibCategoryMaster[i],
      // ibSourcingMaster: pagingProductRepository.ibSourcingMaster[i],
    );
    index++;
    pagingProducts.add(p);
  }
  print(pagingProducts.length);
  return pagingProducts;
}
