import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../translations.dart';

const _kTexto = Color(0xFF0D1527);
const _kTextoSecund = Color(0xFF3A4560);
const _kTextoMuted = Color(0xFF6B7A99);
const _kAzul = Color(0xFF00205B);
const _kDorado = Color(0xFFC9A84C);
const _kRojo = Color(0xFFD0021B);

const Map<int, String> _paisSede = {
  1930: 'Uruguay', 1934: 'Italia', 1938: 'Francia', 1950: 'Brasil',
  1954: 'Suiza', 1958: 'Suecia', 1962: 'Chile', 1966: 'Inglaterra',
  1970: 'México', 1974: 'Alemania', 1978: 'Argentina', 1982: 'España',
  1986: 'México', 1990: 'Italia', 1994: 'Estados Unidos', 1998: 'Francia',
  2002: 'Corea y Japón', 2006: 'Alemania', 2010: 'Sudáfrica', 2014: 'Brasil',
  2018: 'Rusia', 2022: 'Catar',
};

const Map<int, List<String>> _banderasSede = {
  1930: ['🇺🇾'], 1934: ['🇮🇹'], 1938: ['🇫🇷'], 1950: ['🇧🇷'],
  1954: ['🇨🇭'], 1958: ['🇸🇪'], 1962: ['🇨🇱'], 1966: ['🏴󠁧󠁢󠁥󠁮󠁧󠁿'],
  1970: ['🇲🇽'], 1974: ['🇩🇪'], 1978: ['🇦🇷'], 1982: ['🇪🇸'],
  1986: ['🇲🇽'], 1990: ['🇮🇹'], 1994: ['🇺🇸'], 1998: ['🇫🇷'],
  2002: ['🇰🇷', '🇯🇵'], 2006: ['🇩🇪'], 2010: ['🇿🇦'], 2014: ['🇧🇷'],
  2018: ['🇷🇺'], 2022: ['🇶🇦'],
};

String _traducirFase(String nombre) {
  final n = nombre.toLowerCase();
  if (n == 'group stage') return 'Fase de grupos';
  if (n == 'final round') return 'Ronda final';
  if (n == 'group a') return 'Grupo A';
  if (n == 'group b') return 'Grupo B';
  if (n == 'group c') return 'Grupo C';
  if (n == 'group d') return 'Grupo D';
  if (n == 'group e') return 'Grupo E';
  if (n == 'group f') return 'Grupo F';
  if (n == 'group g') return 'Grupo G';
  if (n == 'group h') return 'Grupo H';
  if (n.startsWith('group ')) return 'Grupo ${nombre.split(' ').last}';
  if (n.contains('pool')) return nombre.replaceFirst('Pool', 'Grupo');
  if (n.contains('round of 16')) return 'Octavos de final';
  if (n.contains('first round')) return 'Primera ronda';
  if (n.contains('second round')) return 'Segunda ronda';
  if (n.contains('quarter')) return 'Cuartos de final';
  if (n.contains('semi')) return 'Semifinales';
  if (n.contains('third') || n.contains('match for third')) return '3er y 4º puesto';
  if (n.contains('final tournament')) return 'Fase final';
  if (n.contains('knockout')) return 'Fase eliminatoria';
  if (n.contains('final draw')) return 'Sorteo';
  if (n == 'final') return 'Final';
  if (n.contains('play-off')) return 'Play-off';
  return nombre;
}

bool _esFaseGrupo(String nombre) {
  final n = nombre.toLowerCase();
  return n.startsWith('group ') || n.contains('pool') || n == 'final round';
}

bool _esFaseGrupoContenedor(String nombre) {
  final n = nombre.toLowerCase();
  return n == 'group stage' || n == 'knockout stage';
}

Color _colorFase(String nombre) {
  final n = nombre.toLowerCase();
  if (n == 'final') return _kDorado;
  if (n.contains('semi')) return _kRojo;
  if (n.contains('quarter')) return const Color(0xFF6A1B9A);
  if (n.contains('round of 16')) return const Color(0xFF1565C0);
  return _kAzul;
}

class _BanderaDoble extends StatelessWidget {
  final List<String> banderas;
  final double size;
  const _BanderaDoble({required this.banderas, this.size = 24});

  @override
  Widget build(BuildContext context) {
    if (banderas.length == 1) return Text(banderas[0], style: TextStyle(fontSize: size));
    return SizedBox(
      width: size * 1.4,
      height: size * 1.2,
      child: Stack(
        children: [
          ClipRect(child: Align(alignment: Alignment.centerLeft, widthFactor: 0.55, child: Text(banderas[0], style: TextStyle(fontSize: size)))),
          Positioned(right: 0, child: ClipRect(child: Align(alignment: Alignment.centerRight, widthFactor: 0.55, child: Text(banderas[1], style: TextStyle(fontSize: size))))),
        ],
      ),
    );
  }
}

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});
  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<dynamic> _mundiales = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    try {
      final data = await ApiService.getHistorico();
      setState(() { _mundiales = data; _loading = false; });
    } catch (e) { setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mundiales Históricos')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _mundiales.length,
              itemBuilder: (ctx, i) => _MundialCard(mundial: _mundiales[i]),
            ),
    );
  }
}

class _MundialCard extends StatelessWidget {
  final Map<String, dynamic> mundial;
  const _MundialCard({required this.mundial});

  @override
  Widget build(BuildContext context) {
    final anyo = mundial['anyo'] as int;
    final campeon = traducir(mundial['campeon']);
    final flagCampeon = getBandera(mundial['campeon']);
    final banderas = _banderasSede[anyo] ?? ['🌍'];
    final pais = _paisSede[anyo] ?? (mundial['pais_sede'] ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _kAzul,
          child: _BanderaDoble(banderas: banderas, size: 22),
        ),
        title: Text('$anyo · $pais', style: const TextStyle(fontWeight: FontWeight.bold, color: _kTexto)),
        subtitle: Text('🏆 $flagCampeon  $campeon', style: const TextStyle(color: _kTextoSecund)),
        trailing: const Icon(Icons.chevron_right, color: _kTextoMuted),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _MundialDetalleScreen(anyo: anyo))),
      ),
    );
  }
}

class _MundialDetalleScreen extends StatefulWidget {
  final int anyo;
  const _MundialDetalleScreen({required this.anyo});
  @override
  State<_MundialDetalleScreen> createState() => _MundialDetalleScreenState();
}

class _MundialDetalleScreenState extends State<_MundialDetalleScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String _error = '';

  @override
  void initState() { super.initState(); _cargar(); }

  Future<void> _cargar() async {
    try {
      final data = await ApiService.getMundialDetalle(widget.anyo);
      setState(() { _data = data; _loading = false; });
    } catch (e) { setState(() { _error = 'Error cargando datos'; _loading = false; }); }
  }

  Set<String> _calcularEquiposClasificados(List<dynamic> fases, int ordenActual) {
    final equipos = <String>{};
    for (final fase in fases) {
      final orden = fase['orden'] as int? ?? 0;
      if (orden <= ordenActual) continue;
      final nombreFase = (fase['nombre'] as String).toLowerCase();
      if (nombreFase.contains('third') || nombreFase.contains('tercer')) continue;
      final partidos = fase['partidos'] as List? ?? [];
      for (final p in partidos) {
        if (p['local'] != null) equipos.add(p['local'] as String);
        if (p['visitante'] != null) equipos.add(p['visitante'] as String);
      }
    }
    return equipos;
  }

  @override
  Widget build(BuildContext context) {
    final banderas = _banderasSede[widget.anyo] ?? ['🌍'];
    final pais = _paisSede[widget.anyo] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          _BanderaDoble(banderas: banderas, size: 22),
          const SizedBox(width: 8),
          Text('Mundial ${widget.anyo}'),
        ]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : _data == null
                  ? const Center(child: Text('Sin datos'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _encabezado(_data!, banderas, pais),
                          const SizedBox(height: 16),
                          _buildFases(_data!['fases'] as List? ?? []),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildFases(List<dynamic> fases) {
    final fasesGrupo = fases.where((f) => _esFaseGrupo(f['nombre'] as String)).toList();
    final fasesElim = fases.where((f) => !_esFaseGrupo(f['nombre'] as String) && !_esFaseGrupoContenedor(f['nombre'] as String)).toList();

    return Column(
      children: [
        if (fasesGrupo.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(width: 8, height: 8, decoration: const BoxDecoration(color: _kAzul, shape: BoxShape.circle)),
                title: const Text('Fase de grupos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _kTexto)),
                subtitle: Text('${fasesGrupo.length} grupos', style: const TextStyle(fontSize: 11, color: _kTextoMuted)),
                children: fasesGrupo.map((fase) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _GrupoExpansion(fase: fase),
                )).toList(),
              ),
            ),
          ),
        ...fasesElim.map((fase) {
          final orden = fase['orden'] as int? ?? 0;
          final equiposClasificados = _calcularEquiposClasificados(fases, orden);
          return _FaseElimExpansion(fase: fase, equiposClasificados: equiposClasificados);
        }),
      ],
    );
  }

  Widget _encabezado(Map<String, dynamic> data, List<String> banderas, String pais) {
    final campeon = traducir(data['campeon']);
    final subcampeon = traducir(data['subcampeon']);
    final tercero = traducir(data['tercer_puesto']);
    final flagCampeon = getBandera(data['campeon']);
    final flagSub = getBandera(data['subcampeon']);
    final flagTercero = getBandera(data['tercer_puesto']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_kAzul, _kRojo], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _BanderaDoble(banderas: banderas, size: 28),
            const SizedBox(width: 8),
            Text('Mundial ${data['anyo']}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          ]),
          Text(pais, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _podio('🥇', flagCampeon, campeon),
            _podio('🥈', flagSub, subcampeon),
            _podio('🥉', flagTercero, tercero),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _stat('${data['num_equipos'] ?? '-'}', 'Equipos'),
            _stat('${data['num_partidos'] ?? '-'}', 'Partidos'),
            _stat('${data['goles_totales'] ?? '-'}', 'Goles'),
            _stat('${data['media_goles'] ?? '-'}', 'Media'),
          ]),
          if (data['maximo_goleador'] != null) ...[
            const SizedBox(height: 8),
            Text('👟 ${data['maximo_goleador']}', style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }

  Widget _podio(String medal, String flag, String nombre) => Column(children: [
    Text(medal, style: const TextStyle(fontSize: 18)),
    Text(flag, style: const TextStyle(fontSize: 24)),
    Text(nombre, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
  ]);

  Widget _stat(String valor, String label) => Column(children: [
    Text(valor, style: const TextStyle(color: _kDorado, fontSize: 18, fontWeight: FontWeight.bold)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
  ]);
}

class _GrupoExpansion extends StatelessWidget {
  final Map<String, dynamic> fase;
  const _GrupoExpansion({required this.fase});

  @override
  Widget build(BuildContext context) {
    final partidos = fase['partidos'] as List? ?? [];
    final clasificacion = fase['clasificacion'] as List?;
    final nombreTraducido = _traducirFase(fase['nombre'] as String);
    final numEquipos = clasificacion?.length ?? 4;
    final porJornada = numEquipos == 3 ? 1 : numEquipos == 5 ? 3 : 2;

    final jornadas = <List<dynamic>>[];
    for (int i = 0; i < partidos.length; i += porJornada) {
      final end = i + porJornada <= partidos.length ? i + porJornada : partidos.length;
      jornadas.add(partidos.sublist(i, end));
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(nombreTraducido, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kTexto)),
        subtitle: Text('${partidos.length} partidos', style: const TextStyle(fontSize: 10, color: _kTextoMuted)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (clasificacion != null && clasificacion.isNotEmpty) ...[
                  _TablaClasificacion(clasificacion: clasificacion),
                  const SizedBox(height: 6),
                ],
                ...jornadas.asMap().entries.map((e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: _kAzul, borderRadius: BorderRadius.circular(8)),
                        child: Text('Jornada ${e.key + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    ...e.value.map((p) => _PartidoHistorico(partido: p, equiposClasificados: const {})),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaseElimExpansion extends StatelessWidget {
  final Map<String, dynamic> fase;
  final Set<String> equiposClasificados;
  const _FaseElimExpansion({required this.fase, required this.equiposClasificados});

  @override
  Widget build(BuildContext context) {
    final partidos = fase['partidos'] as List? ?? [];
    final nombreFase = fase['nombre'] as String;
    final nombreTraducido = _traducirFase(nombreFase);
    final esFinal = nombreFase.toLowerCase() == 'final';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: Container(width: 8, height: 8, decoration: BoxDecoration(color: _colorFase(nombreFase), shape: BoxShape.circle)),
          title: Text(nombreTraducido, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: esFinal ? _kDorado : _kTexto)),
          subtitle: Text('${partidos.length} partidos', style: const TextStyle(fontSize: 11, color: _kTextoMuted)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: partidos.map((p) => _PartidoHistorico(
                  partido: p,
                  equiposClasificados: equiposClasificados,
                )).toList(),
              ),
            ),
          ],
        ),
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
      color: const Color(0xFFEEF2F7),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(children: const [
              SizedBox(width: 20, child: Text('#', style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24),
              Expanded(child: Text('Selección', style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24, child: Text('PJ', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24, child: Text('G', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24, child: Text('E', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 24, child: Text('DG', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _kTextoMuted))),
              SizedBox(width: 28, child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _kTextoMuted))),
            ]),
            const Divider(height: 8),
            ...clasificacion.map((s) {
              final pos = s['pos'] as int;
              final nombre = traducir(s['seleccion']);
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: pos <= 2 ? const Color(0xFFE8F5E9) : null,
                  border: Border(left: BorderSide(color: pos <= 2 ? Colors.green : Colors.transparent, width: 2)),
                ),
                child: Row(children: [
                  SizedBox(width: 20, child: Text('$pos', style: const TextStyle(fontSize: 11, color: _kTexto))),
                  _BanderaWidget(nombreBD: s['seleccion'] as String?, size: 14, width: 24),
                  Expanded(child: Text(nombre, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 24, child: Text('${s['pj']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 24, child: Text('${s['pg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 24, child: Text('${s['pe']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 24, child: Text('${s['pp']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 24, child: Text('${s['dg']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: _kTexto))),
                  SizedBox(width: 28, child: Text('${s['pts']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTexto))),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PartidoHistorico extends StatelessWidget {
  final Map<String, dynamic> partido;
  final Set<String> equiposClasificados;
  const _PartidoHistorico({required this.partido, required this.equiposClasificados});

  @override
  Widget build(BuildContext context) {
    final localBD = partido['local'] as String?;
    final visitanteBD = partido['visitante'] as String?;
    final local = traducir(localBD);
    final visitante = traducir(visitanteBD);
    final gl = partido['goles_local'] as int?;
    final gv = partido['goles_visitante'] as int?;
    final prorroga = partido['hubo_prorroga'] == true;
    final penaltis = partido['hubo_penaltis'] == true;
    final fecha = partido['fecha'];

    final localGana = equiposClasificados.isNotEmpty && localBD != null && equiposClasificados.contains(localBD);
    final visitanteGana = equiposClasificados.isNotEmpty && visitanteBD != null && equiposClasificados.contains(visitanteBD);

    String marcador = gl != null ? '$gl - $gv' : '- -';
    String extra = '';
    if (penaltis) extra = '\n(pen.)';
    else if (prorroga) extra = '\n(p.p.)';

    String fechaFmt = '';
    if (fecha != null) {
      try {
        final dt = DateTime.parse(fecha);
        fechaFmt = DateFormat('d MMM', 'es').format(dt);
      } catch (_) {}
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            if (fechaFmt.isNotEmpty)
              SizedBox(width: 36, child: Text(fechaFmt, style: const TextStyle(fontSize: 9, color: _kTextoMuted), textAlign: TextAlign.center))
            else
              const SizedBox(width: 4),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(child: Text(local, textAlign: TextAlign.right, style: TextStyle(
                    fontSize: 12,
                    fontWeight: localGana ? FontWeight.bold : FontWeight.normal,
                    color: localGana ? _kDorado : _kTexto,
                  ))),
                  if (localGana) const Text(' ★', style: TextStyle(fontSize: 10, color: _kDorado)),
                  const SizedBox(width: 4),
                  _BanderaWidget(nombreBD: localBD, size: 18),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: _kAzul, borderRadius: BorderRadius.circular(6)),
              child: Text('$marcador$extra', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Expanded(
              child: Row(
                children: [
                  _BanderaWidget(nombreBD: visitanteBD, size: 18),
                  const SizedBox(width: 4),
                  if (visitanteGana) const Text('★ ', style: TextStyle(fontSize: 10, color: _kDorado)),
                  Flexible(child: Text(visitante, style: TextStyle(
                    fontSize: 12,
                    fontWeight: visitanteGana ? FontWeight.bold : FontWeight.normal,
                    color: visitanteGana ? _kDorado : _kTexto,
                  ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BanderaWidget extends StatelessWidget {
  final String? nombreBD;
  final double size;
  final double? width;
  const _BanderaWidget({required this.nombreBD, required this.size, this.width});

  @override
  Widget build(BuildContext context) {
    final imagePath = getBanderaImagenPath(nombreBD);
    if (imagePath != null) {
      final img = Image.asset(
        imagePath,
        width: size * 1.3,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Text(getBandera(nombreBD), style: TextStyle(fontSize: size)),
      );
      if (width != null) return SizedBox(width: width, child: Center(child: img));
      return img;
    }
    final emoji = Text(getBandera(nombreBD), style: TextStyle(fontSize: size));
    if (width != null) return SizedBox(width: width, child: Center(child: emoji));
    return emoji;
  }
}
