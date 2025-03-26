import 'package:intl/intl.dart';

String getDateByDii(String d) =>
    d.split("T").first.split("-").reversed.join("-");

String showDate(String date) {
  // Conversion de la chaîne en objet DateTime
  DateTime dateTime = DateTime.parse(date);

  // Vérification si la date est aujourd'hui
  if (isSameDate(dateTime)) {
    // Si c'est aujourd'hui, afficher seulement l'heure
    String formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime; // Par exemple : 17:34:08
  } else {
    // Si c'est une date précédente, afficher seulement la date en français
    String formattedDate = DateFormat.yMMMMd('fr_FR').format(dateTime);
    return formattedDate; // Par exemple : mercredi 18 septembre 2024
  }
}

// Fonction pour vérifier si deux DateTime ont la même date (sans tenir compte de l'heure)
bool isSameDate(date1) {
  DateTime now = DateTime.now();

  if (date1.runtimeType == DateTime) {
    return date1.year == now.year &&
        date1.month == now.month &&
        date1.day == now.day;
  } else {
    DateTime dateTime = DateTime.parse(date1 as String);
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
}
