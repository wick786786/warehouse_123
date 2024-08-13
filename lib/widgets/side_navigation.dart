import 'package:flutter/material.dart';
import '../presentation/pages/device_list_page.dart'; // Import the new page
import '../presentation/pages/processed_list.dart';
import '../src/core/constants.dart'; // Import the constants
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideNavigation extends StatefulWidget {
  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  bool _isHoveringCompleted = false;
  bool _isHoveringUnderProcess = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color sidebarColor = theme.colorScheme.secondary;
    final TextStyle drawerHeaderStyle = theme.textTheme.headlineSmall ?? TextStyle();
    final TextStyle listItemStyle = theme.textTheme.bodyLarge ?? TextStyle();

    return Drawer(
      backgroundColor: sidebarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Icon(Icons.person, color: theme.colorScheme.onPrimary, size: 50),
                ),
                Center(
                  child: Text(
                    "Satyam",
                    style: drawerHeaderStyle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  icon: Icons.check_circle,
                  text: AppLocalizations.of(context)!.completed,
                  isHovering: _isHoveringCompleted,
                  onEnter: () => setState(() => _isHoveringCompleted = true),
                  onExit: () => setState(() => _isHoveringCompleted = false),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeviceListPage()),
                    );
                  },
                ),
                const SizedBox(height: 28),
                _buildNavItem(
                  icon: Icons.hourglass_empty,
                  text: AppLocalizations.of(context)!.underProcess,
                  isHovering: _isHoveringUnderProcess,
                  onEnter: () => setState(() => _isHoveringUnderProcess = true),
                  onExit: () => setState(() => _isHoveringUnderProcess = false),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Processing()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required bool isHovering,
    required VoidCallback onEnter,
    required VoidCallback onExit,
    required VoidCallback onTap,
  }) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final TextStyle listItemStyle = theme.textTheme.bodyLarge ?? TextStyle();

    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: primaryColor,
                size: 30,
                shadows: isHovering
                    ? [
                        Shadow(
                          color: primaryColor.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: listItemStyle,
            ),
          ],
        ),
      ),
    );
  }
}
