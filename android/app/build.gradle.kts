// android/app/build.gradle.kts

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.joss_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.eassist_tools_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    // ---- LOAD key.properties (aman kalau file tidak ada) ----
    val keystoreProps = Properties().apply {
        val f = rootProject.file("key.properties")
        if (f.exists()) {
            FileInputStream(f).use { fis -> load(fis) }
        }
    }

    signingConfigs {
        // debug SUDAH ada by default → gunakan getByName, JANGAN create
        getByName("debug") {
            val sf = keystoreProps.getProperty("storeFile")
            if (sf != null) {
                storeFile = file(sf)
                storePassword = keystoreProps.getProperty("storePassword")
                keyAlias = keystoreProps.getProperty("keyAlias")
                keyPassword = keystoreProps.getProperty("keyPassword")
            }
            // kalau sf null, Gradle pakai ~/.android/debug.keystore default
        }

        // RELEASE (opsional; isi kalau punya keystore release)
        // create("release") {
        //     val sf = keystoreProps.getProperty("storeFileRelease")
        //     if (sf != null) {
        //         storeFile = file(sf)
        //         storePassword = keystoreProps.getProperty("storePasswordRelease")
        //         keyAlias = keystoreProps.getProperty("keyAliasRelease")
        //         keyPassword = keystoreProps.getProperty("keyPasswordRelease")
        //     }
        // }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            // Pastikan shrink OFF jika minify OFF agar tidak error
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("release") {
            // aktifkan jika sudah punya release config
            // signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}



/*
*
*
* plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.joss_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.joss_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

* */