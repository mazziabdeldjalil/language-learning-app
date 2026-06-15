# Language Learning App - Deployment Guide

## Deployment to GitHub Pages

This repository is configured to deploy the Flutter Web build output to GitHub Pages.

### Prerequisites
- Flutter SDK installed
- Git configured
- Local repository cloned: `C:\Users\Ztr\Desktop\M2B\THESIS\Prototype Test\language_learning_app`

### Deployment Steps

1. **Clean and build Flutter Web**
   ```bash
   cd C:\Users\Ztr\Desktop\M2B\THESIS\Prototype Test\language_learning_app
   flutter clean
   flutter build web --web-renderer canvaskit
   ```

2. **Copy build output to repository root**
   ```bash
   # Navigate to your GitHub repository
   cd path/to/mazziabdeldjalil/language-learning-app
   
   # Copy all contents from build/web to root
   xcopy "C:\Users\Ztr\Desktop\M2B\THESIS\Prototype Test\language_learning_app\build\web\*" . /E /Y
   ```
   
   For macOS/Linux:
   ```bash
   cp -r C:/Users/Ztr/Desktop/M2B/THESIS/Prototype\ Test/language_learning_app/build/web/* .
   ```

3. **Commit and push to GitHub**
   ```bash
   git add .
   git commit -m "Deploy Flutter Web build to GitHub Pages"
   git push origin main
   ```

4. **Enable GitHub Pages**
   - Go to: `https://github.com/mazziabdeldjalil/language-learning-app/settings`
   - Scroll to "Pages"
   - Set Source to: `Deploy from a branch`
   - Set Branch to: `main / root`
   - Save

5. **Access your deployed app**
   - Your app will be available at: `https://mazziabdeldjalil.github.io/language-learning-app/`

### Repository Structure

After deployment, your repository root will contain:
```
index.html
main.dart.js
flutter.js
manifest.json
assets/
canvaskit/
```

### Important Notes

- ⚠️ **Do NOT commit** the `build/` folder itself
- ⚠️ **Do NOT commit** Flutter source files (`lib/`, `pubspec.yaml`, etc.) unless you need version control for development
- The deployed files are production-ready static assets
- Each deployment overwrites the previous version

### Rollback

If you need to revert to a previous deployment:
```bash
git log --oneline
git revert <commit-hash>
git push origin main
```

### Troubleshooting

**Issue**: Page not found after deployment
- Check GitHub Pages settings are enabled and configured to `main / root`
- Wait 1-2 minutes for GitHub Pages to rebuild

**Issue**: Assets not loading
- Verify `index.html` exists in repository root
- Check that `manifest.json` references correct asset paths

**Issue**: White screen after deployment
- Check browser console for errors
- Ensure `build/web` output is fully copied to root
- Verify no conflicts with other files
