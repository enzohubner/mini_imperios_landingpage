import 'package:flutter/material.dart';

mixin CoresMixin {
  static const Color corAzulMarinho = Color(0xFF1A2744);
  static const Color corVerdeImperial = Color(0xFF1C3A2A);
  static const Color corBordo = Color(0xFF6B1020);
  static const Color corDouradaPrimaria = Color(0xFFC9A84C);
  static const Color corDouradaClara = Color(0xFFE8C878);
  static const Color corMarfim = Color(0xFFF5F0E8);
  static const Color corFundoPrincipal = Color(0xFFFDFAF4);
  static const Color corAreia = Color(0xFFE8E0CC);
  static const Color corTextoPrincipal = Color(0xFF12100A);
  static const Color corTextoSuave = Color(0xFF6A5E42);
  static const Color corBorda = Color(0xFFCEC3A0);
  static const Color corMarromNavegacoes = Color(0xFF7A5C14);
  static const Color corSucessoSuave = Color(0xFFECF3EC);
  static const Color corErroSuave = Color(0xFFF8ECEC);

  Color get corPrimariaApp => corDouradaPrimaria;
  Color get corPrimariaClaraApp => corDouradaClara;
  Color get corSecundariaApp => corVerdeImperial;
  Color get corDestaqueApp => corBordo;
  Color get corCabecalhoApp => corPrimariaApp;
  Color get corCabecalhoModal => corPrimariaApp;
  Color get corFundoApp => corFundoPrincipal;
  Color get corSuperficieApp => corMarfim;
  Color get corTextoApp => corTextoPrincipal;
  Color get corTextoSecundarioApp => corTextoSuave;
  Color get corBordaApp => corBorda;

  double get raioModalApp => 22.0;
}
