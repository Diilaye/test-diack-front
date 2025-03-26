import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';

class TextFieldCheckboxWidget extends StatelessWidget {
  final String title;
  final Function onSelect;
  final Function onChange;
  final bool haveTextField;
  final bool isSelectTed;
  final int choix;

  const TextFieldCheckboxWidget(
      {super.key,
      required this.title,
      required this.onSelect,
      required this.onChange,
      this.haveTextField = false,
      this.isSelectTed = false,
      required this.choix});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: size.width * .01,
          ),
          SizedBox(
            width: size.width * .2,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14,
                          color: noir,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * .05,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onSelect(),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(border: Border.all(color: noir)),
                    child: Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        color: isSelectTed ? noir : blanc,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: size.width * .05,
          ),
          if (haveTextField)
            SizedBox(
              width: size.width * .2,
              height: 60,
              child: TextField(
                cursorColor: Colors.black,
                onChanged: (value) => onChange(value),
                decoration: const InputDecoration(
                    labelText: 'Réponse',
                    labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                    focusColor: Colors.black,
                    fillColor: Colors.black,
                    border: InputBorder.none),
              ),
            ),
          SizedBox(
            width: size.width * .05,
          ),
        ],
      ),
    );
  }
}
