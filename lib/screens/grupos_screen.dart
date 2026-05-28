import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../translations.dart';

const _kTexto = Color(0xFF0D1527);
const _kTextoSecund = Color(0xFF3A4560);
const _kTextoMuted = Color(0xFF6B7A99);
const _kAzul = Color(0xFF00205B);
const _kDorado = Color(0xFFC9A84C);
const _kFondo = Color(0xFFD6DCE8);

class GruposScreen extends StatefulWidget {
  const GruposScreen({super.key});

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _grupos = ['A','B','C','D','E','F','G','H','I','J','K','L','3º'];
  final Map<String, Map<String, dynamic>> _cache = {};
  bool _loading = true;
  String _grupoActual = 'A';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 13, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final g = _grupos[_tabController.index];
        setState(() => _grupoActual = g);
        if (!_cache.containsKey(g)) _cargarGrupo(g);
      }
    });
    _cargarGrupo('A');
  }

  Future<void> _cargarGrupo(String letra) async {
    setState(() => _loading = true);
    try {
      if (letra == '3º') {
        final terceros = <Map<String, dynamic>>[];
        for (final g in ['A','B','C','D','E','F','G','H','I','J','K','L']) {
          if (_cache.containsKey(g)) {
            final clasificacion = _cache[g]!['clasificacion'] as List? ?? [];
            if (clasificacion.length >= 3) terceros.add({...clasificacion[2], 'grupo': g});
          } else {
            final data = await ApiService.getGrupo(g);
            _cache[g] = data;
            final clasificacion = data['clasificacion'] as List? ?? [];
            if (clasificacion.length >= 3) terceros.add({...clasificacion[2], 'grupo': g});
          }
        }
        terceros.sort((a, b) {
          final pts = (b['pts'] as int).compareTo(a['pts'] as int);
          if (pts != 0) return pts;
          final dg = (b['dg'] as int).compareTo(a['dg'] as int);
          if (dg != 0) return dg;
          return (b['gf'] as int).compareTo(a['gf'] as int);
        });
        for (int i = 0; i < terceros.length; i++) terceros[i]['pos'] = i + 1;
        setState(() { _cache['3º'] = {'terceros': terceros}; _loading = false; });
      } else {
        final data = await ApiService.getGrupo(letra);
        setState(() { _cache[letra] = data; _loading = false; });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _cache[_grupoActual];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _grupos.map((g) => Tab(
            child: Text(g,
              style: TextStyle(
                fontWeight: g == '3º' ? FontWeight.w900 : FontWeight.normal,
                color: g == '3º' ? _kDorado : Colors.white,
              ),
            ),
          )).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : data == null
              ? Center(
                  child: ElevatedButton(
                    onPressed: () => _cargarGrupo(_grupoActual),
                    child: const Text('Reintentar'),
                  ),
                )
              : _grupoActual == '3º'
                  ? _TercerosList(terceros: data['terceros'] ?? [])
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TablaClasificacion(clasificacion: data['clasificacion'] ?? []),
                          const SizedBox(height: 16),
                          _PartidosPorJornada(partidos: data['partidos'] ?? []),
                        ],
                      ),
                    ),
    );
  }
}

class _TercerosList extends StatelessWidget {
  final List<dynamic> terceros;
  const _TercerosList({required this.terceros});

  @override
  Widget build(BuildContext context) {
    final clasifican = terceros.take(8).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _kAzul,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '🏆 Los 8 mejores terceros se clasifican para octavos de final',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(children: const [
                    SizedBox(width: 24, child: Text('#', style: TextStyle(fontSize: 11, color: _kTextoMuted))),
                    SizedBox(width: 36),
                    Expanded(child: Text('Selección', style: TextStyle(fontSize: 11, color: _kTextoMuted))),
                    SizedBox(width: 28, child: Text('Gr.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
                    SizedBox(width: 28, child: Text('PJ', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
                    SizedBox(width: 28, child: Text('DG', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
                    SizedBox(width: 32, child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTextoMuted))),
                  ]),
                  const Divider(),
                  ...clasifican.asMap().entries.map((e) {
                    final pos = e.key + 1;
                    final s = e.value;
                    final clasifica = pos <= 8;
                    final nombre = traducir(s['seleccion']);
                    final flag = getBandera(s['seleccion']);
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: clasifica ? const Color(0xFFE8F5E9) : null,
                        border: Border(left: BorderSide(
                          color: clasifica ? Colors.green : Colors.transparent,
                          width: 3,
                        )),
                      ),
                      child: Row(children: [
                        SizedBox(width: 24, child: Text('$pos', style: const TextStyle(fontSize: 13, color: _kTexto))),
                        SizedBox(width: 28, child: Text(flag, style: const TextStyle(fontSize: 18))),
                        const SizedBox(width: 8),
                        Expanded(child: Text(nombre, style: const TextStyle(fontSize: 13, color: _kTexto))),
                        SizedBox(width: 28, child: Text('${s['grupo'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: _kTextoSecund))),
                        SizedBox(width: 28, child: Text('${s['pj']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                        SizedBox(width: 28, child: Text('${s['dg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                        SizedBox(width: 32, child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kTexto))),
                      ]),
                    );
                  }),
                  if (terceros.length > 8) ...[
                    const Divider(),
                    ...terceros.skip(8).toList().asMap().entries.map((e) {
                      final pos = e.key + 9;
                      final s = e.value;
                      final nombre = traducir(s['seleccion']);
                      final flag = getBandera(s['seleccion']);
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(children: [
                          SizedBox(width: 24, child: Text('$pos', style: const TextStyle(fontSize: 13, color: _kTextoMuted))),
                          SizedBox(width: 28, child: Text(flag, style: const TextStyle(fontSize: 18))),
                          const SizedBox(width: 8),
                          Expanded(child: Text(nombre, style: const TextStyle(fontSize: 13, color: _kTextoMuted))),
                          SizedBox(width: 28, child: Text('${s['grupo'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: _kTextoMuted))),
                          SizedBox(width: 28, child: Text('${s['pj']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTextoMuted))),
                          SizedBox(width: 28, child: Text('${s['dg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTextoMuted))),
                          SizedBox(width: 32, child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: _kTextoMuted))),
                        ]),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TablaClasificacion extends StatelessWidget {
  final List<dynamic> clasificacion;
  const _TablaClasificacion({required this.clasificacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(children: const [
              SizedBox(width: 24, child: Text('#', style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28),
              Expanded(child: Text('Selección', style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('PJ', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('G', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('E', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('DG', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: _kTextoMuted))),
              SizedBox(width: 32, child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTextoMuted))),
            ]),
            const Divider(),
            ...clasificacion.map((s) {
              final pos = s['pos'] as int;
              final clasifica = pos <= 2;
              final nombre = traducir(s['seleccion']);
              final flag = getBandera(s['seleccion']);
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: clasifica ? const Color(0xFFE8F5E9) : null,
                  border: Border(left: BorderSide(
                    color: clasifica ? Colors.green : Colors.transparent,
                    width: 3,
                  )),
                ),
                child: Row(children: [
                  SizedBox(width: 24, child: Text('$pos', style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text(flag, style: const TextStyle(fontSize: 18))),
                  Expanded(child: Text(nombre, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['pj']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['pg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['pe']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['pp']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['dg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _kTexto))),
                  SizedBox(width: 32, child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kTexto))),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PartidosPorJornada extends StatelessWidget {
  final List<dynamic> partidos;
  const _PartidosPorJornada({required this.partidos});

  @override
  Widget build(BuildContext context) {
    final jornadas = <List<dynamic>>[];
    for (int i = 0; i < partidos.length; i += 2) {
      jornadas.add(partidos.sublist(i, i + 2 <= partidos.length ? i + 2 : partidos.length));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: jornadas.asMap().entries.map((entry) {
        final jornada = entry.key + 1;
        final ps = entry.value;
        final fechaStr = ps.first['fecha_espana'] ?? ps.first['fecha'] ?? '';
        final fechaFmt = _formatFecha(fechaStr);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _kAzul,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Jornada $jornada',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text(fechaFmt, style: const TextStyle(fontSize: 12, color: _kTextoSecund)),
                ],
              ),
            ),
            ...ps.map((p) => _PartidoGrupo(partido: p)),
            const SizedBox(height: 4),
          ],
        );
      }).toList(),
    );
  }

  String _formatFecha(String fecha) {
    try {
      final dt = DateTime.parse(fecha);
      return DateFormat('EEEE d MMMM', 'es').format(dt);
    } catch (_) {
      return fecha;
    }
  }
}

class _PartidoGrupo extends StatelessWidget {
  final Map<String, dynamic> partido;
  const _PartidoGrupo({required this.partido});

  @override
  Widget build(BuildContext context) {
    final local = traducir(partido['local']);
    final visitante = traducir(partido['visitante']);
    final flagLocal = getBandera(partido['local']);
    final flagVisitante = getBandera(partido['visitante']);
    final hora = partido['hora_espana']?.substring(0, 5) ?? '--:--';
    final estadio = partido['estadio'] ?? '';
    final ciudad = partido['ciudad'] ?? '';
    final gl = partido['goles_local'];
    final gv = partido['goles_visitante'];
    final esFinalizado = gl != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(child: Text(local, textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 13, color: _kTexto, fontWeight: FontWeight.w500))),
                      const SizedBox(width: 6),
                      Text(flagLocal, style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: esFinalizado ? _kAzul : const Color(0xFFEEF2F7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: esFinalizado ? _kDorado : const Color(0xFFC8D0E0),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    esFinalizado ? '$gl-$gv' : hora,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: esFinalizado ? _kDorado : _kTextoSecund,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(flagVisitante, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      Flexible(child: Text(visitante,
                          style: const TextStyle(fontSize: 13, color: _kTexto, fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
              ],
            ),
            if (estadio.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stadium, size: 11, color: _kTextoMuted),
                  const SizedBox(width: 4),
                  Text('$estadio · $ciudad',
                      style: const TextStyle(fontSize: 10, color: _kTextoSecund, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
