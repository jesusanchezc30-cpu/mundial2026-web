import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../translations.dart';

const _kTexto = Color(0xFF0D1527);
const _kTextoSecund = Color(0xFF3A4560);
const _kAzul = Color(0xFF00205B);
const _kDorado = Color(0xFFC9A84C);
const _kRojo = Color(0xFFD0021B);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _partidos = [];
  bool _loading = true;
  String _error = '';
  DateTime _fechaSeleccionada = DateTime.now();

  static final DateTime _primerDia = DateTime(2026, 6, 11);
  static final DateTime _ultimoDia = DateTime(2026, 7, 19);

  @override
  void initState() {
    super.initState();
    _cargarPartidos();
  }

  Future<void> _cargarPartidos() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final fecha = DateFormat('yyyy-MM-dd').format(_fechaSeleccionada);
      final data = await ApiService.getPartidosFecha(fecha);
      setState(() { _partidos = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error cargando partidos'; _loading = false; });
    }
  }

  void _cambiarDia(int dias) {
    final nueva = _fechaSeleccionada.add(Duration(days: dias));
    if (nueva.isBefore(_primerDia) || nueva.isAfter(_ultimoDia)) return;
    setState(() => _fechaSeleccionada = nueva);
    _cargarPartidos();
  }

  Future<void> _seleccionarFecha() async {
    final initialDate = _fechaSeleccionada.isBefore(_primerDia)
        ? _primerDia
        : _fechaSeleccionada.isAfter(_ultimoDia) ? _ultimoDia : _fechaSeleccionada;
    final fecha = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _primerDia,
      lastDate: _ultimoDia,
      locale: const Locale('es', 'ES'),
    );
    if (fecha != null) {
      setState(() => _fechaSeleccionada = fecha);
      _cargarPartidos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final puedeAnterior = _fechaSeleccionada.isAfter(_primerDia);
    final puedeSiguiente = _fechaSeleccionada.isBefore(_ultimoDia);

    return Scaffold(
      appBar: AppBar(
        title: _Logo2026(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _cargarPartidos,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: _kAzul,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left,
                      color: puedeAnterior ? Colors.white : Colors.white30),
                  onPressed: puedeAnterior ? () => _cambiarDia(-1) : null,
                ),
                GestureDetector(
                  onTap: _seleccionarFecha,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2035),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _kDorado, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('📅', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              DateFormat('EEEE', 'es').format(_fechaSeleccionada).toUpperCase(),
                              style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1),
                            ),
                            Text(
                              DateFormat('d MMMM yyyy', 'es').format(_fechaSeleccionada),
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_drop_down, color: _kDorado, size: 20),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right,
                      color: puedeSiguiente ? Colors.white : Colors.white30),
                  onPressed: puedeSiguiente ? () => _cambiarDia(1) : null,
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                    : _partidos.isEmpty
                        ? _sinPartidos()
                        : RefreshIndicator(
                            onRefresh: _cargarPartidos,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: _partidos.length,
                              itemBuilder: (ctx, i) => _PartidoCard(partido: _partidos[i]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _sinPartidos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚽', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No hay partidos el ${DateFormat('d MMMM', 'es').format(_fechaSeleccionada)}',
            style: const TextStyle(fontSize: 16, color: _kTextoSecund),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _cambiarDia(-1),
                icon: const Icon(Icons.chevron_left),
                label: const Text('Día anterior'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _cambiarDia(1),
                icon: const Icon(Icons.chevron_right),
                label: const Text('Día siguiente'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Logo2026 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('⚽', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'MUNDIAL ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
              ),
              TextSpan(
                text: '2026',
                style: TextStyle(color: _kDorado, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String traducirFase(String? fase, String? grupo) {
  if (fase == null) return '';
  final f = fase.toLowerCase();
  if (f.contains('group') || f.contains('fase de grupo')) {
    return grupo != null ? 'Grupo $grupo' : 'Fase de grupos';
  }
  if (f.contains('round of 16') || f.contains('octav')) return 'Octavos de final';
  if (f.contains('quarter')) return 'Cuartos de final';
  if (f.contains('semi')) return 'Semifinal';
  if (f.contains('third') || f.contains('tercer')) return '3er y 4º puesto';
  if (f.contains('final')) return 'Final';
  return fase;
}

Color _colorFase(String? fase) {
  if (fase == null) return _kAzul;
  final f = fase.toLowerCase();
  if (f.contains('final') && !f.contains('semi') && !f.contains('quarter') && !f.contains('third')) return _kDorado;
  if (f.contains('semi')) return _kRojo;
  if (f.contains('quarter')) return const Color(0xFF6A1B9A);
  if (f.contains('round of 16') || f.contains('octav')) return const Color(0xFF1565C0);
  return _kAzul;
}

class _PartidoCard extends StatelessWidget {
  final Map<String, dynamic> partido;
  const _PartidoCard({required this.partido});

  @override
  Widget build(BuildContext context) {
    final local = traducir(partido['local']);
    final visitante = traducir(partido['visitante']);
    final flagLocal = getBandera(partido['local']);
    final flagVisitante = getBandera(partido['visitante']);
    final horaEspana = partido['hora_espana']?.substring(0, 5) ?? '--:--';
    final estadio = partido['estadio'] ?? '';
    final ciudad = partido['ciudad'] ?? '';
    final grupo = partido['grupo'];
    final fase = partido['fase'] ?? '';
    final gl = partido['goles_local'];
    final gv = partido['goles_visitante'];
    final estado = partido['estado'] ?? 'pendiente';
    final esFinalizado = estado == 'finalizado';

    final faseLabel = traducirFase(fase, grupo);
    final faseColor = _colorFase(fase);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: faseColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(faseLabel,
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 13, color: _kTextoSecund),
                    const SizedBox(width: 4),
                    Text('$horaEspana h', style: const TextStyle(fontSize: 12, color: _kTextoSecund, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(flagLocal, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 6),
                      Text(local, textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kTexto)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: esFinalizado ? _kAzul : const Color(0xFFEEF2F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: esFinalizado ? _kDorado : const Color(0xFFC8D0E0),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    gl != null ? '$gl - $gv' : 'vs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: esFinalizado ? _kDorado : _kTextoSecund,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(flagVisitante, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 6),
                      Text(visitante, textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kTexto)),
                    ],
                  ),
                ),
              ],
            ),
            if (estadio.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stadium, size: 13, color: _kTextoSecund),
                  const SizedBox(width: 4),
                  Text('$estadio · $ciudad',
                      style: const TextStyle(fontSize: 11, color: _kTextoSecund, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
