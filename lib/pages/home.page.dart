import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../mixins/cores.mixin.dart';
import '../widgets/cabecalho_principal.widget.dart';
import '../widgets/sistema_modais.widget.dart';

const kHeaderH = 74.0;

// ══════════════════════════════════════════════════════════════
//  TYPE
// ══════════════════════════════════════════════════════════════
TextStyle dsp(double sz, Color c, {bool it = false, double? ls}) => TextStyle(
  fontFamily: 'Georgia',
  fontSize: sz,
  fontWeight: FontWeight.w700,
  color: c,
  height: 1.05,
  letterSpacing: ls ?? (sz > 40 ? -1.5 : -.3),
  fontStyle: it ? FontStyle.italic : FontStyle.normal,
);
TextStyle serif(
  double sz,
  Color c, {
  FontWeight w = FontWeight.w400,
  double h = 1.75,
}) => TextStyle(
  fontFamily: 'Georgia',
  fontSize: sz,
  fontWeight: w,
  color: c,
  height: h,
);
TextStyle caps(double sz, Color c, {double ls = 3.0}) => TextStyle(
  fontFamily: 'Georgia',
  fontSize: sz,
  fontWeight: FontWeight.w600,
  color: c,
  letterSpacing: ls,
  height: 1,
);

// ══════════════════════════════════════════════════════════════
//  APP
// ══════════════════════════════════════════════════════════════
class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Mini Impérios',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: CoresMixin.corFundoPrincipal,
    ),
    home: const _Root(),
  );
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> with TickerProviderStateMixin {
  late final AnimationController _in, _float, _tape, _crest, _stars;
  bool _mLogin = false, _mSignup = false, _mStore = false, _mQuiz = false;
  final _kHow = GlobalKey(), _kBoxes = GlobalKey(), _kPais = GlobalKey();

  @override
  void initState() {
    super.initState();
    _in = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _tape = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
    _crest = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _stars = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _in.dispose();
    _float.dispose();
    _tape.dispose();
    _crest.dispose();
    _stars.dispose();
    super.dispose();
  }

  void _to(GlobalKey k) {
    final ctx = k.currentContext;
    if (ctx != null)
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut,
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CoresMixin.corFundoPrincipal,
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              CabecalhoPrincipalWidget(
                aoClicarEntrar: () => setState(() => _mLogin = true),
                aoClicarCadastrar: () => setState(() => _mSignup = true),
                aoClicarComoFunciona: () => _to(_kHow),
                aoClicarBoxes: () => _to(_kBoxes),
                aoClicarPais: () => _to(_kPais),
              ),
              _Hero(
                ctrlIn: _in,
                ctrlFloat: _float,
                ctrlTape: _tape,
                ctrlCrest: _crest,
                onExplore: () => setState(() => _mStore = true),
                onQuiz: () => setState(() => _mQuiz = true),
              ),
              _HowSection(key: _kHow, ctrlStars: _stars),
              _BoxesSection(
                key: _kBoxes,
                onBuy: () => setState(() => _mStore = true),
              ),
              _ParentsSection(
                key: _kPais,
                onSignup: () => setState(() => _mSignup = true),
              ),
              const _DepoimentosSection(),
              const _EntregaBonusSection(),
              _InvestimentoFaqSection(
                onBuy: () => setState(() => _mStore = true),
                onSignup: () => setState(() => _mSignup = true),
              ),
              _CtaSection(onSignup: () => setState(() => _mSignup = true)),
              const _Footer(),
            ],
          ),
        ),
        if (_mLogin)
          SobreposicaoModalWidget(
            child: _LoginModal(
              onClose: () => setState(() => _mLogin = false),
              toSignup: () => setState(() {
                _mLogin = false;
                _mSignup = true;
              }),
            ),
          ),
        if (_mSignup)
          SobreposicaoModalWidget(
            child: _SignupModal(
              onClose: () => setState(() => _mSignup = false),
              toLogin: () => setState(() {
                _mSignup = false;
                _mLogin = true;
              }),
            ),
          ),
        if (_mStore)
          SobreposicaoModalWidget(
            child: _StoreModal(onClose: () => setState(() => _mStore = false)),
          ),
        if (_mQuiz)
          SobreposicaoModalWidget(
            child: _QuizModal(onClose: () => setState(() => _mQuiz = false)),
          ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  HERO — ivory bg, large imperial title, mascot in heraldic frame
//  Animated: Latin tape scrolling + crest breathing + float
// ══════════════════════════════════════════════════════════════
class _Hero extends StatelessWidget {
  final AnimationController ctrlIn, ctrlFloat, ctrlTape, ctrlCrest;
  final VoidCallback onExplore, onQuiz;
  const _Hero({
    required this.ctrlIn,
    required this.ctrlFloat,
    required this.ctrlTape,
    required this.ctrlCrest,
    required this.onExplore,
    required this.onQuiz,
  });

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corVerdeImperial,
    constraints: BoxConstraints(
      minHeight: math.max(560, MediaQuery.of(context).size.height - kHeaderH),
    ),
    child: Stack(
      children: [
        // Subtle crosshatch on green — imperial feel
        Positioned.fill(child: CustomPaint(painter: _ParchmentGrid())),
        Column(
          children: [
            // Main hero content
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 72, 60, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Left: mascot ─────────────────────────
                  Expanded(
                    flex: 8,
                    child: AnimatedBuilder(
                      animation: ctrlFloat,
                      builder: (_, child) {
                        final sway =
                            math.sin(ctrlFloat.value * math.pi * 2) * 2.0;
                        final tilt =
                            math.sin(ctrlFloat.value * math.pi * 2) * 0.018;
                        return Transform.translate(
                          offset: Offset(0, sway),
                          child: Transform.rotate(angle: tilt, child: child),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: ctrlIn,
                        builder: (_, child) {
                          final t = CurvedAnimation(
                            parent: ctrlIn,
                            curve: const Interval(
                              .18,
                              1,
                              curve: Curves.easeOutBack,
                            ),
                          ).value;
                          return Opacity(
                            opacity: t.clamp(0, 1.0),
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - t)),
                              child: Transform.scale(
                                scale: .9 + .1 * t,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: _MascotFrame(ctrlCrest: ctrlCrest),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // ── Right text ────────────────────────────
                  Expanded(
                    flex: 11,
                    child: AnimatedBuilder(
                      animation: ctrlIn,
                      builder: (_, child) {
                        final t = CurvedAnimation(
                          parent: ctrlIn,
                          curve: Curves.easeOut,
                        ).value;
                        return Opacity(
                          opacity: t.clamp(0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 28 * (1 - t)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 1.5,
                                color: CoresMixin.corDouradaPrimaria,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'PLATAFORMA EDUCACIONAL INFANTIL',
                                style: caps(9, CoresMixin.corDouradaPrimaria),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Text(
                            'Os grandes\nperíodos da\nhistória,',
                            style: dsp(66, CoresMixin.corDouradaPrimaria),
                          ),
                          Text(
                            'do jeito que\ncriança ama.',
                            style: dsp(
                              66,
                              CoresMixin.corDouradaClara,
                              it: true,
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: 420,
                            child: Text(
                              'Livros ilustrados, quizzes e aventuras históricas para crianças de 3 a 11 anos — com os pais ao lado.',
                              style: serif(16, CoresMixin.corTextoSuave),
                            ),
                          ),
                          const SizedBox(height: 44),
                          Row(
                            children: [
                              _HBtn(
                                'EXPLORAR OS BOX',
                                CoresMixin.corDouradaPrimaria,
                                CoresMixin.corVerdeImperial,
                                onExplore,
                              ),
                              const SizedBox(width: 14),
                              _HBtn(
                                'JOGAR UM QUIZ',
                                Colors.transparent,
                                Colors.white,
                                onQuiz,
                                ghost: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 52),
                          Row(
                            children: [
                              _Stat('3–11', 'anos de idade'),
                              _StatDiv(),
                              _Stat('12+', 'box de estudo'),
                              _StatDiv(),
                              _Stat('100%', 'seguro LGPD'),
                              _StatDiv(),
                              _Stat('Web · iOS · Android', 'plataformas'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // ── Latin tape ──────────────────────────────────
            _LatinTape(ctrl: ctrlTape),
          ],
        ),
      ],
    ),
  );
}

class _HBtn extends StatefulWidget {
  final String l;
  final Color bg, fg;
  final VoidCallback cb;
  final bool ghost;
  const _HBtn(this.l, this.bg, this.fg, this.cb, {this.ghost = false});
  @override
  State<_HBtn> createState() => _HBtnSt();
}

class _HBtnSt extends State<_HBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.cb,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          color: widget.ghost
              ? Colors.transparent
              : (_h ? CoresMixin.corDouradaClara : widget.bg),
          border: widget.ghost
              ? Border.all(
                  color: _h ? CoresMixin.corDouradaClara : Colors.white70,
                  width: 1.5,
                )
              : null,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          widget.l,
          style: caps(
            10,
            widget.ghost
                ? (_h ? CoresMixin.corDouradaClara : Colors.white)
                : CoresMixin.corVerdeImperial,
          ),
        ),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  final String v, l;
  const _Stat(this.v, this.l);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        v,
        style: serif(
          14,
          CoresMixin.corDouradaClara,
          w: FontWeight.w700,
          h: 1.2,
        ),
      ),
      const SizedBox(height: 2),
      Text(l, style: serif(11, CoresMixin.corTextoSuave, h: 1)),
    ],
  );
}

class _StatDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    color: CoresMixin.corDouradaPrimaria.withOpacity(.6),
  );
}

// ── Mascot frame with animated crest glow ──────────────────
class _MascotFrame extends StatelessWidget {
  final AnimationController ctrlCrest;
  const _MascotFrame({required this.ctrlCrest});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 500,
    child: Center(
      child: SizedBox(
        width: 280,
        height: 420,
        child: Image.asset('lib/logo/alex_personagem.png', fit: BoxFit.contain),
      ),
    ),
  );
}

// ── Latin tape ──────────────────────────────────────────────
class _LatinTape extends StatelessWidget {
  final AnimationController ctrl;
  const _LatinTape({required this.ctrl});
  static const _t =
      '  HISTORIA MAGISTRA VITAE  ·  VENI VIDI VICI  ·  CARPE DIEM  ·  ARS LONGA VITA BREVIS  ·  FORTES FORTUNA ADIUVAT  ·  IN HOC SIGNO VINCES  ·  ALEA IACTA EST  ·  ';
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: ctrl,
    builder: (_, __) => ClipRect(
      child: Container(
        color: CoresMixin.corVerdeImperial,
        height: 32,
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: double.infinity,
          child: Transform.translate(
            offset: Offset(-ctrl.value * 900, 0),
            child: Row(
              children: List.generate(
                6,
                (_) => Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    _t,
                    style: caps(
                      9,
                      CoresMixin.corDouradaPrimaria.withOpacity(.7),
                      ls: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  HOW IT WORKS — warm white, animated roman numeral reveal
// ══════════════════════════════════════════════════════════════
class _HowSection extends StatelessWidget {
  final AnimationController ctrlStars;
  const _HowSection({super.key, required this.ctrlStars});

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corFundoPrincipal,
    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 1.5,
              color: CoresMixin.corDouradaPrimaria,
            ),
            const SizedBox(width: 14),
            Text(
              'COMO FUNCIONA',
              style: caps(10, CoresMixin.corDouradaPrimaria),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simples\npara os pais.',
                    style: dsp(48, CoresMixin.corVerdeImperial),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Inesquecível\npara os filhos.',
                    style: dsp(48, CoresMixin.corTextoSuave, it: true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Cada box cobre um período histórico completo — do Egito Antigo às Grandes Navegações — com materiais ilustrados, jogos e atividades calibradas para a faixa etária.',
                  style: serif(16, CoresMixin.corTextoSuave),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        // Steps — with animated star next to active one
        _StepRow(
          'I',
          'Escolha um Box',
          'O responsável navega pela loja e adquire o box do período que mais desperta curiosidade na criança.',
          ctrlStars,
          0,
        ),
        Container(height: 1, color: CoresMixin.corBorda),
        _StepRow(
          'II',
          'Leia e Explore',
          'A criança mergulha em materiais ilustrados e interativos, ambientada em cada civilização histórica.',
          ctrlStars,
          1,
        ),
        Container(height: 1, color: CoresMixin.corBorda),
        _StepRow(
          'III',
          'Teste o Conhecimento',
          'Quizzes e desafios desbloqueiam conquistas. O progresso fica visível para os pais em tempo real.',
          ctrlStars,
          2,
        ),
      ],
    ),
  );
}

class _StepRow extends StatefulWidget with CoresMixin {
  final String n, title, body;
  final AnimationController ctrl;
  final int idx;
  const _StepRow(this.n, this.title, this.body, this.ctrl, this.idx);

  @override
  State<_StepRow> createState() => _StepRowState();
}

class _StepRowState extends State<_StepRow> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 36),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Roman numeral with animated gold shimmer
        SizedBox(
          width: 72,
          child: AnimatedBuilder(
            animation: widget.ctrl,
            builder: (_, __) {
              final phase = (widget.ctrl.value + widget.idx * 0.33) % 1.0;
              final op = .15 + .2 * math.sin(phase * math.pi * 2).abs();
              return Text(
                widget.n,
                style: dsp(
                  48,
                  CoresMixin.corDouradaPrimaria.withOpacity(op + .1),
                  it: true,
                  ls: -2,
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: serif(
                  18,
                  CoresMixin.corVerdeImperial,
                  w: FontWeight.w700,
                  h: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: Text(widget.body, style: serif(14, CoresMixin.corTextoSuave)),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  BOXES SECTION — ivory, hover animation on cards
// ══════════════════════════════════════════════════════════════
class _BoxesSection extends StatelessWidget {
  final VoidCallback onBuy;
  const _BoxesSection({super.key, required this.onBuy});

  static const _items = [
    _BD(
      'Egito\nAntigo',
      CoresMixin.corBordo,
      '6–9 anos',
      'Faraós, pirâmides e os mistérios do Nilo.',
      'I',
    ),
    _BD(
      'Grécia\n& Roma',
      CoresMixin.corAzulMarinho,
      '8–11 anos',
      'Deuses, filósofos e a fundação do Ocidente.',
      'II',
    ),
    _BD(
      'Idade\nMédia',
      CoresMixin.corVerdeImperial,
      '7–10 anos',
      'Castelos, cavaleiros e a era das catedrais.',
      'III',
    ),
    _BD(
      'Grandes\nNavegações',
      Color(0xFF7A5C14),
      '9–11 anos',
      'O mundo se expande além do horizonte.',
      'IV',
    ),
  ];

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corMarfim,
    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 1.5,
                      color: CoresMixin.corDouradaPrimaria,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'OS BOX DE ESTUDO',
                      style: caps(10, CoresMixin.corDouradaPrimaria),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Doze séculos\nde história.',
                  style: dsp(50, CoresMixin.corVerdeImperial),
                ),
                Text(
                  'Cada um em seu box.',
                  style: dsp(38, CoresMixin.corDouradaPrimaria, it: true),
                ),
              ],
            ),
            GestureDetector(
              onTap: onBuy,
              child: Text(
                'Ver catálogo →',
                style:
                    serif(
                      13,
                      CoresMixin.corDouradaPrimaria,
                      w: FontWeight.w500,
                      h: 1,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: CoresMixin.corDouradaPrimaria,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 64),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _items
              .map(
                (d) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: _items.indexOf(d) < _items.length - 1 ? 22 : 0,
                    ),
                    child: _BoxCard(data: d, onBuy: onBuy),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 60),
        Center(
          child: _Btn(
            'ADQUIRIR UM BOX',
            CoresMixin.corDouradaPrimaria,
            CoresMixin.corVerdeImperial,
            onBuy,
          ),
        ),
      ],
    ),
  );
}

class _BD {
  final String title;
  final Color c;
  final String age, blurb, roman;
  const _BD(this.title, this.c, this.age, this.blurb, this.roman);
}

class _BoxCard extends StatefulWidget {
  final _BD data;
  final VoidCallback onBuy;
  const _BoxCard({required this.data, required this.onBuy});
  @override
  State<_BoxCard> createState() => _BCState();
}

class _BCState extends State<_BoxCard> with SingleTickerProviderStateMixin {
  bool _h = false;
  late final AnimationController _ripple;

  @override
  void initState() {
    super.initState();
    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) {
      setState(() => _h = true);
      _ripple.forward(from: 0);
    },
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onBuy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.identity()..translate(0.0, _h ? -6.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover with book-cloth texture + ripple animation on hover
            Stack(
              children: [
                Container(
                  height: 196,
                  width: double.infinity,
                  color: widget.data.c,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _BookCloth(widget.data.c)),
                      ),
                      // Roman numeral watermark
                      Positioned(
                        bottom: -14,
                        right: 6,
                        child: Text(
                          widget.data.roman,
                          style: dsp(96, Colors.white.withOpacity(.07), ls: -6),
                        ),
                      ),
                      // Age chip
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          color: Colors.black.withOpacity(.22),
                          child: Text(
                            widget.data.age,
                            style: caps(8, Colors.white.withOpacity(.9)),
                          ),
                        ),
                      ),
                      // Gold top rule
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          color: CoresMixin.corDouradaPrimaria.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated shimmer on hover
                if (_h)
                  AnimatedBuilder(
                    animation: _ripple,
                    builder: (_, __) => Positioned.fill(
                      child: CustomPaint(
                        painter: _ShimmerPainter(_ripple.value, widget.data.c),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.data.title,
              style: dsp(
                20,
                CoresMixin.corAzulMarinho,
                ls: -.3,
              ).copyWith(height: 1.2),
            ),
            const SizedBox(height: 7),
            Text(
              widget.data.blurb,
              style: serif(13, CoresMixin.corTextoSuave, h: 1.6),
            ),
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: serif(
                12,
                _h ? widget.data.c : CoresMixin.corTextoSuave,
                w: FontWeight.w600,
                h: 1,
              ),
              child: const Text('Explorar →'),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  PARENTS SECTION — warm white
// ══════════════════════════════════════════════════════════════
class _ParentsSection extends StatelessWidget {
  final VoidCallback onSignup;
  const _ParentsSection({super.key, required this.onSignup});
  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corDouradaPrimaria,
    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 1.5,
                    color: CoresMixin.corMarfim,
                  ),
                  const SizedBox(width: 14),
                  Text('PARA OS PAIS', style: caps(10, CoresMixin.corMarfim)),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                'Acompanhe\ncada passo\nda jornada.',
                style: dsp(46, CoresMixin.corVerdeImperial),
              ),
              const SizedBox(height: 28),
              Text(
                'Criamos uma experiencia historica com narrativa forte, visual premium e metodo simples para gerar aprendizado real em casa.',
                style: serif(15, CoresMixin.corVerdeImperial, h: 1.7),
              ),
              const SizedBox(height: 14),
              Text(
                'O painel dos responsáveis exibe o progresso individual de cada filho — atividades concluídas, conquistas e materiais ainda por explorar.',
                style: serif(15, CoresMixin.corVerdeImperial, h: 1.7),
              ),
              const SizedBox(height: 14),
              Text(
                'Oferecemos guias pedagógicos para que você possa orientar e aprender junto com a criança.',
                style: serif(15, CoresMixin.corVerdeImperial, h: 1.7),
              ),
              const SizedBox(height: 44),
              _Btn(
                'CRIAR CONTA DE RESPONSÁVEL',
                CoresMixin.corVerdeImperial,
                CoresMixin.corMarfim,
                onSignup,
              ),
            ],
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 72),
              _Feat(
                'Perfil separado por filho',
                'Progresso exclusivo e independente para cada criança.',
              ),
              _FDiv(),
              _Feat(
                'Relatório de progresso',
                'Atividades, tempo de estudo e pontuação em tempo real.',
              ),
              _FDiv(),
              _Feat(
                'Materiais de apoio para pais',
                'Conteúdo pedagógico para orientar os estudos em casa.',
              ),
              _FDiv(),
              _Feat(
                'Conformidade com a LGPD',
                'Dados de menores criptografados e sob seu controle.',
              ),
              _FDiv(),
              _Feat(
                'Funciona offline',
                'Atividades baixadas ficam disponíveis sem internet.',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Feat extends StatelessWidget {
  final String t, b;
  const _Feat(this.t, this.b);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 9, right: 18),
          child: Container(width: 5, height: 5, color: CoresMixin.corMarfim),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t,
                style: serif(
                  15,
                  CoresMixin.corVerdeImperial,
                  w: FontWeight.w700,
                  h: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(b, style: serif(13, CoresMixin.corVerdeImperial, h: 1.7)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FDiv extends StatelessWidget {
  @override
  Widget build(BuildContext c) =>
      Container(height: 1, color: CoresMixin.corVerdeImperial.withOpacity(.35));
}

class _DepoimentosSection extends StatelessWidget {
  const _DepoimentosSection();

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corFundoPrincipal,
    padding: const EdgeInsets.fromLTRB(60, 100, 60, 60),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 1.5,
              color: CoresMixin.corDouradaPrimaria,
            ),
            const SizedBox(width: 14),
            Text('DEPOIMENTOS', style: caps(10, CoresMixin.corDouradaPrimaria)),
          ],
        ),
        const SizedBox(height: 34),
        Text('Famílias que já viveram essa jornada.', style: dsp(44, CoresMixin.corVerdeImperial)),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: _ProofCard(
                '"Meu filho pediu para repetir o quiz de Roma no mesmo dia. Aprendeu brincando e ficou orgulhoso das conquistas."',
                'Ana Paula, mãe do Theo (8 anos)',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _ProofCard(
                '"O material vem pronto e organizado. Em poucos minutos já começamos a atividade sem estresse."',
                'Rafael, pai da Luna (6 anos)',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _ProofCard(
                '"Acompanhamos evolução real: leitura, curiosidade histórica e mais autonomia nos estudos."',
                'Fernanda, mãe do Davi (10 anos)',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _EntregaBonusSection extends StatelessWidget {
  const _EntregaBonusSection();

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corMarfim,
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 1.5,
              color: CoresMixin.corDouradaPrimaria,
            ),
            const SizedBox(width: 14),
            Text(
              'ENTREGA E BONUS',
              style: caps(10, CoresMixin.corDouradaPrimaria),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text('Como funciona a entrega', style: serif(30, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.2)),
        const SizedBox(height: 12),
        const _DeliveryLine(
          '1. Escolha do box e faixa etária',
          'Você seleciona o período histórico e recebe uma trilha adequada para a idade.',
        ),
        const _DeliveryLine(
          '2. Conteúdo + atividade prática',
          'Cada etapa combina leitura ilustrada, desafios e quiz para fixar o aprendizado.',
        ),
        const _DeliveryLine(
          '3. Acompanhamento dos pais',
          'O progresso aparece no painel com conquistas, pontos e próximos passos.',
        ),
        const SizedBox(height: 26),
        Text('Bônus para a família', style: serif(30, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.2)),
        const SizedBox(height: 10),
        Text(
          'Guia rápido para os responsáveis + calendário de estudos semanal + desafios extras para imprimir em casa.',
          style: serif(14, CoresMixin.corTextoSuave, h: 1.7),
        ),
      ],
    ),
  );
}

class _InvestimentoFaqSection extends StatelessWidget {
  final VoidCallback onBuy;
  final VoidCallback onSignup;
  const _InvestimentoFaqSection({required this.onBuy, required this.onSignup});

  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corFundoPrincipal,
    padding: const EdgeInsets.fromLTRB(60, 80, 60, 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 1.5,
              color: CoresMixin.corDouradaPrimaria,
            ),
            const SizedBox(width: 14),
            Text('INVESTIMENTO E PERGUNTAS', style: caps(10, CoresMixin.corDouradaPrimaria)),
          ],
        ),
        const SizedBox(height: 30),
        Text('Investimento', style: serif(30, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.2)),
        const SizedBox(height: 10),
        Text(
          'Assinatura a partir de R\$ 49,90 por box, com acesso imediato ao conteúdo e quizzes interativos.',
          style: serif(14, CoresMixin.corTextoSuave, h: 1.7),
        ),
        const SizedBox(height: 18),
        _Btn(
          'VER PLANOS E BOX',
          CoresMixin.corDouradaPrimaria,
          CoresMixin.corVerdeImperial,
          onBuy,
        ),
        const SizedBox(height: 34),
        Text('Perguntas frequentes', style: serif(30, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.2)),
        const SizedBox(height: 10),
        const _FaqLine('Qual idade recomendada?', 'De 3 a 11 anos, com trilhas separadas por faixa etária.'),
        const _FaqLine('Precisa de conhecimento prévio?', 'Não. O conteúdo começa do básico e evolui passo a passo.'),
        const _FaqLine('Os pais acompanham o progresso?', 'Sim. Existe painel com atividades concluídas e desempenho no quiz.'),
        const SizedBox(height: 20),
        Text(
          'Links importantes: Política de Privacidade · Termos · Contato',
          style: serif(13, CoresMixin.corTextoSuave, h: 1.4),
        ),
        const SizedBox(height: 18),
        _Btn(
          'FALAR COM A EQUIPE',
          CoresMixin.corVerdeImperial,
          CoresMixin.corMarfim,
          onSignup,
        ),
      ],
    ),
  );
}

class _DeliveryLine extends StatelessWidget {
  final String title;
  final String body;
  const _DeliveryLine(this.title, this.body);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: RichText(
      text: TextSpan(
        style: serif(14, CoresMixin.corTextoSuave, h: 1.6),
        children: [
          TextSpan(
            text: '$title. ',
            style: serif(14, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.6),
          ),
          TextSpan(text: body),
        ],
      ),
    ),
  );
}

class _ProofCard extends StatelessWidget {
  final String quote;
  final String author;
  const _ProofCard(this.quote, this.author);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: CoresMixin.corBorda),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(quote, style: serif(13, CoresMixin.corAzulMarinho, w: FontWeight.w600, h: 1.5)),
        const SizedBox(height: 8),
        Text(author, style: serif(12, CoresMixin.corTextoSuave, h: 1)),
      ],
    ),
  );
}

class _FaqLine extends StatelessWidget {
  final String q;
  final String a;
  const _FaqLine(this.q, this.a);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: serif(13, CoresMixin.corTextoSuave, h: 1.6),
        children: [
          TextSpan(
            text: '$q ',
            style: serif(13, CoresMixin.corAzulMarinho, w: FontWeight.w700, h: 1.6),
          ),
          TextSpan(text: a),
        ],
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  CTA — navy background (single use of dark, impactful)
// ══════════════════════════════════════════════════════════════
class _CtaSection extends StatelessWidget {
  final VoidCallback onSignup;
  const _CtaSection({required this.onSignup});
  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corVerdeImperial,
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 88),
    child: Stack(
      children: [
        // Faint crosshatch on navy
        Positioned.fill(child: CustomPaint(painter: _NavyGrid())),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 1.5,
                      color: CoresMixin.corDouradaPrimaria,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'COMECE HOJE',
                      style: caps(10, CoresMixin.corDouradaPrimaria),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text('A história\ncomeça aqui.', style: dsp(54, Colors.white)),
                Text(
                  'E em família.',
                  style: dsp(54, CoresMixin.corDouradaClara, it: true),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 320,
                  child: Text(
                    'Crie sua conta gratuitamente e explore o primeiro box sem pagar nada. Sem cartão de crédito.',
                    textAlign: TextAlign.right,
                    style: serif(15, Colors.white.withOpacity(.6)),
                  ),
                ),
                const SizedBox(height: 36),
                _Btn(
                  'COMEÇAR GRATUITAMENTE',
                  CoresMixin.corDouradaPrimaria,
                  CoresMixin.corVerdeImperial,
                  onSignup,
                ),
                const SizedBox(height: 10),
                Text(
                  'Sem cartão de crédito.',
                  style: serif(12, Colors.white.withOpacity(.35)),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  FOOTER — ivory
// ══════════════════════════════════════════════════════════════
class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) => Container(
    color: CoresMixin.corVerdeImperial,
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 36),
    child: Column(
      children: [
        Container(
          height: 1,
          color: CoresMixin.corDouradaPrimaria.withOpacity(.45),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('lib/logo/logo.png', height: 28, fit: BoxFit.contain),
            Text(
              '© 2026 Mini Impérios · Todos os direitos reservados.',
              style: serif(11, Colors.white.withOpacity(.78)),
            ),
            Row(
              children: [
                _FL('Privacidade'),
                const SizedBox(width: 24),
                _FL('Termos'),
                const SizedBox(width: 24),
                _FL('Contato'),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class _FL extends StatelessWidget {
  final String t;
  const _FL(this.t);
  @override
  Widget build(BuildContext context) => Text(
    t,
    style: serif(11, CoresMixin.corDouradaClara.withOpacity(.9), h: 1),
  );
}

// ══════════════════════════════════════════════════════════════
//  SHARED BUTTON
// ══════════════════════════════════════════════════════════════
class _Btn extends StatefulWidget {
  final String l;
  final Color bg, fg;
  final VoidCallback cb;
  const _Btn(this.l, this.bg, this.fg, this.cb);
  @override
  State<_Btn> createState() => _BtnSt();
}

class _BtnSt extends State<_Btn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.cb,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: _h ? widget.bg.withOpacity(.8) : widget.bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(widget.l, style: caps(10, widget.fg)),
      ),
    ),
  );
}

// ── Login ──────────────────────────────────────────────────
class _LoginModal extends StatefulWidget {
  final VoidCallback onClose, toSignup;
  const _LoginModal({required this.onClose, required this.toSignup});
  @override
  State<_LoginModal> createState() => _LMSt();
}

class _LMSt extends State<_LoginModal> {
  final _e = TextEditingController(), _p = TextEditingController();
  bool _loading = false;
  String? _err;
  void _go() {
    if (_e.text.isEmpty || _p.text.isEmpty) {
      setState(() => _err = 'Preencha e-mail e senha.');
      return;
    }
    setState(() => _loading = true);
    Future.delayed(
      const Duration(milliseconds: 1100),
      () => mounted
          ? setState(() {
              _loading = false;
              _err = 'Credenciais inválidas. Tente criar uma conta.';
            })
          : {},
    );
  }

  @override
  Widget build(BuildContext context) => CartaoModalWidget(
    title: 'Entrar',
    accent: CoresMixin.corBordo,
    onClose: widget.onClose,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CampoTextoModalWidget('E-mail', controller: _e),
        const SizedBox(height: 18),
        CampoTextoModalWidget('Senha', obscureText: true, controller: _p),
        if (_err != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            color: CoresMixin.corBordo.withOpacity(.07),
            child: Text(_err!, style: serif(13, CoresMixin.corBordo, h: 1.4)),
          ),
        ],
        const SizedBox(height: 28),
        BotaoAcaoModalWidget(
          'ENTRAR',
          backgroundColor: CoresMixin.corBordo,
          foregroundColor: Colors.white,
          onTap: _loading ? null : _go,
          loading: _loading,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Não tem conta? ', style: serif(13, CoresMixin.corTextoSuave)),
            GestureDetector(
              onTap: widget.toSignup,
              child: Text(
                'Criar agora',
                style: serif(13, CoresMixin.corBordo).copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: CoresMixin.corBordo,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// ── Signup ─────────────────────────────────────────────────
class _SignupModal extends StatefulWidget {
  final VoidCallback onClose, toLogin;
  const _SignupModal({required this.onClose, required this.toLogin});
  @override
  State<_SignupModal> createState() => _SMSt();
}

class _SMSt extends State<_SignupModal> {
  final _n = TextEditingController(),
      _e = TextEditingController(),
      _p = TextEditingController();
  bool _loading = false, _done = false;
  void _go() {
    if (_n.text.isEmpty || _e.text.isEmpty || _p.text.isEmpty) return;
    setState(() => _loading = true);
    Future.delayed(
      const Duration(milliseconds: 1100),
      () => mounted
          ? setState(() {
              _loading = false;
              _done = true;
            })
          : {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_done)
      return CartaoModalWidget(
        title: 'Bem-vindo!',
        accent: CoresMixin.corDouradaPrimaria,
        onClose: widget.onClose,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: CoresMixin.corDouradaPrimaria,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: CoresMixin.corDouradaPrimaria,
                size: 26,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bem-vindo, ${_n.text}!',
              style: serif(
                20,
                CoresMixin.corAzulMarinho,
                w: FontWeight.w700,
                h: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Explore os box e comece a aventura histórica.',
              style: serif(14, CoresMixin.corTextoSuave),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            BotaoAcaoModalWidget(
              'EXPLORAR OS BOX',
              backgroundColor: CoresMixin.corBordo,
              foregroundColor: Colors.white,
              onTap: widget.onClose,
            ),
          ],
        ),
      );
    return CartaoModalWidget(
      title: 'Criar Conta',
      accent: CoresMixin.corDouradaPrimaria,
      onClose: widget.onClose,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CampoTextoModalWidget('Nome completo', controller: _n),
          const SizedBox(height: 16),
          CampoTextoModalWidget('E-mail', controller: _e),
          const SizedBox(height: 16),
          CampoTextoModalWidget('Senha', obscureText: true, controller: _p),
          const SizedBox(height: 28),
          BotaoAcaoModalWidget(
            'CRIAR CONTA',
            backgroundColor: CoresMixin.corDouradaPrimaria,
            foregroundColor: CoresMixin.corAzulMarinho,
            onTap: _loading ? null : _go,
            loading: _loading,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Já tem conta? ',
                style: serif(13, CoresMixin.corTextoSuave),
              ),
              GestureDetector(
                onTap: widget.toLogin,
                child: Text(
                  'Entrar',
                  style: serif(13, CoresMixin.corDouradaPrimaria).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: CoresMixin.corDouradaPrimaria,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Store ───────────────────────────────────────────────────
class _StoreModal extends StatefulWidget {
  final VoidCallback onClose;
  const _StoreModal({required this.onClose});
  @override
  State<_StoreModal> createState() => _StSt();
}

class _StSt extends State<_StoreModal> {
  int? _sel;
  bool _bought = false;
  static const _it = [
    (
      'Egito Antigo',
      CoresMixin.corBordo,
      'R\$ 49,90',
      'Faraós, pirâmides e os mistérios do Nilo.',
    ),
    (
      'Grécia & Roma',
      CoresMixin.corAzulMarinho,
      'R\$ 49,90',
      'Deuses, filósofos e a fundação do Ocidente.',
    ),
    (
      'Idade Média',
      CoresMixin.corVerdeImperial,
      'R\$ 49,90',
      'Castelos, cavaleiros e a era das catedrais.',
    ),
    (
      'Grandes Navegações',
      CoresMixin.corMarromNavegacoes,
      'R\$ 49,90',
      'O mundo se expande além do horizonte.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    if (_bought)
      return CartaoModalWidget(
        title: 'Compra realizada!',
        accent: CoresMixin.corDouradaPrimaria,
        onClose: widget.onClose,
        width: 460,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: CoresMixin.corDouradaPrimaria,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: CoresMixin.corDouradaPrimaria,
                size: 26,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${_it[_sel!].$1} adquirido!',
              style: serif(
                19,
                CoresMixin.corAzulMarinho,
                w: FontWeight.w700,
                h: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Disponível agora na sua conta.',
              style: serif(14, CoresMixin.corTextoSuave),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            BotaoAcaoModalWidget(
              'FECHAR',
              backgroundColor: CoresMixin.corAzulMarinho,
              foregroundColor: CoresMixin.corDouradaPrimaria,
              onTap: widget.onClose,
            ),
          ],
        ),
      );
    return CartaoModalWidget(
      title: 'Loja de Box',
      accent: CoresMixin.corBordo,
      onClose: widget.onClose,
      width: 500,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selecione o box para começar.',
            style: serif(14, CoresMixin.corTextoSuave),
          ),
          const SizedBox(height: 20),
          ...List.generate(_it.length, (i) {
            final (name, col, price, desc) = _it[i];
            final sel = _sel == i;
            return GestureDetector(
              onTap: () => setState(() => _sel = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 130),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: sel ? col.withOpacity(.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? col : CoresMixin.corBorda,
                    width: sel ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: serif(
                              15,
                              CoresMixin.corAzulMarinho,
                              w: FontWeight.w700,
                              h: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            desc,
                            style: serif(12, CoresMixin.corTextoSuave, h: 1.4),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      price,
                      style: serif(15, col, w: FontWeight.w700, h: 1),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          BotaoAcaoModalWidget(
            _sel != null
                ? 'COMPRAR ${_it[_sel!].$1.toUpperCase()}'
                : 'SELECIONE UM BOX',
            backgroundColor: _sel != null
                ? CoresMixin.corBordo
                : CoresMixin.corBorda,
            foregroundColor: _sel != null
                ? Colors.white
                : CoresMixin.corTextoSuave,
            onTap: _sel != null ? () => setState(() => _bought = true) : null,
          ),
        ],
      ),
    );
  }
}

// ── Quiz ────────────────────────────────────────────────────
class _QuizModal extends StatefulWidget {
  final VoidCallback onClose;
  const _QuizModal({required this.onClose});
  @override
  State<_QuizModal> createState() => _QMSt();
}

class _QMSt extends State<_QuizModal> {
  int _q = 0, _score = 0;
  int? _chosen;
  bool _ans = false;
  static const _qs = [
    (
      'Quem ordenou a construção das pirâmides de Gizé?',
      ['Ramsés II', 'Cleópatra', 'Quéops', 'Tutancâmon'],
      2,
    ),
    (
      'Qual filósofo foi mestre de Alexandre, o Grande?',
      ['Platão', 'Sócrates', 'Aristóteles', 'Epicuro'],
      2,
    ),
    (
      'Como eram chamados os guerreiros medievais a cavalo?',
      ['Legionários', 'Centuriões', 'Cavaleiros', 'Arceiros'],
      2,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    if (_q >= _qs.length)
      return CartaoModalWidget(
        title: 'Resultado',
        accent: CoresMixin.corDouradaPrimaria,
        onClose: widget.onClose,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(
                  color: CoresMixin.corDouradaPrimaria,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$_score/${_qs.length}',
                  style: serif(
                    18,
                    CoresMixin.corDouradaPrimaria,
                    w: FontWeight.w700,
                    h: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _score == 3
                  ? 'Excelente! Você domina a história.'
                  : _score >= 2
                  ? 'Muito bem! Continue explorando.'
                  : 'Continue aprendendo!',
              style: serif(
                17,
                CoresMixin.corAzulMarinho,
                w: FontWeight.w600,
                h: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            BotaoAcaoModalWidget(
              'JOGAR NOVAMENTE',
              backgroundColor: CoresMixin.corDouradaPrimaria,
              foregroundColor: CoresMixin.corAzulMarinho,
              onTap: () => setState(() {
                _q = 0;
                _score = 0;
                _chosen = null;
                _ans = false;
              }),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.onClose,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Fechar',
                    style: serif(12, CoresMixin.corTextoSuave),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    final (q, opts, correct) = _qs[_q];
    return CartaoModalWidget(
      title: 'Quiz de História',
      accent: CoresMixin.corBordo,
      onClose: widget.onClose,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              _qs.length,
              (i) => Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  color: i <= _q ? CoresMixin.corBordo : CoresMixin.corBorda,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pergunta ${_q + 1} de ${_qs.length}',
            style: caps(9, CoresMixin.corTextoSuave, ls: 2),
          ),
          const SizedBox(height: 12),
          Text(
            q,
            style: serif(
              17,
              CoresMixin.corAzulMarinho,
              w: FontWeight.w600,
              h: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          ...List.generate(opts.length, (i) {
            Color bg = Colors.white;
            Color tc = CoresMixin.corTextoPrincipal;
            Color bc = CoresMixin.corBorda;
            double bw = 1;
            if (_ans) {
              if (i == correct) {
                bg = CoresMixin.corSucessoSuave;
                tc = CoresMixin.corVerdeImperial;
                bc = CoresMixin.corVerdeImperial;
                bw = 2;
              } else if (i == _chosen) {
                bg = CoresMixin.corErroSuave;
                tc = CoresMixin.corBordo;
                bc = CoresMixin.corBordo;
                bw = 2;
              }
            } else if (_chosen == i) {
              bc = CoresMixin.corDouradaPrimaria;
              bw = 2;
              bg = CoresMixin.corDouradaPrimaria.withOpacity(.05);
            }
            return GestureDetector(
              onTap: () => mounted && !_ans
                  ? setState(() {
                      _chosen = i;
                      _ans = true;
                      if (i == correct) _score++;
                    })
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 130),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.fromBorderSide(
                    BorderSide(color: bc, width: bw),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      child: Text(
                        ['A', 'B', 'C', 'D'][i],
                        style: caps(10, tc, ls: 0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(opts[i], style: serif(14, tc, h: 1.3)),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_ans) ...[
            const SizedBox(height: 16),
            BotaoAcaoModalWidget(
              _q < _qs.length - 1 ? 'PRÓXIMA PERGUNTA' : 'VER RESULTADO',
              backgroundColor: CoresMixin.corBordo,
              foregroundColor: Colors.white,
              onTap: () => setState(() {
                _q++;
                _chosen = null;
                _ans = false;
              }),
            ),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════════════════════

class _ParchmentGrid extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = CoresMixin.corDouradaPrimaria.withOpacity(.04)
      ..strokeWidth = .5;
    for (double x = 0; x < size.width; x += 72)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 72)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _NavyGrid extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(.03)
      ..strokeWidth = .5;
    for (double x = 0; x < size.width; x += 72)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 72)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

// Book cloth texture for covers
class _BookCloth extends CustomPainter {
  final Color base;
  const _BookCloth(this.base);
  @override
  void paint(Canvas canvas, Size size) {
    final h = Paint()
      ..color = Colors.white.withOpacity(.07)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 9)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), h);
    final d = Paint()
      ..color = Colors.black.withOpacity(.06)
      ..strokeWidth = .5;
    for (double x = -size.height; x < size.width + size.height; x += 18)
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), d);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 3),
      Paint()..color = Colors.white.withOpacity(.18),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 4, size.height),
      Paint()..color = Colors.black.withOpacity(.12),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// Shimmer sweep on card hover — lúdic light effect
class _ShimmerPainter extends CustomPainter {
  final double t;
  final Color accent;
  const _ShimmerPainter(this.t, this.accent);
  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final x = t * (size.width + 80) - 40;
    final grad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(.22),
        Colors.white.withOpacity(.32),
        Colors.white.withOpacity(.22),
        Colors.transparent,
      ],
      stops: const [0, .35, .5, .65, 1],
    ).createShader(Rect.fromLTWH(x - 40, 0, 80, size.height));
    canvas.drawRect(
      Rect.fromLTWH(x - 40, 0, 80, size.height),
      Paint()
        ..shader = grad
        ..blendMode = BlendMode.overlay,
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter o) => o.t != t;
}
