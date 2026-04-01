pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/var/lib/jenkins/flutter'
        ANDROID_HOME = '/var/lib/jenkins/android-sdk'
        PATH = "/var/lib/jenkins/flutter/bin:/var/lib/jenkins/android-sdk/cmdline-tools/latest/bin:/var/lib/jenkins/android-sdk/platform-tools:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Ambil kode dari GitHub...'
                checkout scm
            }
        }

        stage('Flutter Version') {
            steps {
                sh '/var/lib/jenkins/flutter/bin/flutter --version'
            }
        }

        stage('Flutter Install Dependencies') {
            steps {
                sh '/var/lib/jenkins/flutter/bin/flutter pub get'
            }
        }

        stage('Flutter Analyze') {
            steps {
                sh '/var/lib/jenkins/flutter/bin/flutter analyze'
            }
        }

        stage('Flutter Test') {
            steps {
                sh '/var/lib/jenkins/flutter/bin/flutter test'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Build APK release...'
                sh '/var/lib/jenkins/flutter/bin/flutter build apk --release'
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk',
                                 fingerprint: true
            }
        }
    }

    post {
        success { echo 'BUILD BERHASIL! APK siap didownload.' }
        failure { echo 'BUILD GAGAL - cek log.' }
    }
}