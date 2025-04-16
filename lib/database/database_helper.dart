import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

   // Instancia unica de DatabaseHelper (patron Singleton)
   // La otra manera es implementar un factory 
   // factory DatabaseHelper() => _instance;
   static final DatabaseHelper instance = DatabaseHelper._();
   // Constructor privado 'nombrado' -> ._
   // Para implementar singleton
   DatabaseHelper._();


  Future<Database> get database async {
    // ??= (null-aware) Asigna un valor si la variable es nula
    _database ??= await _initDB_();
    return _database!;
  }

  // /Users/mtw308/Library/Containers/com.example.paymentApp/Data/Documents/dmr_payment_system.db

  // 1. Inicializar la base de datos en caso de que no exista
  // 2.- Crear el archivo de base de datos si no existe
  Future<Database> _initDB_() async {
    String path = join(await getDatabasesPath(), 'dmr_ventasapp_system.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear las tablas iniciales de la base de datos
  Future<void> _createDB(Database db, int version) async{
    // Clientes
    await db.execute('''
      CREATE TABLE cliente (
          id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          correo TEXT NOT NULL,
          telefono TEXT NOT NULL,
          direccion TEXT NOT NULL,  
          is_active BOOLEAN NOT NULL DEFAULT 1   
      )
    ''');

    await db.execute('''
      CREATE TABLE sucursal (
        id_sucursal INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ubicacion TEXT NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT 1   
      )
    ''');


    await db.execute('''
      CREATE TABLE producto (
        id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        precio REAL NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');


    await db.execute('''
      CREATE TABLE inventario (
        id_sucursal INTEGER NOT NULL,
        id_producto INTEGER NOT NULL,
        cantidad_disponible INTEGER NOT NULL,
        PRIMARY KEY (id_sucursal, id_producto),
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
      )
    ''');


    final batch = db.batch();

    await batch.commit();

  }

  Future<int> insert(String table, Map<String,dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);    
  }

  // Obtener los registros de la tabla
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  // Consultar registros
  Future<List<Map<String, dynamic>>> query(String table, {String? whereClause, List<dynamic>? whereArgs, List<String>? columns}) async {
    final db = await instance.database;
    return await db.query(
      table,
      columns: columns,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  // Actualizar los registros
  Future<int> update(String table, Map<String, dynamic> row, String whereClause, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.update(table, row, where: whereClause, whereArgs: whereArgs);
  }

  // Eliminar registros
  Future<int> delete(String table, String whereClause, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

}