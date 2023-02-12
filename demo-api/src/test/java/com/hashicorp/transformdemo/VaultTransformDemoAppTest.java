package com.hashicorp.transformdemo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = "spring.cloud.vault.authentication=NONE")
class VaultTransformDemoAppTest {

    @Test
    void contextLoads() {
    }

}