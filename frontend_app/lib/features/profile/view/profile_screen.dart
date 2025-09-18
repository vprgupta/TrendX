import 'package:flutter/material.dart';
import 'preferences_screen.dart';
import 'saved_trends_screen.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  
  const ProfileScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(context, colorScheme),
            const SizedBox(height: 24),
            _buildStatsCards(context, colorScheme),
            const SizedBox(height: 24),
            _buildMenuItems(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ColorScheme colorScheme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 50,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Trend Explorer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(context, colorScheme, 'Following', '1.2k', Icons.people_outline),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(context, colorScheme, 'Bookmarks', '89', Icons.bookmark_outline),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(context, colorScheme, 'Views', '5.4k', Icons.visibility_outlined),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, ColorScheme colorScheme, String label, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, ColorScheme colorScheme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.tune,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Customize your content preferences',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferencesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              widget.isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: widget.isDarkMode,
              onChanged: (_) => widget.onThemeToggle(),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Manage alerts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark_outline,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Saved Trends',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Your bookmarks',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedTrendsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Get assistance',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: colorScheme.onSurfaceVariant,
            ),
            title: Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'App information',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            subtitle: Text(
              'Sign out of your account',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _authController.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}