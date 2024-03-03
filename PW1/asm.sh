#!/bin/bash

# Перевіряємо, чи передано аргумент
if [ -z "$1" ]; then
    echo "Введіть ім'я файлу для компіляції та запуску."
    exit 1
fi

source_file="$1"
output_file="${source_file%.asm}"
mkdir -p bin

# Компіляція за допомогою NASM для 64-біт
nasm -f elf64 "$source_file" -o "bin/$output_file.o"

# Перевіряємо, чи компіляція пройшла успішно
if [ $? -ne 0 ]; then
    echo "Помилка під час компіляції."
    exit 1
fi

# Лінкування та створення виконуваного файлу для 64-біт
ld "bin/$output_file.o" -o "bin/$output_file"

# Перевіряємо, чи лінкування пройшло успішно
if [ $? -ne 0 ]; then
    echo "Помилка під час лінкування."
    exit 1
fi

# Запускаємо виконуваний файл
"./bin/$output_file"
