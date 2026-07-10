package com.kutub.InsuranceManagement.config;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kutub.InsuranceManagement.entity.utility.Bank;
import com.kutub.InsuranceManagement.entity.utility.Branch;
import com.kutub.InsuranceManagement.entity.utility.InsuranceCompany;
import com.kutub.InsuranceManagement.repository.utility.BankRepository;
import com.kutub.InsuranceManagement.repository.utility.BranchRepository;
import com.kutub.InsuranceManagement.repository.utility.InsuranceCompanyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Component
public class DataLoader implements CommandLineRunner {

    @Autowired
    private BankRepository bankRepository;

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private InsuranceCompanyRepository insuranceCompanyRepository;

    private static final java.util.Map<String, String> jsonToDbMap = java.util.Map.ofEntries(
        java.util.Map.entry("AB BANK LIMITED", "AB Bank Ltd."),
        java.util.Map.entry("AGRANI BANK LIMITED", "Agrani Bank"),
        java.util.Map.entry("AL-ARAFAH ISLAMI BANK LIMITED", "Al-Arafah Islami Bank Ltd."),
        java.util.Map.entry("BASIC BANK LTD", "BASIC Bank"),
        java.util.Map.entry("BRAC BANK LIMITED", "BRAC Bank Ltd."),
        java.util.Map.entry("BANGLADESH COMMERCE BANK LIMITED", "Bangladesh Commerce Bank Ltd."),
        java.util.Map.entry("BANGLADESH DEVELOPMENT BANK LIMITED", "Bangladesh Development Bank"),
        java.util.Map.entry("BANGLADESH KRISHI BANK", "Bangladesh Krishi Bank"),
        java.util.Map.entry("BANK ALFALAH LIMITED", "Bank Al-Falah"),
        java.util.Map.entry("BANK ASIA LIMITED", "Bank Asia Ltd."),
        java.util.Map.entry("CITIBANK N.A", "CITI Bank NA"),
        java.util.Map.entry("COMMERCIAL BANK OF CEYLON LIMITED", "Commercial Bank of Ceylon"),
        java.util.Map.entry("DHAKA BANK LIMITED", "Dhaka Bank Ltd."),
        java.util.Map.entry("DUTCH-BANGLA BANK LIMITED", "Dutch Bangla Bank Ltd."),
        java.util.Map.entry("EXIM BANK LTD", "EXIM Bank Ltd."),
        java.util.Map.entry("EASTERN BANK LIMITED", "Eastern Bank Ltd."),
        java.util.Map.entry("FIRST SECURITY ISLAMI BANK LIMITED", "First Security Islami Bank Ltd."),
        java.util.Map.entry("HONGKONG AND SHANGHAI BANKING CORP", "HSBC"),
        java.util.Map.entry("HABIB BANK LIMITED", "Habib Bank Ltd."),
        java.util.Map.entry("ICB ISLAMIC BANK LIMITED", "ICB Islamic Bank"),
        java.util.Map.entry("INTERNATIONAL FINANCE INVEST AND COMMERCE BANK LIMITED", "IFIC Bank Ltd."),
        java.util.Map.entry("ISLAMI BANK BANGLADESH LIMITED", "Islami Bank Bangladesh Ltd."),
        java.util.Map.entry("JAMUNA BANK LIMITED", "Jamuna Bank Ltd."),
        java.util.Map.entry("JANATA BANK LIMITED", "Janata Bank"),
        java.util.Map.entry("MEGHNA BANK LIMITED", "Meghna Bank Ltd."),
        java.util.Map.entry("MERCANTILE BANK LIMITED", "Mercantile Bank Ltd."),
        java.util.Map.entry("MODHUMOTI BANK LIMITED", "Modhumoti Bank Ltd."),
        java.util.Map.entry("MUTUAL TRUST BANK LIMITED", "Mutual Trust Bank Ltd."),
        java.util.Map.entry("NATIONAL CREDIT &amp; COMMERCE BANK LIMITED", "NCC Bank Ltd."),
        java.util.Map.entry("NRB BANK LIMITED", "NRB Bank Ltd."),
        java.util.Map.entry("NRB COMMERCIAL BANK LIMITED", "NRB Commercial Bank Ltd."),
        java.util.Map.entry("NATIONAL BANK LIMITED", "National Bank Ltd."),
        java.util.Map.entry("NATIONAL BANK OF PAKISTAN", "National Bank of Pakistan"),
        java.util.Map.entry("ONE BANK LIMITED", "One Bank Ltd."),
        java.util.Map.entry("THE PREMIER BANK LIMITED", "Premier Bank Ltd."),
        java.util.Map.entry("PRIME BANK LIMITED", "Prime Bank Ltd."),
        java.util.Map.entry("PUBALI BANK LIMITED", "Pubali Bank Ltd."),
        java.util.Map.entry("RAJSHAHI KRISHI UNNAYAN BANK", "Rajshahi Krishi Unnayan Bank"),
        java.util.Map.entry("RUPALI BANK LIMITED", "Rupali Bank"),
        java.util.Map.entry("SOUTH BANGLA AGRICULTURE AND COMMERCE BANK LIMITED", "SBAC Bank Ltd."),
        java.util.Map.entry("SHAHJALAL ISLAMI BANK LIMITED", "Shahjalal Islami Bank Ltd."),
        java.util.Map.entry("SOCIAL ISLAMI BANK LIMITED", "Social Islami Bank Ltd."),
        java.util.Map.entry("SONALI BANK LIMITED", "Sonali Bank"),
        java.util.Map.entry("SOUTHEAST BANK LIMITED", "Southeast Bank Ltd."),
        java.util.Map.entry("STANDARD BANK LIMITED", "Standard Bank Ltd."),
        java.util.Map.entry("STANDARD CHARTERED BANK", "Standard Chartered Bank"),
        java.util.Map.entry("STATE BANK OF INDIA", "State Bank of India"),
        java.util.Map.entry("THE CITY BANK LIMITED", "The City Bank Ltd."),
        java.util.Map.entry("TRUST BANK LIMITED", "Trust Bank Ltd."),
        java.util.Map.entry("UNION BANK LIMITED", "Union Bank Ltd."),
        java.util.Map.entry("UNITED COMMERCIAL BANK LIMITED", "United Commercial Bank Ltd."),
        java.util.Map.entry("UTTARA BANK LIMITED", "Uttara Bank Ltd."),
        java.util.Map.entry("WOORI BANK BANGLADESH", "Woori Bank Ltd.")
    );

    @Override
    public void run(String... args) throws Exception {
        if (bankRepository.count() == 0) {
            loadBankData();
        }
        if (branchRepository.count() == 0) {
            loadBranchData();
        }
        if (insuranceCompanyRepository.count() == 0) {
            loadInsuranceCompanies();
        }
    }

    private void loadInsuranceCompanies() {
        List<InsuranceCompany> companies = new ArrayList<>();

        // Private Sector (Life)
        List.of(
            "Chartered Life Insurance PLC.", "Sonali Life Insurance (PLC)", "Akij Takaful Life Insurance (PLC)",
            "Zenith islami life insurance (PLC)", "Alpha Life Insurance Company Ltd.", "Astha Life Insurance",
            "Guardian Life Insurance Company Ltd.", "Meghna Life Insurance Company Ltd.", "Mercantile Islami Life Insurance Ltd.",
            "Met Life Insurance", "Bangal Islamic Life Insurance Company Ltd.", "Padma Islami Life Insurance Company Ltd.",
            "Popular Life Insurance Company Ltd.", "Pragati Life Insurance Ltd.", "Prime Islami Life Insurance Co. Ltd.",
            "Rupali Life Insurance Company Ltd.", "Sandhani Life Insurance Company Ltd.", "Sunflower Life Insurance Company Ltd.",
            "Sunlife Insurance Company Ltd."
        ).forEach(name -> companies.add(new InsuranceCompany(name, "Life", "Private")));

        // Private Sector (Non-Life)
        List.of(
            "Agrani Insurance Company Ltd.", "Asia Pacific Gen Insurance Co. Ltd.", "Bangladesh Co-operatives Ins. Ltd.",
            "Bangladesh General Insurance Co. Ltd.", "Bangladesh National Insurance Co. Ltd.", "Central Insurance Company Ltd.",
            "City Insurance PLC.", "Continental Insurance Ltd.", "Crystal Insurance Company Ltd.",
            "Desh Gen. Insurance Company Ltd.", "Dhaka Insurance Ltd.", "Eastern Insurance Company Ltd.",
            "Eastland Insurance Company Ltd.", "Express Insurance Ltd.", "Federal Insurance Company Ltd.",
            "Global Insurance Ltd.", "Green Delta Insurance PLC", "Islami Commercial Insurance Co. Ltd.",
            "Islami Insurance Bangladesh Ltd.", "Janata Insurance Company Ltd.", "Karnaphuli Insurance Company Ltd.",
            "Meghna Insurance Company Ltd.", "Mercantile Insurance Company Ltd.", "Nitol Insurance Company Ltd.",
            "Northern General Insurance Company Ltd.", "Paramount Insurance Company Ltd.", "Peoples Insurance Company Ltd.",
            "Phoenix Insurance Company Ltd.", "Pioneer Insurance Company Ltd.", "Pragati Insurance Ltd.",
            "Prime Insurance Company Ltd.", "Provati Insurance Company Ltd.", "Purabi General Insurance Company Ltd.",
            "Reliance Insurance Limited", "Republic Insurance Company Ltd.", "Rupali Insurance Company Ltd.",
            "Sena Kalyan Insurance Company Ltd.", "Sikder Insurance Company Ltd.", "Sonar Bangla Insurance Company Ltd.",
            "South Asia Insurance Company Ltd.", "Standard Insurance Ltd.", "Takaful Islami Insurance Ltd.",
            "Union Insurance Company Ltd.", "United Insurance Company Ltd."
        ).forEach(name -> companies.add(new InsuranceCompany(name, "Non-Life", "Private")));

        // Public Sector
        companies.add(new InsuranceCompany("Bangladesh Jiban Bima Corporation", "Life", "Public"));
        companies.add(new InsuranceCompany("Bangladesh Sadharan Bima Corporation", "Non-Life", "Public"));

        insuranceCompanyRepository.saveAll(companies);
        System.out.println(companies.size() + " insurance companies loaded.");
    }

    private void loadBankData() {
        List<String> bankNames = List.of(
            "AB Bank Ltd.", "Agrani Bank", "Al-Arafah Islami Bank Ltd.", "Ansar VDP Unnayan Bank",
            "BASIC Bank", "BRAC Bank Ltd.", "Bangladesh Commerce Bank Ltd.", "Bangladesh Development Bank",
            "Bangladesh Krishi Bank", "Bank Al-Falah", "Bank Asia Ltd.", "CITI Bank NA",
            "Commercial Bank of Ceylon", "Community Bank Bangladesh Limited", "Dhaka Bank Ltd.",
            "Dutch Bangla Bank Ltd.", "EXIM Bank Ltd.", "Eastern Bank Ltd.", "First Security Islami Bank Ltd.",
            "Global Islamic Bank Ltd.", "Grameen Bank", "HSBC", "Habib Bank Ltd.", "ICB Islamic Bank",
            "IFIC Bank Ltd.", "Islami Bank Bangladesh Ltd.", "Jamuna Bank Ltd.", "Janata Bank",
            "Jubilee Bank", "Karmashangosthan Bank", "Meghna Bank Ltd.", "Mercantile Bank Ltd.",
            "Midland Bank Ltd.", "Modhumoti Bank Ltd.", "Mutual Trust Bank Ltd.", "NCC Bank Ltd.",
            "NRB Bank Ltd.", "NRB Commercial Bank Ltd.", "National Bank Ltd.", "National Bank of Pakistan",
            "One Bank Ltd.", "Padma Bank Ltd.", "Palli Sanchay Bank", "Premier Bank Ltd.",
            "Prime Bank Ltd.", "Pubali Bank Ltd.", "Rajshahi Krishi Unnayan Bank", "Rupali Bank",
            "SBAC Bank Ltd.", "Shahjalal Islami Bank Ltd.", "Shimanto Bank Ltd.", "Social Islami Bank Ltd.",
            "Sonali Bank", "Southeast Bank Ltd.", "Standard Bank Ltd.", "Standard Chartered Bank",
            "State Bank of India", "The City Bank Ltd.", "Trust Bank Ltd.", "Union Bank Ltd.",
            "United Commercial Bank Ltd.", "Uttara Bank Ltd.", "Woori Bank Ltd."
        );

        bankNames.forEach(name -> {
            Bank bank = new Bank();
            bank.setName(name);
            bankRepository.save(bank);
        });

        System.out.println(bankNames.size() + " banks loaded into the database.");
    }

    private void loadBranchData() {
        try {
            ObjectMapper mapper = new ObjectMapper();
            InputStream inputStream = new ClassPathResource("bank_data_minified.json").getInputStream();
            List<Map<String, Object>> banksData = mapper.readValue(inputStream, new TypeReference<>() {});

            int totalBranchesLoaded = 0;
            for (Map<String, Object> bankData : banksData) {
                String jsonBankName = (String) bankData.get("name");
                if (jsonBankName == null) continue;
                String dbBankName = jsonToDbMap.getOrDefault(jsonBankName, jsonBankName);
                Bank bank = bankRepository.findByName(dbBankName).orElse(null);

                if (bank != null) {
                    List<Map<String, Object>> districts = (List<Map<String, Object>>) bankData.get("districts");
                    if (districts != null) {
                        for (Map<String, Object> district : districts) {
                            List<Map<String, Object>> branchesData = (List<Map<String, Object>>) district.get("branches");
                            if (branchesData != null) {
                                for (Map<String, Object> branchData : branchesData) {
                                    Branch branch = new Branch();
                                    branch.setName((String) branchData.get("branch_name"));
                                    branch.setBank(bank);
                                    branchRepository.save(branch);
                                    totalBranchesLoaded++;
                                }
                            }
                        }
                    }
                }
            }
            System.out.println(totalBranchesLoaded + " branch data loaded successfully.");
        } catch (Exception e) {
            System.err.println("Error loading branch data: " + e.getMessage());
        }
    }
}
