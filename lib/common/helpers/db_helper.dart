/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-17 21:05:06
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:sqflite/sqflite.dart';

class DbHelper {
  static late Database _db;

  static Future init() async {}

  static Database get db => _db;
}
