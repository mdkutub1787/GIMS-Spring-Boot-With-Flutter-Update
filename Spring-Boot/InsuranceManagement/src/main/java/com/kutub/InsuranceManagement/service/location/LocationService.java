package com.kutub.InsuranceManagement.service.location;

import com.kutub.InsuranceManagement.entity.location.*;
import com.kutub.InsuranceManagement.repository.location.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {

    @Autowired
    private DivisionRepository divisionRepository;

    @Autowired
    private DistrictRepository districtRepository;

    @Autowired
    private ThanaRepository thanaRepository;

    @Autowired
    private PourashavaRepository pourashavaRepository;

    @Autowired
    private WardRepository wardRepository;

    @Autowired
    private UnionAreaRepository unionAreaRepository;

    @Autowired
    private CityCorporationRepository cityCorporationRepository;

    public List<Division> getAllDivisions() {
        return divisionRepository.findAll();
    }

    public List<District> getDistrictsByDivisionId(Long divisionId) {
        return districtRepository.findByDivisionId(divisionId);
    }

    public List<CityCorporation> getCityCorporationsByDistrictId(Long districtId) {
        return cityCorporationRepository.findByDistrictId(districtId);
    }

    public List<Thana> getThanasByDistrictId(Long districtId) {
        return thanaRepository.findByDistrictId(districtId);
    }

    public List<Thana> getThanasByCityCorporationId(Long cityCorporationId) {
        return thanaRepository.findByCityCorporationId(cityCorporationId);
    }

    public List<Pourashava> getPourashavasByThanaId(Long thanaId) {
        return pourashavaRepository.findByThanaId(thanaId);
    }

    public List<Ward> getWardsByPourashavaId(Long pourashavaId) {
        return wardRepository.findByPourashavaId(pourashavaId);
    }
    
    public List<Ward> getWardsByThanaId(Long thanaId) {
        return wardRepository.findByThanaId(thanaId);
    }

    public List<UnionArea> getUnionsByThanaId(Long thanaId) {
        return unionAreaRepository.findByThanaId(thanaId);
    }
}
