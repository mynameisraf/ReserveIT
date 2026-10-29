import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'users_page.dart';

class PcStation {
  final String id;
  final String name;
  final String zone;
  final String cpu;
  final String gpu;
  final String ram;
  final String monitor;
  final String peripherals;
  final String rate;
  final bool isAvailable;
  final List<String> games;

  const PcStation({
    required this.id,
    required this.name,
    required this.zone,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.monitor,
    required this.peripherals,
    required this.rate,
    required this.isAvailable,
    required this.games,
  });
}

const List<PcStation> samplePcStations = [
  PcStation(
    id: 'PC-01',
    name: 'VIP Rig #01 (Monster Station)',
    zone: 'VIP Lounge',
    cpu: 'Intel Core i9-14900K (24 Cores, 6.0 GHz)',
    gpu: 'NVIDIA GeForce RTX 4090 24GB GDDR6X',
    ram: '64GB DDR5 6000MHz RGB',
    monitor: '27" ASUS ROG Swift 2K 360Hz OLED (0.03ms)',
    peripherals: 'Razer Huntsman V3 Pro TKL • DeathAdder V3 Pro • BlackShark V2 Pro',
    rate: '₱100 / hr',
    isAvailable: true,
    games: ['Cyberpunk 2077', 'Valorant', 'CS2', 'Black Myth: Wukong', 'Apex Legends'],
  ),
  PcStation(
    id: 'PC-05',
    name: 'Esports Rig #05 (Pro Tournament)',
    zone: 'Esports Arena',
    cpu: 'AMD Ryzen 7 7800X3D 3D V-Cache',
    gpu: 'NVIDIA GeForce RTX 4070 Ti Super 16GB',
    ram: '32GB DDR5 5600MHz Kingston Fury',
    monitor: '24.5" ZOWIE XL2546K 240Hz DyAc+',
    peripherals: 'Logitech G Pro X Superlight 2 • G Pro X TKL Mechanical • G Pro X Headset',
    rate: '₱60 / hr',
    isAvailable: true,
    games: ['Valorant', 'CS2', 'Dota 2', 'League of Legends', 'Apex Legends'],
  ),
  PcStation(
    id: 'PC-12',
    name: 'Standard Rig #12 (Battle Station)',
    zone: 'Regular Gaming Zone',
    cpu: 'Intel Core i5-13400F (10 Cores, 4.6 GHz)',
    gpu: 'NVIDIA GeForce RTX 3060 12GB',
    ram: '16GB DDR4 3200MHz Corsair Vengeance',
    monitor: '24" ASUS TUF Gaming 165Hz IPS (1ms)',
    peripherals: 'Redragon Kumara K552 RGB Mechanical • SteelSeries Rival 3 • Havit 7.1',
    rate: '₱35 / hr',
    isAvailable: true,
    games: ['Valorant', 'Dota 2', 'GTA V', 'Roblox', 'Left 4 Dead 2'],
  ),
  PcStation(
    id: 'PC-08',
    name: 'Streamer Pod #08 (Creator Suite)',
    zone: 'Streaming Studio',
    cpu: 'AMD Ryzen 9 7950X (16 Cores, 32 Threads)',
    gpu: 'NVIDIA GeForce RTX 4080 Super 16GB',
    ram: '64GB DDR5 6000MHz',
    monitor: 'Dual 27" MSI 240Hz Fast IPS Displays',
    peripherals: 'Shure SM7B Mic • Elgato Stream Deck • Cam Link 4K • Studio Arm',
    rate: '₱120 / hr',
    isAvailable: false,
    games: ['OBS Studio', 'Valorant', 'Apex Legends', 'GTA V RP', 'Fortnite'],
  ),
];

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination(
    'Dashboard',
    Icon(Icons.dashboard_outlined),
    Icon(Icons.dashboard),
  ),
  ExampleDestination(
    'My PC Bookings',
    Icon(Icons.desktop_windows_outlined),
    Icon(Icons.desktop_windows),
  ),
  ExampleDestination(
    'PC Stations & Specs',
    Icon(Icons.memory_outlined),
    Icon(Icons.memory),
  ),
  ExampleDestination(
    'Gamer Profile',
    Icon(Icons.person_outline),
    Icon(Icons.person),
  ),
  ExampleDestination(
    'Settings',
    Icon(Icons.settings_outlined),
    Icon(Icons.settings),
  ),
  ExampleDestination(
    'Current PC Users',
    Icon(Icons.people_outline),
    Icon(Icons.people),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;

  // Navy Blue & White Theme Colors
  static const Color backgroundColor = Color(0xFF0B1736);
  static const Color cardNavy = Color(0xFF132247);
  static const Color cardNavyLighter = Color(0xFF192B57);
  static const Color accentBlue = Color(0xFF2E5AAC);
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFFBACDE8);

  void handleScreenChanged(int selectedScreen) {
    Navigator.pop(context); // close the drawer first

    // Index 5 = 'Current PC Users' — navigate to UsersPage
    if (selectedScreen == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UsersPage()),
      );
      return;
    }

    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  // Containment Widget: Modal Bottom Sheet (Reserve a PC Station)
  void _showReservePcBottomSheet([PcStation? preselectedStation]) {
    String selectedPcId = preselectedStation?.id ?? 'PC-01';
    int selectedHours = 2;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardNavy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final activePc = samplePcStations.firstWhere(
              (p) => p.id == selectedPcId,
              orElse: () => samplePcStations.first,
            );

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: Icon(Icons.desktop_windows, color: Color(0xFF0B1736), size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Book PC Station',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose your computer cafe unit and playtime duration:',
                    style: GoogleFonts.poppins(fontSize: 13, color: secondaryTextColor),
                  ),
                  const SizedBox(height: 16),

                  // PC Unit Selection
                  Text(
                    'Select PC Unit:',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: cardNavyLighter,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPcId,
                        dropdownColor: cardNavy,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: samplePcStations.map((station) {
                          return DropdownMenuItem<String>(
                            value: station.id,
                            child: Text(
                              '${station.id} - ${station.name} (${station.rate})',
                              style: TextStyle(
                                color: station.isAvailable ? Colors.white : Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) {
                            setModalState(() {
                              selectedPcId = newVal;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Specs preview card inside modal
                  Card(
                    color: const Color(0xFF0F1C3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Specs: ${activePc.gpu} • ${activePc.monitor}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Zone: ${activePc.zone} • Peripherals: ${activePc.peripherals}',
                            style: const TextStyle(color: secondaryTextColor, fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Duration selector chips
                  Text(
                    'Select Duration (Hours):',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [1, 2, 3, 5].map((hours) {
                      final isSelected = selectedHours == hours;
                      return ChoiceChip(
                        label: Text('$hours hr${hours > 1 ? 's' : ''}'),
                        selected: isSelected,
                        selectedColor: Colors.white,
                        backgroundColor: cardNavyLighter,
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF0B1736) : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedHours = hours;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Confirm Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0B1736),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: accentBlue,
                            content: Text(
                              'Success! $selectedPcId booked for $selectedHours hours at ReserveIT Cafe.',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Confirm PC Reservation ($selectedHours Hrs)',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Containment Widget: Dialog (Detailed PC Specifications Breakdown)
  void _showPcSpecsDialog(PcStation station) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: cardNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.white24),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.memory, color: Color(0xFF0B1736)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Zone: ${station.zone} • Rate: ${station.rate}',
                    style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpecRow(Icons.developer_board, 'Processor (CPU)', station.cpu),
              const Divider(color: Colors.white12),
              _buildSpecRow(Icons.videogame_asset, 'Graphics (GPU)', station.gpu),
              const Divider(color: Colors.white12),
              _buildSpecRow(Icons.speed, 'Memory (RAM)', station.ram),
              const Divider(color: Colors.white12),
              _buildSpecRow(Icons.tv, 'Gaming Monitor', station.monitor),
              const Divider(color: Colors.white12),
              _buildSpecRow(Icons.keyboard, 'Peripherals', station.peripherals),
              const SizedBox(height: 12),
              Text(
                'Pre-installed Popular Games:',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: station.games.map((game) {
                  return Chip(
                    label: Text(game, style: const TextStyle(fontSize: 11, color: Colors.white)),
                    backgroundColor: cardNavyLighter,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0B1736),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showReservePcBottomSheet(station);
            },
            child: const Text('Reserve This PC', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Containment Widget: Confirmation Dialog for Sign Out
  void _confirmSignOut() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: cardNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white24),
        ),
        title: const Text('Sign Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to end your session on ReserveIT Cafe?',
          style: TextStyle(color: secondaryTextColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Gamer Member';

    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        backgroundColor: cardNavy,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/logo.png',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'ReserveIT',
              style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 1.5, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Cafe Alerts',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active PC alerts. Your session timer is normal.')),
              );
            },
          ),
        ],
      ),

      // Material Component: Navigation Drawer (Official Flutter Material docs pattern)
      drawer: NavigationDrawer(
        backgroundColor: cardNavy,
        indicatorColor: Colors.white24,
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 52,
                    width: 52,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'ReserveIT',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Computer Cafe • $userEmail',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          ...destinations.map((ExampleDestination destination) {
            return NavigationDrawerDestination(
              label: Text(
                destination.label,
                style: const TextStyle(color: Colors.white),
              ),
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            );
          }),

          // Containment Widget: Divider
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 10),
            child: Divider(color: Colors.white24),
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
            onTap: _confirmSignOut,
          ),
        ],
      ),

      backgroundColor: backgroundColor,

      // Dashboard View and Destination Switching
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _buildScreenContent(userEmail),
        ),
      ),

      // Material Component: Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReservePcBottomSheet(),
        icon: const Icon(Icons.desktop_windows, color: Color(0xFF0B1736)),
        label: const Text(
          'Reserve PC',
          style: TextStyle(color: Color(0xFF0B1736), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  // Dynamic View Content based on NavigationDrawer Destination
  Widget _buildScreenContent(String userEmail) {
    switch (screenIndex) {
      case 0:
        return _buildDashboardView(userEmail);
      case 1:
        return _buildBookingsView();
      case 2:
        return _buildStationsView();
      case 3:
        return _buildProfileView(userEmail);
      case 4:
        return _buildSettingsView();
      default:
        return _buildDashboardView(userEmail);
    }
  }

  // 1. Dashboard View (Computer Cafe Overview)
  Widget _buildDashboardView(String userEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Header
        Text(
          'ReserveIT Gaming Cafe',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome, $userEmail • Fast PC Station Booking',
          style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 13),
        ),

        const SizedBox(height: 20),

        // Containment Widget: Card (Cafe Live Status Banner)
        Card(
          color: cardNavy,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.speed, color: Color(0xFF0B1736)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live Station Status',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const Text(
                              '18 / 24 Gaming Rigs Free',
                              style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Chip(
                      label: Text('OPEN 24/7', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      backgroundColor: accentBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Book your preferred gaming station in advance. High-refresh OLED monitors, RTX 40-Series graphics, and ultra-fast 1 Gbps fiber connection.',
                  style: GoogleFonts.poppins(fontSize: 13, color: secondaryTextColor),
                ),
                const SizedBox(height: 16),
                // Material Action Button: FilledButton.icon
                FilledButton.icon(
                  onPressed: () => _showReservePcBottomSheet(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0B1736),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.flash_on, color: Color(0xFF0B1736)),
                  label: const Text(
                    'Instant PC Booking',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        // Section Title: Available Gaming Stations & Specs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available PC Stations & Specs',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tap for specs',
              style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List of Containment Cards for PC Stations
        ...samplePcStations.map((station) => _buildStationCard(station)),
      ],
    );
  }

  // Helper Widget: PC Station Containment Card
  Widget _buildStationCard(PcStation station) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: cardNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Colors.white12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: cardNavyLighter,
                        child: Icon(
                          station.zone.contains('VIP')
                              ? Icons.workspace_premium
                              : station.zone.contains('Esports')
                                  ? Icons.military_tech
                                  : Icons.desktop_windows,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            station.zone,
                            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: station.isAvailable ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: station.isAvailable ? Colors.greenAccent : Colors.redAccent,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      station.isAvailable ? 'AVAILABLE' : 'OCCUPIED',
                      style: TextStyle(
                        color: station.isAvailable ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Specs summary pills
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardNavyLighter,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.videogame_asset, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            station.gpu,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.tv, size: 16, color: Colors.white70),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            station.monitor,
                            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    station.rate,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                        ),
                        onPressed: () => _showPcSpecsDialog(station),
                        child: const Text('View Specs'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: station.isAvailable ? Colors.white : Colors.white24,
                          foregroundColor: const Color(0xFF0B1736),
                        ),
                        onPressed: station.isAvailable ? () => _showReservePcBottomSheet(station) : null,
                        child: const Text('Book', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. My PC Bookings View
  Widget _buildBookingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Active PC Sessions',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track your current gaming playtime and upcoming station bookings.',
          style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 13),
        ),
        const SizedBox(height: 20),
        Card(
          color: cardNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.white12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Session: VIP Rig #01',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Chip(
                      label: Text('ACTIVE SESSION', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: accentBlue,
                    ),
                  ],
                ),
                const Divider(color: Colors.white12),
                const SizedBox(height: 6),
                const Text('Specs: RTX 4090 • 360Hz OLED 2K Display', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Time Remaining: 1 Hour 24 Mins (Ends at 4:15 PM)', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(backgroundColor: cardNavyLighter),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added +1 Hour to session.')),
                        );
                      },
                      child: const Text('+ Add 1 Hour', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Session ended. Thank you for playing at ReserveIT!')),
                        );
                      },
                      child: const Text('End Session'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 3. PC Stations & Specs View
  Widget _buildStationsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Cafe Rigs & Hardware',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Filter through our high-performance stations and verify hardware specs.',
          style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 13),
        ),
        const SizedBox(height: 20),
        ...samplePcStations.map((station) => _buildStationCard(station)),
      ],
    );
  }

  // 4. Gamer Profile View
  Widget _buildProfileView(String userEmail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gamer Membership Profile',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: cardNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.sports_esports, size: 40, color: Color(0xFF0B1736)),
                ),
                const SizedBox(height: 12),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gold VIP Member • ReserveIT Cafe',
                  style: GoogleFonts.poppins(color: secondaryTextColor, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const ListTile(
                  leading: Icon(Icons.account_balance_wallet, color: Colors.white),
                  title: Text('Prepaid Cafe Balance', style: TextStyle(color: Colors.white)),
                  trailing: Text('₱450.00', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const ListTile(
                  leading: Icon(Icons.timer, color: Colors.white),
                  title: Text('Total Hours Played', style: TextStyle(color: Colors.white)),
                  trailing: Text('48.5 hrs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 5. Cafe Settings View
  Widget _buildSettingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cafe Settings',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: cardNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white12),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Playtime Warning Alerts', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Notify me 10 minutes before PC session expires', style: TextStyle(color: secondaryTextColor)),
                value: true,
                onChanged: (val) {},
              ),
              const Divider(color: Colors.white12),
              const ListTile(
                leading: Icon(Icons.wifi, color: Colors.white70),
                title: Text('High-Speed Cafe Wi-Fi', style: TextStyle(color: Colors.white)),
                subtitle: Text('Connected to ReserveIT-5G (1 Gbps)', style: TextStyle(color: secondaryTextColor)),
                trailing: Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
