List<ShortCutModel> ShortCutData = [
  ShortCutModel(
    productImage: 'images/ordernow.png',
    productName: 'Order by image',
  ),
  ShortCutModel(
    productImage: 'images/Store.png',
    productName: 'Stores',
  ),
];

class ShortCutModel {
  String productName;
  String productImage;
  //String productModel;
  //double productPrice;
  //double productOldPrice;
  // String productSecondImage;
  // String productThirdImage;
  // String productFourImage;
  ShortCutModel({
    // required this.productThirdImage,
    // required this.productFourImage,
    required this.productImage,
    // required this.productModel,
    required this.productName,
    // required this.productOldPrice,
    // required this.productPrice,
    //required this.productSecondImage,
  });
}
