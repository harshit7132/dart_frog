FROM dart:stable AS build

WORKDIR /app

# Copy only pubspec.yaml first and run `dart pub get` to generate pubspec.lock
COPY pubspec.yaml ./
RUN dart pub get

# Now copy the rest of the application files
COPY . .

# Activate Dart Frog globally
RUN dart pub global activate dart_frog_cli
ENV PATH="$PATH:/root/.pub-cache/bin"

# Build the Dart Frog server
RUN dart_frog build

# Expose the port
EXPOSE 8080

# Run the server
CMD ["dart", "run", "bin/server.dart"]
