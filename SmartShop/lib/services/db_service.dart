// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DbService {
//   static final DbService instance = DbService._instance();
//   static Database? _database;

//   DbService._instance();

//   Future<Database> get db async {
//     _database ??= await initDB();
//     return _database!;
//   }

//   Future<Database> initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'smartshop.db');

//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE products (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT NOT NULL,
//             price TEXT NOT NULL,
//             imagePath TEXT NOT NULL,
//             details TEXT,
//             type TEXT,
//           )
//         ''');
//       },
//     );
//   }

//   // Insérer un produit
//   Future<void> insertProduct(Map<String, dynamic> e) async {
//     final db = await instance.db;
//     await db.insert('product', e);
//   }

//   // 1) Ajouter un produit aux favoris

//   Future<int> insertFavorite({
//     required String name,
//     required String price,
//     required String imagePath,
//   }) async {
//     final db = await instance.db;
//     return db.insert('products', {
//       'name': name,
//       'price': price,
//       'imagePath': imagePath,
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }
// }
