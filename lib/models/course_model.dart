class CourseModel {
  final String id;
  final String name;
  final String categoryId;
  final String? categoryName; // ✅ new
  final String? subcategoryId;
  final String? subcategoryName; // ✅ new
  final String? duration;
  final double? fees;
  final String? note1;
  final String? note2;
  final String? note3;
  final String? curriculum;
  final String? imageUrl;

  CourseModel({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.subcategoryId,
    this.subcategoryName,
    this.duration,
    this.fees,
    this.note1,
    this.note2,
    this.note3,
    this.curriculum,
    this.imageUrl,
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'duration': duration,
      'fees': fees,
      'note1': note1,
      'note2': note2,
      'note3': note3,
      'curriculum': curriculum,
      'image_url': imageUrl,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'] ?? map['categories']?['category_id'] ?? '',
      categoryName: map['categories']?['category_name'] ?? '',
      subcategoryId:
          map['subcategory_id'] ?? map['subcategories']?['subcategory_id'],
      subcategoryName: map['subcategories']?['subcategory_name'],
      duration: map['duration'],
      fees: map['fees'] != null
          ? double.tryParse(map['fees'].toString())
          : null,
      note1: map['note1'],
      note2: map['note2'],
      note3: map['note3'],
      curriculum: map['curriculum'],
      imageUrl: map['image_url'],
    );
  }
  
}

class Category {
  final String categoryId;
  final String categoryName;

  Category({required this.categoryId, required this.categoryName});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['category_id'], // matches DB
      categoryName: map['category_name'], // matches DB
    );
  }
}

class SubCategory {
  final String subCategoryId;
  final String subcategoryName;
  final String categoryId;

  SubCategory({
    required this.subCategoryId,
    required this.subcategoryName,
    required this.categoryId,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      subCategoryId: map['subcategory_id'], // matches DB
      subcategoryName: map['subcategory_name'], // matches DB
      categoryId: map['category_id'],
    );
  }
}

