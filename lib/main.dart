import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';


void main() {
 runApp(const CalculatorApp());
}


class CalculatorApp extends StatelessWidget {
 const CalculatorApp({super.key});


 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Kevin Vu',
     theme: ThemeData(
       primarySwatch: Colors.green,
       visualDensity: VisualDensity.adaptivePlatformDensity,
     ),
     home: const CalculatorHomePage(),
   );
 }
}


class CalculatorHomePage extends StatefulWidget {
 const CalculatorHomePage({super.key});


 @override
 _CalculatorHomePageState createState() => _CalculatorHomePageState();
}


class _CalculatorHomePageState extends State<CalculatorHomePage> {
 String _display = '';
 String _expression = '';
 static const int _maxExpressionLength = 50;


 void _onButtonPressed(String buttonText) {
   setState(() {
     if (buttonText == 'C') {
       _display = '';
       _expression = '';
     } else if (buttonText == 'x²') {
       if (_expression.isEmpty) return;


       final matches = RegExp(r'([+\-*/])').allMatches(_expression).toList();
       int lastOpIndex = -1;
       if (matches.isNotEmpty) {
         lastOpIndex = matches.last.start;
       }


       String left = '';
       String lastNumberStr = _expression;


       if (lastOpIndex != -1) {
         left = _expression.substring(0, lastOpIndex + 1);
         lastNumberStr = _expression.substring(lastOpIndex + 1);
       }


       if (lastNumberStr.isEmpty) return;


       final value = double.tryParse(lastNumberStr);
       if (value == null) return;


       final squared = pow(value, 2).toDouble();
       final squaredStr =
           (squared % 1 == 0) ? squared.toInt().toString() : squared.toString();


       _expression = left + squaredStr;
       _display = _expression;
     } else if (buttonText == '=') {
       if (_expression.isEmpty) return;
       try {
         final result = _evaluateExpression(_expression);
         _display = '$_expression = $result';
         _expression = result.toString();
       } catch (e) {
         _display = 'Error';
         _expression = '';
       }
     } else {
       if (_isValidInput(buttonText)) {
         _expression += buttonText;
         _display = _expression;
       }
     }
   });
 }


 bool _isValidInput(String input) {
   if (_expression.length + input.length > _maxExpressionLength) {
     return false;
   }
   if (_expression.isEmpty) {
     return input != '+' && input != '-' && input != '*' && input != '/' && input != '=';
   }
   String lastChar = _expression[_expression.length - 1];
   if ((lastChar == '+' || lastChar == '-' || lastChar == '*' || lastChar == '/') &&
       (input == '+' || input == '-' || input == '*' || input == '/')) {
     return false;
   }
   if (lastChar == '.' && (input == '+' || input == '-' || input == '*' || input == '/')) {
     return false;
   }
   if (input == '.') {
     List<String> parts = _expression.split(RegExp(r'[+\-*/]'));
     String currentNumber = parts.last;
     if (currentNumber.contains('.')) {
       return false;
     }
   }
   return true;
 }


 double _evaluateExpression(String expression) {
   if (expression.isEmpty) {
     throw Exception('Empty expression');
   }
   try {
     final parsedExpression = Expression.parse(expression);
     final evaluator = const ExpressionEvaluator();
     final result = evaluator.eval(parsedExpression, {});
     if (result is double) {
       if (result.isInfinite || result.isNaN) {
         throw Exception('Division by zero or invalid operation');
       }
       return result;
     } else if (result is int) {
       return result.toDouble();
     } else {
       throw Exception('Invalid result type');
     }
   } catch (e) {
     throw Exception('Invalid expression: ${e.toString()}');
   }
 }


 Widget _buildButton(String buttonText, {Color? color}) {
   return Expanded(
     child: ElevatedButton(
       style: ElevatedButton.styleFrom(
         backgroundColor: color ?? Colors.grey[300],
         foregroundColor: Colors.black,
         padding: EdgeInsets.zero,
         minimumSize: Size.zero,
         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20.0),
         ),
       ),
       onPressed: () => _onButtonPressed(buttonText),
       child: Text(
         buttonText,
         style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
       ),
     ),
   );
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.green[50],
     appBar: AppBar(
       title: const Text('Kevin Vu'),
       centerTitle: true,
       backgroundColor: Colors.green[900],
     ),
     body: Column(
       children: <Widget>[
         Expanded(
           flex: 2,
           child: Container(
             padding: const EdgeInsets.all(18.0),
             alignment: Alignment.bottomRight,
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Text(
                 _display,
                 style: const TextStyle(
                   fontSize: 48.0,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
           ),
         ),
         Expanded(
           flex: 5,
           child: Column(
             children: <Widget>[
               Expanded(
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     _buildButton('C', color: Colors.red),
                     _buildButton('x²', color: Colors.blue[900]),
                     _buildButton('7'),
                     _buildButton('8'),
                     _buildButton('9'),
                     _buildButton('/', color: Colors.orange),
                   ],
                 ),
               ),
               Expanded(
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     _buildButton('4'),
                     _buildButton('5'),
                     _buildButton('6'),
                     _buildButton('*', color: Colors.orange),
                   ],
                 ),
               ),
               Expanded(
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     _buildButton('1'),
                     _buildButton('2'),
                     _buildButton('3'),
                     _buildButton('-', color: Colors.orange),
                   ],
                 ),
               ),
               Expanded(
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     _buildButton('0'),
                     _buildButton('.'),
                     _buildButton('=', color: Colors.green),
                     _buildButton('+', color: Colors.orange),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }
}



