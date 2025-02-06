/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-10-14 15:42:03
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

class UserEntity {
  String email;
  String password;
  String fullName;
  String gender;
  int age;

  UserEntity({
    required this.email,
    required this.fullName,
    required this.password,
    required this.age,
    required this.gender,
  });
}
