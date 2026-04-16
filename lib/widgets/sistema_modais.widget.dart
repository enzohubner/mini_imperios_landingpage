import 'package:flutter/material.dart';

import '../mixins/cores.mixin.dart';

TextStyle _textoSerifModal(
  double tamanho,
  Color cor, {
  FontWeight peso = FontWeight.w400,
  double altura = 1.75,
}) => TextStyle(
  fontFamily: 'Georgia',
  fontSize: tamanho,
  fontWeight: peso,
  color: cor,
  height: altura,
);

TextStyle _textoCapsModal(
  double tamanho,
  Color cor, {
  double espacamento = 3.0,
}) => TextStyle(
  fontFamily: 'Georgia',
  fontSize: tamanho,
  fontWeight: FontWeight.w600,
  color: cor,
  letterSpacing: espacamento,
  height: 1,
);

class SobreposicaoModalWidget extends StatelessWidget with CoresMixin {
  final Widget child;

  const SobreposicaoModalWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          CoresMixin.corAzulMarinho.withOpacity(.78),
          CoresMixin.corAzulMarinho.withOpacity(.62),
        ],
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: GestureDetector(onTap: () {}, child: child),
      ),
    ),
  );
}

class CartaoModalWidget extends StatelessWidget with CoresMixin {
  final String title;
  final Color accent;
  final VoidCallback onClose;
  final Widget body;
  final double width;

  const CartaoModalWidget({
    super.key,
    required this.title,
    required this.accent,
    required this.onClose,
    required this.body,
    this.width = 440,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    decoration: BoxDecoration(
      color: corFundoApp,
      border: Border.all(color: corBordaApp.withOpacity(.9), width: 1.1),
      borderRadius: BorderRadius.circular(raioModalApp),
      boxShadow: [
        BoxShadow(
          color: CoresMixin.corAzulMarinho.withOpacity(.14),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: CoresMixin.corAzulMarinho.withOpacity(.26),
          blurRadius: 58,
          offset: const Offset(0, 24),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(28, 22, 20, 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                corCabecalhoModal,
                CoresMixin.corDouradaClara.withOpacity(.92),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(raioModalApp),
              topRight: Radius.circular(raioModalApp),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _textoSerifModal(
                        20,
                        CoresMixin.corAzulMarinho,
                        peso: FontWeight.w700,
                        altura: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 42, height: 2, color: accent),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: CoresMixin.corMarfim.withOpacity(.55),
                    border: Border.all(color: corTextoApp.withOpacity(.2)),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.close, size: 14, color: corTextoApp),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 28, 30, 30),
          child: body,
        ),
      ],
    ),
  );
}

class CampoTextoModalWidget extends StatelessWidget with CoresMixin {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const CampoTextoModalWidget(
    this.label, {
    super.key,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscureText,
    style: _textoSerifModal(14, corTextoApp, altura: 1),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: _textoSerifModal(13, corTextoSecundarioApp, altura: 1),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: corBordaApp.withOpacity(.9), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: corPrimariaApp, width: 2),
      ),
      floatingLabelStyle: _textoSerifModal(
        13,
        corPrimariaApp,
        peso: FontWeight.w600,
        altura: 1,
      ),
    ),
  );
}

class BotaoAcaoModalWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;
  final bool loading;

  const BotaoAcaoModalWidget(
    this.label, {
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: onTap == null
              ? backgroundColor.withOpacity(.3)
              : backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: onTap == null
              ? []
              : [
                  BoxShadow(
                    color: backgroundColor.withOpacity(.26),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: foregroundColor,
                    strokeWidth: 2,
                  ),
                )
              : Text(label, style: _textoCapsModal(10, foregroundColor)),
        ),
      ),
    ),
  );
}
