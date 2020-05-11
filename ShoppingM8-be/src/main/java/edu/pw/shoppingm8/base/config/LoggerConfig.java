package edu.pw.shoppingm8.base.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.zalando.logbook.DefaultHttpLogFormatter;
import org.zalando.logbook.DefaultHttpLogWriter;
import org.zalando.logbook.Logbook;

import static org.zalando.logbook.Conditions.*;

@Configuration
@Slf4j
public class LoggerConfig {
    @Bean
    public Logbook logbook() {
        return Logbook.builder()
                .writer(new DefaultHttpLogWriter(log, DefaultHttpLogWriter.Level.INFO))
                .formatter(new DefaultHttpLogFormatter())
                .condition(exclude(
                        requestTo("/swagger-resources/**"),
                        requestTo("/h2/**"),
                        requestTo("**/swagger-ui/**"),
                        requestTo("**/swagger-ui.html**"),
                        requestTo("**/csrf"),
                        requestTo("**/api-docs"),
                        requestTo("**/springfox-swagger-ui/**"),
                        requestTo("/favicon.ico"),
                        requestTo("/public/**"),
                        requestTo("/json/**"),
                        requestTo("/"),
                        contentType("image/jpeg", "image/png")
                )).build();
    }
}
