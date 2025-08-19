import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0d631b),
      surfaceTint: Color(0xff1b6d24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2e7d32),
      onPrimaryContainer: Color(0xffcbffc2),
      secondary: Color(0xff476644),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc6e9be),
      onSecondaryContainer: Color(0xff4c6a48),
      tertiary: Color(0xff005a8e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff0073b4),
      onTertiaryContainer: Color(0xffeaf2ff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7fbf0),
      onSurface: Color(0xff181d17),
      onSurfaceVariant: Color(0xff40493d),
      outline: Color(0xff707a6c),
      outlineVariant: Color(0xffbfcaba),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322b),
      inversePrimary: Color(0xff88d982),
      primaryFixed: Color(0xffa3f69c),
      onPrimaryFixed: Color(0xff002204),
      primaryFixedDim: Color(0xff88d982),
      onPrimaryFixedVariant: Color(0xff005312),
      secondaryFixed: Color(0xffc9ecc1),
      onSecondaryFixed: Color(0xff052106),
      secondaryFixedDim: Color(0xffadd0a6),
      onSecondaryFixedVariant: Color(0xff304e2e),
      tertiaryFixed: Color(0xffcee5ff),
      onTertiaryFixed: Color(0xff001d33),
      tertiaryFixedDim: Color(0xff97cbff),
      onTertiaryFixedVariant: Color(0xff004a76),
      surfaceDim: Color(0xffd7dbd2),
      surfaceBright: Color(0xfff7fbf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5eb),
      surfaceContainer: Color(0xffebefe5),
      surfaceContainerHigh: Color(0xffe5eadf),
      surfaceContainerHighest: Color(0xffe0e4da),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00400c),
      surfaceTint: Color(0xff1b6d24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2e7d32),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff203d1e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff567551),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00395c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff0073b4),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf0),
      onSurface: Color(0xff0e120d),
      onSurfaceVariant: Color(0xff30392d),
      outline: Color(0xff4c5549),
      outlineVariant: Color(0xff667062),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322b),
      inversePrimary: Color(0xff88d982),
      primaryFixed: Color(0xff2d7c31),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0c631b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff567551),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3e5c3b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff0072b2),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00598c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8be),
      surfaceBright: Color(0xfff7fbf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5eb),
      surfaceContainer: Color(0xffe5eadf),
      surfaceContainerHigh: Color(0xffdaded4),
      surfaceContainerHighest: Color(0xffcfd3c9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003508),
      surfaceTint: Color(0xff1b6d24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005613),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff163215),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff335030),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002e4d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004d7a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf0),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262e24),
      outlineVariant: Color(0xff424c40),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322b),
      inversePrimary: Color(0xff88d982),
      primaryFixed: Color(0xff005613),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003c0a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff335030),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1c391b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004d7a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003557),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6bab1),
      surfaceBright: Color(0xfff7fbf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef2e8),
      surfaceContainer: Color(0xffe0e4da),
      surfaceContainerHigh: Color(0xffd1d6cc),
      surfaceContainerHighest: Color(0xffc3c8be),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff88d982),
      surfaceTint: Color(0xff88d982),
      onPrimary: Color(0xff003909),
      primaryContainer: Color(0xff2e7d32),
      onPrimaryContainer: Color(0xffcbffc2),
      secondary: Color(0xffadd0a6),
      onSecondary: Color(0xff1a3719),
      secondaryContainer: Color(0xff304e2e),
      onSecondaryContainer: Color(0xff9cbe95),
      tertiary: Color(0xff97cbff),
      onTertiary: Color(0xff003353),
      tertiaryContainer: Color(0xff0073b4),
      onTertiaryContainer: Color(0xffeaf2ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff10150f),
      onSurface: Color(0xffe0e4da),
      onSurfaceVariant: Color(0xffbfcaba),
      outline: Color(0xff8a9485),
      outlineVariant: Color(0xff40493d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff1b6d24),
      primaryFixed: Color(0xffa3f69c),
      onPrimaryFixed: Color(0xff002204),
      primaryFixedDim: Color(0xff88d982),
      onPrimaryFixedVariant: Color(0xff005312),
      secondaryFixed: Color(0xffc9ecc1),
      onSecondaryFixed: Color(0xff052106),
      secondaryFixedDim: Color(0xffadd0a6),
      onSecondaryFixedVariant: Color(0xff304e2e),
      tertiaryFixed: Color(0xffcee5ff),
      onTertiaryFixed: Color(0xff001d33),
      tertiaryFixedDim: Color(0xff97cbff),
      onTertiaryFixedVariant: Color(0xff004a76),
      surfaceDim: Color(0xff10150f),
      surfaceBright: Color(0xff363b34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff181d17),
      surfaceContainer: Color(0xff1c211b),
      surfaceContainerHigh: Color(0xff262b25),
      surfaceContainerHighest: Color(0xff31362f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9df096),
      surfaceTint: Color(0xff88d982),
      onPrimary: Color(0xff002d06),
      primaryContainer: Color(0xff53a252),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc3e6bb),
      onSecondary: Color(0xff0f2b0f),
      secondaryContainer: Color(0xff799973),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc3dfff),
      onTertiary: Color(0xff002843),
      tertiaryContainer: Color(0xff4296da),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10150f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd5dfcf),
      outline: Color(0xffabb5a6),
      outlineVariant: Color(0xff899385),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff005412),
      primaryFixed: Color(0xffa3f69c),
      onPrimaryFixed: Color(0xff001602),
      primaryFixedDim: Color(0xff88d982),
      onPrimaryFixedVariant: Color(0xff00400c),
      secondaryFixed: Color(0xffc9ecc1),
      onSecondaryFixed: Color(0xff001602),
      secondaryFixedDim: Color(0xffadd0a6),
      onSecondaryFixedVariant: Color(0xff203d1e),
      tertiaryFixed: Color(0xffcee5ff),
      onTertiaryFixed: Color(0xff001223),
      tertiaryFixedDim: Color(0xff97cbff),
      onTertiaryFixedVariant: Color(0xff00395c),
      surfaceDim: Color(0xff10150f),
      surfaceBright: Color(0xff41463f),
      surfaceContainerLowest: Color(0xff050804),
      surfaceContainerLow: Color(0xff1a1f19),
      surfaceContainer: Color(0xff242923),
      surfaceContainerHigh: Color(0xff2f342d),
      surfaceContainerHighest: Color(0xff3a3f38),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc5ffbc),
      surfaceTint: Color(0xff88d982),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff84d57f),
      onPrimaryContainer: Color(0xff000f01),
      secondary: Color(0xffd6face),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffaacca2),
      onSecondaryContainer: Color(0xff000f01),
      tertiary: Color(0xffe7f1ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff8fc8ff),
      onTertiaryContainer: Color(0xff000c19),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff10150f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe9f3e2),
      outlineVariant: Color(0xffbcc6b6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4da),
      inversePrimary: Color(0xff005412),
      primaryFixed: Color(0xffa3f69c),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff88d982),
      onPrimaryFixedVariant: Color(0xff001602),
      secondaryFixed: Color(0xffc9ecc1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffadd0a6),
      onSecondaryFixedVariant: Color(0xff001602),
      tertiaryFixed: Color(0xffcee5ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff97cbff),
      onTertiaryFixedVariant: Color(0xff001223),
      surfaceDim: Color(0xff10150f),
      surfaceBright: Color(0xff4d514a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211b),
      surfaceContainer: Color(0xff2d322b),
      surfaceContainerHigh: Color(0xff383d36),
      surfaceContainerHighest: Color(0xff434841),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
