package com.docconnect.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to handle database connections.
 */
public class DbConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/docconnect_nepal?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
