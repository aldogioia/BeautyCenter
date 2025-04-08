class DateUtil {
  static String getItalianMonthName({required int month}) {
    switch (month) {
      case 1:
        return 'Gennaio';
      case 2:
        return 'Febbraio';
      case 3:
        return 'Marzo';
      case 4:
        return 'Aprile';
      case 5:
        return 'Maggio';
      case 6:
        return 'Giugno';
      case 7:
        return 'Luglio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Settembre';
      case 10:
        return 'Ottobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Dicembre';
      default:
        return 'Mese non valido';
    }
  }

  static String getItalianWeekDayNamePrefix({required int weekday}){
    switch(weekday){
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mer';
      case 4:
        return 'Gio';
      case 5:
        return 'Ven';
      case 6:
        return 'Sab';
      case 7:
        return 'Dom';
      default:
        return 'Giorno della settimana non valido';
    }
  }

  static bool isSameDay({required DateTime date1, required DateTime date2}){
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}