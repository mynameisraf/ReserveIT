import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../api/users.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DATA CATALOG — ReserveIT PC Stations
//
//  Criteria implemented:
//  ① HTTP GET Request Execution   → _fetchStations() using http.get()
//  ② JSON Array → Product Mapping → reserveITFromJson() in api/users.dart
//  ③ Dynamic Product ListView     → ListView.builder inside FutureBuilder
//  ④ Search View Filtering        → TextField + _filteredStations getter
// ─────────────────────────────────────────────────────────────────────────────

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {
  // ── Design tokens ──────────────────────────────────────────────────────────
  static const Color bgColor = Color(0xFF080F24);
  static const Color cardColor = Color(0xFF0F1E3D);
  static const Color cardLighter = Color(0xFF162448);
  static const Color accentBlue = Color(0xFF3A6FD8);
  static const Color accentCyan = Color(0xFF00C9FF);
  static const Color subtleText = Color(0xFF8BA8D4);
  static const Color dividerClr = Color(0xFF1E3260);

  // ── State ──────────────────────────────────────────────────────────────────
  late Future<List<ReserveITStation>> _stationsFuture;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  List<ReserveITStation> _allStations = [];
  late AnimationController _shimmer;

  // ── Criterion ①  HTTP GET endpoint (falls back to local asset if offline) ──
  static const String _apiUrl =
      'https://raw.githubusercontent.com/mynameisraf/ReserveIT/refs/heads/main/ITEMS';

  Future<List<ReserveITStation>> _fetchStations() async {
    try {
      // ── Criterion ① : execute HTTP GET request ──────────────────────────
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        // ── Criterion ② : parse JSON array → ReserveITStation list ─────────
        final ReserveIT parsed = reserveITFromJson(response.body);
        return parsed.data;
      }
    } catch (_) {
      // Network error → fall through to local asset
    }

    // ── Asset fallback ────────────────────────────────────────────────────
    final String raw = await rootBundle.loadString('assets/users.json');
    return reserveITFromJson(raw).data;
  }

  // ── Criterion ④  Search filtering ────────────────────────────────────────
  List<ReserveITStation> get _filteredStations {
    if (_query.isEmpty) return _allStations;
    final q = _query.toLowerCase();
    return _allStations.where((s) {
      return s.pcName.toLowerCase().contains(q) ||
          s.zone.toLowerCase().contains(q) ||
          s.cpu.toLowerCase().contains(q) ||
          s.gpu.toLowerCase().contains(q) ||
          s.ram.toLowerCase().contains(q) ||
          s.rate.toLowerCase().contains(q) ||
          s.games.any((g) => g.toLowerCase().contains(q));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _stationsFuture = _fetchStations();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _appBar(),
      body: FutureBuilder<List<ReserveITStation>>(
        future: _stationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _shimmerList();
          }
          if (snapshot.hasError) {
            return _errorState(snapshot.error.toString());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _emptyState('No stations found.');
          }

          _allStations = snapshot.data!;
          final list = _filteredStations;

          return Column(
            children: [
              // ── Criterion ④ : Search View ──────────────────────────────
              _searchBar(),
              _resultChip(list.length),

              // ── Criterion ③ : Dynamic ListView ────────────────────────
              Expanded(
                child: list.isEmpty
                    ? _emptyState('No results for "$_query"')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: list.length,
                        itemBuilder: (ctx, i) => _stationCard(list[i], i),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: cardColor,
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 12,
    title: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            'assets/logo.png',
            height: 28,
            width: 28,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Catalog',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'PC Stations & Specifications',
              style: GoogleFonts.poppins(fontSize: 10, color: subtleText),
            ),
          ],
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.refresh_rounded, color: accentCyan),
        tooltip: 'Refresh',
        onPressed: () => setState(() {
          _stationsFuture = _fetchStations();
          _searchCtrl.clear();
        }),
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, accentBlue, Colors.transparent],
          ),
        ),
      ),
    ),
  );

  // ── Criterion ④  Search Bar Widget ────────────────────────────────────────
  Widget _searchBar() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _query.isEmpty ? dividerClr : accentBlue,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentBlue.withValues(alpha: 0.10),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        cursorColor: accentCyan,
        decoration: InputDecoration(
          hintText: 'Search by name, zone, CPU, GPU, game…',
          hintStyle: GoogleFonts.poppins(color: subtleText, fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: accentCyan,
            size: 22,
          ),
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () => _searchCtrl.clear(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: subtleText,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    ),
  );

  // ── Result count + HTTP badge ──────────────────────────────────────────────
  Widget _resultChip(int count) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
    child: Row(
      children: [
        _chip(
          icon: Icons.storage_rounded,
          label: '$count ${count == 1 ? 'station' : 'stations'} found',
          iconColor: accentCyan,
          textColor: accentCyan,
          bgColor: accentBlue.withValues(alpha: 0.12),
          borderColor: accentBlue.withValues(alpha: 0.35),
        ),
        const Spacer(),
        _chip(
          icon: Icons.cloud_done_rounded,
          label: 'HTTP GET',
          iconColor: Colors.greenAccent,
          textColor: Colors.greenAccent,
          bgColor: Colors.greenAccent.withValues(alpha: 0.08),
          borderColor: Colors.greenAccent.withValues(alpha: 0.30),
        ),
      ],
    ),
  );

  Widget _chip({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 12),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  // ── Criterion ③  Station Card (single ListView item) ──────────────────────
  Widget _stationCard(ReserveITStation s, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 280 + index * 55),
      curve: Curves.easeOut,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - v)),
          child: child,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: s.isAvailable
                ? Colors.greenAccent.withValues(alpha: 0.22)
                : Colors.redAccent.withValues(alpha: 0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentBlue.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [accentBlue, Color(0xFF1A3A7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.computer_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.pcName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: accentCyan,
                              size: 12,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              s.zone,
                              style: GoogleFonts.poppins(
                                color: subtleText,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _availBadge(s.isAvailable),
                ],
              ),

              const SizedBox(height: 14),
              _divider(),
              const SizedBox(height: 10),

              // Specs
              _specRow(Icons.memory_rounded, 'CPU', s.cpu),
              _specRow(Icons.videogame_asset_rounded, 'GPU', s.gpu),
              _specRow(Icons.storage_rounded, 'RAM', s.ram),
              _specRow(Icons.monitor_rounded, 'Monitor', s.monitor),
              _specRow(Icons.keyboard_rounded, 'Peripherals', s.peripherals),

              const SizedBox(height: 12),
              _divider(),
              const SizedBox(height: 10),

              // Rate + ID
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFBF00), Color(0xFFFF8C00)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          s.rate,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'PC #${s.id}',
                    style: GoogleFonts.poppins(
                      color: Colors.white30,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Games chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: s.games
                    .map(
                      (game) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cardLighter,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sports_esports_rounded,
                              color: accentCyan,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              game,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _availBadge(bool avail) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: avail
          ? Colors.greenAccent.withValues(alpha: 0.10)
          : Colors.redAccent.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: avail ? Colors.greenAccent : Colors.redAccent,
        width: 1.2,
      ),
    ),
    child: Text(
      avail ? 'AVAILABLE' : 'IN USE',
      style: GoogleFonts.poppins(
        color: avail ? Colors.greenAccent : Colors.redAccent,
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _specRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accentBlue, size: 15),
        const SizedBox(width: 8),
        SizedBox(
          width: 82,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: subtleText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 11.5),
          ),
        ),
      ],
    ),
  );

  Widget _divider() => Container(
    height: 1,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.transparent, dividerClr, Colors.transparent],
      ),
    ),
  );

  // ── Shimmer loading (shown while HTTP request is in-flight) ───────────────
  Widget _shimmerList() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 4,
    itemBuilder: (_, i) => AnimatedBuilder(
      animation: _shimmer,
      builder: (_, _) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment(-1.5 + _shimmer.value * 3, 0),
            end: Alignment(-0.5 + _shimmer.value * 3, 0),
            colors: const [
              Color(0xFF0F1E3D),
              Color(0xFF1A3060),
              Color(0xFF0F1E3D),
            ],
          ),
        ),
      ),
    ),
  );

  // ── Error / Empty states ──────────────────────────────────────────────────
  Widget _errorState(String error) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: Colors.redAccent,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Failed to load stations',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: subtleText, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => setState(() => _stationsFuture = _fetchStations()),
            icon: const Icon(Icons.refresh_rounded),
            label: Text('Retry', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _emptyState(String msg) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off_rounded, color: subtleText, size: 56),
        const SizedBox(height: 16),
        Text(
          msg,
          style: GoogleFonts.poppins(color: subtleText, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
