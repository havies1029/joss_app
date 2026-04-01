import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.10.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "id.co.jayaproteksindo.proteksiplus"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "id.co.jayaproteksindo.proteksiplus"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // ===== LOAD KEYSTORE =====
    val keystoreProps = Properties().apply {
        val f = rootProject.file("key.properties")
        if (f.exists()) {
            FileInputStream(f).use { fis -> load(fis) }
        }
    }

    signingConfigs {
        getByName("debug") {
            val sf = keystoreProps.getProperty("storeFile")
            if (sf != null) {
                storeFile = file(sf)
                storePassword = keystoreProps.getProperty("storePassword")
                keyAlias = keystoreProps.getProperty("keyAlias")
                keyPassword = keystoreProps.getProperty("keyPassword")
            }
        }

        create("release") {
            val sf = keystoreProps.getProperty("storeFileRelease")
                ?: keystoreProps.getProperty("storeFile")

            if (sf != null) {
                storeFile = file(sf)
                storePassword = keystoreProps.getProperty("storePasswordRelease")
                    ?: keystoreProps.getProperty("storePassword")
                keyAlias = keystoreProps.getProperty("keyAliasRelease")
                    ?: keystoreProps.getProperty("keyAlias")
                keyPassword = keystoreProps.getProperty("keyPasswordRelease")
                    ?: keystoreProps.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
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
