allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
// Workaround for legacy plugins (like contacts_service 0.6.x) that lack an Android namespace
// This configures a namespace for that subproject so AGP 8+ can build.
plugins.withId("com.android.library") {
    if (project.name == "contacts_service") {
        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
            namespace = "flutter.plugins.contacts_service"
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
