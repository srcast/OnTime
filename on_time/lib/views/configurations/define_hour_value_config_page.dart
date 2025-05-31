import 'package:flutter/material.dart';

class DefineValorHoraPage extends StatefulWidget {
  @override
  _DefineValorHoraPageState createState() => _DefineValorHoraPageState();
}

class _DefineValorHoraPageState extends State<DefineValorHoraPage> {
  final TextEditingController _baseValueController = TextEditingController(
    text: '10,00',
  );

  List<Map<String, String>> regrasEspeciais = [
    {'tipo': 'dia', 'dia': 'Segunda', 'valor': '12,00 €'},
    {'tipo': 'horas', 'horas': '8', 'valor': '15,00 €'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Definir Valor/Hora'),
        leading: BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF7F9F8), // cor de fundo clara
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Valor Base por Hora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _baseValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Regras Especiais',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // lógica para adicionar nova regra
              },
              child: Text('Adicionar Regra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D5A), // botão verde
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: regrasEspeciais.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final regra = regrasEspeciais[index];
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          regra['tipo'] == 'dia'
                              ? Icons.calendar_today
                              : Icons.access_time,
                          color: Color(0xFF2E7D5A),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                regra['tipo'] == 'dia'
                                    ? 'Valor no dia da semana'
                                    : 'Valor após X horas trabalhadas',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                regra['tipo'] == 'dia'
                                    ? 'Dia: ${regra['dia']}\nValor: ${regra['valor']}'
                                    : 'Após: ${regra['horas']} horas\nValor: ${regra['valor']}',
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, size: 20),
                              onPressed: () {
                                setState(() => regrasEspeciais.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // lógica para guardar
              },
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D5A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
