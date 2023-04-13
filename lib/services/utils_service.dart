  DateTime firebasetime(DateTime dateTime) {
    //هنا حيث نستقبل الوقت الممدخل ونتأكد من سلامة البيانات وانها تتدخل بشكل صحيح ومن ثم نرجع تلك القيمة للكائن
    DateTime newDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      0,
      0,
    );
    return newDate;
  }