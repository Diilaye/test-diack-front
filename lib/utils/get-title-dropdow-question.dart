// ignore: file_names
String getTitleDropdownQuestion(String title) {
  switch (title) {
    case "textfield":
      return 'Champ de texte';
    case "textarea":
      return 'Zone de texte';
    case "multichoice":
      return 'Choix multiple';
    case "checkbox":
      return 'Case à cocher';
    case "dropdowns":
      return 'Listes déroulantes';
    case "file":
      return 'Fichier';
    default:
      return '';
  }
}
