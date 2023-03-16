class MyDate
{
  static String dateToString(DateTime t) {
    int year=t.year;
    int month=t.month;
    int day=t.day<10?0+t.day:t.day;
    String sMonth=month<10?'0$month':'$month';
    String sDay=day<10?'0$day':'$day';

    return '$year-$sMonth-$sDay';
  }
  static DateTime toDate(String date)=> DateTime.parse(date);
  static int getDiffDate({required DateTime oldDate,required DateTime newDate}) {
    return newDate.difference(oldDate).inDays;
  }
 static bool isExpire(DateTime expireDate)
  {
    bool expire=false;
    if(getDiffDate(oldDate:DateTime.now(),newDate:expireDate)<0)
    {
     expire=true;
    }
    return expire;
  }
  static bool isNearExpire(DateTime expireDate)
  {
    bool nearExpire=true;
    if(getDiffDate(oldDate:DateTime.now(),newDate:expireDate)>7)
    {
      nearExpire=false;
    }
    return nearExpire;
  }
}