import 'package:flutter/material.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/response-ui.dart';
import 'package:form/utils/widget/padding-global.dart';

class TextFieldResponseWidget extends StatelessWidget {
  final ChampsFormulaireModel champ;

  const TextFieldResponseWidget({super.key, required this.champ});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double w = deviceName(size) == ScreenType.Desktop
        ? size.width * .4
        : deviceName(size) == ScreenType.Tablet
            ? size.width * .4
            : size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                champ.nom!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              paddingHorizontalGlobal(8),
              if (champ.isObligatoire == '1')
                Icon(
                  Icons.star,
                  size: 10,
                  color: rouge,
                ),
              const Spacer(),
              Text('(${champ.notes!})')
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: w - 32,
                child: TextField(
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300, color: noir),
                  cursorColor: blanc,
                  decoration: InputDecoration(hintText: champ.description!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
