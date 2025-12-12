import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Trading/Fintech styled app bar with theme toggle
class TradingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userName;
  final VoidCallback onLogout;
  final VoidCallback onThemeToggle;
  final ThemeMode currentThemeMode;
  final List<Widget>? additionalActions;

  const TradingAppBar({
    Key? key,
    required this.title,
    required this.userName,
    required this.onLogout,
    required this.onThemeToggle,
    required this.currentThemeMode,
    this.additionalActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        if (additionalActions != null) ...additionalActions!,
        // Theme Toggle
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: AppColors.textSecondary,
          ),
          onPressed: onThemeToggle,
          tooltip: 'Toggle theme',
        ),
        // User Menu
        PopupMenuButton<String>(
          icon: Icon(
            Icons.account_circle_outlined,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          ),
          onSelected: (value) {
            if (value == 'logout') {
              onLogout();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryMain,
                      fontSize: 14,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.negativeTrend, size: 20),
                  const SizedBox(width: 8),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Trading styled drawer
class TradingDrawer extends StatelessWidget {
  final String userName;
  final String userRole;
  final int selectedIndex;
  final List<Map<String, dynamic>> menuItems;
  final Function(int) onMenuItemSelected;

  const TradingDrawer({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.selectedIndex,
    required this.menuItems,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkPaper : AppColors.lightPaper;
    final dividerColor = isDark ? AppColors.divider : AppColors.dividerLight;

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          // Header with user info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.primaryMain,
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    userRole,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedIndex == index;
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryMain.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primaryMain,
                            width: 1,
                          )
                        : null,
                  ),
                  child: ListTile(
                    leading: Icon(
                      item['icon'],
                      color: isSelected
                          ? AppColors.primaryMain
                          : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
                      size: 22,
                    ),
                    title: Text(
                      item['label'],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryMain
                            : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    selected: isSelected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Trading styled card
class TradingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const TradingCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

/// Trading styled stat card (like portfolio value card)
class TradingStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? change;
  final bool? isPositive;
  final VoidCallback? onTap;

  const TradingStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.change,
    this.isPositive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TradingCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primaryMain).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? AppColors.primaryMain,
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? AppColors.textDisabled : AppColors.textDisabledLight,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          if (change != null && isPositive != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive! ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositive! ? AppColors.positiveTrend : AppColors.negativeTrend,
                ),
                const SizedBox(width: 4),
                Text(
                  change!,
                  style: TextStyle(
                    color: isPositive! ? AppColors.positiveTrend : AppColors.negativeTrend,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Section header for lists
class TradingSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const TradingSectionHeader({
    Key? key,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Stock/Asset list tile (can be repurposed for schedules, grades, etc.)
class TradingListTile extends StatelessWidget {
  final String code; // e.g., "MTK-101"
  final String name; // e.g., "Matematika"
  final String value; // e.g., "A" or "85"
  final String? subtitle; // e.g., "08:00 - 09:30"
  final bool? isPositive;
  final VoidCallback? onTap;

  const TradingListTile({
    Key? key,
    required this.code,
    required this.name,
    required this.value,
    this.subtitle,
    this.isPositive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TradingCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          // Code Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryMain.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.primaryMain.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.primaryMain,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Name & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Value
          Text(
            value,
            style: TextStyle(
              color: isPositive != null
                  ? (isPositive! ? AppColors.positiveTrend : AppColors.negativeTrend)
                  : AppColors.primaryMain,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip for filtering views
class TradingFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TradingFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryMain : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryMain
                : (isDark ? AppColors.divider : AppColors.dividerLight),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textPrimary : AppColors.textPrimaryLight),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
