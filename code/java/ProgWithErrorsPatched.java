/* code/java/ProgWithErrorsPatched.java */

import java.sql.*;

public class ProgWithErrorsPatched {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/" +
    "HW_TestDB?user=testuser&password=password"); Statement stmt = conn.createStatement();
  ) {

   /* Errors after this point.*/

   String strSelect = "SELECT title FROM DISKS WHERE qty > 40;";
   ResultSet rset = stmt.executeQuery(strSelect); // Error 1

   System.out.println("The records selected are: (listed last first):");
   rset.last();

   do { // Error 2
    String title = rset.getString("title"); // Error 3
    System.out.println(title); // Not an error, but we probably don't need two new lines.
   } while (rset.previous()); // Error 2 bis

   String sss = "SELECT title FROM DISKS WHERE Price <= ?";
   PreparedStatement ps = conn.prepareStatement(sss);
   ps.setInt(1, 10); // Error 4
   ResultSet result = ps.executeQuery();

   conn.close();

   /* Errors before this point.*/

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
