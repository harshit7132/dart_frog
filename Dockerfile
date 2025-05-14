# Use the official Dart image
FROM dart:stable

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy rest of the source code
COPY . .

# Build the Dart Frog server
RUN dart_frog build

# Start the server
CMD ["dart", "build/bin/server.dart"]
