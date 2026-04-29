import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dot_loader/flutter_dot_loader.dart';

void main() => runApp(const DotMatrixGalleryApp());

class DotMatrixGalleryApp extends StatelessWidget {
  const DotMatrixGalleryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dot Matrix Studio',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF3333),
          surface: Color(0xFF0A0A0C),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// ─── Shared Components ───

// ─── Blocks Game Animation Logo ───

class _BlocksLogo extends StatelessWidget {
  final double dotSize;
  final double spacing;
  const _BlocksLogo({this.dotSize = 3.5, this.spacing = 1.8});

  static const List<List<List<int>>> _frames = [
    // 1. Empty
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    // 2. L-block appears
    [
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    // 3. L-block falls
    [
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    // 4. L-block falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    // 5. L-block falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0]
    ],
    // 6. L-block hits bottom
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0]
    ],

    // 7. Square appears
    [
      [0, 0, 0, 1, 1, 0],
      [0, 0, 0, 1, 1, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 8. Square falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1, 0],
      [0, 0, 0, 1, 1, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 9. Square falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1, 0],
      [0, 0, 0, 1, 1, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 10. Square hits bottom
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],

    // 11. Line appears
    [
      [0, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 12. Line falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 13. Line falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 14. Line hits bottom - line clear animation (flash)
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 0],
      [1, 1, 1, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 15. Flash empty
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 16. Flash full
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 17. Cleared and dropped
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],

    // 18. T-Block appears
    [
      [0, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 19. T-Block falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 20. T-Block falls
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
    // 21. T-Block hits bottom
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],

    // 22. Wait before loop
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 0],
      [0, 0, 0, 1, 0, 0],
      [1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0]
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Keep width static to match the layout
      width: 6 * (dotSize + spacing) - spacing,
      height: 7 * (dotSize + spacing) - spacing,
      child: MatrixLoader(
        columns: 6,
        rows: 7,
        dotSize: dotSize,
        spacing: spacing,
        pattern: MatrixPattern.custom,
        activeColor: const Color(0xFFFF3333),
        inactiveColor: const Color(0xFF1A1A1E),
        duration: const Duration(seconds: 4),
        customIntensity: (row, col, progress) {
          int idx = (progress * _frames.length).floor();
          if (idx >= _frames.length) idx = _frames.length - 1;
          return _frames[idx][row][col] == 1 ? 1.0 : 0.0;
        },
      ),
    );
  }
}

class GlobalTint extends InheritedWidget {
  final Color tint;
  final VoidCallback showPicker;

  const GlobalTint({
    super.key,
    required this.tint,
    required this.showPicker,
    required super.child,
  });

  static GlobalTint of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalTint>()!;
  }

  @override
  bool updateShouldNotify(GlobalTint oldWidget) => tint != oldWidget.tint;
}

// ─── Main Navigation ───
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  Color _globalTint = Colors.white;

  final List<Widget> _pages = const [
    GalleryScreen(),
    PlaygroundScreen(),
    StudioScreen(),
    TextScreen(),
    InteractiveScreen(),
  ];

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        final colors = [
          Colors.white,
          Colors.redAccent,
          Colors.orangeAccent,
          Colors.amberAccent,
          Colors.greenAccent,
          Colors.cyanAccent,
          Colors.blueAccent,
          Colors.purpleAccent,
          Colors.pinkAccent,
        ];
        return AlertDialog(
          backgroundColor: const Color(0xFF0A0A0C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          title: const Text(
            'SELECT TINT',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((c) {
              return GestureDetector(
                onTap: () {
                  setState(() => _globalTint = c);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          _globalTint == c ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0C),
        elevation: 0,
        title: Row(
          children: [
            const _BlocksLogo(dotSize: 3, spacing: 1.5),
            const SizedBox(width: 16),
            if (!isMobile)
              const Text(
                'DOT MATRIX',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        actions: [
          _NavBarTab(
            title: 'Gallery',
            isActive: _currentIndex == 0,
            onTap: () => setState(() => _currentIndex = 0),
          ),
          _NavBarTab(
            title: 'Playground',
            isActive: _currentIndex == 1,
            onTap: () => setState(() => _currentIndex = 1),
          ),
          _NavBarTab(
            title: 'Studio',
            isActive: _currentIndex == 2,
            onTap: () => setState(() => _currentIndex = 2),
          ),
          _NavBarTab(
            title: 'Text',
            isActive: _currentIndex == 3,
            onTap: () => setState(() => _currentIndex = 3),
          ),
          _NavBarTab(
            title: 'Interactive',
            isActive: _currentIndex == 4,
            onTap: () => setState(() => _currentIndex = 4),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _globalTint,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child:
                  const Icon(Icons.color_lens, size: 16, color: Colors.black45),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GlobalTint(
        tint: _globalTint,
        showPicker: _showColorPicker,
        child: _pages[_currentIndex],
      ),
    );
  }
}

class _NavBarTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const _NavBarTab(
      {required this.title, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}

// ─── Data Models ───
class _LoaderEntry {
  final String name;
  final MatrixShape shape;
  final MatrixPattern pattern;
  const _LoaderEntry(this.name, this.shape, this.pattern);
}

const _squareLoaders = [
  _LoaderEntry('Neon Drift', MatrixShape.square, MatrixPattern.square1),
  _LoaderEntry('Pulse Ladder', MatrixShape.square, MatrixPattern.square2),
  _LoaderEntry('Core Spiral', MatrixShape.square, MatrixPattern.square3),
  _LoaderEntry('Twin Orbit', MatrixShape.square, MatrixPattern.square4),
  _LoaderEntry('Prism Sweep', MatrixShape.square, MatrixPattern.square5),
  _LoaderEntry('Checker Shift', MatrixShape.square, MatrixPattern.square6),
  _LoaderEntry('Diamond Pulse', MatrixShape.square, MatrixPattern.square7),
  _LoaderEntry('Snake Trail', MatrixShape.square, MatrixPattern.square8),
  _LoaderEntry('Cross Weave', MatrixShape.square, MatrixPattern.square9),
  _LoaderEntry('Scan Line', MatrixShape.square, MatrixPattern.square10),
  _LoaderEntry('Vortex Spin', MatrixShape.square, MatrixPattern.square11),
  _LoaderEntry('Diagonal Fade', MatrixShape.square, MatrixPattern.square12),
  _LoaderEntry('Grid Bloom', MatrixShape.square, MatrixPattern.square13),
  _LoaderEntry('Spiral Arm', MatrixShape.square, MatrixPattern.square14),
  _LoaderEntry('Interference', MatrixShape.square, MatrixPattern.square15),
  _LoaderEntry('Corner Wave', MatrixShape.square, MatrixPattern.square16),
  _LoaderEntry('Sine Band', MatrixShape.square, MatrixPattern.square17),
  _LoaderEntry('Rail Scan', MatrixShape.square, MatrixPattern.square18),
  _LoaderEntry('Ripple Echo', MatrixShape.square, MatrixPattern.square19),
  _LoaderEntry('Star Burst', MatrixShape.square, MatrixPattern.square20),
];

const _circularLoaders = [
  _LoaderEntry('Halo Drift', MatrixShape.circular, MatrixPattern.circular1),
  _LoaderEntry('Pulse Ring', MatrixShape.circular, MatrixPattern.circular2),
  _LoaderEntry('Orbit Wave', MatrixShape.circular, MatrixPattern.circular3),
  _LoaderEntry('Ripple Out', MatrixShape.circular, MatrixPattern.circular4),
  _LoaderEntry('Galaxy Arm', MatrixShape.circular, MatrixPattern.circular5),
  _LoaderEntry('Tri Sweep', MatrixShape.circular, MatrixPattern.circular6),
  _LoaderEntry('Flower Spin', MatrixShape.circular, MatrixPattern.circular7),
  _LoaderEntry('Beacon Pulse', MatrixShape.circular, MatrixPattern.circular8),
  _LoaderEntry('Helix Curl', MatrixShape.circular, MatrixPattern.circular9),
  _LoaderEntry('Glyph Cycle', MatrixShape.circular, MatrixPattern.circular10),
  _LoaderEntry('Radial Mix', MatrixShape.circular, MatrixPattern.circular11),
  _LoaderEntry('Siren Wave', MatrixShape.circular, MatrixPattern.circular12),
  _LoaderEntry('Bloom Fade', MatrixShape.circular, MatrixPattern.circular13),
  _LoaderEntry('Shock Ring', MatrixShape.circular, MatrixPattern.circular14),
  _LoaderEntry('Petal Drift', MatrixShape.circular, MatrixPattern.circular15),
  _LoaderEntry('Orbit Cell', MatrixShape.circular, MatrixPattern.circular16),
  _LoaderEntry('Aurora Spin', MatrixShape.circular, MatrixPattern.circular17),
  _LoaderEntry('Sonar Ping', MatrixShape.circular, MatrixPattern.circular18),
  _LoaderEntry('Glyph Cluster', MatrixShape.circular, MatrixPattern.circular19),
  _LoaderEntry('Cosmic Halo', MatrixShape.circular, MatrixPattern.circular20),
];

const _triangleLoaders = [
  _LoaderEntry('Core Spokes', MatrixShape.triangle, MatrixPattern.triangle1),
  _LoaderEntry('Altitude Wave', MatrixShape.triangle, MatrixPattern.triangle2),
  _LoaderEntry('Corner Bounce', MatrixShape.triangle, MatrixPattern.triangle3),
  _LoaderEntry('Vertex Chase', MatrixShape.triangle, MatrixPattern.triangle4),
  _LoaderEntry('Twin Helix', MatrixShape.triangle, MatrixPattern.triangle5),
  _LoaderEntry('Rung Shift', MatrixShape.triangle, MatrixPattern.triangle6),
  _LoaderEntry('Tri Vortex', MatrixShape.triangle, MatrixPattern.triangle7),
  _LoaderEntry('Column Wave', MatrixShape.triangle, MatrixPattern.triangle8),
  _LoaderEntry('Apex Pulse', MatrixShape.triangle, MatrixPattern.triangle9),
  _LoaderEntry('Fan Sweep', MatrixShape.triangle, MatrixPattern.triangle10),
  _LoaderEntry('Cascade Fall', MatrixShape.triangle, MatrixPattern.triangle11),
  _LoaderEntry('Cross Hatch', MatrixShape.triangle, MatrixPattern.triangle12),
  _LoaderEntry('Prism Burst', MatrixShape.triangle, MatrixPattern.triangle13),
  _LoaderEntry('Blade Spin', MatrixShape.triangle, MatrixPattern.triangle14),
  _LoaderEntry('Ripple Edge', MatrixShape.triangle, MatrixPattern.triangle15),
  _LoaderEntry('Spiral Glow', MatrixShape.triangle, MatrixPattern.triangle16),
  _LoaderEntry('Ladder Shift', MatrixShape.triangle, MatrixPattern.triangle17),
  _LoaderEntry('Mesh Pulse', MatrixShape.triangle, MatrixPattern.triangle18),
  _LoaderEntry('Storm Spin', MatrixShape.triangle, MatrixPattern.triangle19),
  _LoaderEntry('Harmony', MatrixShape.triangle, MatrixPattern.triangle20),
];

// ─── 1. Gallery Screen ───
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _selectedTab = 0;
  final _tabs = const ['all', 'square', 'circular', 'triangle'];

  String _searchQuery = '';
  bool _isCompact = false;
  bool _isPaused = false;
  double _speed = 1.0;

  List<_LoaderEntry> get _currentLoaders {
    List<_LoaderEntry> list;
    switch (_selectedTab) {
      case 1:
        list = _squareLoaders;
        break;
      case 2:
        list = _circularLoaders;
        break;
      case 3:
        list = _triangleLoaders;
        break;
      default:
        list = [..._squareLoaders, ..._circularLoaders, ..._triangleLoaders];
        break;
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where(
              (l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    int crossAxisCount;
    if (_isCompact) {
      crossAxisCount = isMobile ? 3 : (screenWidth < 900 ? 5 : 8);
    } else {
      crossAxisCount = isMobile ? 2 : (screenWidth < 900 ? 3 : 5);
    }

    final hPad = isMobile ? 16.0 : 40.0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(hPad, isMobile ? 24 : 40, hPad, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line 1: § THE SET & click a tile...
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '§ THE SET',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    if (!isMobile)
                      Row(
                        children: [
                          Text(
                            'click a tile to copy its SVG, or focus and press ',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1E),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Text(
                              'c',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Line 2: Search, Layout toggle, Pause
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0C),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.3)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) =>
                                    setState(() => _searchQuery = val),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'filter by name...',
                                  hintStyle: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '/',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 16),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isCompact = false),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: !_isCompact
                                      ? const Color(0xFF1A1A1E)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                ),
                                child: Text(
                                  'comfortable',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: !_isCompact
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.1)),
                            GestureDetector(
                              onTap: () => setState(() => _isCompact = true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _isCompact
                                      ? const Color(0xFF1A1A1E)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                child: Text(
                                  'compact',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: _isCompact
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => setState(() => _isPaused = !_isPaused),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(_isPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                _isPaused ? 'play all' : 'pause all',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 16),

                // Line 3: Filter Pills & Loader Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_tabs.length, (index) {
                        final isSelected = _selectedTab == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTab = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEFE94B)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFEFE94B)
                                      : Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    if (!isMobile)
                      Text(
                        '${_currentLoaders.length} loaders',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Line 4: TINT and SPEED
                Row(
                  children: [
                    Text(
                      'TINT',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: GlobalTint.of(context).showPicker,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: GlobalTint.of(context).tint,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Text(
                      'SPEED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: Colors.white.withValues(alpha: 0.2),
                          inactiveTrackColor:
                              Colors.white.withValues(alpha: 0.1),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: _speed,
                          min: 0.1,
                          max: 3.0,
                          onChanged: (val) => setState(() => _speed = val),
                        ),
                      ),
                    ),
                    Text(
                      '${_speed.toStringAsFixed(1)}x',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: isMobile ? 16 : 24)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: isMobile ? 8 : 12,
              crossAxisSpacing: isMobile ? 8 : 12,
              childAspectRatio: isMobile ? 0.9 : 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _LoaderCard(
                entry: _currentLoaders[index],
                isMobile: isMobile,
                tint: GlobalTint.of(context).tint,
                speed: _speed,
                isPaused: _isPaused,
              ),
              childCount: _currentLoaders.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }
}

class _LoaderCard extends StatelessWidget {
  final _LoaderEntry entry;
  final bool isMobile;
  final Color tint;
  final double speed;
  final bool isPaused;
  const _LoaderCard({
    required this.entry,
    this.isMobile = false,
    this.tint = Colors.white,
    this.speed = 1.0,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0C),
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: const Color(0xFF1A1A1E), width: 1),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: MatrixLoader(
                columns: 5,
                rows: 5,
                dotSize: isMobile ? 3.5 : 4,
                spacing: isMobile ? 2.5 : 3,
                size: isMobile ? 36 : 44,
                shape: entry.shape,
                pattern: entry.pattern,
                activeColor: tint,
                duration: isPaused
                    ? const Duration(days: 999)
                    : Duration(milliseconds: (1500 / speed).round()),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: isMobile ? 10 : 16),
            child: Text(
              entry.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: isMobile ? 10 : 11,
                color: const Color(0xFF71717A),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 2. Playground Screen ───
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});
  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  int _cols = 7;
  int _rows = 7;
  double _dotSize = 6;
  double _spacing = 2;
  double _speed = 1.5;
  MatrixShape _shape = MatrixShape.square;
  MatrixPattern _pattern = MatrixPattern.square1;

  final List<MatrixShape> _shapes = [
    MatrixShape.square,
    MatrixShape.circular,
    MatrixShape.triangle
  ];

  List<MatrixPattern> get _availablePatterns {
    if (_shape == MatrixShape.square) {
      return _squareLoaders.map((e) => e.pattern).toList();
    }
    if (_shape == MatrixShape.circular) {
      return _circularLoaders.map((e) => e.pattern).toList();
    }
    return _triangleLoaders.map((e) => e.pattern).toList();
  }

  void _onShapeChanged(MatrixShape? val) {
    if (val == null) return;
    setState(() {
      _shape = val;
      _pattern = _availablePatterns.first;
    });
  }

  String _generateCode(Color tint) {
    final hex = tint.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return '''
MatrixLoader(
  columns: $_cols,
  rows: $_rows,
  dotSize: ${_dotSize.toStringAsFixed(1)},
  spacing: ${_spacing.toStringAsFixed(1)},
  duration: const Duration(milliseconds: ${(1000 * _speed).toInt()}),
  shape: MatrixShape.${_shape.name},
  pattern: MatrixPattern.${_pattern.name},
  activeColor: Color(0x$hex),
)''';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    Widget controls = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CONTROLS',
              style:
                  TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 24),
          _buildDropdown<MatrixShape>('Shape', _shapes, _shape, _onShapeChanged,
              (s) => s.name.toUpperCase()),
          const SizedBox(height: 16),
          _buildDropdown<MatrixPattern>('Pattern', _availablePatterns, _pattern,
              (v) => setState(() => _pattern = v!), (p) => p.name),
          const SizedBox(height: 24),
          _buildSlider('Columns', _cols.toDouble(), 1, 20,
              (v) => setState(() => _cols = v.toInt())),
          _buildSlider('Rows', _rows.toDouble(), 1, 20,
              (v) => setState(() => _rows = v.toInt())),
          _buildSlider(
              'Dot Size', _dotSize, 2, 20, (v) => setState(() => _dotSize = v)),
          _buildSlider(
              'Spacing', _spacing, 0, 10, (v) => setState(() => _spacing = v)),
          _buildSlider('Duration (s)', _speed, 0.5, 5,
              (v) => setState(() => _speed = v)),
        ],
      ),
    );

    Widget preview = Container(
      color: const Color(0xFF050505),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: MatrixLoader(
                columns: _cols,
                rows: _rows,
                dotSize: _dotSize,
                spacing: _spacing,
                duration: Duration(milliseconds: (1000 * _speed).toInt()),
                shape: _shape,
                pattern: _pattern,
                activeColor: GlobalTint.of(context).tint,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF1A1A1E))),
              color: Color(0xFF0A0A0C),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Code Snippet',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70)),
                    TextButton.icon(
                      icon:
                          const Icon(Icons.copy, size: 14, color: Colors.white),
                      label: const Text('Copy',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: _generateCode(GlobalTint.of(context).tint)));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Copied to clipboard!')));
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _generateCode(GlobalTint.of(context).tint),
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFFA1A1AA)),
                ),
              ],
            ),
          )
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          Expanded(flex: 3, child: preview),
          const Divider(height: 1, color: Color(0xFF1A1A1E)),
          Expanded(flex: 4, child: controls),
        ],
      );
    }
    return Row(
      children: [
        Expanded(flex: 2, child: preview),
        const VerticalDivider(width: 1, color: Color(0xFF1A1A1E)),
        SizedBox(width: 320, child: controls),
      ],
    );
  }

  Widget _buildDropdown<T>(String label, List<T> items, T value,
      ValueChanged<T?> onChanged, String Function(T) labeler) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF27272A)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              dropdownColor: const Color(0xFF1A1A1E),
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(labeler(e),
                          style: const TextStyle(fontSize: 14))))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.white54)),
              Text(value.toStringAsFixed(1),
                  style:
                      const TextStyle(fontSize: 12, fontFamily: 'monospace')),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFFF3333),
              inactiveTrackColor: const Color(0xFF27272A),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFFFF3333).withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child:
                Slider(value: value, min: min, max: max, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

// ─── 3. Studio Screen ───
class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});
  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  final int cols = 7;
  final int rows = 8;
  late List<List<List<int>>> frames;
  int currentFrame = 0;

  @override
  void initState() {
    super.initState();
    // Start with one empty frame
    frames = [List.generate(rows, (_) => List.filled(cols, 0))];
  }

  void _toggleDot(int r, int c) {
    setState(() {
      frames[currentFrame][r][c] = frames[currentFrame][r][c] == 1 ? 0 : 1;
    });
  }

  void _addFrame() {
    setState(() {
      // Copy current frame
      final newFrame =
          List.generate(rows, (r) => List<int>.from(frames[currentFrame][r]));
      frames.add(newFrame);
      currentFrame = frames.length - 1;
    });
  }

  void _deleteFrame() {
    if (frames.length <= 1) return;
    setState(() {
      frames.removeAt(currentFrame);
      if (currentFrame >= frames.length) currentFrame = frames.length - 1;
    });
  }

  void _clearFrame() {
    setState(() {
      frames[currentFrame] = List.generate(rows, (_) => List.filled(cols, 0));
    });
  }

  void _invertFrame() {
    setState(() {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          frames[currentFrame][r][c] = frames[currentFrame][r][c] == 1 ? 0 : 1;
        }
      }
    });
  }

  String _generateCode() {
    final frameStrs = frames.map((f) {
      final rowsStrs = f.map((r) => '[${r.join(', ')}]').join(',\n      ');
      return '    [\n      $rowsStrs\n    ]';
    }).join(',\n');

    return '''
// 1. Define your custom frames
final List<List<List<int>>> customFrames = [
$frameStrs
];

// 2. Use MatrixLoader with customIntensity
MatrixLoader(
  columns: $cols,
  rows: $rows,
  pattern: MatrixPattern.custom,
  customIntensity: (row, col, progress) {
    int frameIndex = (progress * customFrames.length).floor();
    if (frameIndex >= customFrames.length) frameIndex = customFrames.length - 1;
    return customFrames[frameIndex][row][col] == 1 ? 1.0 : 0.0;
  },
)''';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    Widget editor = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1A1A1E)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows, (r) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(cols, (c) {
                  final isActive = frames[currentFrame][r][c] == 1;
                  return GestureDetector(
                    onTap: () => _toggleDot(r, c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.all(4),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFFFF3333)
                            : const Color(0xFF1A1A1E),
                        border: Border.all(
                            color: isActive
                                ? const Color(0xFFFF6666)
                                : const Color(0xFF27272A)),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                    color: const Color(0xFFFF3333)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 8)
                              ]
                            : [],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _clearFrame,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _invertFrame,
              icon: const Icon(Icons.invert_colors, size: 16),
              label: const Text('Invert'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text('TIMELINE',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white54)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < frames.length; i++)
                GestureDetector(
                  onTap: () => setState(() => currentFrame = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: currentFrame == i
                              ? const Color(0xFFFF3333)
                              : const Color(0xFF27272A),
                          width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF0A0A0C),
                    ),
                    width: 48,
                    height: 48,
                    child: CustomPaint(painter: _MiniFramePainter(frames[i])),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addFrame,
                icon: const Icon(Icons.add_box),
                color: Colors.white54,
                iconSize: 32,
              ),
              if (frames.length > 1)
                IconButton(
                  onPressed: _deleteFrame,
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                  iconSize: 32,
                ),
            ],
          ),
        ),
      ],
    );

    Widget rightPanel = Column(
      children: [
        Expanded(
          child: Container(
            color: const Color(0xFF0A0A0C),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('LIVE PREVIEW',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white54)),
                  const SizedBox(height: 24),
                  MatrixLoader(
                    columns: cols,
                    rows: rows,
                    dotSize: 6,
                    spacing: 3,
                    pattern: MatrixPattern.custom,
                    activeColor: const Color(0xFFFF3333),
                    customIntensity: (row, col, progress) {
                      int idx = (progress * frames.length).floor();
                      if (idx >= frames.length) idx = frames.length - 1;
                      return frames[idx][row][col] == 1 ? 1.0 : 0.0;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF1A1A1E))),
            color: Color(0xFF050505),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Generated Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white70)),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 14, color: Colors.white),
                    label: const Text('Copy',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generateCode()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Copied to clipboard!')));
                    },
                  )
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(
                    _generateCode(),
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFFA1A1AA)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [Tab(text: 'Editor'), Tab(text: 'Preview')],
              indicatorColor: Color(0xFFFF3333),
              labelColor: Colors.white,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                      padding: const EdgeInsets.all(24), child: editor),
                  rightPanel,
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: editor),
        const VerticalDivider(width: 1, color: Color(0xFF1A1A1E)),
        Expanded(flex: 2, child: rightPanel),
      ],
    );
  }
}

class _MiniFramePainter extends CustomPainter {
  final List<List<int>> frame;
  _MiniFramePainter(this.frame);
  @override
  void paint(Canvas canvas, Size size) {
    final rows = frame.length;
    final cols = frame[0].length;
    final dotW = size.width / cols;
    final dotH = size.height / rows;
    final paint = Paint()..style = PaintingStyle.fill;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (frame[r][c] == 1) {
          paint.color = const Color(0xFFFF3333);
        } else {
          paint.color = const Color(0xFF1A1A1E);
        }
        canvas.drawRect(
            Rect.fromLTWH(c * dotW + 0.5, r * dotH + 0.5, dotW - 1, dotH - 1),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MiniFramePainter old) => true;
}

// ─── Text Marquee Screen ───
class TextScreen extends StatefulWidget {
  const TextScreen({super.key});
  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  String _text = "HELLO WORLD";
  double _speed = 4.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1A1A1E)),
            ),
            child: MatrixLoader(
              size: 400,
              dotSize: 10,
              spacing: 4,
              columns: 24,
              rows: 7,
              pattern: MatrixPattern.custom,
              duration: Duration(milliseconds: (10000 / _speed).round()),
              customIntensity: MatrixText.scrolling(_text, loopPadding: 24),
              activeColor: Colors.cyanAccent,
              inactiveColor: const Color(0xFF1A1A1E),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 300,
            child: TextField(
              onChanged: (val) => setState(() => _text = val),
              decoration: const InputDecoration(
                labelText: 'Marquee Text',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: _text)
                ..selection = TextSelection.collapsed(offset: _text.length),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 300,
            child: Row(
              children: [
                const Text('Speed'),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (val) => setState(() => _speed = val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Interactive Screen ───
class InteractiveScreen extends StatefulWidget {
  const InteractiveScreen({super.key});
  @override
  State<InteractiveScreen> createState() => _InteractiveScreenState();
}

class _InteractiveScreenState extends State<InteractiveScreen> {
  final List<List<int>> _grid =
      List.generate(8, (_) => List.generate(8, (_) => 0));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'TAP THE DOTS TO LIGHT THEM UP',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white54),
          ),
          const SizedBox(height: 32),
          MatrixLoader(
            size: 220,
            columns: 8,
            rows: 8,
            dotSize: 20,
            spacing: 8,
            opacityBase: 0.2,
            pattern: MatrixPattern.custom,
            duration: const Duration(seconds: 1),
            customIntensity: (row, col, progress) => _grid[row][col].toDouble(),
            activeColor: Colors.amberAccent,
            inactiveColor: const Color(0xFF3A3A40),
            onDotTapped: (row, col) {
              setState(() {
                _grid[row][col] = _grid[row][col] == 1 ? 0 : 1;
              });
            },
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {
              setState(() {
                for (var r = 0; r < 8; r++) {
                  for (var c = 0; c < 8; c++) {
                    _grid[r][c] = 0;
                  }
                }
              });
            },
            child: const Text('Clear Pad'),
          ),
        ],
      ),
    );
  }
}
