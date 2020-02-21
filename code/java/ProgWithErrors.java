/* code/java/ProgWithErrors.java */

import java.sql.*; 

public class ProgWithErrors{
  public static void main(String[] args) {
    try (
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/"
      +"HW_TestDB?user=testuser&password=password");
      Statement stmt = conn.createStatement();
    ) {  

/* Errors after this point.*/

      String strSelect = "SELECT title FROM DISKS WHERE qty > 40;";
      ResultSet rset = stmt.executeUpdate(strSelect);

      System.out.println("The records selected are: (listed last first):");
      rset.last();

      while(rset.previous()) {
        String title = rset.getDouble("title");
        System.out.println(title + "\n");
      }

      String sss = "SELECT title FROM DISKS WHERE Price <= ?";
      PreparedStatement ps = conn.prepareStatement(sss);
      ResultSet result = ps.executeQuery();

      conn.close();

/* Errors before this point.*/

    } catch(SQLException ex) {
        ex.printStackTrace();
    }
  }
}  
