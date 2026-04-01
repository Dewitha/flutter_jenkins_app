pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Ambil kode dari GitHub...'
                checkout scm
            }
        }

        stage('Flutter Install Dependencies') {
            steps {
                echo 'flutter pub get...'
                sh 'flutter pub get'
            }
        }

        stage('Flutter Analyze') {
            steps {
                echo 'Analisis kode...'
                sh 'flutter analyze'
            }
        }

        stage('Flutter Test') {
            steps {
                echo 'Jalankan unit tests...'
                sh 'flutter test'
            }
        }

        stage('Build APK') {
            steps {
                echo 'Build APK release...'
                sh 'flutter build apk --release'
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