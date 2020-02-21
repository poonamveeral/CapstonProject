/* code/java/SimpleInjection_2.java */

import java.sql.*;
import java.util.Scanner; // Importing a java API to read from the keyboard.

public class SimpleInjection_2 {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/?user=testuser&password=password" +
    "&allowMultiQueries=true"
   ); Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
  ) {
   stmt.addBatch("DROP SCHEMA IF EXISTS HW_SIMPLE_INJECTION_2");
   stmt.addBatch("CREATE SCHEMA HW_SIMPLE_INJECTION_2");
   stmt.addBatch("USE HW_SIMPLE_INJECTION_2");
   stmt.addBatch("CREATE TABLE SECRETVIP(Name VARCHAR(30))");
   stmt.addBatch("INSERT INTO SECRETVIP VALUES (\"Marcus Hells\")");
   stmt.executeBatch();

   Scanner key = new Scanner(System.in);


   System.out.print("\n\nTo test the program, enter\n" +
    "\t• \"Marcus Hells\" (without the quotes) to confirm that guessing correctly triggers the correct result,\n" +
    "\t• \"nope'; DROP SCHEMA HW_SIMPLE_INJECTION_2;\" (without the double quotes (\")) to perform an SQL injection.\n" +
    "\t• anything else to confirm that guessing correctly triggers the correct result,\n");

   while (true) {
    System.out.print("\n\nType the name of someone who may be the secret VIP.\n");

    String entered = key.nextLine();

    stmt.execute("SELECT * FROM SECRETVIP WHERE Name ='" + entered + "';");
    ResultSet rst = stmt.getResultSet();

    boolean found = rst.first();

    if (found) {
     System.out.print("Yes, you found it!\n");
    } else {
     System.out.print("Nope, " + entered + " is not our secret VIP.\n");
    }
   }

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
