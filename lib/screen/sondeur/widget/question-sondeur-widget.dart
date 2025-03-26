import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/get-title-dropdow-question.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class QuestionSondeurWidget extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const QuestionSondeurWidget({super.key, required this.champ});

  @override
  State<QuestionSondeurWidget> createState() => _QuestionSondeurWidgetState();
}

class _QuestionSondeurWidgetState extends State<QuestionSondeurWidget> {
  bool isOpenCorige = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: widget.champ.type! == 'multiChoice' ||
                widget.champ.type! == 'checkBox'
            ? (widget.champ.listeOptions!.length * 80) + 230
            : 200,
        width: size.width * .75,
        decoration: BoxDecoration(color: blanc),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: size.width * .75,
              child: Row(
                children: [
                  paddingHorizontalGlobal(8),
                  Expanded(
                      child: TextField(
                    onSubmitted: (value) =>
                        formulaireSondeurBloc.updateChampFormulaireNomQuestions(
                            widget.champ.id!, value),
                    controller: TextEditingController()
                      ..text = widget.champ.nom!,
                    decoration: const InputDecoration(hintText: 'QUESTIONS'),
                  )),
                  paddingHorizontalGlobal(32),
                  DropdownButton(
                    onChanged: (value) {
                      formulaireSondeurBloc.updateChampFormulaireTypeQuestions(
                          widget.champ.id!, value!);
                    },
                    value: widget.champ.type,
                    items: formulaireSondeurBloc.questions
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(getTitleDropdownQuestion(
                                e.toLowerCase().toLowerCase()))))
                        .toList(),
                  ),
                  paddingHorizontalGlobal(8),
                ],
              ),
            ),
            paddingVerticalGlobal(8),
            Row(
              children: [
                paddingHorizontalGlobal(32),
                isOpenCorige
                    ? Expanded(
                        child: TextField(
                        onSubmitted: (value) => formulaireSondeurBloc
                            .updateChampFormulaireDescriptionQuestions(
                                widget.champ.id!, value),
                        controller: TextEditingController()
                          ..text = widget.champ.description!,
                        decoration: const InputDecoration(
                            hintText: 'Description question'),
                      ))
                    : Expanded(
                        child: TextField(
                        onSubmitted: (value) => formulaireSondeurBloc
                            .updateChampFormulaireNotesQuestions(
                                widget.champ.id!, value),
                        controller: TextEditingController()
                          ..text = widget.champ.notes!,
                        decoration:
                            const InputDecoration(labelText: 'Point question'),
                      )),
                paddingHorizontalGlobal(32),
              ],
            ),
            if (widget.champ.type! == 'multiChoice' ||
                widget.champ.type! == 'checkBox')
              Column(
                children: [
                  ...widget.champ.listeOptions!
                      .map((optionsV) => isOpenCorige
                          ? SizedBox(
                              height: 64,
                              child: Row(
                                children: [
                                  paddingHorizontalGlobal(32),
                                  Icon(
                                    Icons.square_outlined,
                                    color: noir,
                                    size: 25,
                                  ),
                                  paddingHorizontalGlobal(8),
                                  Expanded(
                                      child: TextField(
                                    controller: TextEditingController()
                                      ..text = optionsV.option!,
                                    onSubmitted: (value) =>
                                        formulaireSondeurBloc
                                            .updateChampFormulaireOptions(
                                                widget.champ.id!,
                                                optionsV.id!,
                                                value),
                                    decoration: InputDecoration(
                                        hintText: optionsV.option!),
                                  )),
                                  paddingHorizontalGlobal(32),
                                  IconButton(
                                      onPressed: () => formulaireSondeurBloc
                                          .deleteChampFormulaireOptions(
                                              widget.champ.id!, optionsV.id!),
                                      icon: Icon(
                                        Icons.delete,
                                        color: noir,
                                        size: 25,
                                      )),
                                  paddingHorizontalGlobal(32),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 64,
                              child: Row(
                                children: [
                                  paddingHorizontalGlobal(32),
                                  IconButton(
                                    onPressed: () => formulaireSondeurBloc
                                        .addChampFormulaireResponse(
                                            widget.champ.id!,
                                            optionsV.id!,
                                            optionsV),
                                    icon: Icon(
                                      // widget.champ.listeReponses!
                                      //             .firstWhere(
                                      //               (op) =>
                                      //                   op.id! == optionsV.id!,
                                      //               orElse: () =>
                                      //                   ReponseChampModel(
                                      //                       id: ''),
                                      //             )
                                      //             .id ==
                                      //         optionsV.id!
                                      //     ? Icons.square
                                      //     :
                                      Icons.square_outlined,
                                      color: noir,
                                      size: 25,
                                    ),
                                  ),
                                  paddingHorizontalGlobal(8),
                                  Expanded(child: Text(optionsV.option!)),
                                  paddingHorizontalGlobal(32),
                                ],
                              ),
                            ))
                      .toList(),
                  isOpenCorige
                      ? SizedBox(
                          height: 64,
                          child: Row(
                            children: [
                              paddingHorizontalGlobal(8),
                              const Expanded(child: SizedBox()),
                              paddingHorizontalGlobal(32),
                              IconButton(
                                  onPressed: () => formulaireSondeurBloc
                                      .addChampsFormulaireOptions(
                                          widget.champ.id!),
                                  icon: Icon(
                                    Icons.add,
                                    color: noir,
                                    size: 25,
                                  )),
                              paddingHorizontalGlobal(32),
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            const Spacer(),
            if (isOpenCorige)
              Row(
                children: [
                  paddingHorizontalGlobal(32),
                  GestureDetector(
                    onTap: () => setState(() {
                      isOpenCorige = false;
                    }),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: noir.withOpacity(.4),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(4),
                          Icon(
                            Icons.checklist_rounded,
                            color: blanc,
                          ),
                          paddingHorizontalGlobal(3),
                          Text(
                            'Corrigé',
                            style: TextStyle(fontSize: 13, color: blanc),
                          ),
                          paddingHorizontalGlobal(4),
                        ],
                      ),
                    ),
                  ),
                  paddingHorizontalGlobal(3),
                  Text(
                    ' (${widget.champ.notes!} points) ',
                    style: TextStyle(fontSize: 13, color: noir),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      dialogRequest(
                              context: context,
                              title: 'Voullez-vous suprimez ce champ')
                          .then((value) {
                        if (value) {
                          formulaireSondeurBloc
                              .deleteChampFormulaire(widget.champ.id!);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 24,
                      color: noir,
                    ),
                  ),
                  paddingHorizontalGlobal(8),
                  Container(
                    height: 20,
                    width: 1,
                    color: noir,
                  ),
                  paddingHorizontalGlobal(8),
                  Text(
                    "Obligatoire",
                    style: TextStyle(color: noir, fontWeight: FontWeight.w300),
                  ),
                  paddingHorizontalGlobal(8),
                  GestureDetector(
                    onTap: () async {
                      print(
                          " formulaireSondeurBloc.updateChampFormulaireObligatoireQuestions(");
                      formulaireSondeurBloc
                          .updateChampFormulaireObligatoireQuestions(
                              widget.champ.id!,
                              widget.champ.isObligatoire == '1' ? '0' : '1');
                    },
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: noir.withOpacity(.4))),
                      child: Center(
                        child: widget.champ.isObligatoire == '1'
                            ? Icon(
                                Icons.check,
                                color: vert,
                                size: 12,
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  paddingHorizontalGlobal(32),
                ],
              ),
            if (!isOpenCorige)
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() {
                      isOpenCorige = true;
                    }),
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: noir.withOpacity(.4),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(4),
                          Text(
                            'Terminé',
                            style: TextStyle(fontSize: 13, color: blanc),
                          ),
                          paddingHorizontalGlobal(4),
                        ],
                      ),
                    ),
                  ),
                  paddingHorizontalGlobal(32),
                ],
              ),
            paddingVerticalGlobal(8),
          ],
        ),
      ),
    );
  }
}
