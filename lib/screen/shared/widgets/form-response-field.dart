import 'package:flutter/material.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';

class FormResponseField extends StatefulWidget {
  final ChampsFormulaireModel champ;
  final dynamic value;
  final Function(dynamic) onChanged;

  const FormResponseField({
    Key? key,
    required this.champ,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<FormResponseField> createState() => _FormResponseFieldState();
}

class _FormResponseFieldState extends State<FormResponseField> {
  late TextEditingController _controller;
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initializeValue();
  }

  @override
  void didUpdateWidget(FormResponseField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _initializeValue();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeValue() {
    if (widget.value != null) {
      if (widget.champ.type == 'textField' ||
          widget.champ.type == 'textArea' ||
          widget.champ.type == 'email' ||
          widget.champ.type == 'telephone' ||
          widget.champ.type == 'nomComplet' ||
          widget.champ.type == 'addresse') {
        _controller.text = widget.value.toString();
      } else if (widget.champ.type == 'multiChoice') {
        _selectedOptions = List<String>.from(widget.value ?? []);
      } else if (widget.champ.type == 'date') {
        // Pour les champs de date, la valeur peut être un DateTime ou une String
        // La logique d'affichage est gérée dans _buildDateField
        // Rien à faire ici pour les contrôleurs de texte
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionTitle(),
          const SizedBox(height: 16),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildQuestionTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.champ.nom ?? 'Question sans titre',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (widget.champ.isObligatoire == '1')
          Text(
            ' *',
            style: TextStyle(
              color: rouge,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildInputField() {
    switch (widget.champ.type) {
      case 'textField':
      case 'nomComplet':
      case 'email':
      case 'telephone':
      case 'addresse':
        return _buildTextField();

      case 'textArea':
        return _buildTextArea();

      case 'date':
        return _buildDateField();

      case 'singleChoice':
      case 'yesno':
        return _buildSingleChoice();

      case 'multiChoice':
        return _buildMultiChoice();

      case 'checkBox':
        return _buildCheckbox();

      case 'file':
        return _buildFileUpload();

      case 'image':
        return _buildImageUpload();

      case 'separator':
        return _buildSeparator();

      case 'explication':
        return _buildExplanation();

      default:
        return _buildTextField();
    }
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: _getKeyboardType(),
      decoration: InputDecoration(
        hintText: widget.champ.description ?? 'Votre réponse...',
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: vert, width: 2),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: widget.champ.description ?? 'Votre réponse...',
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: vert, width: 2),
        ),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSingleChoice() {
    final options = widget.champ.listeOptions ?? [];

    if (options.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: Colors.orange[600],
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Aucune option disponible pour ce choix unique',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: options.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.value == option.id ? vert : Colors.grey[300]!,
              width: widget.value == option.id ? 2 : 1,
            ),
            color: widget.value == option.id
                ? vert.withOpacity(0.1)
                : Colors.white,
          ),
          child: RadioListTile<String>(
            title: Text(
              option.option ?? '',
              style: TextStyle(
                fontWeight: widget.value == option.id
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: widget.value == option.id ? vert : Colors.black87,
              ),
            ),
            value: option.id ?? '',
            groupValue: widget.value,
            onChanged: (value) {
              widget.onChanged(value);
            },
            activeColor: vert,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiChoice() {
    final options = widget.champ.listeOptions ?? [];

    if (options.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: Colors.orange[600],
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Aucune option disponible pour ce choix multiple',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: options.map((option) {
        final isSelected = _selectedOptions.contains(option.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? vert : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? vert.withOpacity(0.1) : Colors.white,
          ),
          child: CheckboxListTile(
            title: Text(
              option.option ?? '',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? vert : Colors.black87,
              ),
            ),
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedOptions.add(option.id!);
                } else {
                  _selectedOptions.remove(option.id);
                }
              });
              widget.onChanged(_selectedOptions);
            },
            activeColor: vert,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCheckbox() {
    return CheckboxListTile(
      title: Text(widget.champ.description ?? ''),
      value: widget.value == true,
      onChanged: (bool? value) {
        widget.onChanged(value ?? false);
      },
      activeColor: vert,
    );
  }

  Widget _buildFileUpload() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Cliquez pour télécharger un fichier',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          if (widget.value != null)
            Text(
              'Fichier sélectionné: ${widget.value}',
              style: TextStyle(
                color: vert,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.value != null
          ? Image.network(
              widget.value,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildUploadPlaceholder(
                    Icons.image_outlined, 'Image sélectionnée');
              },
            )
          : _buildUploadPlaceholder(
              Icons.image_outlined, 'Cliquez pour télécharger une image'),
    );
  }

  Widget _buildUploadPlaceholder(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 2,
          width: double.infinity,
          color: vert,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.champ.description ?? 'Information',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    DateTime? selectedDate = widget.value is DateTime
        ? widget.value as DateTime
        : widget.value is String && (widget.value as String).isNotEmpty
            ? DateTime.tryParse(widget.value as String)
            : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: btnColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            widget.onChanged(picked);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedDate != null
                      ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                      : 'Sélectionner une date',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey.shade500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey.shade600,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.champ.type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'telephone':
        return TextInputType.phone;
      case 'addresse':
        return TextInputType.streetAddress;
      default:
        return TextInputType.text;
    }
  }
}
