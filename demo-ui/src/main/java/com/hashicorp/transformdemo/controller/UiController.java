package com.hashicorp.transformdemo.controller;

import com.hashicorp.transformdemo.UiAppUtil;
import com.hashicorp.transformdemo.service.UiService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class UiController {

    private final UiService uiService;

    public UiController(UiService uiService) {
        this.uiService = uiService;
    }

    @GetMapping(value = "/")
    public String home(Model model) throws Exception {
        model.addAttribute("eusers", this.uiService.getEncryptedUsers());
        model.addAttribute("tusers", this.uiService.getTransformedUsers());
        model.addAttribute("stusers", this.uiService.getSimpleTransformedUsers());
        model.addAttribute("stestusers", this.uiService.getSimplestTransformedUsers());
        model.addAttribute("dtusers", this.uiService.getDefaultTokenizationUsers());
        model.addAttribute("ctusers", this.uiService.getConvergentTokenizationUsers());
        return "ui/index";
    }

    @PostMapping(value = "/encrypt")
    public String encrypt(HttpServletRequest request) {
        String howto = "";

        if(request.getParameter("transit") != null) {
            howto = "transit";
        } else if (request.getParameter("transformation") != null) {
            howto = "transformation";
        } else if (request.getParameter("simple-transformation") != null) {
            howto = "simple-transformation";
        } else if (request.getParameter("simplest-transformation") != null) {
            howto = "simplest-transformation";
        } else if (request.getParameter("default-tokenization") != null) {
            howto = "default-tokenization";
        } else if (request.getParameter("convergent-tokenization") != null) {
            howto = "convergent-tokenization";
        }
        this.uiService.addOneEncryptedUser(
                request.getParameter("username"),
                request.getParameter("password"),
                request.getParameter("email"),
                request.getParameter("creditcard"),
                howto
        );
        return "redirect:/";
    }

    @PostMapping(value = "/decrypt")
    public String decrypt(HttpServletRequest request, Model model) {
        this.uiService.getOneDecryptedUser(request.getParameter("username"));
        String response = this.uiService.getOneDecryptedUser(request.getParameter("username"));
        new UiAppUtil().userSetup(response, model);
        return "ui/userinfo";
    }

    @PostMapping(value = "/decode")
    public String decode(HttpServletRequest request, Model model) {
        String response = this.uiService.getOneDecodedUser(request.getParameter("username"), request.getParameter("flag"));
        new UiAppUtil().userSetup(response, model);
        return "ui/userinfo";
    }
}