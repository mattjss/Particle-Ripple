# Particle Ripple — Setup Instructions

## Step 1: Start Fresh (Avoid Conflicts)

You currently have nested Xcode projects. The simplest approach is to use a clean project.

**Option A: Use the existing project at the root**

1. Quit Xcode if it’s open.
2. Open this folder in Finder: `Particle Ripple`
3. Double‑click `Particle Ripple.xcodeproj` (the one next to the `Particle Ripple` folder, not inside it).
4. In Xcode, select the **Particle Ripple** scheme (top toolbar).
5. Choose a simulator (e.g. **iPhone 16**) or your device.
6. Press ⌘R or the **Play** button.

---

**Option B: Create a new project and add the files**

1. In Xcode: **File → New → Project**
2. Choose **iOS → App**
3. Set **Product Name** to `ParticleRipple` (no spaces helps)
4. **Interface:** SwiftUI | **Language:** Swift | **Storage:** None
5. Save it somewhere (e.g. Desktop).
6. Delete the default `ContentView.swift` that Xcode creates.
7. Add the ripple files:

   - Right‑click the blue project icon in the navigator → **Add Files to "ParticleRipple"...**
   - Add these 4 files:
     - `RippleEffect.metal`
     - `RippleModifier.swift`
     - `ContentView.swift`
     - `ParticleRippleApp.swift`
   - Leave **Copy items if needed** unchecked if the files are already in the project folder.
   - Ensure **ParticleRipple** target is checked for each file.

8. Make sure `ParticleRippleApp.swift` is the app entry (it must have `@main`).
9. Set **Minimum Deployment** to **iOS 17.0** or higher: select the project → **General → Minimum Deployments**.
10. Run with ⌘R.

---

## Files You Need

These 4 files must be in your app target:

| File | Purpose |
|------|---------|
| `RippleEffect.metal` | Metal shader for the ripple |
| `RippleModifier.swift` | Swift view modifiers |
| `ContentView.swift` | Example UI with 3 tabs |
| `ParticleRippleApp.swift` | App entry point (`@main`) |

---

## Verify the Metal File Is Compiled

1. In Xcode’s left sidebar, select the blue project icon.
2. Under **TARGETS**, select your app target.
3. Open the **Build Phases** tab.
4. Expand **Compile Sources**.
5. Confirm `RippleEffect.metal` is listed. If it’s missing, click **+** and add it.

---

## Requirements

- **Xcode 15+** (for Metal shaders in SwiftUI)
- **iOS 17+** deployment target
- **Simulator or physical device** (Metal works in both)

---

## If the Build Still Fails

Check the exact error message in the **Issue Navigator** (⌘5):

- **"Cannot find 'ShaderLibrary' in scope"** → Metal file is not in the target. Add `RippleEffect.metal` to **Compile Sources**.
- **"No such module 'SwiftUI'"** or deployment errors → Set minimum deployment to iOS 17+.
- **Duplicate symbol or multiple @main** → Only `ParticleRippleApp.swift` should have `@main`. Remove it from any other app entry file.
