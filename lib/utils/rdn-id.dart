import 'dart:math';

String makeId(int length) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(
      length, (_) => characters[random.nextInt(characters.length)]).join();
}
