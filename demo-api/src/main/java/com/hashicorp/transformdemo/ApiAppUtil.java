package com.hashicorp.transformdemo;

import com.hashicorp.transformdemo.entity.User;

import java.util.UUID;

public class ApiAppUtil {
    public User userSetup(String username, String password, String email, String creditcard, String flag) {
        User u = new User();
        u.setId(UUID.randomUUID().toString());
        u.setUsername(username);
        u.setPassword(password);
        u.setEmail(email);
        u.setCreditcard(creditcard);
        u.setFlag(flag);
        return u;
    }
}