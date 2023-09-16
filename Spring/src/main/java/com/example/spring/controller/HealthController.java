package com.example.spring.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class HealthController {

    @GetMapping("/healthz")
    public ResponseEntity<Void> returnHealthStatus() {
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
