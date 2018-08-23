import ballerina/io;
import ballerina/mysql;

endpoint mysql:Client testDB{
    host: "localhost",
    port: 3306,
    name: "test",
    username: "root",
    password: "",
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
};

function main(string... args){

    io:println("Creating a table:");
    var ret = testDB -> update("CREATE TABLE student(id INT AUTO_INCREMENT, age INT, name varchar(10), PRIMARY KEY (id))");
    handleUpdate(ret, "Create Student Table");

    io:println("Insert Data to a table");
    var ins = testDB -> update("INSERT INTO student(age, name) VALUES (12,'Nimal')");
    handleUpdate(ins, "Insert Data into the Table");

    testDB.stop();
}

function handleUpdate(int|error returned, string message){
    match returned {
        int retInt => io:println(message+" status : "+retInt);
        error e => io:println(message+" failed "+e.message);
    }
}