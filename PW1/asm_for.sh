#!/bin/bash

# Перевіряємо, чи передано каталог та команду
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Введіть каталог та команду для виконання."
    exit 1
fi

directory="$1"
command_to_execute="$2"

# Перебираємо файли у вказаному каталозі
for file in "$directory"/*.asm; do
    # Перевіряємо, чи є файл
    if [ -f "$file" ]; then
        # Виконуємо команду для кожного файлу
        $command_to_execute "$file"
    fi
done

