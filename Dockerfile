# Stage 1: Build
FROM dart:stable AS build

WORKDIR /app

# Copy project files
COPY . .

# Activate Dart Frog CLI
RUN dart pub global activate dart_frog_cli
ENV PATH="$PATH:/root/.pub-cache/bin"

# Install dependencies
RUN dart pub get

# Build Dart Frog app (this generates a build/ folder)
RUN dart_frog build

# Stage 2: Run
FROM dart:stable

WORKDIR /app

# Copy the built server from the build stage
COPY --from=build /app/build /app

# Set the startup command
CMD ["dart", "run", "bin/server.dart"]
