import 'package:flutter/material.dart';
import 'package:fluid_adaptive/fluid_adaptive.dart';

void main() {
  runApp(const ResponsiveDemoApp());
}

class ResponsiveDemoApp extends StatelessWidget {
  const ResponsiveDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Adaptive Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final info = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text('Fluid Adaptive (${info.sizeClass.name.toUpperCase()})'),
        centerTitle: true,
      ),
      // 2. ResponsiveCenter ensures tablets/desktops don't stretch phone content infinitely
      body: ResponsiveCenter(
        maxWidth: 1000,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3. Smart Numeric Extensions Demo Card
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: EdgeInsets.all(context.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text already applies the user's text scale itself,
                      // so a plain fontSize is correct here.
                      Text(
                        'Smart numeric extensions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade900,
                        ),
                      ),
                      8.gapH,
                      Icon(Icons.text_fields, size: 24.textScaled(context, maxScaleFactor: 2)),
                      Text('• 24.textScaled(context) -> icon size that follows the text scale.'),
                      Text('• 16.fluid(context, max: 24) -> ${16.fluid(context, max: 24).toStringAsFixed(1)} dp'),
                      Text('• 100.clampedW(context) -> ${100.clampedW(context).toStringAsFixed(1)} dp (Never blows up on tablets!)'),
                      Text('• 200.responsive(context, medium: 350) -> ${200.responsive(context, medium: 350).toStringAsFixed(1)} dp'),
                      Text('• context.spacing.md -> ${context.spacing.md} dp'),
                    ],
                  ),
                ),
              ),

              context.spacing.md.gapH,

              // 4. Metrics Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Viewport Metrics',
                        style: context.responsive.isCompact
                            ? Theme.of(context).textTheme.titleMedium
                            : Theme.of(context).textTheme.titleLarge,
                      ),
                      8.gapH,
                      Text('• Size Class: ${info.sizeClass.name}'),
                      Text('• Local Width: ${info.localWidth.toStringAsFixed(1)} dp'),
                      Text('• Window Width: ${info.windowSize.width.toStringAsFixed(1)} dp'),
                      Text('• Is Wide (>=600): ${info.isWide}'),
                      Text('• Calculated Gutters: ${info.gutter(compact: 16).toStringAsFixed(1)} dp'),
                      Text('• Fluid Heading Size: ${info.fluid(min: 16, max: 28).toStringAsFixed(1)} pt'),
                    ],
                  ),
                ),
              ),

              context.spacing.md.gapH,

              // 5. ResponsiveRowColumn: Stacks vertically on phones, side-by-side on tablets!
              ResponsiveRowColumn(
                spacing: 12,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Side Navigation / Filter', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Switches from top banner to sidebar on wide screens.'),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Main Content Area', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Takes more space horizontally on wider screens without stretched text.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              context.spacing.lg.gapH,

              Text(
                'Adaptive Product / Service Grid',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              12.gapH,

              // 6. ResponsiveGridView: Automatically calculates column count using minTileWidth!
              ResponsiveGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                minTileWidth: 160,
                itemCount: 8,
                childAspectRatio: 1.2,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.teal.shade50,
                    child: Center(
                      child: Text('Service Item #${index + 1}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
