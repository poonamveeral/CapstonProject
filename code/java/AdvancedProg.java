/* code/java/AdvancedProg.java */

/*

  This is a long program, introducing:
  I. How to pass options when connecting to the database,
  II.  How to create a table
  III. How to insert values
  IV. How to use prepared statements
  V. How to read backward and write in ResultSets
                 
  If you want to run this program multiple times, you have to either:

  1. Comment first statement of II. Creating a table
  2. Change the name of the schema, from HW_DBPROG to whatever you want
  3. Drop the DVD table: connect to your database, and then enter
  USE HW_DBPROG;
  DROP TABLE DVD;
  Or do it from within your program!
    
  If you use option 1, you will keep inserting tuples in your table: cleaning it with 
  DELETE FROM DVD;
  can help. You can do it from within the program!
*/

import java.sql.*;

public class AdvancedProg {
 public static void main(String[] args) {
  try (

   /*
    * I. Passing options to the dababse
    */

   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HW_DBPROG" +
    "?user=testuser" +
    "&password=password" +
    "&allowMultiQueries=true" +
    "&createDatabaseIfNotExist=true" +
    "&useSSL=true");

   // Read about other options at 
   // https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-configuration-properties.html
   // https://jdbc.postgresql.org/documentation/head/connect.html

   Statement stmt = conn.createStatement();
  ) {

   /*
    * II. Creating a table
    */

   stmt.execute("CREATE TABLE DVD (" +
    "Title CHAR(25) PRIMARY KEY, " +
    "Minutes INTEGER, " +
    "Price DOUBLE)");

   /* If we were to execute
    * SHOW TABLES
    * directly in the MySQL interpreter, this would display at the screen
    *        
    * +--------------------------+
    * | Tables_in_HW_NewDataBase |
    * +--------------------------+
    * | DVD                      |
    * +--------------------------+
    *        
    * But here, to access this information, we will use the connection's metadata.
    */

   DatabaseMetaData md = conn.getMetaData();
   // DatabaseMetaData is a class used to get information about the database: the driver, the user, the versions, etc.

   ResultSet rs = md.getTables(null, null, "%", null);

   /* 
    * You can read at
    * https://docs.oracle.com/javase/7/docs/api/java/sql/DatabaseMetaData.html#getTables(java.lang.String,%20java.lang.String,%20java.lang.String,%20java.lang.String[])
    * the full specification of this method.
    * All you need to know, for now, is that the third parameter is 
    *       String tableNamePattern,
    * i.e., what must match the table name as it is stored in the database
    * Here, by using the wildcard "%", we select all the table names.
    * We can then iterate over the ResultSet as usual:
    */

   while (rs.next()) {
    System.out.println(rs.getString(3)); // In the ResultSet returned by getTables, 3 is the TABLE_NAME.
   }

   /*
    *  III. Inserting values
    */

   String sqlStatement = "INSERT INTO DVD VALUES ('Gone With The Wind', 221, 3);";
   int rowsAffected = stmt.executeUpdate(sqlStatement);
   System.out.print(sqlStatement + " changed " + rowsAffected + " row(s).\n");


   /*
    * Batch Insertion
    */

   String insert1 = "INSERT INTO DVD VALUES ('Aa', 129, 0.2)";
   String insert2 = "INSERT INTO DVD VALUES ('Bb', 129, 0.2)";
   String insert3 = "INSERT INTO DVD VALUES ('Cc', 129, 0.2)";
   String insert4 = "INSERT INTO DVD VALUES ('DD', 129, 0.2)";

   // Method 1: Using executeUpdate, if the option allowMultiQueries=true was passed in the url given to getConnection and your DBMS supports it.
   stmt.executeUpdate(insert1 + ";" + insert2);

   // Method 2: Using the addBatch and executeBatch methods
   stmt.addBatch(insert3);
   stmt.addBatch(insert4);
   stmt.executeBatch();


   /*
    * IV. Prepared Statements
    */

   // Example 1
   sqlStatement = "SELECT title FROM DVD WHERE Price <= ?"; // We have a string with an empty slot, represented by "?".
   PreparedStatement ps = conn.prepareStatement(sqlStatement); // We create a PreparedStatement object, using that string with an empty slot.
   // Note that once the object is created, we cannot change the content of the query, beside instantiating the slot.
   // cf. e.g. the discussion at <https://stackoverflow.com/q/25902881/>.
   double maxprice = 0.5;
   ps.setDouble(1, maxprice); // This statement says "Fill the first slot with the value of maxprice".
   ResultSet result = ps.executeQuery(); // And then we can execute the query, and display the results:

   System.out.printf("For %.2f you can get:\n", maxprice);

   while (result.next()) {
    System.out.printf("\t %s \n", result.getString(1));
   }

   // Example 2
   sqlStatement = "INSERT INTO DVD VALUES (?, ?, ?)"; // Now, our string has 3 empty slots, and it is an INSERT statement.
   PreparedStatement preparedStatement = conn.prepareStatement(sqlStatement);

   preparedStatement.setString(1, "The Great Dictator");
   preparedStatement.setInt(2, 124);
   preparedStatement.setDouble(3, 5.4);

   rowsAffected = preparedStatement.executeUpdate(); // You can check "by hand" that this statement was correctly executed.
   System.out.print(preparedStatement.toString() + " changed " + rowsAffected + " row(s).\n");


   // If we try to mess things up, i.e., provide wrong datatypes:
   preparedStatement.setString(1, "The Great Dictator");
   preparedStatement.setString(2, "The Great Dictator");
   preparedStatement.setString(3, "The Great Dictator");

   // Java compiler will be ok, but we'll have an error at execution time when executing the query. You can uncomment the line below to see for yourself.
   //rowsAffected = preparedStatement.executeUpdate();

   // Of course, we can use prepared statement inside loops.
   for (int i = 1; i < 5; i++) {
    preparedStatement.setString(1, "Saw " + i);
    preparedStatement.setInt(2, 100);
    preparedStatement.setDouble(3, .5);
    preparedStatement.executeUpdate();
   }

   /* 
    * V. Reading backward and writing in ResultSets
    */

   // To read backward and write in ResultSets, you need to have a statement with certain options:

   Statement stmtNew = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

   /*
    * Those options change two things about the ResultSet we obtain using this statement
    *
    * The first argument is the scrolling level:
    * TYPE_FORWARD_ONLY = default.
    * TYPE_SCROLL_INSENSITIVE = can scroll, but updates don't impact result set.
    * TYPE_SCROLL_SENSITIVE = can scroll, update impact result set.
    *
    * The second argument is the concurrency level:
    * CONCUR_READ_ONLY: default.
    * CONCUR_UPDATABLE: we can change the database without issuing SQL statement.
    */

   /*
    * Reading backward
    */

   sqlStatement = "SELECT title FROM DVD WHERE Price < 1;";
   result = stmtNew.executeQuery(sqlStatement);

   System.out.println("For $1, you can get:");

   if (result.last()) { // We can jump to the end of the ResultSet
    System.out.print(result.getString("Title") + " ");
   }

   System.out.print("and also, (in reverse order)");

   while (result.previous()) { // Now we can scroll back!
    System.out.print(result.getString("Title") + " ");
   }

   /* 
    * Other methods to navigate in ResultSet:
    * first()
    * last()
    * next()
    * previous()
    * relative(x) : move cursor x times (positive = forward, negative = backward)
    * absolute(x): move to the row number x. 1 is the first.
    */

   /*
    * Changing the values
    */

   System.out.print("\n\nLet us apply a 50% discount. Currently, the prices are:\n");

   sqlStatement = "SELECT title, price FROM DVD;";
   result = stmtNew.executeQuery(sqlStatement);
   while (result.next()) {
    System.out.printf("%20s \t $%3.2f\n", result.getString("title"), result.getDouble("price"));
   }


   result.absolute(0); // We need to scroll back!

   while (result.next()) {
    double current = result.getDouble("price");
    result.updateDouble("price", (current * 0.5));
    result.updateRow();
   }
   System.out.print("\n\nAfter update, the prices are:\n");

   result.absolute(0); // We need to scroll back!

   while (result.next()) {
    System.out.printf("%20s \t $%3.2f\n", result.getString("title"), result.getDouble("price"));
   }


   conn.close();
  } catch (SQLException ex) {
   ex.printStackTrace();
  }
 }
}
