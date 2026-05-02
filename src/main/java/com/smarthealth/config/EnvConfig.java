package com.smarthealth.config;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.File;

public class EnvConfig {
    private static final Dotenv dotenv;

    static {
        String workDir = System.getProperty("user.dir");
        System.out.println("[EnvConfig] Initializing. Working Directory: " + workDir);
        
        // Try multiple locations for .env
        Dotenv tempDotenv = null;
        String[] paths = {"./", "../", "./src/main/resources/", "../../"};
        
        for (String path : paths) {
            File envFile = new File(path + ".env");
            if (envFile.exists()) {
                System.out.println("[EnvConfig] Found .env at: " + envFile.getAbsolutePath());
                tempDotenv = Dotenv.configure()
                        .directory(path)
                        .ignoreIfMissing()
                        .load();
                break;
            }
        }
        
        if (tempDotenv == null) {
            System.err.println("[EnvConfig] WARNING: No .env file found in searched locations.");
            tempDotenv = Dotenv.configure().ignoreIfMissing().load();
        }
        dotenv = tempDotenv;
    }

    public static String get(String key) {
        String value = System.getenv(key);
        if (value == null) {
            value = dotenv.get(key);
        }
        if (value != null && !value.trim().isEmpty()) {
            return value.trim();
        }
        return value;
    }

    public static String get(String key, String defaultValue) {
        String value = get(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
}
