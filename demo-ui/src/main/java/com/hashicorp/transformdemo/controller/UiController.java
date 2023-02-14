package com.hashicorp.transformdemo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import javax.servlet.http.HttpServletRequest;

@Controller
public class UiController {

    public UiController() {
    }

    @GetMapping(value = "/")
    public String home(Model model) throws Exception {
        return "ui/index";
    }
}