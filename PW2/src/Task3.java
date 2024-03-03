/**
 * Завдання 3
 * Написати фрагменти коду для таких операцій (результат має бути виведено в консоль):
 * Для будь якого введеного числа x та n (0<=n<=31)
 * 1) вивести значення n-го біта
 * 2) вивести значення числа з переключеним n-м бітом
 * 3) вивести кількість 1 в бінарному записі числа x
 * 4) Перевірити, чи є 32-бітне число від’ємним, не використовуючи умову “більше” або “менше”
 * 5) Перевірити, чи є введене число парним, не використовуючи операцію ділення.
 */
public class Task3 {
    public static void main(String[] args) {
        do {
            Integer value = getValue();
            Integer bitNumber = getBitNumber();
            System.out.println("The value of " + bitNumber + " bit is " + getBitValue(value, bitNumber));
            System.out.println("The value with " + bitNumber + " bit toggled is " + toggleBit(value, bitNumber));
            System.out.println("The number of 1s in binary representation of " + value + " is " + countOnes(value));
            System.out.println("The number " + value + " is " + (isNegative(value) ? "negative" : "positive"));
            System.out.println("The number " + value + " is " + (isEven(value) ? "even" : "odd"));
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

    private static int getValue() {
        int f = Integer.MAX_VALUE;
        System.out.print("Enter a decimal number: ");
        Integer number = DataInput.getInt();
        while (number == null || number < Integer.MIN_VALUE || number > Integer.MAX_VALUE) {
            System.out.println("Invalid input");
            System.out.print("Enter a decimal number: ");
            number = DataInput.getInt();
        }
        return number;
    }

    private static int getBitNumber() {
        System.out.print("Enter a bit number: ");
        Integer number = DataInput.getInt();
        while (number == null || number < 0 || number > 31) {
            System.out.print("Invalid input. Please enter a bit number: ");
            number = DataInput.getInt();
        }
        return number;
    }

    private static int getBitValue(int value, int number) {
        return (value >> number) & 1;
    }

    private static int toggleBit(int value, int number) {
        int mask = 1 << number;
        return value ^ mask;
    }

    private static int countOnes(int value) {
        boolean isNegative = isNegative(value);
        if (isNegative) {
            value = ~value + 1;
        }
        int count = 0;
        while (value != 0) {
            if ((value & 1) == 1) {
                count++;
            }
            value >>= 1;
        }
        return !isNegative ? count : Integer.SIZE - count;
    }

    private static boolean isNegative(int value) {
        return getBitValue(value, 31) == 1;
    }

    private static boolean isEven(int value) {
        return (value & 1) == 0;
    }
}
