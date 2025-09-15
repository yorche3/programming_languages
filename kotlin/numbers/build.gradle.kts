plugins {
    kotlin("jvm") version "2.2.10" // Example Kotlin version for Gradle 9
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.withType<Test> {
    testLogging {
        // Log standard output and error from tests
        showStandardStreams = true

        // Log events at INFO level
        events("passed", "failed", "skipped", "standardOut", "standardError")
        info.events("passed", "failed", "skipped")

        // Configure exception formatting
        showExceptions = true
        showStackTraces = true
        showCauses = true

        // Set granularity for test events
        displayGranularity = 2
    }
}