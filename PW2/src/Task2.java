/**
 * Завдання 2
 * Написати фрагмент коду: отримати бінарне значення у змінній (uint32) за символьним представленням десяткового числа, наприклад “5555”.
 * Приклад: "543" => 543 та ...1000011111 (посимвольно перевели у int, '3'*10^0 + '4'*10^1 + '5'*10^2)
 * Модифікувати фрагмент коду для введення значення в будь-якій системі числення 2<=n<=16 (для позначення цифр >=10 a-f)
 * Приклад: a='543', b=16 => 1347 та ...10101000011 ('3'*16^0 + '4'*16^1 + '5'*16^2)
 * Модифікувати фрагмент коду для підтримки від’ємних значень (такі мають символьне представлення, що починається з “-”, наприклад “-5555”).
 * Приклад: a='-543', b=16 => -1347 та бінарний вигляд у доповнювальному коді
 */
public class Task2 {
    private final static String HEX_ALPHABET = "0123456789ABCDEF";

    public static void main(String[] args) {
        do {
            String value = getValue();
            int base = getBase();
            System.out.println("The number " + value + " of base " + base + " in decimal is " + convertFromBase(value, base));
            System.out.println("The number " + value + " of base " + base + " in binary is " + toBinaryFromDecimal(convertFromBase(value, base)));
        } while (getRepeat());
    }

    private static boolean getRepeat() {
        System.out.println("\nDo you want to repeat the program? [Y/n]");
        Character repeat = DataInput.getChar();
        if (repeat != null && Character.toLowerCase(repeat) == 'n') {
            return false;
        }
        return true;
    }

    /**
     * @param value
     * @return true if value is valid, otherwise false
     */
    private static boolean isValid(String value) {
        int start = 0;
        if (value.charAt(0) == '-') {
            if (value.length() == 1) {
                return false;
            }
            start = 1;
        }
        for (int i = start; i < value.length(); i++) {
            if (HEX_ALPHABET.indexOf(Character.toUpperCase(value.charAt(i))) == -1) {
                return false;
            }
        }
        return true;
    }


    private static String getValue() {
        System.out.print("Enter a decimal number: ");
        String number = DataInput.getText();
        while (number == null || !isValid(number)) {
            System.out.print("Invalid input. Please enter a decimal number: ");
            number = DataInput.getText();
        }
        return number;
    }

    private static int getBase() {
        System.out.print("Enter a number's base: ");
        Integer base = DataInput.getInt();
        while (base < 2 || base > 16) {
            System.out.print("Invalid input. Please enter a number's base: ");
            base = DataInput.getInt();
        }
        return base;
    }

    private static long convertFromBase(String value, int base) {
        boolean isNegative = false;
        if (value.charAt(0) == '-') {
            isNegative = true;
        }
        long res = 0;
        long multiplier = 1;
        for (int i = value.length() - 1; i >= (isNegative ? 1 : 0); i--) {
            char digit = Character.toUpperCase(value.charAt(i));
            int index = HEX_ALPHABET.indexOf(digit);
            res += index * multiplier;
            multiplier *= base;
        }
        return isNegative ? ~res + 1 : res;
    }

    private static String toBinaryFromDecimal(long value) {
        boolean isNegative = false;
        if (value < 0) {
            value = ~value + 1;
            isNegative = true;
        }
        StringBuilder res = new StringBuilder();
        do {
            int digit = (int) (value & 1);
            res.append(digit);
            value >>= 1;
        } while (value > 0);
        if (isNegative) {
            res.append("-");
        }
        res.reverse();
        return res.toString();
    }
}
