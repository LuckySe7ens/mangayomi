import 'package:hive/hive.dart';
import 'package:mangayomi/models/model_manga.dart';
part 'categories.g.dart';

@HiveType(typeId: 8)
class CategoriesModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<ModelManga> listModelManga;
  CategoriesModel(
      {required this.id, required this.name, required this.listModelManga});
}