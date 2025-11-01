import 'package:flutter/material.dart';
import '../platform/view/platform_screen.dart';
import '../country/view/country_screen.dart';
import '../world/view/world_screen.dart';
import '../technology/view/technology_screen.dart';
import '../profile/view/profile_screen.dart';
import '../news/view/news_screen.dart';

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
    const NewsScreen(),
    const CountryScreen(),
    const WorldScreen(),
    const TechnologyScreen(),
    ProfileScreen(onThemeToggle: widget.onThemeToggle, isDarkMode: widget.isDarkMode),
  ];

  final List<NavItem> _navItems = [
    NavItem(Icons.apps_outlined, Icons.apps, 'Platform', Colors.blue),
    NavItem(Icons.article_outlined, Icons.article, 'Shorts', Colors.red),
    NavItem(Icons.flag_outlined, Icons.flag, 'Country', Colors.green),
    NavItem(Icons.public_outlined, Icons.public, 'World', Colors.purple),
    NavItem(Icons.computer_outlined, Icons.computer, 'Technology', Colors.orange),
    NavItem(Icons.person_outline, Icons.person, 'Profile', Colors.teal),
  ];

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = _currentIndex == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? item.color.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isSelected && _animationController.isAnimating ? _scaleAnimation.value : 1.0,
                          child: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color: isSelected ? item.color : colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isSelected ? 11 : 9,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? item.color : colorScheme.onSurfaceVariant,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Color color;

  NavItem(this.icon, this.selectedIcon, this.label, this.color);
}