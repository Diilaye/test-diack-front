import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:form/blocs/folder-bloc.dart';
import 'package:provider/provider.dart';

class AddFolderDialog extends StatefulWidget {
  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final TextEditingController _titleController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final folderBloc = Provider.of<FolderBloc>(context);

    return AlertDialog(
      title: Text(
        'Ajouter Dossier'.toUpperCase(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: 200,
        width: 450,
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Titre',
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Couleur'),
              ],
            ),
            BlockPicker(
              pickerColor: _selectedColor,
              layoutBuilder: (context, colors, child) => SizedBox(
                height: 100,
                width: 450,
                child: GridView.count(
                  crossAxisCount: 10,
                  children: List.generate(colors.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          print("onTap");
                          print(colors[index].toHexString());
                          setState(() {
                            _selectedColor = colors[index];
                          });
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[index],
                          ),
                          child: Center(
                            child: _selectedColor == colors[index]
                                ? Icon(
                                    Icons.done,
                                    color: useWhiteForeground(colors[index])
                                        ? Colors.white
                                        : Colors.black,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              onColorChanged: (color) {
                print("onColorChanged");
                print(color);
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            folderBloc.addFolder({
              "titre": _titleController.text,
              "color": _selectedColor.toHexString()
            });
            Navigator.of(context).pop(true);
          },
          child: folderBloc.chargement == 0
              ? const Text('Ajouter')
              : const Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator())),
        ),
      ],
    );
  }
}
