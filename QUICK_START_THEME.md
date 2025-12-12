# 🎨 Quick Start: Cyberpunk Theme

## How to Run the App

```bash
flutter run
```

## Default Theme
The app starts in **Dark Mode** by default for that true cyberpunk experience! 🌃

## Theme Toggle
Click the **sun/moon icon** in the top-right corner of any screen to switch between:
- 🌙 **Dark Cyberpunk** - Neon lights on dark backgrounds
- ☀️ **Light Cyberpunk** - Vibrant colors on light backgrounds

## Login Credentials

### Admin
- **Username**: `admin`
- **Password**: `admin123`

### Test the Theme
1. Open the app
2. Notice the animated grid background on the login page
3. Click the theme toggle button (top-right)
4. Watch the smooth transition between themes
5. Login and explore the dashboards with the new theme

## Color Scheme Preview

### Dark Theme
- **Background**: Deep Dark Blue
- **Primary**: Neon Pink (#FF006E)
- **Secondary**: Neon Blue (#00D9FF)
- **Accent**: Neon Purple (#B700FF)

### Light Theme  
- **Background**: Light Gray
- **Primary**: Bright Pink (#FF4081)
- **Secondary**: Bright Blue (#00B0FF)
- **Accent**: Purple (#9C27B0)

## Features to Notice

### ✨ Visual Effects
- Glowing neon borders on cards
- Gradient text in headers
- Animated grid background on login
- Smooth theme transitions
- Shadow glow effects on buttons

### 🎯 Typography
- UPPERCASE titles for that cyberpunk feel
- Increased letter spacing
- Bold, futuristic fonts

### 🎨 Components
- **Cards**: Neon borders with glow
- **Buttons**: Elevated style with shadows
- **Inputs**: Glowing focus effects
- **Drawer**: Gradient header
- **App Bar**: Gradient title text

## Using Cyberpunk Widgets

If you need to add new screens, use these components:

```dart
// Section Header
CyberpunkSectionHeader(
  title: 'My Section',
),

// Stat Card
CyberpunkStatCard(
  title: 'Total Users',
  value: '100',
  icon: Icons.person,
  color: CyberpunkColors.neonPink,
),

// Regular Card
CyberpunkCard(
  child: Text('Content here'),
),
```

## 🚀 Next Steps

1. Run the app and test both themes
2. Check out all the screens (Admin, Teacher, Student dashboards)
3. Notice the consistent design across all pages
4. Customize colors in `lib/utils/app_theme.dart` if desired

## 📝 Documentation

For complete documentation, see:
- **CYBERPUNK_THEME_GUIDE.md** - Full implementation details
- **lib/utils/app_theme.dart** - Theme configuration
- **lib/utils/cyberpunk_widgets.dart** - Reusable components

Enjoy your new cyberpunk-themed school management system! 🎉✨
