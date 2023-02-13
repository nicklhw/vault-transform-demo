package com.hashicorp.transformdemo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = { "spring.cloud.vault.authentication=NONE", "spring.cloud.vault.database.enabled=false" })
class VaultTransformDemoAppTest {

    @Test
    void contextLoads() {
    }

}