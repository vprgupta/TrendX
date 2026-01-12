import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/view/home_screen.dart';
import '../platform/view/platform_screen.dart';
import '../country/view/country_screen.dart';
import '../world/view/world_screen.dart';
import '../technology/view/technology_screen.dart';
import '../profile/view/profile_screen.dart';
import '../../screens/reels_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/ui/glass_container.dart';
import '../../config/theme.dart';

class MainNavigation extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  
  const MainNavigation({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  List<Widget> get _screens => [
    const PlatformScreen(),
    const ReelsScreen(),
    const CountryScreen(),
    const TechnologyScreen(),
    ProfileScreen(onThemeToggle: widget.onThemeToggle, isDarkMode: widget.isDarkMode),
  ];

  final List<NavItem> _navItems = [
    NavItem(LucideIcons.layoutGrid, 'Platform', AppTheme.cyan),
    NavItem(LucideIcons.clapperboard, 'Shorts', AppTheme.violet),
    NavItem(LucideIcons.flag, 'Country', Colors.green),
    NavItem(LucideIcons.monitor, 'Tech', Colors.orange), 
    NavItem(LucideIcons.user, 'Profile', AppTheme.neonRed),
  ];
// ... rest of class unchanged ...
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (_currentIndex != index) {
      // Haptic Feedback for premium feel
      HapticFeedback.lightImpact();

      if (index == 2) { // Adjusted index for Reels check if needed
         // Reels might need full screen
      }
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to extend behind the fab/bottom bar
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
        bottomNavigationBar: GlassContainer(
          height: 85,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          margin: const EdgeInsets.only(top: 10),
          opacity: Theme.of(context).brightness == Brightness.dark ? 0.15 : 0.9,
          color: Theme.of(context).brightness == Brightness.dark ? null : Colors.white,
          blur: 20,
        child: SingleChildScrollView( // Added scroll to prevent overflow with 7 items
          scrollDirection: Axis.horizontal,
          child: Container(
             padding: const EdgeInsets.symmetric(horizontal: 10),
             width: MediaQuery.of(context).size.width,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _currentIndex == index;
                
                return GestureDetector(
                  onTap: () => _onNavItemTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         AnimatedContainer(
                           duration: const Duration(milliseconds: 300),
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Wider capsule
                           decoration: BoxDecoration(
                             color: isSelected ? item.color.withOpacity(0.2) : Colors.transparent,
                             borderRadius: BorderRadius.circular(20), // Pill shape
                            border: isSelected ? Border.all(color: item.color.withOpacity(0.3), width: 1) : null,
                           ),
                           child: Icon(
                             item.icon,
                             // Keep icon color neutral but high contrast for premium feel
                             color: Theme.of(context).brightness == Brightness.dark 
                                 ? (isSelected ? Colors.white : Colors.white60)
                                 : (isSelected ? Colors.black : Colors.black54),
                             size: 26, // Slightly bigger
                           ),
                         ),
                         const SizedBox(height: 4),
                         AnimatedOpacity(
                           duration: const Duration(milliseconds: 200),
                           opacity: isSelected ? 1.0 : 0.6,
                           child: Text(
                             item.label,
                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
                               fontSize: 11,
                               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                               color: Theme.of(context).brightness == Brightness.dark 
                                   ? Colors.white 
                                   : Colors.black,
                             ),
                           ),
                         ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color color;

  NavItem(this.icon, this.label, this.color);
}
