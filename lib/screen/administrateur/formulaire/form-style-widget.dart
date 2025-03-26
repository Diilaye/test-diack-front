import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class FromStyleWidget extends StatefulWidget {
  final String title;
  final Function onchange;
  final String value;
  const FromStyleWidget(
      {super.key,
      required this.title,
      required this.onchange,
      required this.value});

  @override
  State<FromStyleWidget> createState() => _FromStyleWidgetState();
}

class _FromStyleWidgetState extends State<FromStyleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  paddingHorizontalGlobal(8),
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 12, color: noir, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  paddingHorizontalGlobal(8),
                  Expanded(
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: widget.value,
                              onChanged: (newValue) {
                                setState(() {
                                  state.didChange(newValue);
                                });
                                widget.onchange(newValue);
                              },
                              iconSize: 12,
                              items: ["1", "2", "3"].map((String value) {
                                if (value == "1") {
                                  return const DropdownMenuItem<String>(
                                    value: "1",
                                    child: Text(
                                      "Aligné au centre",
                                    ),
                                  );
                                } else if (value == "2") {
                                  return const DropdownMenuItem<String>(
                                    value: "2",
                                    child: Text(
                                      "Aligné au gauche",
                                    ),
                                  );
                                } else if (value == "3") {
                                  return const DropdownMenuItem<String>(
                                    value: "3",
                                    child: Text(
                                      "Aligné au droite",
                                    ),
                                  );
                                } else {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  paddingHorizontalGlobal(8),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
