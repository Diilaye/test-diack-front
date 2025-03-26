import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class SeparatorFielForm extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const SeparatorFielForm({super.key, required this.champ});

  @override
  State<SeparatorFielForm> createState() => _SeparatorFielFormState();
}

class _SeparatorFielFormState extends State<SeparatorFielForm> {
  bool isOpenSetting = false;
  bool isObligatoire = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);

    return Column(
      children: [
        paddingVerticalGlobal(8),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () => dialogRequest(
                      context: context, title: 'Voullez-vous suprimez ce champ')
                  .then((value) {
                if (value) {
                  formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
                }
              }),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: blanc,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(2, 2),
                          blurRadius: 2,
                          color: noir.withOpacity(.4))
                    ]),
                child: Center(
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 14,
                    color: rouge,
                  ),
                ),
              ),
            ),
            paddingHorizontalGlobal(8)
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            paddingHorizontalGlobal(size.width * .0),
            Expanded(
              child: Container(
                height: 1,
                decoration: DottedDecoration(),
              ),
            ),
            paddingHorizontalGlobal(size.width * .0),
          ],
        ),
      ],
    );
  }
}
