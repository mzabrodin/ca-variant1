/**
 * Завдання 1
 * Написати фрагмент коду: вивести в консоль значення (uint32) змінної у бінарному вигляді (за основою 2) шляхом ділення на 2 та виведення остачі.
 * Наприклад:
 * uint32 a = 7   => 111
 * uint32 a = 5   => 101
 * Якщо мова не має unsigned integer, використовуємо long.
 * Модифікувати фрагмент коду для виведення значення в будь-якій системі числення 2<=n<=16 (для позначення >=10 використовувати a-f).
 * Наприклад:
 * uint32 a = 17; b=16  => 11 (а - число в десятковій, b - система числення в яку треба перевести a)
 * Модифікувати фрагмент коду для виведення знакового бінарного числа у доповнювальному коді (uint32) в будь якій системі числення  2<=n<=16
 * (від'ємні значення виводити як "-" + абсолютне значення числа). Не можна використовувати знаковий тип даних (int32).
 * Наприклад:
 * uint32 a = 1111 1111 1111 1111 1111 1111 1111 0000, b=10 => -16 (а - бінарне число, b - система числення в яку треба перевести a)
 * (додаткове): вивести значення у бінарному вигляді, не використовуючи операцію ділення. Те саме для шістнадцяткового вигляду.
 */
public class Task1 {
    public static void main(String[] args) {
        do {
            long number = getDecimalValue();
            int base = getBase();
            System.out.println("The number " + number + " in base " + base + " by dividing is " + convertBase(number, base));
            System.out.println("The number " + number + " in binary without division is " + toBinary(number));
            System.out.println("The number " + number + " in hex without division is " + toHex(number));
        } while (getRepeat());
    }

    private static boolean getRepeat() {
        System.out.println("Do you want to repeat the program? [Y/n]");
        Character repeat = DataInput.getChar();
        if (repeat != null && Character.toLowerCase(repeat) == 'n') {
            return false;
        }
        return true;
    }

    private static long getDecimalValue() {
        System.out.print("Enter a decimal number: ");
        Long number = DataInput.getLong();
        while (number == null) {
            System.out.print("Invalid input. Please enter a decimal number: ");
            number = DataInput.getLong();
        }
        return number;
    }

    private static int getBase() {
        System.out.print("Enter a base to convert to: ");
        Integer base = DataInput.getInt();
        while (base < 2 || base > 16) {
            System.out.print("Invalid input. Please enter a base: ");
            base = DataInput.getInt();
        }
        return base;
    }

    private static String convertBase(long value, int base) {
        boolean isNegative = false;
        if (value < 0) {
            value = ~value + 1;
            isNegative = true;
        }
        final String alphabet = "0123456789ABCDEF";
        StringBuilder res = new StringBuilder();
        do {
            int remain = (int) (value % base);
            res.append(alphabet.charAt(remain));
            value /= base;
        } while (value > 0);
        if (isNegative) {
            res.append("-");
        }
        res.reverse();
        return res.toString();
    }

    private static String toBinary(long value) {
        boolean isNegative = false;
        if (value < 0) {
            value = ~value + 1;
            isNegative = true;
        }
        final String alphabet = "0123456789ABCDEF";
        StringBuilder res = new StringBuilder();
        do {
            int digit = (int) (value & 1);
            res.append(alphabet.charAt(digit));
            value = value >> 1;
        } while (value > 0);
        if (isNegative) {
            res.append("-");
        }
        res.reverse();
        return res.toString();
    }

    private static String toHex(long value) {
        boolean isNegative = false;
        if (value < 0) {
            value = ~value + 1;
            isNegative = true;
        }
        final String alphabet = "0123456789ABCDEF";
        StringBuilder res = new StringBuilder();
        do {
            int digit = (int) (value & 15);
            res.append(alphabet.charAt(digit));
            value = value >> 4;
        } while (value > 0);
        if (isNegative) {
            res.append("-");
        }
        res.reverse();
        return res.toString();
    }
}
