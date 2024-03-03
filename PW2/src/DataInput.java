import java.io.BufferedReader;
import java.io.InputStreamReader;

public final class DataInput {

    public static Double getDouble() {
        try {
            String s = getString();
            Double value = Double.valueOf(s);
            return value;
        } catch (Exception e) {
            return null;
        }
    }

    public static Long getLong() {
        try {
            String s = getString();
            Long value = Long.valueOf(s);
            return value;
        } catch (Exception e) {
            return null;
        }
    }

    public static Character getChar() {
        try {
            String s = getString();
            return s.charAt(0);
        } catch (Exception e) {
            return null;
        }
    }

    public static Integer getInt() {
        try {
            String s = getString();
            Integer value = Integer.valueOf(s);
            return value;
        } catch (Exception e) {
            return null;
        }
    }

    public static String getText() {
        try {
            String input = getString();
            String result = String.valueOf(input);
            return result;
        } catch (Exception e) {
            return null;
        }
    }

    public static String getString() throws Exception {
        InputStreamReader isr = new InputStreamReader(System.in);
        BufferedReader br = new BufferedReader(isr);
        String s = br.readLine();
        return s;
    }


}