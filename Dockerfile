FROM dart:stable AS build

WORKDIR /app

# Only copy the pubspec.yaml if pubspec.lock is not available
COPY pubspec.yaml ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application files
COPY . .

# Activate Dart Frog globally
RUN dart pub global activate dart_frog_cli
ENV PATH="$PATH:/root/.pub-cache/bin"

# Build the Dart Frog server
RUN dart_frog build

# Expose the port the app will run on
EXPOSE 8080

# Start the app
CMD ["dart", "run", "bin/server.dart"]
