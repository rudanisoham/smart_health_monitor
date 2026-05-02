package com.smarthealth.service;

import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class SmsService {

    // ───────────────── FAST2SMS CONFIGURATION ─────────────────
    private String getApiKey() {
        return com.smarthealth.config.EnvConfig.get("FAST2SMS_API_KEY", "PASTE_YOUR_FAST2SMS_API_KEY_HERE");
    }
    // ─────────────────────────────────────────────────────────

    public boolean sendSms(String toNumber, String content) {
        try {
            // Check if API key is still a placeholder
            if ("PASTE_YOUR_FAST2SMS_API_KEY_HERE".equals(getApiKey())) {
                System.out.println("[FAST2SMS SIMULATION] To: " + toNumber + " | Msg: " + content);
                return true; // Return true as simulation success
            }

            // Encode message and number to avoid URL issues
            String encodedMessage = URLEncoder.encode(content, StandardCharsets.UTF_8);
            String encodedNumber = URLEncoder.encode(toNumber.replaceAll("[^0-9]", ""), StandardCharsets.UTF_8);

            // Fast2SMS Quick SMS Route (route=q)
            String apiUrl = "https://www.fast2sms.com/dev/bulkV2?authorization=" + getApiKey() +
                    "&route=q&message=" + encodedMessage + "&language=english&flash=0&numbers=" + encodedNumber;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                System.out.println("[FAST2SMS SUCCESS] Response: " + response.toString());
                return true;
            } else {
                System.err.println("[FAST2SMS ERROR] HTTP Response Code: " + responseCode);
                return false;
            }
        } catch (Exception e) {
            System.err.println("[FAST2SMS EXCEPTION] Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
