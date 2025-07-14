import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.artacho.app"
    compileSdk = 35  // Actualizado a 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.artacho.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35  // Actualizado a 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 🔐 Configuración de firma
    signingConfigs {
        create("release") {
            val keystoreProperties = Properties().apply {
                load(File(rootDir, "key.properties").inputStream())
            }

            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    // 🏗️ Configuración del build release
    buildTypes {
        getByName("release") {
            // isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("release")
        }
    }

    // 👇 Nuevo: Configuración para Android 15
    buildFeatures {
        buildConfig = true
    }
    dependencies {
        implementation("com.google.android.material:material:1.11.0")
        // ... otras dependencias
    }
}

flutter {
    source = "../.."
}