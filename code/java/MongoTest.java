/* code/java/MongoTest.java */

// javac -cp .:mongo-java-driver-3.7.0-rc0.jar MongoTest.java 
// java -cp .:mongo-java-driver-3.7.0-rc0.jar MongoTest

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;

import org.bson.Document;
import java.util.Arrays;

import java.util.ArrayList;
import java.util.List;

public class MongoTest {
 public static void main(String[] args) {
 
 
  // MongoClientURI connectionString = new MongoClientURI("mongodb://localhost:27017");
  // MongoClient mongoClient = new MongoClient(connectionString);
  MongoClient mongoClient = new MongoClient();

  MongoDatabase database = mongoClient.getDatabase("mydb"); // Creates the database if it doesn't exist, when we add documents to it.

  MongoCollection < Document > collection = database.getCollection("test");

  // To create a document, we use the Document class: https://mongodb.github.io/mongo-java-driver/3.4/driver/getting-started/quick-start/
  // We want to insert the following document:
  /*
  {
   "name" : "MongoDB",
   "type" : "database",
   "count" : 1,
   "versions": [ "v3.2", "v3.0", "v2.6" ],
   "info" : { "level" : "easy", "used" : "yes" }
  }
   */
   // Remember that the order does not matter.

  Document doc = new Document("name", "MongoDB");
  doc.append("type", "database");
  doc.append("count", 1);
  doc.append("versions", Arrays.asList("v3.2", "v3.0", "v2.6"));
  doc.append("info", new Document("level", "easy").append("used", "yes"));

  collection.insertOne(doc);

  List < Document > documents = new ArrayList < Document > ();
  for (int i = 0; i < 10; i++) {
   documents.add(new Document("i", i));
  }

  collection.insertMany(documents);

  System.out.println(collection.count());
  
 }
}
