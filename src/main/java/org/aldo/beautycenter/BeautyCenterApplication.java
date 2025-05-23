package org.aldo.beautycenter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class BeautyCenterApplication {

    public static void main(String[] args) {
        SpringApplication.run(BeautyCenterApplication.class, args);
    }

}
