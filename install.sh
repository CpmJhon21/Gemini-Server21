#!/bin/bash

# Fungsi untuk menampilkan ASCII art di tengah terminal
display_ascii() {
    clear
    cols=$(tput cols)
    text="SERVER MANAGEMENT TOOLS"
    padding=$(( (cols - ${#text}) / 2 ))
    printf "%*s\n" $((padding + ${#text})) "$text"
    echo "======================================="
    echo "  Pilih opsi untuk mengelola server   "
    echo "======================================="
    echo ""
}

# Fungsi untuk menginstal bahan server
install_dependencies() {
    echo -e "\nMenginstal bahan server...\n"

    # Update sistem dan install Node.js serta NPM
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y nodejs npm openssh-client
    elif command -v pkg &> /dev/null; then
        pkg update && pkg upgrade -y
        pkg install -y nodejs openssh
    else
        echo "Paket manager tidak dikenali! Harap instal manual."
        exit 1
    fi

    # Cek versi Node.js dan NPM
    echo -e "\nCek versi Node.js dan NPM:"
    node -v
    npm -v

    # Inisialisasi proyek Node.js dan instal dependensi
    npm init -y
    npm install express node-fetch@2

    echo -e "\n✓ Instalasi selesai!\n"
}

# Fungsi untuk masuk ke dalam server dan menjalankan SSH tunneling
start_server() {
    echo -e "\nMemulai server...\n"
    node server.js &  # Menjalankan server di background
    sleep 2  # Tunggu sebentar sebelum menjalankan SSH tunneling
    echo -e "\nMengaktifkan SSH tunneling...\n"
    ssh -R 80:localhost:3333 nokey@localhost.run
}

# Menampilkan menu utama
main_menu() {
    display_ascii
    echo "1. Masuk ke dalam server & aktifkan SSH tunneling"
    echo "2. Instal bahan untuk server"
    echo "3. Keluar"
    echo ""
    read -p "Pilih opsi [1-3]: " choice

    case $choice in
        1) start_server ;;
        2) install_dependencies ;;
        3) echo -e "\nKeluar...\n"; exit 0 ;;
        *) echo -e "\nPilihan tidak valid!"; sleep 1; main_menu ;;
    esac
}

# Jalankan menu utama
main_menu
