/* code/java/InsecureProgram.java */

import java.sql.*;
import java.util.Scanner;

public class InsecureProgram {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/?user=testuser&password=password");
    Statement stmt = conn.createStatement();
  ) {

   stmt.addBatch("DROP SCHEMA IF EXISTS HW_InsecureProgram");
   stmt.addBatch("CREATE SCHEMA HW_InsecureProgram");
   stmt.addBatch("USE HW_InsecureProgram");
   stmt.addBatch("CREATE TABLE DISK(Title VARCHAR(30), Price DOUBLE)");
   stmt.addBatch("CREATE TABLE BOOK(Title VARCHAR(30), Price DOUBLE)");
   stmt.addBatch("CREATE TABLE VINYL(Title VARCHAR(30), Price DOUBLE)");
   stmt.addBatch("INSERT INTO DISK VALUES('test', 12)");
   stmt.addBatch("INSERT INTO DISK VALUES('Hidden', NULL)");
   stmt.executeBatch();

   Scanner key = new Scanner(System.in);
   System.out.print("Do you want to browse the table containing DISK, BOOK or VINYL? (please enter exactly the table name)?\n");
   String table = key.nextLine();
   System.out.print("How much money do you have?\n");
   String max = key.nextLine();
   ResultSet rst = stmt.executeQuery("SELECT Title FROM " + table + " WHERE PRICE <= " + max + ";");
    System.out.printf("Here are the %s you can afford with %s: \n", table, max);
   while(rst.next()){
    System.out.printf("\t- %s \n", rst.getString(1));
   }

  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
