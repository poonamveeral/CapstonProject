/* code/java/GuestProgram_Solution.java */

import java.sql.*;
import java.util.Scanner; // Importing a java API to read from the keyboard.

/* This first part is "standard". Just note that we allow multiple statements and that
   the ResultsSet we will construct with our conn objects will be scrollables.*/

public class GuestProgram_Solution {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/?user=testuser&password=password&allowMultiQueries=true"
   ); Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
  ) {
   stmt.execute(
    "DROP SCHEMA IF EXISTS HW_GUEST_PROGRAM;" +
    "CREATE SCHEMA HW_GUEST_PROGRAM;" +
    "USE HW_GUEST_PROGRAM;" +
    "CREATE TABLE GUEST(" +
    "Id INT PRIMARY KEY," +
    "Name VARCHAR(30)," +
    "Confirmed BOOL" +
    ");" +
    "CREATE TABLE BLACKLIST(" +
    "Name VARCHAR(30)" +
    ");" +
    "INSERT INTO BLACKLIST VALUES (\"Marcus Hells\");"
   );

   System.out.print("How many guests do you have?\n");
   Scanner key = new Scanner(System.in);
   int guest_total = key.nextInt();

   key.nextLine(); // "Hack" to flush the buffer. Please ignore.

   // EXERCISE 1
   int guest_id;
   String guest_name;
   int counter = 0;

   
   // Solution A
   while (counter < guest_total) {
    System.out.print("Enter name of guest " + (counter + 1) + ".\n");
    guest_name = key.nextLine();
    stmt.addBatch("INSERT INTO GUEST VALUES (" + counter + ", \"" + guest_name + "\", NULL)");
    counter++;
   }
   stmt.executeBatch();
    

   // Solution B
/*
   PreparedStatement ps = conn.prepareStatement("INSERT INTO GUEST VALUES(?, ?, NULL);");
   while (counter < guest_total) {
    System.out.print("Enter name of guest " + (counter + 1) + ".\n");
    guest_name = key.nextLine();
    ps.setInt(1, counter);
    ps.setString(2, guest_name);
    ps.executeUpdate();
    counter++;
   }
*/

   // Needed to test our solution to the following two exercises.
   stmt.execute("INSERT INTO GUEST VALUES (-1, \"Marcus Hells\", true);");
   stmt.execute("INSERT INTO GUEST VALUES (-2, \"Marcus Hells\", false);");

   // EXERCISE 2
   ResultSet rset = stmt.executeQuery("SELECT * FROM GUEST, BLACKLIST WHERE GUEST.Name = BLACKLIST.Name AND GUEST.Confirmed = true");
   if (rset.next()) {
    System.out.print("Oh no, (at least) one of the guest from the black list confirmed their presence!\nThe name of the first one is " + rset.getString(2) + ".\n");
   }

   // EXERCISE 3
   System.out.print("Do you want to remove all the guests that are on the black list and confirmed their presence? Enter \"Y\" for yes, anything else for no.\n");
   if (key.nextLine().equals("Y")) {
    stmt.execute("DELETE FROM GUEST WHERE NAME IN (SELECT NAME FROM BLACKLIST) AND Confirmed = true;");
   }

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
