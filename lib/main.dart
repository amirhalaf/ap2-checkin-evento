import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const EventoApp());
}

class EventoApp extends StatelessWidget {
  const EventoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evento Check-in',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3949AB),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const PaginaCheckin(),
    );
  }
}

class Participante {
  final String nome;
  final String email;
  final String codigo;

  const Participante({
    required this.nome,
    required this.email,
    required this.codigo,
  });
}

class PaginaCheckin extends StatefulWidget {
  const PaginaCheckin({super.key});

  @override
  State<PaginaCheckin> createState() => _PaginaCheckinState();
}

class _PaginaCheckinState extends State<PaginaCheckin> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<Participante> presencas = [];

  String? ingresso;
  String resultado = '';
  String tipoResultado = '';

  bool lendoIngresso = false;
  bool processandoLeitura = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void gerarIngresso() {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();

    if (nome.isEmpty || !email.contains('@') ||
        email.startsWith('@') || email.endsWith('@')) {
      setState(() {
        resultado = 'Informe um nome e um e-mail válido.';
        tipoResultado = 'erro';
      });
      return;
    }

    setState(() {
      ingresso = 'CHECKIN|$nome|$email';
      resultado = 'Ingresso gerado com sucesso!';
      tipoResultado = 'sucesso';
    });
  }

  void abrirLeitor() {
    setState(() {
      lendoIngresso = true;
      processandoLeitura = false;
      resultado = '';
      tipoResultado = '';
    });
  }

  void cancelarLeitura() {
    setState(() {
      lendoIngresso = false;
      processandoLeitura = false;
    });
  }

  void processarLeitura(BarcodeCapture captura) {
    if (processandoLeitura || !lendoIngresso) return;

    String? codigo;

    for (final barcode in captura.barcodes) {
      if (barcode.rawValue != null) {
        codigo = barcode.rawValue;
        break;
      }
    }

    if (codigo == null) return;

    // Processa somente uma leitura por tentativa.
    processandoLeitura = true;

    final partes = codigo.split('|');

    if (partes.length != 3 ||
        partes[0] != 'CHECKIN' ||
        partes[1].trim().isEmpty ||
        partes[2].trim().isEmpty ||
        !partes[2].contains('@')) {
      setState(() {
        lendoIngresso = false;
        resultado =
        'QR Code inválido. Esse ingresso não foi reconhecido.';
        tipoResultado = 'erro';
      });
      return;
    }

    final nome = partes[1].trim();
    final email = partes[2].trim();

    final jaConfirmado = presencas.any(
          (participante) => participante.codigo == codigo,
    );

    if (jaConfirmado) {
      setState(() {
        lendoIngresso = false;
        resultado = 'Este ingresso já teve o check-in confirmado.';
        tipoResultado = 'aviso';
      });
      return;
    }

    setState(() {
      presencas.add(
        Participante(
          nome: nome,
          email: email,
          codigo: codigo!,
        ),
      );

      lendoIngresso = false;
      resultado = 'Check-in confirmado para $nome!';
      tipoResultado = 'sucesso';
    });
  }

  Color get corResultado {
    switch (tipoResultado) {
      case 'sucesso':
        return Colors.green.shade700;
      case 'aviso':
        return Colors.orange.shade800;
      case 'erro':
        return Colors.red.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  IconData get iconeResultado {
    switch (tipoResultado) {
      case 'sucesso':
        return Icons.check_circle;
      case 'aviso':
        return Icons.warning_amber_rounded;
      case 'erro':
        return Icons.cancel;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Durante a leitura, o scanner ocupa a página inteira.
    if (lendoIngresso) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Ler ingresso'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            tooltip: 'Cancelar leitura',
            icon: const Icon(Icons.close),
            onPressed: cancelarLeitura,
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              onDetect: processarLeitura,
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 35,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Aponte a câmera para o QR Code do ingresso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evento • Check-in'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Seu ingresso',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),

              TextField(
                controller: nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: nomeController.text.trim().isEmpty
                    ? null
                    : gerarIngresso,
                icon: const Icon(Icons.confirmation_number),
                label: const Text('Gerar ingresso'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              if (ingresso != null) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.event,
                                size: 42,
                                color: Color(0xFF3949AB),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'INGRESSO DO EVENTO',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF303F9F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          nomeController.text.trim(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(emailController.text.trim()),
                        const SizedBox(height: 16),
                        QrImageView(
                          data: ingresso!,
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Apresente este QR Code para realizar o check-in.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 18),

              OutlinedButton.icon(
                onPressed: abrirLeitor,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Ler ingresso'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),

              if (resultado.isNotEmpty) ...[
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          iconeResultado,
                          color: corResultado,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            resultado,
                            style: TextStyle(
                              color: corResultado,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              Text(
                'Lista de presença (${presencas.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (presencas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Nenhum check-in confirmado ainda.'),
                )
              else
                Column(
                  children: presencas.map((participante) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE8EAFB),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF3949AB),
                          ),
                        ),
                        title: Text(participante.nome),
                        subtitle: Text(participante.email),
                        trailing: const Icon(
                          Icons.verified,
                          color: Colors.green,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}