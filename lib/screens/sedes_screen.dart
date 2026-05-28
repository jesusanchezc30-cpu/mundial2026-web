import 'package:flutter/material.dart';

const _kTexto = Color(0xFF0D1527);
const _kTextoSecund = Color(0xFF3A4560);
const _kAzul = Color(0xFF00205B);
const _kRojo = Color(0xFFD0021B);
const _kDorado = Color(0xFFC9A84C);

const List<Map<String, dynamic>> _ciudadesSede = [
  {
    'ciudad': 'Nueva York / Nueva Jersey', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'MetLife Stadium', 'capacidad': 82500, 'habitantes': 19000000,
    'descripcion': 'La mayor área metropolitana de EE.UU. El MetLife Stadium albergará la Gran Final del Mundial 2026.',
    'emoji': '🗽', 'partidos': 8, 'foto': 'assets/estadios/metlife.jpg',
  },
  {
    'ciudad': 'Los Ángeles', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'SoFi Stadium', 'capacidad': 70240, 'habitantes': 13200000,
    'descripcion': 'Ciudad del cine y la cultura pop. Sede también de los Juegos Olímpicos 2028.',
    'emoji': '🎬', 'partidos': 7, 'foto': 'assets/estadios/sofi.jpg',
  },
  {
    'ciudad': 'Dallas', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'AT&T Stadium', 'capacidad': 80000, 'habitantes': 7600000,
    'descripcion': 'El AT&T Stadium es uno de los recintos deportivos más grandes y modernos del mundo.',
    'emoji': '🤠', 'partidos': 7, 'foto': 'assets/estadios/att.jpg',
  },
  {
    'ciudad': 'San Francisco', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': "Levi's Stadium", 'capacidad': 68500, 'habitantes': 4700000,
    'descripcion': 'Capital tecnológica mundial, hogar del Golden Gate y Silicon Valley.',
    'emoji': '🌉', 'partidos': 6, 'foto': 'assets/estadios/levis.jpg',
  },
  {
    'ciudad': 'Miami', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Hard Rock Stadium', 'capacidad': 65326, 'habitantes': 6200000,
    'descripcion': 'Ciudad cosmopolita con gran influencia latinoamericana y playas paradisíacas.',
    'emoji': '🌴', 'partidos': 6, 'foto': 'assets/estadios/hardrock.jpg',
  },
  {
    'ciudad': 'Seattle', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Lumen Field', 'capacidad': 68740, 'habitantes': 4000000,
    'descripcion': 'Ciudad de la tecnología entre el océano y las montañas. Sede de Amazon.',
    'emoji': '☁️', 'partidos': 6, 'foto': 'assets/estadios/lumen.jpg',
  },
  {
    'ciudad': 'Boston', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Gillette Stadium', 'capacidad': 66829, 'habitantes': 4900000,
    'descripcion': 'Ciudad histórica y cuna de la independencia americana. Hogar de Harvard y el MIT.',
    'emoji': '🏛️', 'partidos': 6, 'foto': 'assets/estadios/gillette.jpg',
  },
  {
    'ciudad': 'Houston', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'NRG Stadium', 'capacidad': 72220, 'habitantes': 7300000,
    'descripcion': 'Capital energética de EE.UU. y sede de la NASA. Gran diversidad cultural.',
    'emoji': '🚀', 'partidos': 6, 'foto': 'assets/estadios/nrg.jpg',
  },
  {
    'ciudad': 'Filadelfia', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Lincoln Financial Field', 'capacidad': 69176, 'habitantes': 6200000,
    'descripcion': 'Primera capital de EE.UU. y cuna de la Declaración de Independencia.',
    'emoji': '🔔', 'partidos': 6, 'foto': 'assets/estadios/lincoln.jpg',
  },
  {
    'ciudad': 'Kansas City', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Arrowhead Stadium', 'capacidad': 76416, 'habitantes': 2200000,
    'descripcion': 'Corazón de EE.UU. famosa por su barbacoa y el jazz.',
    'emoji': '🎷', 'partidos': 5, 'foto': 'assets/estadios/arrowhead.jpg',
  },
  {
    'ciudad': 'Atlanta', 'pais': 'Estados Unidos', 'bandera': '🇺🇸',
    'estadio': 'Mercedes-Benz Stadium', 'capacidad': 71000, 'habitantes': 6200000,
    'descripcion': 'Ciudad sede de los Juegos Olímpicos de 1996. El Mercedes-Benz Stadium es uno de los más modernos del mundo.',
    'emoji': '🏟️', 'partidos': 5, 'foto': 'assets/estadios/mercedes.jpg',
  },
  {
    'ciudad': 'Ciudad de México', 'pais': 'México', 'bandera': '🇲🇽',
    'estadio': 'Estadio Azteca', 'capacidad': 87523, 'habitantes': 21700000,
    'descripcion': 'El Azteca es el único estadio que ha albergado dos finales mundialistas (1970 y 1986).',
    'emoji': '🏛️', 'partidos': 5, 'foto': 'assets/estadios/azteca.jpg',
  },
  {
    'ciudad': 'Guadalajara', 'pais': 'México', 'bandera': '🇲🇽',
    'estadio': 'Estadio Akron', 'capacidad': 46355, 'habitantes': 5200000,
    'descripcion': 'Capital del estado de Jalisco y cuna del mariachi y la charrería.',
    'emoji': '🎺', 'partidos': 5, 'foto': 'assets/estadios/akron.jpg',
  },
  {
    'ciudad': 'Monterrey', 'pais': 'México', 'bandera': '🇲🇽',
    'estadio': 'Estadio BBVA', 'capacidad': 53500, 'habitantes': 5300000,
    'descripcion': 'Capital industrial de México rodeada de montañas espectaculares.',
    'emoji': '⛰️', 'partidos': 5, 'foto': 'assets/estadios/bbva.jpg',
  },
  {
    'ciudad': 'Toronto', 'pais': 'Canadá', 'bandera': '🇨🇦',
    'estadio': 'BMO Field', 'capacidad': 45700, 'habitantes': 6400000,
    'descripcion': 'Ciudad más grande de Canadá y una de las más multiculturales del mundo.',
    'emoji': '🗼', 'partidos': 5, 'foto': 'assets/estadios/bmo.jpg',
  },
  {
    'ciudad': 'Vancouver', 'pais': 'Canadá', 'bandera': '🇨🇦',
    'estadio': 'BC Place', 'capacidad': 54500, 'habitantes': 2600000,
    'descripcion': 'Ciudad entre el océano y las montañas. Una de las ciudades más habitables del mundo.',
    'emoji': '🏔️', 'partidos': 5, 'foto': 'assets/estadios/bcplace.jpg',
  },
];

const List<Map<String, dynamic>> _paises = [
  {'nombre': '🇺🇸 Estados Unidos', 'pais': 'Estados Unidos', 'sedes': 11},
  {'nombre': '🇲🇽 México', 'pais': 'México', 'sedes': 3},
  {'nombre': '🇨🇦 Canadá', 'pais': 'Canadá', 'sedes': 2},
];

class SedesScreen extends StatelessWidget {
  const SedesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sedes del Mundial')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _encabezado(),
          const SizedBox(height: 16),
          ..._paises.map((p) => _PaisExpansion(paisData: p)),
        ],
      ),
    );
  }

  Widget _encabezado() {
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
          const Text('⚽ MUNDIAL 2026', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 4),
          const Text('🇺🇸 🇲🇽 🇨🇦', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('16', 'Sedes'),
              _stat('3', 'Países'),
              _stat('104', 'Partidos'),
              _stat('48', 'Equipos'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String valor, String label) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(color: _kDorado, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _PaisExpansion extends StatelessWidget {
  final Map<String, dynamic> paisData;
  const _PaisExpansion({required this.paisData});

  @override
  Widget build(BuildContext context) {
    final sedes = _ciudadesSede.where((c) => c['pais'] == paisData['pais']).toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(paisData['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTexto)),
          subtitle: Text('${paisData['sedes']} sedes', style: const TextStyle(fontSize: 12, color: _kTextoSecund)),
          children: sedes.map((s) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: _SedeCard(sede: s),
          )).toList(),
        ),
      ),
    );
  }
}

class _SedeCard extends StatelessWidget {
  final Map<String, dynamic> sede;
  const _SedeCard({required this.sede});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.asset(
              sede['foto'],
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                color: const Color(0xFFD6DCE8),
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sede['emoji'], style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(sede['estadio'], style: const TextStyle(color: _kTextoSecund, fontSize: 11)),
                  ],
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(sede['ciudad'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kTexto))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _kRojo, borderRadius: BorderRadius.circular(10)),
                      child: Text('${sede['partidos']} partidos', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(sede['estadio'], style: const TextStyle(fontSize: 12, color: _kDorado, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(sede['descripcion'], style: const TextStyle(fontSize: 12, height: 1.5, color: _kTextoSecund)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 14, color: _kTextoSecund),
                    const SizedBox(width: 4),
                    Text(_formatNum(sede['habitantes'] as int),
                        style: const TextStyle(fontSize: 12, color: _kTextoSecund)),
                    const SizedBox(width: 16),
                    const Icon(Icons.event_seat, size: 14, color: _kTextoSecund),
                    const SizedBox(width: 4),
                    Text(_formatNum(sede['capacidad'] as int),
                        style: const TextStyle(fontSize: 12, color: _kTextoSecund)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M hab.';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }
}
