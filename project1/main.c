#include <stdio.h>

#define LINE_MAX_LENGTH 255
#define LINES_MAX_LENGTH 100

/*
 * Stores line index and occurrences of substring
 */
struct Line {
    int index;
    int occurrences;
};

/*
 * Counts occurrences of substring in string
 * @param string - string to search in
 * @param substring - substring to search for
 */
int count_occurrences(const char *string, const char *substring);

/*
 * Sorts an array
 * @param array - array
 * @param length - length of array
 */
void sort(struct Line *array, int length);

int main(int argc, char **argv) {
    char *substring = argv[1];
    printf("Substring: %s\n", substring);

    int number_of_lines = 0;
    struct Line lines[LINES_MAX_LENGTH];

    int ch;
    char str[LINE_MAX_LENGTH + 1];
    int str_length = 0;
    while (1) {
        ch = getchar();
        if (ch == EOF) {
            break;
        }
        if (ch == '\r' || ch == '\n') {
            str[str_length] = '\0';
            str_length = 0;
            lines[number_of_lines].index = number_of_lines;
            lines[number_of_lines].occurrences = count_occurrences(str, substring);
            number_of_lines++;
            continue;
        }

        str[str_length++] = (char) ch;
    }

    if (str_length > 0) {
        str[str_length] = '\0';
        lines[number_of_lines].index = number_of_lines;
        lines[number_of_lines].occurrences = count_occurrences(str, substring);
        number_of_lines++;
    }

    sort(lines, number_of_lines);

    for (int i = 0; i < number_of_lines; ++i) {
        printf("%d %d\n", lines[i].occurrences, lines[i].index);
    }

    return 0;
}

int count_occurrences(const char *string, const char *substring) {
    int substring_length = 0;
    while (substring[substring_length] != '\0') {
        substring_length++;
    }

    int string_length = 0;
    while (string[string_length] != '\0') {
        string_length++;
    }

    int count = 0;
    for (int i = 0; i < string_length; ++i) {
        int j = 0;
        while (j < substring_length && i + j < string_length && string[i + j] == substring[j]) {
            j++;
        }

        if (j == substring_length) {
            count++;
            i += substring_length - 1;
        }
    }

    return count;
}

void sort(struct Line *array, int length) {
    if (length <= 1) {
        return;
    }

    int middle = length / 2;
    struct Line left[middle];
    struct Line right[length - middle];

    for (int i = 0; i < middle; ++i) {
        left[i] = array[i];
    }
    for (int i = middle; i < length; ++i) {
        right[i - middle] = array[i];
    }

    sort(left, middle);
    sort(right, length - middle);

    int left_index = 0;
    int right_index = 0;
    int index = 0;
    while (left_index < middle && right_index < length - middle) {
        if (left[left_index].occurrences <= right[right_index].occurrences) {
            array[index++] = left[left_index++];
        } else {
            array[index++] = right[right_index++];
        }
    }

    while (left_index < middle) {
        array[index++] = left[left_index++];
    }

    while (right_index < length - middle) {
        array[index++] = right[right_index++];
    }
}