class Child {
  String childId;
  String name;
  String category;

  Child({required this.childId, required this.name, required this.category});

  factory Child.fromMap(Map<String, dynamic> data) {
    return Child(
      childId: data['childId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'name': name,
      'category': category,
    };
  }
}

class UserModel {
  String userId;
  String username;
  List<Child> children;

  UserModel({
    required this.userId,
    required this.username,
    required this.children,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    var childrenList = (data['children'] as List)
        .map((child) => Child.fromMap(child))
        .toList();

    return UserModel(
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      children: childrenList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'children': children.map((child) => child.toMap()).toList(),
    };
  }
}
