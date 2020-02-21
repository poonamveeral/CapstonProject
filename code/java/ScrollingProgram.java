/* code/java/ScrollingProgram.java */

import java.sql.*;

public class ScrollingProgram {
 public static void main(String[] args) {
  try (
   Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/"
    // We connect to the database, not to a particular schema.
    +
    "?user=testuser" +
    "&password=password" +
    "&allowMultiQueries=true"
    // We want to allow multiple statements
    // to be shipped in one execute() call.
   );
   Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
   // Finally, we want to be able to move back and forth in our 
   // ResultSets. This implies that we have to also chose if the
   // ResultSets will be updatable or not: we chose to have them 
   // to be "read-only".
  ) {

   // Before you ask: no, there are no "simple" way of 
   // constructing a string over multiple lines,
   // besides concatenating them,
   // cf. e.g. https://stackoverflow.com/q/878573

   stmt.execute(
    "DROP SCHEMA IF EXISTS HW_SCROLLABLE_DEMO;" +
    // We drop the schema we want to use if it already exists.
    // (This allows to execute the same program multiple times.)
    "CREATE SCHEMA HW_SCROLLABLE_DEMO;" +
    "USE HW_SCROLLABLE_DEMO;" +
    // We create and use the schema.
    "CREATE TABLE TEST(" +
    "    Id INT" +
    ");"
    // The schema contains only one very simple table.
   );

   // We can execute all those queries at once
   // because we passed the "allowMultiQueries=true"
   // token when we created the Connection object.

   // Let us insert some dummy values in this dummy table:
   for (int i = 0; i < 10; i++)
    stmt.addBatch("INSERT INTO TEST VALUES (" + i + ")");
   // no ";" in the statements that we add 
   // to the batch!

   stmt.executeBatch();
   // We execute the 10 statements that were loaded
   // at once.

   // Now, let us write a simple query, and navigate in the result:

   ResultSet rs = stmt.executeQuery("SELECT * FROM TEST");
   /* We select all the tuples in the table.
      If we were to execute this instruction on the 
      command-line interface, we would get:

   MariaDB [HW_SCROLLABLE_DEMO]> SELECT * FROM TEST;
   +----+
   | Id |
   +----+
   | 0  |
   | 1  |
   | 2  |
   | 3  |
   | 4  |
   | 5  |
   | 6  |
   | 7  |
   | 8  |
   | 9  |
   +----+
   10 rows in set (0.001 sec)

   */

   // We can "jump" to the 8th result in the set:
   rs.absolute(8);
   System.out.printf("%-22s %s %d.\n", "After absolute(8),", "we are at Id", rs.getInt(1));
   // Note that this would display "7" since the 
   // 8th result contains the value 7 (sql starts
   // counting at 1.

   // We can move back 1 item:
   rs.relative(-1);
   System.out.printf("%-22s %s %d.\n", "After relative(-1),", "we are at Id", rs.getInt(1));

   // We can move to the last item:
   rs.last();
   System.out.printf("%-22s %s %d.\n", "After last(),", "we are at Id", rs.getInt(1));

   // We can move to the first item:
   rs.first();
   System.out.printf("%-22s %s %d.\n", "After first(),", "we are at Id", rs.getInt(1));


   conn.close();
  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
 
