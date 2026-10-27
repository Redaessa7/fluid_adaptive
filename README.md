# Fluid Adaptive for Flutter 🚀

[![Dart](https://img.shields.io/badge/Dart-3.13+-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

A modern, robust, and truly adaptive responsive design architecture for Flutter.

Built to replace blind-scaling libraries (like `flutter_screenutil`) with **content-budgeting**, **adaptive multi-column layouts**, **symmetric dynamic gutters**, **fluid clamped sizing**, and **jitter-free window metrics**.

---

## 🛑 Why Traditional Scaling Libraries (ScreenUtil) Fail

| Problem | `flutter_screenutil` (Blind Scaling) | `fluid_adaptive` (Adaptive Architecture) |
|---|---|---|
| **Tablets & iPads** | Multiplies buttons and text by ~2.5x, turning UIs into giant inflated phone screens. | Keeps ergonomic phone sizing, budgets content width (`contentMaxWidth`), and increases information density (multi-column layouts). |
| **Local Subtrees & Split Views** | Always looks at full device screen width; breaks inside dialogs, bottom sheets, and split-screen views. | Uses `LayoutBuilder` local constraints; a 400px panel inside a desktop layout acts like a phone regardless of screen size. |
| **Keyboard Jitter & Rotations** | Naive listeners drop 30+ frames when the keyboard pops up due to continuous rebuild storms. | `ResponsiveWindowGate` differentiates keyboard insets (debounced) from real rotation/resizes (rebuilt immediately). |
| **Accessibility (Font Scaling)** | Hardcodes fixed `.sp` multiplications that battle against the user's OS accessibility text scaler. | Integrates with `MediaQuery.textScalerOf(context)` and applies safety clamps without breaking card layouts. |
| **Foldables & Desktop Windows** | Glitches when windows resize dynamically or fold/unfold. | Real-time classification: `compact`, `medium`, `expanded`, and `large`. |

---

## 📦 Key Concepts & Architecture

### 1. Window Size Classes (Material 3 Standard)
Instead of checking device models or orientation, layouts adapt according to the width available to the widget:
- **`compact`** (`< 600dp`): Single-column vertical phone rhythm.
- **`medium`** (`600dp - 839dp`): Small tablets, unfolded foldables, landscape phones (2-column grids/split view).
- **`expanded`** (`840dp - 1199dp`): Large tablets, landscape foldables, small laptops.
- **`large`** (`>= 1200dp`): Desktop windows, ultra-wide displays.

### 2. Content Budgeting & Symmetrical Gutters
On wide displays, stretching a single column of text or buttons across the screen makes it unreadable.
- `ResponsiveCenter`: Constrains max width (defaults to `720dp`) and centers the content.
- `ResponsiveGutters.sideOf(width)`: Keeps standard `16dp` gutter on phones, but dynamically grows symmetric side padding on tablets:
  $$\text{sideGutter} = \max(\text{compactGutter}, \frac{\text{width} - \text{contentMaxWidth}}{2})$$

### 3. Fluid Clamped Dimensions
No runaway inflation! `ResponsiveSpacing.fluid` or `context.responsiveFluid`:
```dart
// Smoothly scales from 14pt (at 375dp width) to 20pt (at 1200dp width)
// Clamped: never shrinks below 14pt, never blows up past 20pt!
final fontSize = context.responsiveFluid(min: 14, max: 20);
```

---

## ⚡ Quick Start

### 1. Wrap your root in `ResponsiveWindowGate`
Eliminates keyboard rebuild storms and handles rotation flips immediately:

```dart
void main() {
  runApp(
    const ResponsiveWindowGate(
      child: MyApp(),
    ),
  );
}
```

### 2. Build Adaptive Screens with `context.responsive`

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = context.responsive;

    return Scaffold(
      // ResponsiveCenter prevents UI from stretching endlessly on tablets/desktop
      body: ResponsiveCenter(
        maxWidth: 800,
        child: SingleChildScrollView(
          padding: context.responsive.gutters(compact: 16, vertical: 16),
          child: Column(
            children: [
              Text(
                'Welcome',
                style: context.responsiveValue(
                  compact: Theme.of(context).textTheme.headlineSmall,
                  medium: Theme.of(context).textTheme.headlineMedium,
                  expanded: Theme.of(context).textTheme.headlineLarge,
                ),
              ),

              // Automatically switches between Column (mobile) and Row (tablet/desktop)
              ResponsiveRowColumn(
                spacing: 16,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: FilterSidebar(),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 3,
                    child: MainFeed(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## ⚡ Smart Numeric Extensions (Easy as ScreenUtil, but Safe!)

If you love the speed and simplicity of `16.w` or `14.sp`, but want **guaranteed safety against tablet-inflation and overflow**, use the built-in numeric extensions:

```dart
// 1. Clamped Fluid Scaling (Scales gently on larger viewports, never exceeds max)
Padding(padding: EdgeInsets.all(16.fluid(context, max: 24)))

// 2. Adaptive Screen Class Selection
width: 200.responsive(context, tablet: 320, desktop: 450)

// 3. Proportional Width/Height with Safety Clamps (Prevents ballooning)
width: 150.clampedW(context)  // Clamped within [0.85x - 1.35x] of design width

// 4. Accessible & Clamped Typography
Text('Title', style: TextStyle(fontSize: 16.sp(context))) // Honors TextScaler safely

// 5. Quick Sized Gaps
16.gapH  // SizedBox(height: 16)
24.gapW  // SizedBox(width: 24)

// 6. Standard 8-point Design Spacing Tokens
SizedBox(height: context.spacing.md) // 16 on phone, 20 on wide screens
```

---

## 🛠️ Adaptive Widgets Suite

### `ResponsiveLayout`
Declarative widget switching based on breakpoint class:
```dart
ResponsiveLayout(
  compact: (context) => MobileLayout(),
  medium: (context) => TabletLayout(),
  expanded: (context) => DesktopLayout(),
)
```

### `ResponsiveCenter`
Capping content width with symmetric margin centering:
```dart
ResponsiveCenter(
  maxWidth: 720,
  child: ProfileForm(),
)
```

### `ResponsiveGridView`
Auto-calculates column count based on available space and minimum tile width:
```dart
ResponsiveGridView.builder(
  minTileWidth: 170, // Each tile gets at least 170dp
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(items[index]),
)
```

### `ResponsiveRowColumn`
Replaces nested Row/Column boilerplate:
```dart
ResponsiveRowColumn(
  spacing: 12,
  isRow: (info) => info.isWide, // Row on tablet/desktop, Column on phone
  children: [
    ResponsiveRowColumnItem(child: WidgetA()),
    ResponsiveRowColumnItem(child: WidgetB()),
  ],
)
```

---

## 📐 BuildContext Extensions Cheatsheet

```dart
// Booleans
context.isCompact   // < 600dp (Phone)
context.isMedium    // 600 - 839dp (Tablet/Foldable)
context.isExpanded  // 840 - 1199dp (Large tablet/Desktop)
context.isWide      // >= 600dp (Multi-column viewports)
context.isLandscape // width > height

// Values
context.responsiveValue<int>(compact: 1, medium: 2, expanded: 4);
context.responsiveGutter(compact: 16);
context.responsiveColumns(minTileWidth: 180);
context.responsiveSpacing(compact: 12, medium: 16, expanded: 24);
context.responsiveFluid(min: 14, max: 20);
```

---

## 🧪 Testing

The library is fully covered with comprehensive unit and widget tests:
```bash
flutter test
flutter analyze
```

---

## 📄 License
MIT License. Created by Reda Essa.
