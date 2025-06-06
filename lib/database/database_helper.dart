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

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {      
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  // Crear las tablas iniciales de la base de datos
  Future<void> _createDB(Database db, int version) async {

    //Usuarios
    await db.execute('''
      CREATE TABLE usuario (
        id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido_paterno TEXT NOT NULL,
        apellido_materno TEXT,
        correo TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        rol TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');


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
        cantidad_minima INTEGER NOT NULL,
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

    //Metodos de pago
    await db.execute('''
      CREATE TABLE metodo_pago(
        id_metodo_pago INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        is_active BOOLEAN NOT NULL DEFAULT 1        
      )
    ''');

    await db.execute('''
      CREATE TABLE venta (
        id_venta INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        id_sucursal INTEGER NOT NULL,
        id_cliente INTEGER NOT NULL,
        id_metodo_pago INTEGER NOT NULL,
        id_usuario INTEGER NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
        FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago),
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
      )
    ''');

    await db.execute('''
    CREATE TABLE detalle_venta (
      id_venta INTEGER NOT NULL,
      id_producto INTEGER NOT NULL,
      cantidad INTEGER NOT NULL,
      precio_unitario REAL NOT NULL,
      PRIMARY KEY (id_venta, id_producto),
      FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
      FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
    )
  ''');


  await db.execute('''
    CREATE TABLE transaccion (
      id_transaccion INTEGER PRIMARY KEY AUTOINCREMENT,
      referencia TEXT NOT NULL,
      fecha TEXT NOT NULL,      
      estatus TEXT NOT NULL,
      id_venta INTEGER NOT NULL,
      FOREIGN KEY (id_venta) REFERENCES venta(id_venta)
    )
  ''');


    final batch = db.batch();


    // Insertar usuarios predeterminados
    batch.insert('usuario', { 'nombre': 'Javier', 'apellido_paterno': 'Fuentes', 'apellido_materno': 'Lopez', 'correo': 'admin@mail.com', 'password': '1234', 'rol': 'administrador', 'is_active': 1 });
    batch.insert('usuario', { 'nombre': 'Alan', 'apellido_paterno': 'Mata', 'apellido_materno': 'Alfaro', 'correo': 'vendedor@mail.com', 'password': '1234', 'rol': 'vendedor', 'is_active': 1 });

    // Insertar metodos de pago predeterminados
    batch.insert('metodo_pago', {'codigo': 'efectivo', 'descripcion':'Efectivo' , 'is_active': 1});
    batch.insert('metodo_pago', {'codigo': 'tarjeta_credito', 'descripcion':'Tarjeta de credito' ,'is_active': 1});
    batch.insert('metodo_pago', {'codigo': 'tarjeta_debito', 'descripcion':'Tarjeta de debito' ,'is_active': 1});
    batch.insert('metodo_pago', {'codigo': 'paypal', 'descripcion':'Paypal' ,'is_active': 1});
    batch.insert('metodo_pago', {'codigo': 'transferencia_bancaria','descripcion':'Transferencia Bancaria', 'is_active': 1,});

    await batch.commit();

  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  // Obtener los registros de la tabla
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  // Consultar registros
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? whereClause,
    List<dynamic>? whereArgs,
    List<String>? columns,
  }) async {
    final db = await instance.database;
    return await db.query(
      table,
      columns: columns,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  // Actualizar los registros
  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await instance.database;
    return await db.update(
      table,
      row,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  // Eliminar registros
  Future<int> delete(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await instance.database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }


}
