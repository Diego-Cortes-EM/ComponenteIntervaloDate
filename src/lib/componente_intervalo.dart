import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataComponente extends StatefulWidget {
  final String? titulo;
  final DateTimeRange options;
  final void Function(DateTimeRange? index) onChanged;

  const DataComponente({
    super.key,
    required this.options,
    required this.onChanged,
    this.titulo,
  });

  @override
  _DataComponenteState createState() => _DataComponenteState();
}

class _DataComponenteState extends State<DataComponente> {
  DateTimeRange? _selectedRange; // Usar DateTimeRange para armazenar a seleção

  final DateTime data = DateTime.now();
  final DateTime _startDate = DateTime.now().subtract(Duration(days: 30));

  final List<String> _options = [
    "Um Dia",
    "Uma Semana",
    "Um Mês",
    "Um Ano",
    "Período"
  ];

  void _updateDateRange(int? selectedIndex) {
    DateTime startDate;
    DateTime endDate = data;

    if (selectedIndex == null) {
      return;
    }

    switch (selectedIndex) {
      case 0:
        startDate = data.subtract(const Duration(days: 1));
        _selectedRange = DateTimeRange(start: startDate, end: endDate);
        break;
      case 1:
        startDate = data.subtract(const Duration(days: 7));
        _selectedRange = DateTimeRange(start: startDate, end: endDate);
        break;
      case 2:
        startDate = data.subtract(const Duration(days: 30));
        _selectedRange = DateTimeRange(start: startDate, end: endDate);
        break;
      case 3:
        startDate = data.subtract(const Duration(days: 365));
        _selectedRange = DateTimeRange(start: startDate, end: endDate);
        break;
      default:
    }

    setState(() {
      widget.onChanged(_selectedRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedRange ??= DateTimeRange(start: _startDate, end: data);

    String startHint = DateFormat('dd/MM/yyyy').format(_selectedRange!.start);
    String endHint = DateFormat('dd/MM/yyyy').format(_selectedRange!.end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titulo ?? '',
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(4),
        ),
        Row(
          children: [
            Expanded(
              child: _buildElevatedButton(
                startHint,
                (int? newIndex) {
                  setState(() {
                    _updateDateRange(newIndex);
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
            Expanded(
              child: _buildElevatedButton(
                endHint,
                (int? newIndex) {
                  setState(() {
                    _updateDateRange(newIndex);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElevatedButton(
    String hintText,
    void Function(int? newIndex) onChanged,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: const BorderSide(color: Colors.grey), // Borda do botão
      ),
      onPressed: () async {
        final int? selectedIndex = await showModalBottomSheet<int>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                children: [
                  const Text(
                    'Selecione uma opção',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                _options[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, index);
                              },
                            ),
                            if (index <
                                4) // Evita adicionar o Divider após o último item
                              const Divider(
                                color: Colors.grey, // Cor do separador
                                thickness: 1, // Espessura do separador
                                indent: 15, // Espaço à esquerda do separador
                                endIndent: 15, // Espaço à direita do separador
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );

        if (selectedIndex != null && selectedIndex > 3) {
          _selectedRange ??= DateTimeRange(start: _startDate, end: data);
          DateTimeRange? datePeriodo = await showDateRangePicker(
            context: context,
            initialDateRange: _selectedRange,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (datePeriodo != null) {
            _selectedRange = datePeriodo;
          }
        }
        onChanged(selectedIndex);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          hintText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
