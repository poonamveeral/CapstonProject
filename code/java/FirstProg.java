// code/java/FirstProg.java

import java.sql.*;

public class FirstProg {
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
   String strSelect = "SELECT title, price, qty FROM BOOKS WHERE qty > 40";
   System.out.print("The SQL query is: " + strSelect + "\n");
   ResultSet rset = stmt.executeQuery(strSelect);

   System.out.println("The records selected are:");
   int rowCount = 0;
   String title;
   double price;
   int qty;

   while (rset.next()) {
    title = rset.getString("title");
    price = rset.getDouble("price");
    qty = rset.getInt("qty");
    System.out.println(title + ", " + price + ", " + qty);
    rowCount++;
   }

   System.out.println("Total number of records = " + rowCount);
   conn.close();

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
