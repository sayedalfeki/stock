abstract class BasicModel
{
  final int rowId;
  BasicModel(this.rowId);
  Map<String,Object> toMap();
}