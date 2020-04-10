package edu.pw.shoppingm8.base.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.zalando.logbook.DefaultHttpLogFormatter;
import org.zalando.logbook.DefaultHttpLogWriter;
import org.zalando.logbook.Logbook;

import static org.zalando.logbook.Conditions.exclude;
import static org.zalando.logbook.Conditions.requestTo;

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
                        requestTo("/favicon.ico"),
                        requestTo("/public/**"),
                        requestTo("/json/**"),
                        requestTo("/")
                )).build();
    }
}
