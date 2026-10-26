# Evento Check-in

Aplicativo Flutter para geração e validação de ingressos de eventos por QR Code.

## Funcionalidades

- Cadastro de participantes com nome e e-mail.
- Geração de ingresso digital com QR Code.
- Leitura do QR Code pela câmera.
- Confirmação de check-in.
- Bloqueio de check-in duplicado.
- Rejeição de QR Codes inválidos.
- Lista de presença com contador de participantes.

## Tecnologias utilizadas

- Flutter
- Dart
- [qr_flutter](https://pub.dev/packages/qr_flutter)
- [mobile_scanner](https://pub.dev/packages/mobile_scanner)

## Integrante

- **Amir Halaf**

## Como executar

Na pasta do projeto, execute os seguintes comandos no terminal:

```bash
flutter pub get
flutter run
```

É necessário ter o Flutter instalado e um dispositivo ou emulador configurado.

## Formato do QR Code

O conteúdo do QR Code segue o padrão:

`CHECKIN|nome|email`

Exemplo:

`CHECKIN|Ana Souza|ana@email.com`

## Testes realizados

- **Ingresso válido:** check-in confirmado.
- **Ingresso repetido:** nova confirmação bloqueada.
- **QR Code inválido:** ingresso rejeitado.

## Capturas de tela

Adicione nesta seção as capturas de tela do aplicativo demonstrando:

- Ingresso gerado com QR Code.
- Leitura do QR Code pela câmera.
- Check-in confirmado.
- Tentativa de check-in duplicado.
- Rejeição de QR Code inválido.

## Armazenamento dos dados

A lista de presença é mantida em memória durante a execução do aplicativo. Os dados não são persistidos após o encerramento da aplicação.

## Objetivo acadêmico

Projeto desenvolvido individualmente por Amir Halaf como atividade acadêmica, com o objetivo de aplicar conceitos de desenvolvimento mobile com Flutter e Dart, geração e leitura de QR Codes e controle de check-in de participantes.

