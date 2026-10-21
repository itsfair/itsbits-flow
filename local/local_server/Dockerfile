# Docker build context = repo root. Build with:
#   docker build -f local/local_server/Dockerfile -t itsbits-flow-local .
#
# Prerequisites for shipping the admin web app inside the image: the
# Flutter web app must be prebuilt with the DEV toolchain (no Linux
# Flutter 3.47.5 base image exists; cirruslabs is stuck at 3.44.0) and
# copied into the server's web/app directory, e.g. from local/local_flutter:
#   flutter build web --base-href /
#   xcopy /E /I /Y build\web ..\local_server\web\app   (Windows)
#   cp -R build/web ../local_server/web/app             (posix)
# Without web/app the image still builds; the web server then serves the
# "build flutter app" placeholder page.
#
# Secrets (config/passwords.yaml) are excluded via .dockerignore — the
# container receives ALL passwords through SERVERPOD_PASSWORD_<key>
# environment variables.

FROM dart:3.12.2 AS build

# Minimal workspace preserving the locked versions of the root lockfile.
# local_server pulls in the generated GLOBAL client (global-credentials
# verification during site setup) and the pure-Dart door-code package.
WORKDIR /app
COPY pubspec.lock .
COPY global/global_client global/global_client
COPY itsbits_dart itsbits_dart
COPY local/local_server local/local_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - global/global_client' \
  '  - itsbits_dart' \
  '  - local/local_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/local/local_server
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Fallback for possibly missing directories (web/app is mounted in from
# the prebuilt Flutter web app if present).
RUN mkdir -p config web migrations

# Final stage
FROM alpine:latest
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/local/local_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/local/local_server/config/ config/
COPY --from=build /app/local/local_server/web/ web/
COPY --from=build /app/local/local_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/local/local_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8180
EXPOSE 8181
EXPOSE 8182

# Define the entrypoint command
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
