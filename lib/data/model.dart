class Product {
  String? pid;
  String pName;
  String image;
  String dateNow;
  String nextDate;

  Product({
    required this.pName,
    required this.image,
    required this.dateNow,
    required this.nextDate,
    this.pid,
  }
      );
}