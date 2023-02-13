package com.hashicorp.transformdemo;

import org.json.JSONObject;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class TransformUtil {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    private String vaultHost = System.getenv("SPRING_CLOUD_VAULT_HOST") != null ? System.getenv("SPRING_CLOUD_VAULT_HOST") : "localhost";

    public String encode(String value, String transformationName) {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        Map<String, Object> input = new LinkedHashMap<>();
        input.put("transformation", transformationName);
        input.put("value", value);

        System.out.println(input.toString());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(input, headers);

        ResponseEntity<String> response = this.restTemplate().postForEntity(String.format("http://%s:8100/v1/transform/encode/payments", vaultHost), entity, String.class);
        JSONObject jsonObject = new JSONObject(response.getBody());

        return jsonObject.getJSONObject("data").getString("encoded_value");
    }

    public String decode(String value, String transformationName) {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        Map<String, Object> input = new LinkedHashMap<>();
        input.put("transformation", transformationName);
        input.put("value", value);

        System.out.println(input.toString());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(input, headers);

        ResponseEntity<String> response = this.restTemplate().postForEntity(String.format("http://%s:8100/v1/transform/decode/payments", vaultHost), entity, String.class);
        JSONObject jsonObject = new JSONObject(response.getBody());

        return jsonObject.getJSONObject("data").getString("decoded_value");
    }

    public String masking(String value, String transformationName) {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        Map<String, Object> input = new LinkedHashMap<>();
        input.put("transformation", transformationName);
        input.put("value", value);

        System.out.println(input.toString());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(input, headers);

        ResponseEntity<String> response = this.restTemplate().postForEntity(String.format("http://%s:8100/v1/transform/encode/payments", vaultHost), entity, String.class);
        JSONObject jsonObject = new JSONObject(response.getBody());

        return jsonObject.getJSONObject("data").getString("encoded_value");
    }

}