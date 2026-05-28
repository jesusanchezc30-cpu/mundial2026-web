import 'package:flutter/material.dart';
import '../translations.dart';

// Datos de ejemplo — se actualizarán cuando FIFA publique los cruces
const _POR_DEFINIR = 'Por definir';

class _Partido {
  final String local;
  final String visitante;
  final int? golesLocal;
  final int? golesVisitante;
  final bool prorroga;
  final bool penaltis;
  final int? penLocal;
  final int? penVisitante;

  const _Partido({
    required this.local,
    required this.visitante,
    this.golesLocal,
    this.golesVisitante,
    this.prorroga = false,
    this.penaltis = false,
    this.penLocal,
    this.penVisitante,
  });

  String get ganador {
    if (golesLocal == null) return _POR_DEFINIR;
    if (penaltis) {
      return (penLocal ?? 0) > (penVisitante ?? 0) ? local : visitante;
    }
    if ((golesLocal ?? 0) > (golesVisitante ?? 0)) return local;
    if ((golesVisitante ?? 0) > (golesLocal ?? 0)) return visitante;
    return _POR_DEFINIR;
  }
}

// Estructura del cuadro — se rellenará con datos reales
final _octavos = [
  const _Partido(local: '1º Grupo A', visitante: '2º Grupo B'),
  const _Partido(local: '1º Grupo C', visitante: '2º Grupo D'),
  const _Partido(local: '1º Grupo E', visitante: '2º Grupo F'),
  const _Partido(local: '1º Grupo G', visitante: '2º Grupo H'),
  const _Partido(local: '1º Grupo I', visitante: '2º Grupo J'),
  const _Partido(local: '1º Grupo K', visitante: '2º Grupo L'),
  const _Partido(local: '3º (por determinar)', visitante: '3º (por determinar)'),
  const _Partido(local: '3º (por determinar)', visitante: '3º (por determinar)'),
];

class CuadroScreen extends StatelessWidget {
  const CuadroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuadro Eliminatorio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avisoProvisional(),
            const SizedBox(height: 16),
            _seccion('⚽ Octavos de Final', _octavos, context),
            const SizedBox(height: 8),
            _seccion('🏆 Cuartos de Final', _cuartos(), context),
            const SizedBox(height: 8),
            _seccion('🔥 Semifinales', _semis(), context),
            const SizedBox(height: 8),
            _seccion('🥉 3er y 4º Puesto', _tercerPuesto(), context),
            const SizedBox(height: 8),
            _seccion('🌟 Final', _final(), context),
          ],
        ),
      ),
    );
  }

  List<_Partido> _cuartos() => List.generate(4,
      (_) => const _Partido(local: _POR_DEFINIR, visitante: _POR_DEFINIR));

  List<_Partido> _semis() => List.generate(2,
      (_) => const _Partido(local: _POR_DEFINIR, visitante: _POR_DEFINIR));

  List<_Partido> _tercerPuesto() =>
      [const _Partido(local: _POR_DEFINIR, visitante: _POR_DEFINIR)];

  List<_Partido> _final() =>
      [const _Partido(local: _POR_DEFINIR, visitante: _POR_DEFINIR)];

  Widget _avisoProvisional() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC9A84C), width: 1),
      ),
      child: const Row(
        children: [
          Text('⏳', style: TextStyle(fontSize: 20)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Los cruces oficiales serán publicados por FIFA antes del inicio del torneo.',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccion(String titulo, List<_Partido> partidos, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00205B), Color(0xFFD0021B)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(titulo,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        ...partidos.asMap().entries.map((e) =>
            _PartidoCuadro(partido: e.value, numero: e.key + 1)),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _PartidoCuadro extends StatelessWidget {
  final _Partido partido;
  final int numero;
  const _PartidoCuadro({required this.partido, required this.numero});

  @override
  Widget build(BuildContext context) {
    final pendiente = partido.golesLocal == null;
    final localNombre = traducir(partido.local);
    final visitanteNombre = traducir(partido.visitante);
    final flagLocal = getBandera(partido.local);
    final flagVisitante = getBandera(partido.visitante);
    final ganador = partido.ganador;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            // Equipo local
            _equipoFila(
              flag: flagLocal,
              nombre: localNombre,
              goles: partido.golesLocal,
              penaltis: partido.penLocal,
              esGanador: ganador == partido.local,
              pendiente: pendiente,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(height: 1),
            ),
            // Equipo visitante
            _equipoFila(
              flag: flagVisitante,
              nombre: visitanteNombre,
              goles: partido.golesVisitante,
              penaltis: partido.penVisitante,
              esGanador: ganador == partido.visitante,
              pendiente: pendiente,
            ),
            if (partido.prorroga || partido.penaltis) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (partido.prorroga)
                    _badge('Prórroga', const Color(0xFF1565C0)),
                  if (partido.penaltis) ...[
                    const SizedBox(width: 4),
                    _badge('Penaltis', const Color(0xFF6A1B9A)),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _equipoFila({
    required String flag,
    required String nombre,
    required int? goles,
    required int? penaltis,
    required bool esGanador,
    required bool pendiente,
  }) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            nombre,
            style: TextStyle(
              fontSize: 13,
              fontWeight: esGanador ? FontWeight.bold : FontWeight.normal,
              color: esGanador ? const Color(0xFFC9A84C) : Colors.white,
            ),
          ),
        ),
        if (!pendiente) ...[
          if (penaltis != null)
            Text('($penaltis) ',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: esGanador ? const Color(0xFF00205B) : const Color(0xFF1A2035),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: esGanador ? const Color(0xFFC9A84C) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              '$goles',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: esGanador ? const Color(0xFFC9A84C) : Colors.white70,
              ),
            ),
          ),
        ] else
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2035),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('-',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
      ],
    );
  }

  Widget _badge(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(texto,
          style: const TextStyle(fontSize: 10, color: Colors.white)),
    );
  }
}
