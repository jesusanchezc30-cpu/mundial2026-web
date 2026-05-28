import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../translations.dart';
import '../paises_data.dart';
import '../alineaciones_data.dart';

const _kTexto = Color(0xFF0D1527);
const _kTextoSecund = Color(0xFF3A4560);
const _kAzul = Color(0xFF00205B);
const _kDorado = Color(0xFFC9A84C);
const _kRojo = Color(0xFFD0021B);

class SeleccionesScreen extends StatefulWidget {
  const SeleccionesScreen({super.key});

  @override
  State<SeleccionesScreen> createState() => _SeleccionesScreenState();
}

class _SeleccionesScreenState extends State<SeleccionesScreen> {
  List<dynamic> _selecciones = [];
  List<dynamic> _filtradas = [];
  bool _loading = true;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargar();
    _search.addListener(_filtrar);
  }

  Future<void> _cargar() async {
    try {
      final data = await ApiService.getSelecciones();
      setState(() { _selecciones = data; _filtradas = data; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _filtrar() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtradas = _selecciones.where((s) {
        final nombre = traducir(s['nombre']).toLowerCase();
        final grupo = (s['grupo'] ?? '').toLowerCase();
        return nombre.contains(q) || grupo.contains(q);
      }).toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<dynamic>> porGrupo = {};
    for (final s in _filtradas) {
      final g = s['grupo'] ?? '?';
      porGrupo.putIfAbsent(g, () => []).add(s);
    }
    final grupos = porGrupo.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciones')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: 'Buscar selección o grupo...',
                      hintStyle: const TextStyle(color: _kTextoSecund),
                      prefixIcon: const Icon(Icons.search, color: _kAzul),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: grupos.length,
                    itemBuilder: (ctx, i) {
                      final g = grupos[i];
                      final sels = porGrupo[g]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text('Grupo $g',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: _kAzul, fontSize: 15)),
                          ),
                          ...sels.map((s) {
                            final nombre = traducir(s['nombre']);
                            final flag = getBandera(s['nombre']);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                dense: true,
                                leading: Text(flag, style: const TextStyle(fontSize: 28)),
                                title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w500, color: _kTexto)),
                                subtitle: Text(s['codigo_fifa'] ?? '', style: const TextStyle(fontSize: 11, color: _kTextoSecund)),
                                trailing: const Icon(Icons.chevron_right, size: 16, color: _kAzul),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _SeleccionDetalleScreen(
                                      selId: s['id'],
                                      nombreBD: s['nombre'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _SeleccionDetalleScreen extends StatefulWidget {
  final int selId;
  final String nombreBD;
  const _SeleccionDetalleScreen({required this.selId, required this.nombreBD});

  @override
  State<_SeleccionDetalleScreen> createState() => _SeleccionDetalleScreenState();
}

class _SeleccionDetalleScreenState extends State<_SeleccionDetalleScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final data = await ApiService.getSeleccionDetalle(widget.selId);
      setState(() { _data = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error cargando datos'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre = traducir(widget.nombreBD);
    final flag = getBandera(widget.nombreBD);
    final paisData = getPaisData(nombre);
    final alineacionPath = getAlineacion(widget.nombreBD);

    return Scaffold(
      appBar: AppBar(title: Text('$flag $nombre')),
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
                          _encabezado(_data!, paisData, flag, nombre),
                          const SizedBox(height: 12),
                          if (alineacionPath != null) ...[
                            _seccionTitulo('🗃️ 11 Titular'),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                alineacionPath,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, e, s) => const SizedBox(
                                  height: 100,
                                  child: Center(child: Text('Imagen no disponible', style: TextStyle(color: _kTextoSecund))),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (paisData != null) ...[
                            _datosPais(paisData),
                            const SizedBox(height: 12),
                          ],
                          _estadisticasMundiales(_data!),
                          const SizedBox(height: 12),
                          if ((_data!['palmares'] as List?)?.isNotEmpty == true) ...[
                            _palmares(_data!),
                            const SizedBox(height: 12),
                          ],
                          _mundiales(_data!),
                          if (paisData != null) ...[
                            const SizedBox(height: 12),
                            _curiosidadesPais(paisData),
                          ],
                        ],
                      ),
                    ),
    );
  }

  Widget _encabezado(Map<String, dynamic> data, PaisData? paisData, String flag, String nombre) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kAzul, _kRojo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(flag, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text(nombre, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          if (paisData != null) ...[
            const SizedBox(height: 4),
            Text(paisData.continente, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Text('👔 ${paisData.entrenador}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('${data['participaciones'] ?? 0}', 'Mundiales'),
              _stat(data['mejor_puesto'] ?? '-', 'Mejor puesto'),
              _stat('${data['campeonatos'] ?? 0}', 'Títulos 🏆'),
              if (paisData != null) _stat('#${paisData.rankingFifa}', 'Ranking FIFA'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String valor, String label) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(color: _kDorado, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _seccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kDorado)),
    );
  }

  Widget _datosPais(PaisData paisData) {
    return _seccion('🌍 Datos del País', [
      _fila('🏛️ Capital', paisData.capital),
      _fila('👥 Habitantes', _formatNum(paisData.habitantes)),
      _fila('🏙️ Ciudades', paisData.ciudades.join(', ')),
      _fila('⚽ Clubes destacados', paisData.clubes.join(', ')),
    ]);
  }

  Widget _estadisticasMundiales(Map<String, dynamic> data) {
    final stats = data['stats'] as Map<String, dynamic>? ?? {};
    final mejorRival = traducir(data['mejor_rival']);
    final peorRival = traducir(data['peor_rival']);
    final goleadaDada = data['mayor_goleada_dada'] as Map<String, dynamic>?;
    final goleadaRecibida = data['mayor_goleada_recibida'] as Map<String, dynamic>?;

    return _seccion('📊 Estadísticas en Mundiales', [
      if (stats.isNotEmpty && (stats['pj'] ?? 0) > 0) ...[
        _fila('🎮 Partidos jugados', '${stats['pj']}'),
        _fila('✅ Victorias', '${stats['pg']}'),
        _fila('➖ Empates', '${stats['pe']}'),
        _fila('❌ Derrotas', '${stats['pp']}'),
        _fila('⚽ Goles a favor', '${stats['gf']}'),
        _fila('🥅 Goles en contra', '${stats['gc']}'),
        _fila('📅 Última participación', '${data['ultima_participacion'] ?? '-'}'),
      ] else
        const Text('Sin participaciones históricas', style: TextStyle(color: _kTextoSecund, fontSize: 13)),
      _fila('😊 Rival favorito', mejorRival.isNotEmpty ? mejorRival : '-'),
      _fila('😰 Rival difícil', peorRival.isNotEmpty ? peorRival : '-'),
      _fila('💪 Mayor goleada dada',
          goleadaDada != null ? '${goleadaDada['resultado']} vs ${traducir(goleadaDada['rival'])} (${goleadaDada['anyo']})' : '-'),
      _fila('😓 Mayor goleada recibida',
          goleadaRecibida != null ? '${goleadaRecibida['resultado']} vs ${traducir(goleadaRecibida['rival'])} (${goleadaRecibida['anyo']})' : '-'),
    ]);
  }

  Widget _palmares(Map<String, dynamic> data) {
    final palmares = data['palmares'] as List? ?? [];
    return _seccion('🏆 Palmarés',
        palmares.map((p) => _fila(p['puesto'], '${p['anyo']}')).toList());
  }

  Widget _mundiales(Map<String, dynamic> data) {
    final mundiales = data['mundiales'] as List? ?? [];
    if (mundiales.isEmpty) return const SizedBox();
    return _seccion('📅 Mundiales disputados',
        mundiales.map((m) => _fila('${m['anyo']}', traducir(m['pais_sede']))).toList());
  }

  Widget _curiosidadesPais(PaisData paisData) {
    return _seccion('💡 Curiosidades',
        paisData.curiosidades.map((c) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(color: _kDorado, fontSize: 14)),
              Expanded(child: Text(c, style: const TextStyle(fontSize: 13, height: 1.4, color: _kTexto))),
            ],
          ),
        )).toList());
  }

  Widget _seccion(String titulo, List<Widget> hijos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kDorado)),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...hijos,
          ],
        ),
      ),
    );
  }

  Widget _fila(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(fontSize: 12, color: _kTextoSecund))),
          Expanded(child: Text(valor, style: const TextStyle(fontSize: 12, color: _kTexto))),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }
}
