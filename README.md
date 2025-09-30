
# KShopList

![KShopList Icon](assets/launcher/icon.png)

A cross-platform Flutter app with Go [backend](https://github.com/mkeiji/kshoplist-srv) for managing your grocery shopping lists, supporting Android, iOS, and Web.

---

## Features

- 🛒 Create and manage multiple shopping lists by store
- 🏪 Store images and easy store selection
- 🔄 Real-time sync via WebSocket (see `.env` for configuration)
- 📱 Responsive UI for mobile and web
- ☁️ Asset management for store icons
- 🖼️ Customizable with your own store images

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.13.8 • channel stable • https://github.com/flutter/flutter.git
- Framework • revision 6c4930c4ac (1 year, 11 months ago) • 2023-10-18 10:57:55 -0500
- Engine • revision 767d8c75e8
- Tools • Dart 3.1.4 • DevTools 2.25.0
- (Optional) Docker for deployment

### Installation

```bash
# Clone the repository
$ git clone https://github.com/mkeiji/kshoplist.git
$ cd kshoplist

# Get dependencies
$ flutter pub get

# Set up environment variables (see below)
```

### Running the App

#### Android/iOS
```bash
flutter run
```

#### Web
```bash
flutter run -d chrome
```

#### Docker (Web)
```bash
docker build --build-arg WS_URL=[[host-addr]] -t kshoplist .
docker run --rm -p 8080:80 kshoplist
```

Access the app at `http://localhost:8080`

---

## Project Structure

- `lib/` — Main Dart source code
- `assets/images/` — Store images
- `assets/launcher/` — App icons
- `web/` — Web entrypoint and favicon
- `test/` — Widget and unit tests

---

## Configuration

- WebSocket URL and other secrets are managed in `assets/.env` (uses `flutter_dotenv`)
- if you deploy, make sure to Set the `WS_URL` in `.env` to your server URL:
    ```.env
    # PROD
    # WS_URL=wss://<<host-addr>>/ws/1

    # DEV
    WS_URL=ws://localhost:8081/ws/1

    ```
- To add a new store, update the `shops` list in `lib/home-widget/home.widget.dart` and add an image to `assets/images/`
