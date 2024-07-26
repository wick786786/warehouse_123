import 'package:flutter/material.dart';
import 'device_list_page.dart'; // Import the new page
import 'processed_list.dart';
import 'constants.dart'; // Import the constants

class SideNavigation extends StatefulWidget {
  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  bool _isHoveringCompleted = false;
  bool _isHoveringUnderProcess = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Icon(Icons.person, color: AppColors.whiteColor, size: 50),
                ),
                Center(
                  child: Text(
                    'Satyam',
                    style: AppTextStyles.drawerHeader,
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
                  text: 'Completed',
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
                SizedBox(height: 28),
                _buildNavItem(
                  icon: Icons.hourglass_empty,
                  text: 'Under Process',
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
      backgroundColor: AppColors.sidebarColor,
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
                color: AppColors.primaryColor,
                size: 30,
                shadows: isHovering
                    ? [
                        Shadow(
                          color: AppColors.primaryColor.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
            ),
            SizedBox(height: 6),
            Text(
              text,
              style: AppTextStyles.listItem,
            ),
          ],
        ),
      ),
    );
  }
}
