pluginManagement {
    // Define the logic to read local.properties and get the SDK path here
    fun getFlutterSdkPath(): String {
        val localProperties = java.util.Properties()
        val localPropertiesFile = settings.rootDir.resolve("local.properties") // Use settings.rootDir
        if (localPropertiesFile.exists()) {
            // Add explicit type for stream
            localPropertiesFile.inputStream().use { stream: java.io.InputStream ->
                localProperties.load(stream)
            }
        }
        val flutterSdkPath = localProperties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        return flutterSdkPath
    }

    val flutterSdkPath = getFlutterSdkPath()
    // Use settings.rootDir.resolve to get the File object explicitly
    includeBuild(settings.rootDir.resolve(flutterSdkPath).resolve("packages/flutter_tools/gradle").path)

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.2.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")
