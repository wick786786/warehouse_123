import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:warehouse_phase_1/presentation/pages/guidelines/help.dart';
import '../../DeviceListPage/device_list_page.dart';
import '../../processed_list.dart';
import '../../../../src/core/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideNavigation extends StatefulWidget {
  const SideNavigation({super.key});

  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  bool _isHoveringCompleted = false;
  bool _isHoveringUnderProcess = false;
  bool _isHoveringSettings = false;
  bool _isHoveringHelp = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color sidebarColor = theme.colorScheme.secondary;
    final TextStyle drawerHeaderStyle = theme.textTheme.headlineSmall ?? const TextStyle();
    final TextStyle listItemStyle = theme.textTheme.bodyLarge ?? const TextStyle();

    return Drawer(
      backgroundColor: sidebarColor,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
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
                  text: "trash",
                  isHovering: _isHoveringUnderProcess,
                  onEnter: () => setState(() => _isHoveringUnderProcess = true),
                  onExit: () => setState(() => _isHoveringUnderProcess = false),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Processing()),
                    );
                  },
                ),
                const SizedBox(height: 28),
                _buildNavItem(
                  icon: Icons.settings,
                  text: "settings",
                  isHovering: _isHoveringSettings,
                  onEnter: () => setState(() => _isHoveringSettings = true),
                  onExit: () => setState(() => _isHoveringSettings = false),
                  onTap: () {
                    // Implement your settings navigation
                    
                  },
                ),
                const SizedBox(height: 28),
                _buildNavItem(
                  icon: Icons.help_outline,
                  text: "help",
                  isHovering: _isHoveringHelp,
                  onEnter: () => setState(() => _isHoveringHelp = true),
                  onExit: () => setState(() => _isHoveringHelp = false),
                  onTap: () {
                    // Implement your help navigation
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Help()),
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

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        
      ),
      child: Center(
        child: Column(
          
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
              size:50,
            ),

            Text(
              "satyam",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String text,
    required bool isHovering,
    required Function() onEnter,
    required Function() onExit,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      onHover: (hovering) {
        if (hovering) {
          onEnter();
        } else {
          onExit();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isHovering
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isHovering
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isHovering
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
