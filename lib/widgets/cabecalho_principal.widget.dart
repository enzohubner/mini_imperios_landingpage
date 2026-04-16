import 'package:flutter/material.dart';

import '../mixins/cores.mixin.dart';

TextStyle _textoSerifCabecalho(
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

TextStyle _textoCapsCabecalho(
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

class CabecalhoPrincipalWidget extends StatelessWidget with CoresMixin {
  final VoidCallback aoClicarEntrar;
  final VoidCallback aoClicarCadastrar;
  final VoidCallback aoClicarComoFunciona;
  final VoidCallback aoClicarBoxes;
  final VoidCallback aoClicarPais;

  const CabecalhoPrincipalWidget({
    super.key,
    required this.aoClicarEntrar,
    required this.aoClicarCadastrar,
    required this.aoClicarComoFunciona,
    required this.aoClicarBoxes,
    required this.aoClicarPais,
  });

  @override
  Widget build(BuildContext context) => Container(
    color: corCabecalhoApp,
    padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 14),
    child: Row(
      children: [
        SizedBox(
          height: 34,
          child: Image.asset('lib/logo/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 20),
        _LinkCabecalhoWidget('O Clube', aoClicarComoFunciona),
        const SizedBox(width: 30),
        _LinkCabecalhoWidget('Box de Estudo', aoClicarBoxes),
        const SizedBox(width: 30),
        _LinkCabecalhoWidget('Para Pais', aoClicarPais),
        const SizedBox(width: 30),
        _LinkCabecalhoWidget('Como Funciona', aoClicarComoFunciona),
        const Spacer(),
        _BotaoSecundarioCabecalhoWidget('LOGIN', aoClicarEntrar),
        const SizedBox(width: 12),
        _BotaoPrimarioCabecalhoWidget('FAÇA PARTE', aoClicarCadastrar),
      ],
    ),
  );
}

class _LinkCabecalhoWidget extends StatefulWidget {
  final String texto;
  final VoidCallback aoClicar;

  const _LinkCabecalhoWidget(this.texto, this.aoClicar);

  @override
  State<_LinkCabecalhoWidget> createState() => _LinkCabecalhoWidgetState();
}

class _LinkCabecalhoWidgetState extends State<_LinkCabecalhoWidget>
    with CoresMixin {
  bool _estaComHover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _estaComHover = true),
    onExit: (_) => setState(() => _estaComHover = false),
    child: GestureDetector(
      onTap: widget.aoClicar,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: _textoSerifCabecalho(
          12,
          _estaComHover ? corSecundariaApp : corTextoApp,
          peso: FontWeight.w600,
          altura: 1,
        ),
        child: Text(widget.texto),
      ),
    ),
  );
}

class _BotaoSecundarioCabecalhoWidget extends StatefulWidget {
  final String texto;
  final VoidCallback aoClicar;

  const _BotaoSecundarioCabecalhoWidget(this.texto, this.aoClicar);

  @override
  State<_BotaoSecundarioCabecalhoWidget> createState() =>
      _BotaoSecundarioCabecalhoWidgetState();
}

class _BotaoSecundarioCabecalhoWidgetState
    extends State<_BotaoSecundarioCabecalhoWidget>
    with CoresMixin {
  bool _estaComHover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _estaComHover = true),
    onExit: (_) => setState(() => _estaComHover = false),
    child: GestureDetector(
      onTap: widget.aoClicar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _estaComHover
                ? corSecundariaApp
                : corTextoApp.withOpacity(.55),
            width: 1,
          ),
        ),
        child: Text(
          widget.texto,
          style: _textoCapsCabecalho(
            9,
            _estaComHover ? corSecundariaApp : corTextoApp,
            espacamento: 1.4,
          ),
        ),
      ),
    ),
  );
}

class _BotaoPrimarioCabecalhoWidget extends StatefulWidget {
  final String texto;
  final VoidCallback aoClicar;

  const _BotaoPrimarioCabecalhoWidget(this.texto, this.aoClicar);

  @override
  State<_BotaoPrimarioCabecalhoWidget> createState() =>
      _BotaoPrimarioCabecalhoWidgetState();
}

class _BotaoPrimarioCabecalhoWidgetState
    extends State<_BotaoPrimarioCabecalhoWidget>
    with CoresMixin {
  bool _estaComHover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _estaComHover = true),
    onExit: (_) => setState(() => _estaComHover = false),
    child: GestureDetector(
      onTap: widget.aoClicar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _estaComHover ? corPrimariaClaraApp : corPrimariaApp,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          widget.texto,
          style: _textoCapsCabecalho(9, corTextoApp, espacamento: 1.4),
        ),
      ),
    ),
  );
}
