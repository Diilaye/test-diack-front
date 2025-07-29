import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';

class SondeAccessButton extends StatelessWidget {
  const SondeAccessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/sonde-test'),
        icon: const Icon(CupertinoIcons.lab_flask),
        label: const Text('Tester Authentification Sonde'),
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
