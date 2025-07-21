#!/bin/bash

set -e

log_info() { echo -e "\033[1;34mℹ️ $1\033[0m"; }
log_success() { echo -e "\033[1;32m✅ $1\033[0m"; }
log_error() { echo -e "\033[1;31m❌ $1\033[0m"; }

# 🔍 Налаштування шляху до TTSModManager
MOD_MANAGER="$HOME/TTSModManager/TTSModManager"

# 📦 Перевірка на jq
if ! command -v jq &> /dev/null; then
  log_error "jq не встановлений. Встанови через 'brew install jq'"
  exit 1
fi

# 🔍 Перевірка наявності TTSModManager
if [ ! -x "$MOD_MANAGER" ]; then
  log_error "TTSModManager не знайдено або не має прав на виконання: $MOD_MANAGER"
  exit 1
fi

# 🧠 Зчитування версії
if [ ! -f config.json ]; then
  log_error "config.json не знайдено!"
  exit 1
fi

SAVE_NAME=$(jq -r '.SaveName' config.json)
if [ -z "$SAVE_NAME" ]; then
  log_error "SaveName не знайдено або порожнє"
  exit 1
fi

# 🛠️ Шляхи
MODDIR="$(pwd)"
OUTPUT_DIR="$MODDIR/saves"
OUTPUT_FILE="AH ${SAVE_NAME}.json"
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_FILE"

# 📂 Створити папку, якщо нема
mkdir -p "$OUTPUT_DIR"

# 🧱 Перевірка: чи файл вже існує
if [ -f "$OUTPUT_PATH" ]; then
  log_error "Файл уже існує: saves/$OUTPUT_FILE. Змініть SaveName у config.json або видаліть старий файл."
  exit 1
fi

# 🚀 Запуск генерації
log_info "Генерується мод з SaveName: $SAVE_NAME"
"$MOD_MANAGER" \
  --moddir="$MODDIR" \
  --modfile="$OUTPUT_PATH"

log_success "Save generated: saves/$OUTPUT_FILE"
