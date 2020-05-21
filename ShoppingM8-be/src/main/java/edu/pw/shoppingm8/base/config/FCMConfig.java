package edu.pw.shoppingm8.base.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Configuration
@Slf4j
public class FCMConfig {
    private final String firebaseConfigurationFilePath;

    public FCMConfig(@Value("${shoppingM8.fcm.configuration-file}") String firebaseConfigurationFilePath) {
        this.firebaseConfigurationFilePath = firebaseConfigurationFilePath;
    }

    @PostConstruct
    public void initialize() {
        try {
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(new ClassPathResource(firebaseConfigurationFilePath).getInputStream()))
                    .build();
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("FCM initialized");
            }
        } catch (IOException e) {
            log.error("Could not initialize FCM", e);
        }
    }
}
