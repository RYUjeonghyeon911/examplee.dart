import 'dart:io';

class ShoppingMall {
  List<Product> products;
  int totalPrice;

  ShoppingMall(this.products) : totalPrice = 0;

  void showProducts() {
    for (var product in products) {
      print('${product.name} / ${product.price}원');
    }
  }

  void addToCart() {
    print('장바구니에 담을 상품 이름을 입력하세요:');
    String? productName = stdin.readLineSync();
    if (productName == null || productName.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    var product = products.firstWhere(
      (p) => p.name == productName,
      orElse: () => Product('', 0),
    );
    if (product.name.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    print('상품의 개수를 입력하세요:');
    String? quantityInput = stdin.readLineSync();
    try {
      int quantity = int.parse(quantityInput ?? '0');
      if (quantity <= 0) {
        print('0개보다 많은 개수의 상품만 담을 수 있어요 !');
        return;
      }
      totalPrice += product.price * quantity;
      print('장바구니에 상품이 담겼어요 !');
    } catch (e) {
      print('입력값이 올바르지 않아요 !');
    }
  }

  void showTotal() {
    print('장바구니에 $totalPrice원 어치를 담으셨네요 !');
  }
}

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

void main() {
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];
  ShoppingMall shoppingMall = ShoppingMall(products);

  bool running = true;
  while (running) {
    print('[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        shoppingMall.showProducts();
        break;
      case '2':
        shoppingMall.addToCart();

        break;
      case '3':
        shoppingMall.showTotal();
        break;
      case '4':
        running = false;
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요 !');
        break;
      default:
        print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
    }
  }
}
