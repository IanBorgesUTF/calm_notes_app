class User {
  final String id;
  final String? name;
  final String? email;
  final String? phone;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };
}