# Language Learning App

A Flutter Web application for language learning, deployed on GitHub Pages.

## Live Demo

🚀 **[View the Live Application](https://mazziabdeldjalil.github.io/language-learning-app/)**

## About This Project

This is a thesis project prototype demonstrating a language learning application built with Flutter and deployed as a static web application to GitHub Pages.

## Technology Stack

- **Framework**: Flutter
- **Platform**: Web (HTML5, Canvas)
- **Hosting**: GitHub Pages
- **Backend**: [Firebase/Supabase - as configured in your project]

## Local Development

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK

### Setup

```bash
# Clone the repository
git clone https://github.com/mazziabdeldjalil/language-learning-app.git
cd language-learning-app

# Get Flutter dependencies
flutter pub get

# Run development server
flutter run -d chrome
```

### Building for Web

```bash
# Clean previous builds
flutter clean

# Build optimized web release
flutter build web --web-renderer canvaskit

# Output will be in: build/web/
```

## Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for complete deployment instructions.

**Quick Deploy**:
```bash
flutter clean && flutter build web
# Copy build/web/* to repo root
git add . && git commit -m "Deploy" && git push origin main
```

## Project Structure

```
language-learning-app/
├── README.md           # This file
├── DEPLOYMENT.md       # Deployment instructions
├── .gitignore         # Git ignore rules
├── index.html         # Entry point (generated)
├── main.dart.js       # Main app code (generated)
├── flutter.js         # Flutter runtime (generated)
├── manifest.json      # PWA manifest (generated)
├── assets/            # Static assets (generated)
└── canvaskit/         # Canvas rendering engine (generated)
```

## Features

- ✨ Interactive language learning interface
- 📱 Responsive web design
- 🎨 Flutter UI components
- 🚀 Fast static site hosting

## Status

**Current Version**: Thesis Prototype
**Last Deployed**: [Check GitHub Pages settings]
**Status**: 🟢 Active

## License

This project is part of a thesis project.

## Contact

**Author**: Mazzi Abdeldjalil
**Repository**: [https://github.com/mazziabdeldjalil/language-learning-app](https://github.com/mazziabdeldjalil/language-learning-app)
