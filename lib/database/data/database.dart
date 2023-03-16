
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stock/Helper/constants.dart';
class StockDatabase {
  StockDatabase._internal();
  static final StockDatabase _db = StockDatabase._internal();
  static StockDatabase get instance => _db;
  static Database? _database;
  Future<Database> get database async
  {
    if (_database != null) {
      return _database!;
    }
    _database = await _createDataBase();
    return _database!;
  }
  Future<Database> _createDataBase() async
  {
    return openDatabase(
        join(await getDatabasesPath(), stockDatabase),
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE $reagentTable ($reagentIdColumn INTEGER PRIMARY KEY AUTOINCREMENT ,'
                  '$reagentNameColumn TEXT UNIQUE,$reagentMinimumStockLevelColumn INTEGER,$stockReagentTemperatureColumn TEXT'
                  ',$reagentCategoryColumn TEXT,$reagentSubCategoryColumn TEXT)');
          db.execute(
              'CREATE TABLE IF NOT EXISTS $lotTable($lotIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,'
                  '$lotNumberColumn TEXT ,$lotExpireDateColumn TEXT ,$lotQuantityColumn INTEGER,$reagentIdColumn INTEGER ,'
                  'FOREIGN KEY ($reagentIdColumn) REFERENCES $reagentTable($reagentIdColumn))');
          db.execute(
              'CREATE TABLE IF NOT EXISTS $lotProcessTable ($lotProcessIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,'
                  '$lotDateQuantityColumn  INTEGER , $lotProcessAddingColumn INTEGER,$lotProcessSubtractingColumn INTEGER ,'
                  '$lotProcessDateColumn TEXT,$lotIdColumn INTEGER ,'
                  'FOREIGN KEY ($lotIdColumn) REFERENCES $lotTable($lotIdColumn))'
          );
          db.execute(
              'CREATE TABLE IF NOT EXISTS $expiredLotTable($expiredLotIdColumn INTEGER PRIMARY KEY,$expiredLotNumberColumn TEXT ,'
                  '$expiredLotExpireDateColumn TEXT ,$expiredLotQuantityColumn INTEGER,$reagentIdColumn INTEGER ,'
                  'FOREIGN KEY ($reagentIdColumn) REFERENCES $reagentTable($reagentIdColumn))');
          db.execute(
              'CREATE TABLE IF NOT EXISTS $expiredLotProcessTable ($expiredLotProcessIdColumn INTEGER PRIMARY KEY ,'
                  '$expiredLotDateQuantityColumn  INTEGER , $expiredLotProcessAddingColumn INTEGER,'
                  '$expiredLotProcessSubtractingColumn INTEGER ,$expiredLotProcessDateColumn TEXT,'
                  '$expiredLotIdColumn INTEGER,'
                  'FOREIGN KEY ($expiredLotIdColumn) REFERENCES $expiredLotTable($expiredLotIdColumn))'
          );
        },
        version: 1,

    );
  }
}
