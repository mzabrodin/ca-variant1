/**
 * Постановка задачі
 * <p>
 * Прочитати з stdin N рядків до появи EOF (макс довжина рядка 255 символів, максимум 100 рядків), у масив з рядків.
 * Рядки розділяються АБО послідовністю байтів 0x0D та 0x0A (CR LF), або одним символом - 0x0D чи 0x0A.
 * Як зберігати рядки, неважливо (ASCIIZ або Pascal string або якось ще). Або не зберігати взагалі, якщо робити наступний крок line-by-line.
 * <p>
 * Знайти всі входження вказанного підрядка (1й аргумент командного рядка) в кожному з рядків. Може бути більше одного входження на рядок.
 * Входження не мають перетинатися, наприклад кількість входжень підрядока "aa" в "aaa" = 1.
 * <p>
 * Відсортувати знайдені результати алгоритмом merge sort по кількості входженнь (asc), та вивести в консоль (stdout)
 * "<\кількість входжень> <\індекс рядка у текстовому файлі починаючи з 0>".
 * Наприклад:
 * <p>
 * aaaaa bbaa
 * aaz a
 * Результат:
 * <p>
 * 1 1
 * 3 0
 */

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {

    private static final int MAX_LINE_LENGTH = 255;
    private static final int MAX_LINES = 100;

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = readLines(reader);
        for (String l : lines) {
            if (l != null) {
                System.out.println(l);
            }
        }
        String substring = findSubstring(lines, "aa");
        System.out.println("Number of occurrences/line index:");
        System.out.println(substring);
    }

    private static String readLine(BufferedReader reader) throws IOException {
        StringBuilder lineBuilder = new StringBuilder();
        int c;
        while ((c = reader.read()) != -1) {
            if (c == 0x0D || c == 0x0A) {
                break;
            }
            if (lineBuilder.length() < MAX_LINE_LENGTH) {
                lineBuilder.append((char) c);
            }
        }
        return lineBuilder.toString();
    }

    private static String[] readLines(BufferedReader reader) throws IOException {
        String[] lines = new String[MAX_LINES];
        int lineCount = 0;
        while (lineCount < MAX_LINES) {
            String line = readLine(reader);
            if (line.isEmpty()) {
                break;
            }
            lines[lineCount++] = line;
        }
        return lines;
    }

    private static String findSubstring(String[] lines, String substring) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < lines.length; i++) {
            int count = 0;
            int index = 0;
            while (index != -1 && lines[i] != null) {
                index = lines[i].indexOf(substring, index);
                if (index != -1) {
                    count++;
                    index += substring.length();
                }
            }
            if (count > 0) {
                result.append(count).append(" ").append(i).append("\n");
            }
        }
        return result.toString();
    }
}

