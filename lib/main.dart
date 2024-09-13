import 'package:flutter/material.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String textoDisplay = '0';

  Widget botaoCalculadora(String textoBotao, Color corBotao, Color corTexto) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          calcular(textoBotao);
        },
        child: Text(
          textoBotao,
          style: TextStyle(
            fontSize: 35,
            color: corTexto,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: corBotao,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculadora'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      textoDisplay,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            criarLinhaBotoes(['AC', '+/-', '%', '/'], Colors.amber[700]!),
            SizedBox(height: 10),
            criarLinhaBotoes(['7', '8', '9', 'x'], Colors.amber[700]!),
            SizedBox(height: 10),
            criarLinhaBotoes(['4', '5', '6', '-'], Colors.amber[700]!),
            SizedBox(height: 10),
            criarLinhaBotoes(['1', '2', '3', '+'], Colors.amber[700]!),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                    shape: StadiumBorder(),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () {
                    calcular('0');
                  },
                  child: Text(
                    '0',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                ),
                botaoCalculadora('.', Colors.grey[850]!, Colors.white),
                botaoCalculadora('=', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Row criarLinhaBotoes(List<String> botoes, Color corOperador) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: botoes.map((textoBotao) {
        Color corBotao = (textoBotao == '+' ||
                textoBotao == '-' ||
                textoBotao == 'x' ||
                textoBotao == '/' ||
                textoBotao == '=')
            ? corOperador
            : Colors.grey[850]!;
        return botaoCalculadora(textoBotao, corBotao, Colors.white);
      }).toList(),
    );
  }

  String texto = '0';
  double numUm = 0;
  double numDois = 0;

  String resultado = '';
  String resultadoFinal = '';
  String operador = '';
  String operadorAnterior = '';

  void calcular(String textoBotao) {
    if (textoBotao == 'AC') {
      texto = '0';
      numUm = 0;
      numDois = 0;
      resultado = '';
      resultadoFinal = '0';
      operador = '';
      operadorAnterior = '';
    } else if (operador == '=' && textoBotao == '=') {
      if (operadorAnterior == '+') {
        resultadoFinal = somar();
      } else if (operadorAnterior == '-') {
        resultadoFinal = subtrair();
      } else if (operadorAnterior == 'x') {
        resultadoFinal = multiplicar();
      } else if (operadorAnterior == '/') {
        resultadoFinal = dividir();
      }
    } else if (textoBotao == '+' ||
        textoBotao == '-' ||
        textoBotao == 'x' ||
        textoBotao == '/' ||
        textoBotao == '=') {
      if (numUm == 0) {
        numUm = double.parse(resultado);
      } else {
        numDois = double.parse(resultado);
      }

      if (operador == '+') {
        resultadoFinal = somar();
      } else if (operador == '-') {
        resultadoFinal = subtrair();
      } else if (operador == 'x') {
        resultadoFinal = multiplicar();
      } else if (operador == '/') {
        resultadoFinal = dividir();
      }

      operadorAnterior = operador;
      operador = textoBotao;
      resultado = '';
    } else if (textoBotao == '%') {
      resultado = (numUm / 100).toString();
      resultadoFinal = verificarDecimal(resultado);
    } else if (textoBotao == '.') {
      if (!resultado.contains('.')) {
        resultado = resultado + '.';
      }
      resultadoFinal = resultado;
    } else if (textoBotao == '+/-') {
      resultado =
          resultado.startsWith('-') ? resultado.substring(1) : '-' + resultado;
      resultadoFinal = resultado;
    } else {
      resultado = resultado + textoBotao;
      resultadoFinal = resultado;
    }

    setState(() {
      textoDisplay = resultadoFinal;
    });
  }

  String somar() {
    resultado = (numUm + numDois).toString();
    numUm = double.parse(resultado);
    return verificarDecimal(resultado);
  }

  String subtrair() {
    resultado = (numUm - numDois).toString();
    numUm = double.parse(resultado);
    return verificarDecimal(resultado);
  }

  String multiplicar() {
    resultado = (numUm * numDois).toString();
    numUm = double.parse(resultado);
    return verificarDecimal(resultado);
  }

  String dividir() {
    resultado = (numUm / numDois).toString();
    numUm = double.parse(resultado);
    return verificarDecimal(resultado);
  }

  String verificarDecimal(String resultado) {
    if (resultado.contains('.')) {
      List<String> splitDecimal = resultado.split('.');
      if (int.parse(splitDecimal[1]) == 0) {
        return splitDecimal[0];
      }
    }
    return resultado;
  }
}
