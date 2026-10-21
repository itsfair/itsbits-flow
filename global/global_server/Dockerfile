# Docker build context = repo root. Build either image with:
#   docker build -f global/global_server/Dockerfile -t itsbits-flow-global .
#   docker build -f local/local_server/Dockerfile -t itsbits-flow-local .
#
# Prerequisites for shipping the admin web apps inside the image: the
# Flutter web apps must be prebuilt with the DEV toolchain (no Linux
# Flutter 3.47.5 base image exists; cirruslabs is stuck at 3.44.0) and
# copied into the server's web/app directory, e.g. from each app dir:
#   flutter build web --base-href /
#   xcopy /E /I /Y build\web ..\<server>\web\app      (Windows)
#   cp -R build/web ../global_server/web/app          (posix)
# Without web/app the image still builds; the web server then serves the
# "build flutter app" placeholder page.
#
# Secrets (config/passwords.yaml) are excluded via .dockerignore — the
# container receives ALL passwords through SERVERPOD_PASSWORD_<key>
# environment variables.

FROM dart:3.12.2 AS build

# Minimal workspace preserving the locked versions of the root lockfile.
WORKDIR /app
COPY pubspec.lock .
COPY global/global_server global_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - global_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/global_server
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
COPY --from=build /app/global_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/global_server/config/ config/
COPY --from=build /app/global_server/web/ web/
COPY --from=build /app/global_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/global_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
