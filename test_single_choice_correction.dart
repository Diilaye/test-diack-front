import 'package:flutter/material.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/shared/widgets/form-response-field.dart';
import 'package:form/utils/colors-by-dii.dart';

void main() {
  runApp(TestSingleChoiceApp());
}

class TestSingleChoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Choix Unique - Correction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestSingleChoicePage(),
    );
  }
}

class TestSingleChoicePage extends StatefulWidget {
  @override
  _TestSingleChoicePageState createState() => _TestSingleChoicePageState();
}

class _TestSingleChoicePageState extends State<TestSingleChoicePage> {
  Map<String, dynamic> _responses = {};

  void _updateResponse(String champId, dynamic value) {
    setState(() {
      _responses[champId] = value;
    });
    print('Valeur mise à jour pour $champId: $value');
  }

  @override
  Widget build(BuildContext context) {
    // Création d'un champ de test avec des options
    final testChamp = ChampsFormulaireModel(
      id: 'test-single-choice',
      nom: 'Test - Sélection d\'une option',
      description: 'Choisissez une seule option parmi les suivantes',
      type: 'singleChoice',
      isObligatoire: '1',
      haveResponse: '0',
      formulaire: 'test-form',
      listeOptions: [
        ListeOptions(id: 'option-1', option: 'Option 1 - Première choice'),
        ListeOptions(id: 'option-2', option: 'Option 2 - Deuxième choix'),
        ListeOptions(id: 'option-3', option: 'Option 3 - Troisième choix'),
        ListeOptions(id: 'option-4', option: 'Option 4 - Quatrième choix'),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Choix Unique - Correction'),
        backgroundColor: btnColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600]),
                      SizedBox(width: 8),
                      Text(
                        'Test de correction',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ce test vérifie que les choix uniques fonctionnent correctement après correction.',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: FormResponseField(
                champ: testChamp,
                value: _responses[testChamp.id],
                onChanged: (value) => _updateResponse(testChamp.id!, value),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'État actuel:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _responses[testChamp.id] != null
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _responses[testChamp.id] != null
                            ? Colors.green
                            : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _responses[testChamp.id] != null
                              ? 'Sélection: ${_responses[testChamp.id]}'
                              : 'Aucune sélection',
                          style: TextStyle(
                            color: _responses[testChamp.id] != null
                                ? Colors.green[700]
                                : Colors.grey[600],
                            fontWeight: _responses[testChamp.id] != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_responses[testChamp.id] != null) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Text(
                        '✅ La sélection fonctionne correctement !',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _responses.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Réinitialiser la sélection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
