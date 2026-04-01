pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/var/lib/jenkins/flutter'
        PATH = "/var/lib/jenkins/flutter/bin:${env.PATH}"
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
                echo 'Cek versi Flutter...'
                sh '/var/lib/jenkins/flutter/bin/flutter --version'
            }
        }

        stage('Flutter Install Dependencies') {
            steps {
                echo 'flutter pub get...'
                sh '/var/lib/jenkins/flutter/bin/flutter pub get'
            }
        }

        stage('Flutter Analyze') {
            steps {
                echo 'Analisis kode...'
                sh '/var/lib/jenkins/flutter/bin/flutter analyze'
            }
        }

        stage('Flutter Test') {
            steps {
                echo 'Jalankan unit tests...'
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
                echo 'Simpan APK...'
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk',
                                 fingerprint: true
            }
        }
    }

    post {
        success { echo 'BUILD BERHASIL!' }
        failure { echo 'BUILD GAGAL - cek log.' }
    }
}