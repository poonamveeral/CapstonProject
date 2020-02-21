/* code/java/GuestProgram.java */

import java.sql.*;
import java.util.Scanner; // Importing a java API to read from the keyboard.

// This first part is "standard". Just note that we allow multiple statements.

public class GuestProgram {
	public static void main(String[] args) {
		try (
		Connection conn = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/?user=testuser&password=password"
		+"&allowMultiQueries=true"
		);
		Statement stmt = conn.createStatement();
		) {
// We create a schema, use it, create two tables, and insert a value in the second one.
			stmt.execute(
			"CREATE SCHEMA HW_GUEST_PROGRAM;" +
			"USE HW_GUEST_PROGRAM;"
			"CREATE TABLE GUEST(" +
				"Id INT PRIMARY KEY," +
				"Name VARCHAR(30)," +
				"Confirmed BOOL" +
			");" +
			"CREATE TABLE BLACKLIST(" +
				"Name VARCHAR(30)" +
			");" +
			"INSERT INTO BLACKLIST VALUES (\"Marcus Hells\");";
			);
			
			// INSERT HERE Solution to exercises 1, 2 and 3.
			// Tip for Exercise 1, this solves the first item.
			System.out.print("How many guests do you have?\n");
			Scanner key = new Scanner(System.in);
			int guest_total = key.nextInt();

		} catch (SQLException ex) {
			ex.printStackTrace();
		}
	}
}
