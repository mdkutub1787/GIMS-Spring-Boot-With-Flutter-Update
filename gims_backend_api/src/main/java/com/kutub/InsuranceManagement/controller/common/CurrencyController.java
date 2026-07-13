package com.kutub.InsuranceManagement.controller.common;

import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.common.CurrencyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("api/currency")
@CrossOrigin(origins = "*")
public class CurrencyController {

    @Autowired
    private CurrencyService currencyService;

    @GetMapping("/rate")
    public ResponseEntity<Object> getExchangeRate() {
        Double rate = currencyService.fetchExchangeRate();
        return ResponseEntity.ok(ApiResponse.success(Map.of("currency", "BDT", "usd_rate", rate)));
    }
}
