import 'package:flutter/material.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/shared/widgets/form-response-field.dart';

void main() {
  runApp(TestFormResponseApp());
}

class TestFormResponseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Choix Unique',
      home: TestFormResponsePage(),
    );
  }
}

class TestFormResponsePage extends StatefulWidget {
  @override
  _TestFormResponsePageState createState() => _TestFormResponsePageState();
}

class _TestFormResponsePageState extends State<TestFormResponsePage> {
  dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    // Création d'un champ de test avec des options
    final testChamp = ChampsFormulaireModel(
      id: 'test-champ',
      nom: 'Test - Comment évaluez-vous notre service ?',
      description: 'Choisissez une option',
      type: 'singleChoice',
      isObligatoire: '1',
      haveResponse: '0',
      formulaire: 'test-form',
      listeOptions: [
        ListeOptions(id: 'option-1', option: 'Excellent'),
        ListeOptions(id: 'option-2', option: 'Très bien'),
        ListeOptions(id: 'option-3', option: 'Bien'),
        ListeOptions(id: 'option-4', option: 'Passable'),
        ListeOptions(id: 'option-5', option: 'Insuffisant'),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Test des Choix Uniques'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test de fonctionnalité des choix uniques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FormResponseField(
              champ: testChamp,
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                print('Valeur sélectionnée: $value');
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valeur sélectionnée:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    selectedValue?.toString() ?? 'Aucune sélection',
                    style: TextStyle(
                      color: selectedValue != null ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
