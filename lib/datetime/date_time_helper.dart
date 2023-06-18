//To convert DateTime object to a string in form yyymmdd

String convertDateTimeToString(DateTime dateTime) {
  //Year in yyyy
  String year = dateTime.year.toString();

  //Month in mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }
  //Day in dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
