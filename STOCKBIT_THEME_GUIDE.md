# 📊 Stockbit/TradingView Theme Guide

## Overview
This app now uses a clean, professional trading app aesthetic inspired by Stockbit and TradingView platforms. The theme features a modern fintech design with subtle borders, clean typography, and a focused color palette.

---

## 🎨 Color Palette

### Primary Colors
- **Primary Blue**: `#1F3DA0` (Dark) / `#3E5CC9` (Light)
  - Used for primary actions, links, and key UI elements

### Trend Colors
- **Positive (Green)**: `#D8FE74` - Neon green for positive trends
- **Negative (Pink)**: `#F007E0` - Pink for negative trends/warnings

### Background Colors
#### Dark Theme
- **Background**: `#121212`
- **Surface**: `#1E1E1E`

#### Light Theme
- **Background**: `#F5F7FA`
- **Surface**: `#FFFFFF`

### Text Colors
- Automatically managed by Material Design 3 based on theme mode
- High contrast ratios for accessibility

---

## 📝 Typography

### Font System
Inspired by Gilroy font family:

- **Portfolio Values**: 32px, Weight 800
- **Section Headers**: 18px, Weight 700
- **Body Text**: 14px, Weight 400-600
- **Ticker Codes**: 14px, Weight 600, Uppercase

### Usage Guidelines
```dart
// Large values (portfolio, prices)
Text(
  '\$1,234.56',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
  ),
)

// Section headers
Text(
  'Portfolio',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  ),
)

// Body text
Text(
  'Regular content',
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
)
```

---

## 🧩 Components

### Cards
- **Border Radius**: 12px
- **Elevation**: 0 (flat design)
- **Border**: 1px subtle border using `colorScheme.outline`
- **Background**: Uses theme's surface color

```dart
TradingCard(
  child: YourContent(),
)
```

### App Bar
Clean header with theme toggle and user menu:

```dart
TradingAppBar(
  title: 'Dashboard',
  currentThemeMode: themeMode,
  onThemeToggle: () => toggleTheme(),
  currentUser: user,
  onLogout: () => handleLogout(),
)
```

### Navigation Drawer
Professional side navigation:

```dart
TradingDrawer(
  menuItems: menuItems,
  selectedIndex: selectedIndex,
  onItemTapped: (index) => setState(() => _selectedIndex = index),
  currentUser: user,
  currentThemeMode: themeMode,
  onThemeToggle: () => toggleTheme(),
  onLogout: () => handleLogout(),
)
```

### Stat Cards
Portfolio-style statistics display:

```dart
TradingStatCard(
  label: 'Total Students',
  value: '142',
  icon: Icons.people,
  trend: '+5.2%',
  isPositive: true,
)
```

### List Tiles
Trading asset list style:

```dart
TradingListTile(
  title: 'Student Name',
  subtitle: 'Class 10A',
  trailing: '95.5',
  icon: Icons.person,
)
```

### Filter Chips
Clean filter selection:

```dart
TradingFilterChip(
  label: 'All',
  isSelected: selectedFilter == 'all',
  onSelected: (selected) => handleFilter('all'),
)
```

---

## 🎯 Design Principles

### 1. Clean & Minimal
- No heavy shadows or glow effects
- Subtle 1px borders for definition
- Flat design with proper spacing

### 2. Professional Aesthetic
- Trading platform inspired
- Financial data-focused
- High information density without clutter

### 3. Accessibility
- High contrast ratios
- Clear typography hierarchy
- Consistent spacing system

### 4. Dark/Light Mode
- Seamless theme switching
- Colors optimized for both modes
- Consistent experience across themes

---

## 📂 File Structure

```
lib/
├── utils/
│   ├── app_theme.dart           # Theme configuration
│   └── trading_widgets.dart      # Reusable components
├── screens/
│   ├── login_page.dart
│   ├── admin_dashboard.dart
│   ├── teacher_dashboard.dart
│   └── student_dashboard.dart
└── main.dart
```

---

## 🚀 Implementation Guide

### Using the Theme

The theme is automatically applied app-wide through `main.dart`:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: currentThemeMode,
  // ...
)
```

### Accessing Colors

Always use theme colors instead of hardcoded values:

```dart
// ✅ Correct
color: Theme.of(context).colorScheme.primary

// ❌ Avoid
color: Color(0xFF1F3DA0)
```

### Custom Colors

Access custom colors from AppColors:

```dart
// Trend colors
color: AppColors.positiveTrend  // Neon green
color: AppColors.negativeTrend  // Pink

// Primary colors
color: AppColors.primaryDark    // #1F3DA0
color: AppColors.primaryLight   // #3E5CC9
```

---

## 🔧 Customization

### Changing Primary Color

Edit `app_theme.dart`:

```dart
static const Color primaryDark = Color(0xFF1F3DA0);  // Change this
static const Color primaryLight = Color(0xFF3E5CC9); // Change this
```

### Adding New Colors

Add to `AppColors` class:

```dart
class AppColors {
  // Existing colors...
  
  static const Color yourNewColor = Color(0xFFXXXXXX);
}
```

### Creating Custom Widgets

Follow the pattern in `trading_widgets.dart`:

```dart
class YourCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: YourContent(),
    );
  }
}
```

---

## ✨ Key Features

1. **Theme Toggle**
   - Available in AppBar and Drawer
   - Persistent across app restart
   - Smooth transition animations

2. **Responsive Design**
   - Adapts to different screen sizes
   - Consistent spacing system
   - Touch-friendly tap targets

3. **Component Library**
   - Pre-built trading-style widgets
   - Consistent design language
   - Easy to use and customize

4. **Material Design 3**
   - Modern design system
   - Built-in accessibility
   - Native platform feel

---

## 📱 Screenshots Reference

The design is inspired by:
- **Stockbit**: Clean portfolio views, stat cards, asset lists
- **TradingView**: Professional charts, data tables, minimalist UI
- **Fintech Apps**: Modern banking interfaces, clean forms

---

## 🐛 Troubleshooting

### Theme not applying
```dart
// Make sure you're wrapping with MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
)
```

### Colors look wrong
```dart
// Always use Theme.of(context)
final colorScheme = Theme.of(context).colorScheme;
color: colorScheme.primary // Not AppColors directly in widgets
```

### Widgets not found
```dart
// Import trading widgets
import '../utils/trading_widgets.dart';
```

---

## 📚 Resources

- [Material Design 3](https://m3.material.io/)
- [Flutter Theming Guide](https://docs.flutter.dev/cookbook/design/themes)
- [Color Accessibility](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)

---

**Last Updated**: December 2024
**Theme Version**: 2.0 (Stockbit/Trading Inspired)
