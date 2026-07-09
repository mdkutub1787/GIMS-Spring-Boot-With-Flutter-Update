package com.kutub.InsuranceManagement.controller.location;

import com.kutub.InsuranceManagement.entity.location.*;
import com.kutub.InsuranceManagement.model.ApiResponse;
import com.kutub.InsuranceManagement.service.location.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("api/location")
@CrossOrigin(origins = "*")
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/divisions")
    public ResponseEntity<ApiResponse<List<Division>>> getAllDivisions() {
        List<Division> divisions = locationService.getAllDivisions();
        return ResponseEntity.ok(ApiResponse.success(divisions));
    }

    @GetMapping("/districts")
    public ResponseEntity<ApiResponse<List<District>>> getDistrictsByDivisionId(@RequestParam Long divisionId) {
        List<District> districts = locationService.getDistrictsByDivisionId(divisionId);
        return ResponseEntity.ok(ApiResponse.success(districts));
    }

    @GetMapping("/city-corporations")
    public ResponseEntity<ApiResponse<List<CityCorporation>>> getCityCorporationsByDistrictId(@RequestParam Long districtId) {
        List<CityCorporation> cityCorporations = locationService.getCityCorporationsByDistrictId(districtId);
        return ResponseEntity.ok(ApiResponse.success(cityCorporations));
    }

    @GetMapping("/thanas")
    public ResponseEntity<ApiResponse<List<Thana>>> getThanas(
            @RequestParam Optional<Long> districtId,
            @RequestParam Optional<Long> cityCorporationId) {

        List<Thana> thanas;
        if (districtId.isPresent()) {
            thanas = locationService.getThanasByDistrictId(districtId.get());
        } else if (cityCorporationId.isPresent()) {
            thanas = locationService.getThanasByCityCorporationId(cityCorporationId.get());
        } else {
            return ResponseEntity.badRequest().body(ApiResponse.error("Either districtId or cityCorporationId is required."));
        }
        return ResponseEntity.ok(ApiResponse.success(thanas));
    }

    @GetMapping("/pourashavas")
    public ResponseEntity<ApiResponse<List<Pourashava>>> getPourashavasByThanaId(@RequestParam Long thanaId) {
        List<Pourashava> pourashavas = locationService.getPourashavasByThanaId(thanaId);
        return ResponseEntity.ok(ApiResponse.success(pourashavas));
    }

    @GetMapping("/wards")
    public ResponseEntity<ApiResponse<List<Ward>>> getWards(
            @RequestParam Optional<Long> pourashavaId,
            @RequestParam Optional<Long> thanaId) {

        List<Ward> wards;
        if (pourashavaId.isPresent()) {
            wards = locationService.getWardsByPourashavaId(pourashavaId.get());
        } else if (thanaId.isPresent()) {
            wards = locationService.getWardsByThanaId(thanaId.get());
        } else {
            return ResponseEntity.badRequest().body(ApiResponse.error("Either pourashavaId or thanaId is required."));
        }
        return ResponseEntity.ok(ApiResponse.success(wards));
    }

    @GetMapping("/unions")
    public ResponseEntity<ApiResponse<List<UnionArea>>> getUnionsByThanaId(@RequestParam Long thanaId) {
        List<UnionArea> unions = locationService.getUnionsByThanaId(thanaId);
        return ResponseEntity.ok(ApiResponse.success(unions));
    }
}
