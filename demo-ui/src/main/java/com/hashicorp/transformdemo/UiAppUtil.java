package com.hashicorp.transformdemo;

import com.hashicorp.transformdemo.model.User;
import org.json.JSONObject;
import org.springframework.ui.Model;
import org.springframework.web.util.UriComponentsBuilder;

public class UiAppUtil {
    public String urlBuilder(String host, String path, String username, String password, String email, String creditcard){
        return UriComponentsBuilder.fromUriString(host)
                .path("api/v1/" + path + "/add-user")
                .queryParam("username", username)
                .queryParam("password", password)
                .queryParam("email", email)
                .queryParam("creditcard", creditcard)
                .build()
                .toString();
    }
    public void userSetup(String response, Model model) {
        User user = new User();
        JSONObject jsonObject = new JSONObject(response);
        user.setUsername(jsonObject.getString("username"));
        user.setEmail(jsonObject.getString("email"));
        user.setCreditcard(jsonObject.getString("creditcard"));
        model.addAttribute("userinfo", user);
    }
}