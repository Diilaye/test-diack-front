import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class FormSettingTop extends StatelessWidget {
  const FormSettingTop({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireBloc = Provider.of<FormulaireBloc>(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => formulaireBloc.setHoverSettingForm(1),
      onExit: (event) => formulaireBloc.setHoverSettingForm(0),
      child: GestureDetector(
        onTap: () => formulaireBloc.setMenuForm(2),
        child: DottedBorder(
            dashPattern: const [5, 5],
            color: formulaireBloc.hoverSettingForm == 0 ? blanc : noir,
            child: SizedBox(
              height: 90,
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: formulaireBloc.styleTitreForm == "1"
                        ? MainAxisAlignment.center
                        : formulaireBloc.styleTitreForm == "2"
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    children: [
                      paddingHorizontalGlobal(),
                      Text(
                        formulaireBloc.titleForm,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 20, color: noir),
                      ),
                      paddingHorizontalGlobal(),
                    ],
                  )),
                  paddingVerticalGlobal(),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: formulaireBloc.styleDescForm == "1"
                          ? MainAxisAlignment.center
                          : formulaireBloc.styleDescForm == "2"
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                      children: [
                        paddingHorizontalGlobal(),
                        Text(
                          formulaireBloc.descForm,
                          style: TextStyle(fontSize: 14, color: noir),
                        ),
                      ],
                    ),
                  ),
                  paddingVerticalGlobal(),
                  if (formulaireBloc.hoverSettingForm == 0)
                    Row(
                      children: [
                        paddingHorizontalGlobal(),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: noir,
                          ),
                        ),
                        paddingHorizontalGlobal(),
                      ],
                    )
                ],
              ),
            )),
      ),
    );
  }
}
