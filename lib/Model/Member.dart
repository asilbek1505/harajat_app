class Member {
  String user_id = '';
  String email;
  String password = '';
  String user_name;
  // bool isDarkMode;

  Member(this.user_name, this.email,);

  Member.fromJson(Map<String, dynamic> json)
      : user_id = json['user_id'] ?? '',
        email = json['email'] ?? '',
        password = json['password'] ?? '',
        user_name = json['name'] ?? '';
        // isDarkMode = json['darkMode'] ?? true;

  Map<String, dynamic> toJson() => {
    'user_id': user_id,
    'email': email,
    'password': password,
    'name': user_name,
    // 'darkMode': isDarkMode,
  };
}
