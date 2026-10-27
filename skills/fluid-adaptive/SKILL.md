---
name: fluid-adaptive
description: "Expert guide and coding standards for building adaptive, jitter-free responsive Flutter applications using fluid_adaptive. Eliminates blind scaling bugs on tablets, foldables, and desktops."
---

# Fluid Adaptive Expert Guide

Use this skill whenever you write Flutter UI code, build responsive screens, or adapt designs across Mobile (iOS/Android), Tablets/iPads, Foldables, and Web/Desktop.

## 🛑 Fundamental Philosophy (Never Use Blind Scaling)

Traditional libraries like `flutter_screenutil` multiply every value by a scale ratio (`16.w`, `20.h`), turning tablet and desktop UIs into giant, blown-up phone screens with ballooned buttons and broken layouts.

**Golden Rule:**
- **Phones:** Preserve compact ergonomic single-column rhythm.
- **Tablets & Desktops:** Do **NOT** blow up UI elements. Instead, **increase information density** (more columns, split views) and **budget content width** (`ResponsiveCenter`).

---

## 🏗️ 1. App Root Setup (Zero Keyboard Jitter)

Wrap your root widget in `ResponsiveWindowGate`. This differentiates orientation/window resizing from keyboard show/hide, eliminating 30+ dropped frames during typing:

```dart
import 'package:flutter/material.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  runApp(
    const ResponsiveWindowGate(
      child: MyApp(),
    ),
  );
}
```

---

## 📱 2. Window Size Classes (Material 3 Standard)

Always check semantic window size classes rather than device hardware:
- `context.isCompact` (`< 600dp`): Phone vertical rhythm.
- `context.isMedium` (`600dp - 839dp`): Small tablet, landscape phone, unfolded foldable.
- `context.isExpanded` (`840dp - 1199dp`): Large tablet, landscape foldable, small laptop.
- `context.isLarge` (`>= 1200dp`): Desktop, ultra-wide display.
- `context.isWide` (`>= 600dp`): Any screen suitable for multi-column content.

---

## 🎨 3. Best Practices & Patterns

### A. Centered Content Budgeting (`ResponsiveCenter`)
For detail pages, auth screens, settings, and forms, never allow text fields or cards to stretch 1000px wide across a tablet:

```dart
Scaffold(
  body: ResponsiveCenter(
    maxWidth: 720, // Content is centered and capped at 720dp on wide viewports
    child: LoginForm(),
  ),
)
```

### B. Dynamic Symmetric Gutters
Use `context.responsive.gutters()` for horizontal page padding. It keeps standard `16dp` on phones, and grows symmetrically on tablets:

```dart
SingleChildScrollView(
  padding: context.responsive.gutters(compact: 16, vertical: 16),
  child: Column(...),
)
```

### C. Adaptive Switching (`ResponsiveRowColumn`)
Switches between `Column` (phones) and `Row` (tablets/desktops) without boilerplate:

```dart
ResponsiveRowColumn(
  spacing: 16,
  isRow: (info) => info.isWide,
  children: [
    ResponsiveRowColumnItem(
      rowFlex: 1,
      child: Sidebar(),
    ),
    ResponsiveRowColumnItem(
      rowFlex: 3,
      child: MainContent(),
    ),
  ],
)
```

### D. Adaptive Grids (`ResponsiveGridView` / `ResponsiveSliverGrid`)
Never hardcode `crossAxisCount: 2`. Use `minTileWidth` so columns adapt automatically:

```dart
ResponsiveGridView.builder(
  minTileWidth: 170, // Automatically allocates 2 cols on mobile, 4 on tablet, 6 on desktop
  itemCount: items.length,
  itemBuilder: (context, index) => ProductCard(items[index]),
)
```

### E. CustomScrollView & Slivers (`ResponsiveSliverCenter`)
In sliver layouts, center slivers on tablets using `ResponsiveSliverCenter`:

```dart
CustomScrollView(
  slivers: [
    ResponsiveSliverCenter(
      maxWidth: 800,
      sliver: SliverList(...),
    ),
  ],
)
```

---

## ⚡ 4. Fast & Safe Numeric Extensions

Use these for micro-adjustments instead of creating extra widgets:

| Task | Syntax | Why It Is Safe |
|---|---|---|
| **Adaptive dimension** | `200.responsive(context, tablet: 350)` | Pick exact values per screen tier |
| **Fluid gentle growth** | `16.fluid(context, max: 24)` | Scales smoothly between bounds, never balloons |
| **Clamped width** | `150.clampedW(context)` | Clamped between [0.85x, 1.35x] of design width |
| **Accessible font** | `16.sp(context)` | Respects OS font scaling with overflow safety cap |
| **Sized gaps** | `16.gapH` / `16.gapW` | Zero-boilerplate `SizedBox` |
| **8-point tokens** | `context.spacing.md` | Standard semantic tokens (16 phone, 20 tablet) |

---

## 🛡️ Cupertino & Material Agnostic

All widgets and extensions natively support both `MaterialApp` and `CupertinoApp`. When styling text, `16.sp(context)` and `ResponsiveTypography` seamlessly fall back to `CupertinoTheme` if `Theme` is absent.
