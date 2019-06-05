import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:ofypets_mobile_app/widgets/rating_bar.dart';
import 'package:ofypets_mobile_app/models/product.dart';
import 'package:ofypets_mobile_app/scoped-models/main.dart';
import 'package:ofypets_mobile_app/screens/product_detail.dart';
import 'package:ofypets_mobile_app/widgets/snackbar.dart';

Widget addToCartButton(List<Product> todaysDealProducts, int index) {
  return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    return FlatButton(
      onPressed: () async {
        if (todaysDealProducts[index].isOrderable) {
          Scaffold.of(context).showSnackBar(processSnackbar);
          model.addProduct(
              variantId: todaysDealProducts[index].id, quantity: 1);
          if (!model.isLoading) {
            Scaffold.of(context).showSnackBar(completeSnackbar);
          }
        }
      },
      child: !model.isLoading
          ? Text(
              todaysDealProducts[index].isOrderable
                  ? 'ADD TO CART'
                  : 'OUT OF STOCK',
              style: TextStyle(
                  color: todaysDealProducts[index].isOrderable
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
    );
  });
}

Widget todaysDealsCard(int index, List<Product> todaysDealProducts,
    Size _deviceSize, BuildContext context) {
  return GestureDetector(
      onTap: () {
        MaterialPageRoute addressRoute = MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(todaysDealProducts[index]));
        Navigator.push(context, addressRoute);
      },
      child: SizedBox(
          width: _deviceSize.width * 0.4,
          child: Card(
            borderOnForeground: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(todaysDealProducts[index].image),
                  placeholder:
                      AssetImage('images/placeholders/no-product-image.png'),
                  height: _deviceSize.height * 0.2,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(
                    todaysDealProducts[index].name,
                    maxLines: 3,
                  ),
                ),
                Text(
                  todaysDealProducts[index].displayPrice,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ratingBar(todaysDealProducts[index].avgRating, 20),
                    Text(todaysDealProducts[index].reviewsCount),
                  ],
                ),
                Divider(),
                addToCartButton(todaysDealProducts, index)
              ],
            ),
          )));
}