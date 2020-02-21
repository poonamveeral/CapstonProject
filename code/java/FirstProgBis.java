// code/java/FirstProgBis.java

import java.sql.*;

public class FirstProgBis {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/HW_EBOOKSHOP",
    "testuser",
    "password"
   );
   /* If at execution time you receive an error that starts with
    * "java.sql.SQLException: The server time zone value 'EDT' is unrecognized or 
    * represents more than one time zone. You must configure either the server ..."
    * add ?serverTimezone=UTC at the end of the previous string,
    * i.e., replace the previous line of code with:
    * Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HW_EBOOKSHOP?serverTimezone=UTC", "testuser","password");
    * cf. for instance https://stackoverflow.com/q/26515700
    */
   Statement stmt = conn.createStatement();
  ) {
   String strSelect = "SELECT * FROM BOOKS";
   ResultSet rset = stmt.executeQuery(strSelect);

   System.out.println("The records selected are:");

   ResultSetMetaData rsmd = rset.getMetaData();
   int columnsNumber = rsmd.getColumnCount();
   String columnValue;
   while (rset.next()) {
    for (int i = 1; i <= columnsNumber; i++) {
     if (i > 1) System.out.print(",  ");
     columnValue = rset.getString(i);
     System.out.print(columnValue + " " + rsmd.getColumnName(i));
    }
    System.out.println();
   }
   conn.close();
  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
