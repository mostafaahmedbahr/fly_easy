import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.zerobugs.teamsapp"
    compileSdk = 36

    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled  = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.zerobugs.teamsapp"
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // أضف هذا
            isShrinkResources = true // أضف هذا
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // For AGP 7.4+
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // For AGP 7.3
    // coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.2.3'
    // For AGP 4.0 to 7.2
    // coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.1.9'
    implementation("androidx.core:core:1.9.0") // أضف هذا السطر

    //Introduce Firebase BoM
    implementation  ("com.google.firebase:firebase-bom:31.0.2")

// Add dependencies for Firebase SDK for Google Analytics and FCM.
// When using BoM, do not specify the version in the Firebase dependency
    implementation ("com.google.firebase:firebase-analytics")
    implementation ("com.google.firebase:firebase-messaging:23.2.1")
    implementation ("im.zego:zpns-fcm:2.8.0") //ZPNs package for Google FCM push

}
configurations.all {
    resolutionStrategy {
        force("com.google.code.gson:gson:2.11.0")
    }
}