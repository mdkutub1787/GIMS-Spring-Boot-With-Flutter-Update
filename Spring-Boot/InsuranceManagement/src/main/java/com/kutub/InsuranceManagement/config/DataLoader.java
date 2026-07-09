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

            for (Map<String, Object> bankData : banksData) {
                String bankName = (String) bankData.get("BankName");
                Bank bank = bankRepository.findByName(bankName).orElse(null);

                if (bank != null) {
                    List<Map<String, String>> branchesData = (List<Map<String, String>>) bankData.get("Branches");
                    for (Map<String, String> branchData : branchesData) {
                        Branch branch = new Branch();
                        branch.setName(branchData.get("BranchName"));
                        branch.setBank(bank);
                        // You can also set routing number and branch code if you add those fields to the Branch entity
                        branchRepository.save(branch);
                    }
                }
            }
            System.out.println("Branch data loaded successfully.");
        } catch (Exception e) {
            System.err.println("Error loading branch data: " + e.getMessage());
        }
    }
}
