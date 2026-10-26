
# Evento Check-in

Aplicativo Flutter para geração e validação de ingressos de eventos por QR Code.

## Funcionalidades

- Cadastro de participante com nome e e-mail.
- Geração de ingresso com QR Code.
- Leitura do QR Code pela câmera.
- Confirmação de check-in.
- Bloqueio de check-in duplicado.
- Rejeição de QR Codes inválidos.
- Lista de presença com contador de participantes.

## Tecnologias utilizadas

- Flutter
- Dart
- qr_flutter
- mobile_scanner

## Integrantes do grupo

- NOME COMPLETO DO INTEGRANTE 1
- NOME COMPLETO DO INTEGRANTE 2

## Como executar

Execute no terminal, na pasta do projeto:

```bash
flutter pub get
flutter run
```

## Formato do QR Code

O conteúdo segue o padrão:

`CHECKIN|nome|email`

Exemplo:

`CHECKIN|Ana Souza|ana@email.com`

## Testes realizados

- Ingresso válido: check-in confirmado.
- Ingresso repetido: nova confirmação bloqueada.
- QR Code inválido: ingresso rejeitado.

## Capturas de tela

Adicione imagens do ingresso gerado, check-in confirmado, ingresso repetido e QR Code inválido.

## Observação

A lista de presença é mantida em memória durante a execução do aplicativo.
