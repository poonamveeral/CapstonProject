/* code/java/TestForNull.java */

import java.sql.*;

public class TestForNull {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HW_DBPROG?user=testuser&password=password&createDatabaseIfNotExist=true&serverTimezone=UTC"); Statement stmt = conn.createStatement();
  ) {
   stmt.execute("CREATE TABLE Test (" +
    "A CHAR(25), " +
    "B INTEGER, " +
    "C DOUBLE)");

   String strAdd = "INSERT INTO Test VALUES (NULL, NULL, NULL);";
   int number_of_row_changed = stmt.executeUpdate(strAdd);
   System.out.print("This last query changed " + number_of_row_changed + " row(s).\n");

   ResultSet result = stmt.executeQuery("SELECT * FROM Test");

   if (result.next()) {
    System.out.print(result.getString(1) + " " + result.getDouble(2) + " " + result.getInt(3));
    if (result.getString(1) == null) {
     System.out.print("\nAnd null for CHAR in SQL is null for String in Java.\n");
    }
   }
   conn.close();
  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
