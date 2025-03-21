#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[1;35m'
NC='\033[0m'

echo -e "\e[1;35m
███████╗ ██████╗ █████╗ ██╗   ██╗███████╗███╗   ██╗ ██████╗ ███████╗██████╗ 
██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝████╗  ██║██╔════╝ ██╔════╝██╔══██╗
███████╗██║     ███████║██║   ██║█████╗  ██╔██╗ ██║██║  ███╗█████╗  ██████╔╝
╚════██║██║     ██╔══██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██║   ██║██╔══╝  ██╔══██╗
███████║╚██████╗██║  ██║ ╚████╔╝ ███████╗██║ ╚████║╚██████╔╝███████╗██║  ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
 █████╗ ██╗██████╗ ██████╗ ██████╗  ██████╗ ██████╗     
██╔══██╗██║██╔══██╗██╔══██╗██╔══██╗██╔═══██╗██╔══██╗    
███████║██║██████╔╝██║  ██║██████╔╝██║   ██║██████╔╝    
██╔══██║██║██╔══██╗██║  ██║██╔══██╗██║   ██║██╔═══╝     
██║  ██║██║██║  ██║██████╔╝██║  ██║╚██████╔╝██║         
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝ 
                                                                                                                                                     
\e[1;34m
               Bergabunglah dengan airdrop scavenger sekarang!\e[1;32m
        ──────────────────────────────────────
        Grup Telegram: \e[1;4;33mhttps://t.me/scavengerairdrop\e[0m
        ──────────────────────────────────────"
echo -e "${NC}"

echo -e "${BLUE}Soundness CLI Installer${NC}"
echo "============================"

install_package() {
    package_name=$1
    if ! command -v $package_name &> /dev/null; then
        echo -e "${YELLOW}Menginstal $package_name...${NC}"
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &> /dev/null; then
                sudo apt-get update
                sudo apt-get install -y $package_name
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y $package_name
            elif command -v yum &> /dev/null; then
                sudo yum install -y $package_name
            else
                echo -e "${RED}Tidak dapat menginstal $package_name. Silakan instal secara manual.${NC}"
                return 1
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}Homebrew tidak ditemukan. Menginstal Homebrew...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install $package_name
        else
            echo -e "${RED}Sistem operasi tidak didukung untuk instalasi otomatis.${NC}"
            return 1
        fi
    else
        echo -e "${GREEN}$package_name sudah terinstal.${NC}"
    fi
    return 0
}

echo "Memeriksa dependensi..."
install_package git
install_package curl
install_package wget

if ! command -v cargo &> /dev/null; then
    echo -e "${YELLOW}Rust dan Cargo tidak ditemukan. Menginstal...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo -e "${GREEN}Rust dan Cargo berhasil diinstal!${NC}"
else
    echo -e "${GREEN}Rust dan Cargo sudah terinstal.${NC}"
fi

echo "Menginstal dependensi build..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y build-essential pkg-config libssl-dev clang
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gcc openssl-devel pkg-config clang
    elif command -v yum &> /dev/null; then
        sudo yum install -y gcc openssl-devel pkg-config clang
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install openssl pkg-config llvm
fi

TEMP_DIR=$(mktemp -d)
echo "Membuat direktori sementara: $TEMP_DIR"

echo "Mengkloning repositori Soundness Layer..."
git clone --depth 1 https://github.com/SoundnessLabs/soundness-layer.git "$TEMP_DIR/soundness-layer"

if [ $? -ne 0 ]; then
    echo -e "${RED}Gagal mengkloning repositori. Periksa koneksi internet Anda.${NC}"
    exit 1
fi

echo "Mencari direktori CLI..."

COMMON_CLI_DIRS=(
    "soundnessup"
    "soundness-cli"
    "cli"
    "soundness/cli"
)

CLI_DIR=""
for dir in "${COMMON_CLI_DIRS[@]}"; do
    if [ -d "$TEMP_DIR/soundness-layer/$dir" ] && [ -f "$TEMP_DIR/soundness-layer/$dir/Cargo.toml" ]; then
        CLI_DIR="$TEMP_DIR/soundness-layer/$dir"
        echo -e "${GREEN}Menemukan CLI di: $CLI_DIR${NC}"
        break
    fi
done

if [ -z "$CLI_DIR" ]; then
    echo "Mencari file Cargo.toml yang relevan..."
    for cargo_file in $(find "$TEMP_DIR/soundness-layer" -name "Cargo.toml" -type f); do
        if grep -q "name.*soundness\|name.*cli\|name.*scavenger" "$cargo_file"; then
            CLI_DIR=$(dirname "$cargo_file")
            echo -e "${GREEN}Menemukan CLI di: $CLI_DIR${NC}"
            break
        fi
    done
fi

if [ -z "$CLI_DIR" ]; then
    FIRST_CARGO=$(find "$TEMP_DIR/soundness-layer" -name "Cargo.toml" -type f | head -n 1)
    if [ -n "$FIRST_CARGO" ]; then
        CLI_DIR=$(dirname "$FIRST_CARGO")
        echo -e "${YELLOW}Tidak dapat menemukan CLI spesifik. Menggunakan: $CLI_DIR${NC}"
    else
        echo -e "${RED}Error: Tidak dapat menemukan file Cargo.toml di repositori.${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

cd "$CLI_DIR"
echo "Menginstal dari direktori: $CLI_DIR"

echo "Menginstal Soundness CLI menggunakan Cargo..."
cargo install --path .

if [ $? -ne 0 ]; then
    echo -e "${RED}Instalasi gagal. Coba lagi atau laporkan masalah.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

INSTALLED_BINS=$(find "$HOME/.cargo/bin" -type f -executable -mmin -1 | grep -i "soundness\|scavenger")
if [ -n "$INSTALLED_BINS" ]; then
    echo -e "${GREEN}Berhasil menginstal binary berikut:${NC}"
    for bin in $INSTALLED_BINS; do
        echo "  - $(basename "$bin")"
    done
    MAIN_BIN=$(basename "$(echo "$INSTALLED_BINS" | head -n 1)")
else
    echo -e "${YELLOW}Tidak dapat menemukan binary yang terinstal dengan nama relevan.${NC}"
    RECENT_BINS=$(find "$HOME/.cargo/bin" -type f -executable -mmin -1)
    if [ -n "$RECENT_BINS" ]; then
        echo -e "${GREEN}Binary terinstal baru-baru ini:${NC}"
        for bin in $RECENT_BINS; do
            echo "  - $(basename "$bin")"
        done
        MAIN_BIN=$(basename "$(echo "$RECENT_BINS" | head -n 1)")
    fi
fi

if ! echo "$PATH" | grep -q "$HOME/.cargo/bin"; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    if [ -f ~/.zshrc ]; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    fi
    echo -e "${YELLOW}Path ~/.cargo/bin telah ditambahkan ke PATH Anda.${NC}"
    echo -e "${YELLOW}Jalankan perintah berikut untuk memperbarui PATH di sesi saat ini:${NC}"
    echo "  source ~/.bashrc  # untuk bash"
    echo "  # atau"
    echo "  source ~/.zshrc   # untuk zsh"
    echo "  # atau"
    echo "  source ~/.cargo/env  # cara cepat"
fi

echo "Membersihkan file sementara..."
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✅ Instalasi Soundness CLI selesai!${NC}"
if [ -n "$MAIN_BIN" ]; then
    echo -e "${GREEN}Gunakan '$MAIN_BIN' untuk menjalankan CLI.${NC}"
fi
echo -e "${BLUE}Informasi tambahan:${NC}"
echo -e "  - ${YELLOW}Untuk bergabung dengan testnet, buat kunci Anda dan minta akses di Discord.${NC}"
echo -e "  - ${YELLOW}Gunakan perintah !access <kunci-publik-base64-encoded> di channel testnet-access${NC}"
