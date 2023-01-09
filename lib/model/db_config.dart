import 'package:diet/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "diet.db";
  static const int _databaseVersion = 1;
  static const foodTable = "food";
  static const workoutTable = "workout";
  static const bodyTable = "body";
  static const weightTable = "weight";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS $foodTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER DEFAULT 0,
        type INTEGER DEFAULT 0,
        kcal INTEGER DEFAULT 0,
        time INTEGER DEFAULT 0,
        memo String,
        image String 
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $workoutTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER DEFAULT 0,
        time INTEGER DEFAULT 0,
        kcal INTEGER DEFAULT 0,
        intense INTEGER DEFAULT 0,
        part INTEGER DEFAULT 0,
        name String,
        memo String
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $bodyTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER DEFAULT 0,
        image String,
        memo String
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $weightTable (
        date INTEGER DEFAULT 0,
        weight INTEGER DEFAULT 0,
        fat INTEGER DEFAULT 0,
        muscle INTEGER DEFAULT 0
      )
    """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // Database Manipulate (INSERT, UPDATE, SELECT, DELETE)

  Future<int> insertFood(Food food) async {
    Database db = await instance.database;

    if (food.id == null) {
      // Data 생성
      final map = food.toMap();

      return await db.insert(foodTable, map);
    } else {
      // Data 변경
      final map = food.toMap();

      return await db
          .update(foodTable, map, where: "id = ?", whereArgs: [food.id]);
    }
  }

  // Data query
  Future<List<Food>> queryFoodByDate(int date) async {
    Database db = await instance.database;

    List<Food> foods = [];

    final queries =
        await db.query(foodTable, where: "date = ?", whereArgs: [date]);

    for (final query in queries) {
      foods.add(Food.fromDB(query));
    }

    return foods;
  }

  Future<List<Food>> queryAllFood() async {
    Database db = await instance.database;

    List<Food> foods = [];

    final queries = await db.query(foodTable);

    for (final query in queries) {
      foods.add(Food.fromDB(query));
    }

    return foods;
  }

  Future<int> insertWorkout(Workout workout) async {
    Database db = await instance.database;

    if (workout.id == null) {
      // Data 생성
      final map = workout.toMap();

      return await db.insert(workoutTable, map);
    } else {
      // Data 변경
      final map = workout.toMap();

      return await db
          .update(workoutTable, map, where: "id = ?", whereArgs: [workout.id]);
    }
  }

  // Data query
  Future<List<Workout>> queryWorkoutByDate(int date) async {
    Database db = await instance.database;

    List<Workout> workouts = [];

    final queries =
        await db.query(workoutTable, where: "date = ?", whereArgs: [date]);

    for (final query in queries) {
      workouts.add(Workout.fromDB(query));
    }

    return workouts;
  }

  Future<List<Workout>> queryAllWorkout() async {
    Database db = await instance.database;

    List<Workout> workouts = [];

    final queries = await db.query(workoutTable);

    for (final query in queries) {
      workouts.add(Workout.fromDB(query));
    }

    return workouts;
  }

  Future<int> insertEyeBody(EyeBody eyeBody) async {
    Database db = await instance.database;

    if (eyeBody.id == null) {
      // Data 생성
      final map = eyeBody.toMap();

      return await db.insert(bodyTable, map);
    } else {
      // Data 변경
      final map = eyeBody.toMap();

      return await db
          .update(bodyTable, map, where: "id = ?", whereArgs: [eyeBody.id]);
    }
  }

  // Data query
  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db = await instance.database;

    List<EyeBody> eyeBodies = [];

    final queries =
        await db.query(bodyTable, where: "date = ?", whereArgs: [date]);

    for (final query in queries) {
      eyeBodies.add(EyeBody.fromDB(query));
    }

    return eyeBodies;
  }

  Future<List<EyeBody>> queryAllEyeBody() async {
    Database db = await instance.database;

    List<EyeBody> eyeBodies = [];

    final queries = await db.query(bodyTable);

    for (final query in queries) {
      eyeBodies.add(EyeBody.fromDB(query));
    }

    return eyeBodies;
  }

  Future<int> insertWeight(Weight weight) async {
    Database db = await instance.database;

    List<Weight> d = await queryWeightByDate(weight.date);

    if (d.isEmpty) {
      // Data 생성
      final map = weight.toMap();

      return await db.insert(weightTable, map);
    } else {
      // Data 변경
      final map = weight.toMap();

      return await db.update(weightTable, map,
          where: "date = ?", whereArgs: [weight.date]);
    }
  }

  // Data query
  Future<List<Weight>> queryWeightByDate(int date) async {
    Database db = await instance.database;

    List<Weight> weights = [];

    final queries =
        await db.query(weightTable, where: "date = ?", whereArgs: [date]);

    for (final query in queries) {
      weights.add(Weight.fromDB(query));
    }

    return weights;
  }

  Future<List<Weight>> queryAllWeight() async {
    Database db = await instance.database;

    List<Weight> eyeBodies = [];

    final queries = await db.query(bodyTable);

    for (final query in queries) {
      eyeBodies.add(Weight.fromDB(query));
    }

    return eyeBodies;
  }
}
