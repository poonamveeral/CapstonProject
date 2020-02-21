/* code/java/SimpleInjection_3.java */

import java.sql.*;
import java.util.Scanner; // Importing a java API to read from the keyboard.

public class SimpleInjection_3 {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/?user=testuser&password=password" +
    "&allowMultiQueries=true"
   ); Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
  ) {
   stmt.addBatch("DROP SCHEMA IF EXISTS HW_SIMPLE_INJECTION_3");
   stmt.addBatch("CREATE SCHEMA HW_SIMPLE_INJECTION_3");
   stmt.addBatch("USE HW_SIMPLE_INJECTION_3");
   stmt.addBatch("CREATE TABLE SECRETVIP(Name VARCHAR(30))");
   stmt.addBatch("INSERT INTO SECRETVIP VALUES (\"Marcus Hells\")");
   stmt.executeBatch();

   Scanner key = new Scanner(System.in);


   System.out.print("\n\nTo test the program, enter\n" +
    "\t• \"Marcus Hells\" (without the quotes) to confirm that guessing correctly triggers the correct result,\n" +
    "\t• anything else to confirm that guessing correctly triggers the correct result.\n\n" +
    "This program uses prepared statement, and as such is extremely good at preventing SQL injections.\n\n");

   PreparedStatement ps = conn.prepareStatement("SELECT * FROM SECRETVIP WHERE Name = ?;");

   while (true) {
    System.out.print("\n\nType the name of someone who may be the secret VIP.\n");

    String entered = key.nextLine();

    ps.setString(1, entered);
    ResultSet rset = ps.executeQuery();

    if (rset.next()) {
     System.out.print("Yes, " + rset.getString(1) + "is our secret VIP!\n");
    } else {
     System.out.print("Nope, " + entered + " is not our secret VIP.\n");
    }
   }

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
