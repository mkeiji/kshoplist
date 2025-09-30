ARG WS_URL

# --- Build Stage ---
FROM debian:bullseye-slim AS build

RUN apt-get update && apt-get install -y \
    curl unzip git xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 101 flutteruser

WORKDIR /usr/local
RUN git clone https://github.com/flutter/flutter.git -b 3.13.8
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN chown -R flutteruser:flutteruser /usr/local/flutter
USER flutteruser

RUN flutter config --enable-web
WORKDIR /app
COPY --chown=flutteruser:flutteruser . .
RUN mkdir -p assets && echo "WS_URL=wss://${WS_URL}/ws/1" > assets/.env
RUN flutter pub get
RUN flutter build web --release

# --- Serve Stage ---
FROM nginx:alpine AS serve
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
