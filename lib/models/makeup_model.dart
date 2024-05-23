class Makup {
  int? id;
  String? brand;
  String? name;
  String? price;

  String? imageLink;
  String? productLink;
  String? websiteLink;
  String? description;
  double? rating; // Change to double to handle decimals

  String? productType;

  String? createdAt;
  String? updatedAt;
  String? productApiUrl;
  String? apiFeaturedImage;

  Makup({
    this.id,
    this.brand,
    this.name,
    this.price,
    this.imageLink,
    this.productLink,
    this.websiteLink,
    this.description,
    this.rating,
    this.productType,
    this.createdAt,
    this.updatedAt,
    this.productApiUrl,
    this.apiFeaturedImage,
  });

  Makup.fromJson(Map<String, dynamic> json) {
    id = (json['id'] is int) ? json['id'] : (json['id'] as num?)?.toInt();
    brand = json['brand'];
    name = json['name'];
    price = json['price'];

    imageLink = json['image_link'];
    productLink = json['product_link'];
    websiteLink = json['website_link'];
    description = json['description'];
    rating = (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : json['rating']?.toDouble(); // Handle both int and double

    productType = json['product_type'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productApiUrl = json['product_api_url'];
    apiFeaturedImage = json['api_featured_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['brand'] = brand;
    data['name'] = name;
    data['price'] = price;

    data['image_link'] = imageLink;
    data['product_link'] = productLink;
    data['website_link'] = websiteLink;
    data['description'] = description;
    data['rating'] = rating;

    data['product_type'] = productType;

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_api_url'] = productApiUrl;
    data['api_featured_image'] = apiFeaturedImage;

    return data;
  }
}
