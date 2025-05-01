// Root project build.gradle fayli

allprojects {
    repositories {
        // Google va Maven Central repository'larini qo'llash
        google()
        mavenCentral()
    }
}

// Maxsus build katalogi o'rnatish
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Har bir sub-loyiha uchun alohida build katalogi sozlash
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Sub-loyihalarni :app moduliga bog'lash
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task yaratilishi: tozalash uchun
tasks.register<Delete>("clean") {
    // Root build katalogini o'chirish
    delete(rootProject.layout.buildDirectory)
}
