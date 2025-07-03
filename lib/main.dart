import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DeadTimeApp());
}

class DeadTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeadTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    
    _animationController.forward();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'DeadTime',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Transform dead time into digital gold',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'PWA Version - Works on any device!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(),
          OpportunitiesScreen(),
          EarningsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1A1A2E),
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Opportunities'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _isDetecting = true;
  String _currentStatus = 'Web monitoring active...';
  double _todayEarnings = 0.0;
  int _opportunitiesFound = 0;
  
  Timer? _detectionTimer;
  DateTime? _lastActivity;
  bool _isStationary = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(_pulseController);
    
    _startDetection();
    _loadTodayStats();
  }

  Future<void> _loadTodayStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todayEarnings = prefs.getDouble('today_earnings') ?? 0.0;
      _opportunitiesFound = prefs.getInt('opportunities_found') ?? 0;
    });
  }

  void _startDetection() {
    setState(() {
      _isDetecting = true;
      _currentStatus = 'Simulating dead time detection...';
    });

    // Simulate dead time detection every 30 seconds for demo
    _detectionTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (Random().nextBool()) {
        _simulateDeadTime();
      }
    });
  }

  void _simulateDeadTime() {
    if (!_isStationary) {
      setState(() {
        _isStationary = true;
        _currentStatus = 'Dead time detected!';
        _opportunitiesFound++;
      });
      _showOpportunityNotification();
    }
  }

  void _showOpportunityNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            '🎯 Opportunity Detected!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Dead time simulation detected. Would you like to earn money during this time?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Later', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startEarningOpportunity();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Start Earning'),
            ),
          ],
        );
      },
    );
  }

  void _startEarningOpportunity() async {
    double earning = Random().nextDouble() * 2.0 + 0.5;
    
    setState(() {
      _todayEarnings += earning;
      _isStationary = false;
      _currentStatus = 'Monitoring...';
    });
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('today_earnings', _todayEarnings);
    await prefs.setInt('opportunities_found', _opportunitiesFound);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Earned €${earning.toStringAsFixed(2)}!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ${_getTimeOfDay()}!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'PWA ready to monetize!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.web,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 30),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isDetecting ? Icons.radar : Icons.pause,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Text(
                      _currentStatus,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _isDetecting ? 'PWA demo monitoring active' : 'Detection paused',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Earnings',
                      '€${_todayEarnings.toStringAsFixed(2)}',
                      Icons.euro,
                      Color(0xFF4CAF50),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Opportunities',
                      '$_opportunitiesFound',
                      Icons.search,
                      Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 30),
              
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 15),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Pause Detection',
                      Icons.pause,
                      () {
                        setState(() {
                          _isDetecting = !_isDetecting;
                          _currentStatus = _isDetecting ? 'Monitoring...' : 'Paused';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildActionButton(
                      'Force Opportunity',
                      Icons.bolt,
                      () {
                        _simulateDeadTime();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xFF6C63FF).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF6C63FF), size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    int hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _detectionTimer?.cancel();
    super.dispose();
  }
}

class OpportunitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Opportunities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildOpportunityCard(context, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(BuildContext context, int index) {
    List<Map<String, dynamic>> opportunities = [
      {
        'title': 'Quick Survey',
        'description': 'Share your opinion on mobile apps',
        'reward': '€1.50',
        'duration': '3 min',
        'icon': Icons.poll,
        'color': Color(0xFF4CAF50),
      },
      {
        'title': 'Video Ad',
        'description': 'Watch a short promotional video',
        'reward': '€0.75',
        'duration': '30 sec',
        'icon': Icons.play_circle,
        'color': Color(0xFF2196F3),
      },
      {
        'title': 'Product Demo',
        'description': 'Try a new productivity app',
        'reward': '€2.25',
        'duration': '5 min',
        'icon': Icons.apps,
        'color': Color(0xFF9C27B0),
      },
      {
        'title': 'Location Check-in',
        'description': 'Verify business information',
        'reward': '€1.00',
        'duration': '1 min',
        'icon': Icons.location_on,
        'color': Color(0xFFFF9800),
      },
      {
        'title': 'Interactive Game',
        'description': 'Play a mini-game for rewards',
        'reward': '€1.75',
        'duration': '4 min',
        'icon': Icons.games,
        'color': Color(0xFFE91E63),
      },
    ];

    final opportunity = opportunities[index];

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: opportunity['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              opportunity['icon'],
              color: opportunity['color'],
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  opportunity['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.white54),
                    SizedBox(width: 4),
                    Text(
                      opportunity['duration'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                opportunity['reward'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _startOpportunity(context, opportunity);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('Start', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startOpportunity(BuildContext context, Map<String, dynamic> opportunity) async {
    final prefs = await SharedPreferences.getInstance();
    double currentEarnings = prefs.getDouble('today_earnings') ?? 0.0;
    double reward = double.parse(opportunity['reward'].replaceAll('€', ''));
    
    await prefs.setDouble('today_earnings', currentEarnings + reward);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Completed ${opportunity['title']}! Earned ${opportunity['reward']}'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

class EarningsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Earnings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Demo Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<double>(
                      future: _getTotalEarnings(),
                      builder: (context, snapshot) {
                        return Text(
                          '€${(snapshot.data ?? 24.75).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showWithdrawDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF6C63FF),
                      ),
                      child: Text('Withdraw (Demo)'),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 15),
              
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _buildActivityItem(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> _getTotalEarnings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('today_earnings') ?? 24.75;
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            '💳 Withdraw Earnings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'In the full version, you would be able to withdraw your earnings to:\n\n'
            '• PayPal\n'
            '• Bank Account\n'
            '• Crypto Wallet\n'
            '• Gift Cards\n\n'
            'This is a PWA demo version!',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityItem(int index) {
    List<Map<String, dynamic>> activities = [
      {'type': 'Survey', 'amount': '€1.50', 'time': '2 hours ago'},
      {'type': 'Video Ad', 'amount': '€0.75', 'time': '4 hours ago'},
      {'type': 'Product Demo', 'amount': '€2.25', 'time': '6 hours ago'},
      {'type': 'Check-in', 'amount': '€1.00', 'time': '1 day ago'},
      {'type': 'Game', 'amount': '€1.75', 'time': '1 day ago'},
    ];

    final activity = activities[index % activities.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.monetization_on,
              color: Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['type'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['amount'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF6C63FF),
                      child: Text(
                        'DT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'DeadTime PWA User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Progressive Web App Version',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileOption(
                      'Install as App',
                      Icons.download,
                      () => _showInstallInstructions(context),
                    ),
                    _buildProfileOption(
                      'PWA Features',
                      Icons.web,
                      () => _showPWAFeatures(context),
                    ),
                    _buildProfileOption(
                      'Demo Settings',
                      Icons.settings,
                      () => _showDemoSettings(context),
                    ),
                    _buildProfileOption(
                      'About PWA Version',
                      Icons.info,
                      () => _showAbout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF6C63FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF6C63FF),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white54,
        ),
        onTap: onTap,
        tileColor: Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showInstallInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            '📱 Install DeadTime PWA',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'To install DeadTime on your device:\n\n'
            '📱 iPhone/iPad:\n'
            '1. Open in Safari\n'
            '2. Tap Share button\n'
            '3. Select "Add to Home Screen"\n'
            '4. Tap "Add"\n\n'
            '🤖 Android:\n'
            '1. Open in Chrome\n'
            '2. Tap menu (3 dots)\n'
            '3. Select "Add to Home screen"\n'
            '4. Tap "Add"\n\n'
            '💻 Desktop:\n'
            '1. Look for install icon in address bar\n'
            '2. Click "Install"\n\n'
            'Works like a native app!',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  void _showPWAFeatures(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            '🚀 PWA Features',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'DeadTime PWA includes:\n\n'
            '✅ Works offline\n'
            '✅ App-like experience\n'
            '✅ Push notifications (web)\n'
            '✅ Local data storage\n'
            '✅ Responsive design\n'
            '✅ Auto-updates\n'
            '✅ Cross-platform\n'
            '✅ No app store needed\n'
            '✅ Small download size\n'
            '✅ Fast loading\n\n'
            'Future updates will add:\n'
            '• Real GPS tracking\n'
            '• Advanced sensors\n'
            '• Background sync\n'
            '• More opportunities',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Amazing!'),
            ),
          ],
        );
      },
    );
  }

  void _showDemoSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            '⚙️ Demo Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Current demo features:\n\n'
            '🎯 Simulated dead time detection\n'
            '💰 Virtual earnings system\n'
            '📊 Local data storage\n'
            '🎮 Interactive opportunities\n'
            '📱 PWA installation\n\n'
            'Demo limitations:\n'
            '• No real money transactions\n'
            '• Simulated GPS/sensors\n'
            '• Limited background processing\n\n'
            'Full version will include:\n'
            '• Real earnings\n'
            '• Advanced AI detection\n'
            '• Payment integration\n'
            '• Enterprise features',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Understood'),
            ),
          ],
        );
      },
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          title: Text(
            'ℹ️ About DeadTime PWA',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'DeadTime PWA Demo v1.0\n\n'
            '🚀 Built with Flutter Web\n'
            '📱 Progressive Web App\n'
            '🌐 Cross-platform compatible\n'
            '⚡ Lightning fast performance\n'
            '🔒 Secure and private\n'
            '🔄 Auto-updating\n\n'
            'Transform your dead time into digital gold!\n\n'
            'This PWA demonstrates the full potential of web-based mobile applications.\n\n'
            '© 2024 DeadTime. All rights reserved.\n'
            'PWA Technology Demo',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C63FF)),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
