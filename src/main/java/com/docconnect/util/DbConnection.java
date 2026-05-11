package com.docconnect.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database utility class for managing JDBC connections.
 * Loads configuration from db.properties file.
 */
public class DbConnection {

    private static final Logger LOGGER = Logger.getLogger(DbConnection.class.getName());
    private static String url;
    private static String username;
    private static String password;
    private static boolean initialized = false;

    static {
        loadProperties();
    }

    private DbConnection() {
        // Prevent instantiation
    }

    /**
     * Loads database properties from the db.properties file.
     */
    private static void loadProperties() {
        try (InputStream input = DbConnection.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (input == null) {
                LOGGER.severe("db.properties file not found in classpath!");
                return;
            }

            Properties props = new Properties();
            props.load(input);

            String driver = props.getProperty("db.driver");
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");

            // Load the JDBC driver
            Class.forName(driver);
            initialized = true;
            LOGGER.info("Database configuration loaded successfully.");

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to load database properties.", e);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found.", e);
        }
    }

    /**
     * Returns a new database connection.
     *
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            throw new SQLException("Database is not properly initialized. Check db.properties.");
        }
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Safely closes a connection.
     *
     * @param connection the connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database connection.", e);
            }
        }
    }

}
