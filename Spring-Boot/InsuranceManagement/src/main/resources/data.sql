-- Clear existing bank data to avoid duplicates
TRUNCATE TABLE bank;

-- =============================================
-- Insert New Bank Data from JSON
-- =============================================

INSERT INTO bank (name) VALUES ('AB Bank Ltd.');
INSERT INTO bank (name) VALUES ('Agrani Bank');
INSERT INTO bank (name) VALUES ('Al-Arafah Islami Bank Ltd.');
INSERT INTO bank (name) VALUES ('Ansar VDP Unnayan Bank');
INSERT INTO bank (name) VALUES ('BASIC Bank');
INSERT INTO bank (name) VALUES ('BRAC Bank Ltd.');
INSERT INTO bank (name) VALUES ('Bangladesh Commerce Bank Ltd.');
INSERT INTO bank (name) VALUES ('Bangladesh Development Bank');
INSERT INTO bank (name) VALUES ('Bangladesh Krishi Bank');
INSERT INTO bank (name) VALUES ('Bank Al-Falah');
INSERT INTO bank (name) VALUES ('Bank Asia Ltd.');
INSERT INTO bank (name) VALUES ('CITI Bank NA');
INSERT INTO bank (name) VALUES ('Commercial Bank of Ceylon');
INSERT INTO bank (name) VALUES ('Community Bank Bangladesh Limited');
INSERT INTO bank (name) VALUES ('Dhaka Bank Ltd.');
INSERT INTO bank (name) VALUES ('Dutch Bangla Bank Ltd.');
INSERT INTO bank (name) VALUES ('EXIM Bank Ltd.');
INSERT INTO bank (name) VALUES ('Eastern Bank Ltd.');
INSERT INTO bank (name) VALUES ('First Security Islami Bank Ltd.');
INSERT INTO bank (name) VALUES ('Global Islamic Bank Ltd.');
INSERT INTO bank (name) VALUES ('Grameen Bank');
INSERT INTO bank (name) VALUES ('HSBC');
INSERT INTO bank (name) VALUES ('Habib Bank Ltd.');
INSERT INTO bank (name) VALUES ('ICB Islamic Bank');
INSERT INTO bank (name) VALUES ('IFIC Bank Ltd.');
INSERT INTO bank (name) VALUES ('Islami Bank Bangladesh Ltd.');
INSERT INTO bank (name) VALUES ('Jamuna Bank Ltd.');
INSERT INTO bank (name) VALUES ('Janata Bank');
INSERT INTO bank (name) VALUES ('Jubilee Bank');
INSERT INTO bank (name) VALUES ('Karmashangosthan Bank');
INSERT INTO bank (name) VALUES ('Meghna Bank Ltd.');
INSERT INTO bank (name) VALUES ('Mercantile Bank Ltd.');
INSERT INTO bank (name) VALUES ('Midland Bank Ltd.');
INSERT INTO bank (name) VALUES ('Modhumoti Bank Ltd.');
INSERT INTO bank (name) VALUES ('Mutual Trust Bank Ltd.');
INSERT INTO bank (name) VALUES ('NCC Bank Ltd.');
INSERT INTO bank (name) VALUES ('NRB Bank Ltd.');
INSERT INTO bank (name) VALUES ('NRB Commercial Bank Ltd.');
INSERT INTO bank (name) VALUES ('National Bank Ltd.');
INSERT INTO bank (name) VALUES ('National Bank of Pakistan');
INSERT INTO bank (name) VALUES ('One Bank Ltd.');
INSERT INTO bank (name) VALUES ('Padma Bank Ltd.');
INSERT INTO bank (name) VALUES ('Palli Sanchay Bank');
INSERT INTO bank (name) VALUES ('Premier Bank Ltd.');
INSERT INTO bank (name) VALUES ('Prime Bank Ltd.');
INSERT INTO bank (name) VALUES ('Pubali Bank Ltd.');
INSERT INTO bank (name) VALUES ('Rajshahi Krishi Unnayan Bank');
INSERT INTO bank (name) VALUES ('Rupali Bank');
INSERT INTO bank (name) VALUES ('SBAC Bank Ltd.');
INSERT INTO bank (name) VALUES ('Shahjalal Islami Bank Ltd.');
INSERT INTO bank (name) VALUES ('Shimanto Bank Ltd.');
INSERT INTO bank (name) VALUES ('Social Islami Bank Ltd.');
INSERT INTO bank (name) VALUES ('Sonali Bank');
INSERT INTO bank (name) VALUES ('Southeast Bank Ltd.');
INSERT INTO bank (name) VALUES ('Standard Bank Ltd.');
INSERT INTO bank (name) VALUES ('Standard Chartered Bank');
INSERT INTO bank (name) VALUES ('State Bank of India');
INSERT INTO bank (name) VALUES ('The City Bank Ltd.');
INSERT INTO bank (name) VALUES ('Trust Bank Ltd.');
INSERT INTO bank (name) VALUES ('Union Bank Ltd.');
INSERT INTO bank (name) VALUES ('United Commercial Bank Ltd.');
INSERT INTO bank (name) VALUES ('Uttara Bank Ltd.');
INSERT INTO bank (name) VALUES ('Woori Bank Ltd.');

-- =============================================
-- Insert Insurance Company Data
-- =============================================

-- Clear existing insurance company data
TRUNCATE TABLE insurance_companies;

-- Life Insurance (Private)
INSERT INTO insurance_companies (name, type, sector) VALUES ('Chartered Life Insurance PLC.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sonali Life Insurance (PLC)', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Akij Takaful Life Insurance (PLC)', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Zenith islami life insurance (PLC)', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Alpha Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Astha Life Insurance', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Guardian Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Meghna Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Mercantile Islami Life Insurance Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Met Life Insurance', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangal Islamic Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Padma Islami Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Popular Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Pragati Life Insurance Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Prime Islami Life Insurance Co. Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Rupali Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sandhani Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sunflower Life Insurance Company Ltd.', 'Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sunlife Insurance Company Ltd.', 'Life', 'Private');

-- Non-Life Insurance (Private)
INSERT INTO insurance_companies (name, type, sector) VALUES ('Agrani Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Asia Pacific Gen Insurance Co. Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangladesh Co-operatives Ins. Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangladesh General Insurance Co. Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangladesh National Insurance Co. Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Central Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('City Insurance PLC.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Continental Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Crystal Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Desh Gen. Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Dhaka Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Eastern Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Eastland Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Express Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Federal Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Global Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Green Delta Insurance PLC', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Islami Commercial Insurance Co. Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Islami Insurance Bangladesh Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Janata Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Karnaphuli Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Meghna Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Mercantile Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Nitol Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Northern General Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Paramount Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Peoples Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Phoenix Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Pioneer Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Pragati Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Prime Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Provati Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Purabi General Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Reliance Insurance Limited', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Republic Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Rupali Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sena Kalyan Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sikder Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Sonar Bangla Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('South Asia Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Standard Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Takaful Islami Insurance Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Union Insurance Company Ltd.', 'Non-Life', 'Private');
INSERT INTO insurance_companies (name, type, sector) VALUES ('United Insurance Company Ltd.', 'Non-Life', 'Private');

-- Public Sector
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangladesh Jiban Bima Corporation', 'Life', 'Public');
INSERT INTO insurance_companies (name, type, sector) VALUES ('Bangladesh Sadharan Bima Corporation', 'Non-Life', 'Public');

-- =============================================
-- Insert Branch Data for Major Banks
-- =============================================

-- Clear existing branch data
TRUNCATE TABLE branch;

-- Branches for AB Bank Ltd. (Bank ID: 1)
INSERT INTO branch (name, bank_id) VALUES ('Principal Branch, Motijheel', 1);
INSERT INTO branch (name, bank_id) VALUES ('Gulshan Branch', 1);
INSERT INTO branch (name, bank_id) VALUES ('Agrabad Branch, Chattogram', 1);

-- Branches for Agrani Bank (Bank ID: 2)
INSERT INTO branch (name, bank_id) VALUES ('Principal Office, Motijheel', 2);
INSERT INTO branch (name, bank_id) VALUES ('Dhanmondi Branch', 2);
INSERT INTO branch (name, bank_id) VALUES ('Rajshahi Main Branch', 2);

-- Branches for BRAC Bank Ltd. (Bank ID: 6)
INSERT INTO branch (name, bank_id) VALUES ('Gulshan 1 Branch', 6);
INSERT INTO branch (name, bank_id) VALUES ('Uttara Branch', 6);
INSERT INTO branch (name, bank_id) VALUES ('Mirpur Branch', 6);

-- Branches for Dutch Bangla Bank Ltd. (Bank ID: 16)
INSERT INTO branch (name, bank_id) VALUES ('Local Office, Motijheel', 16);
INSERT INTO branch (name, bank_id) VALUES ('Banani Branch', 16);
INSERT INTO branch (name, bank_id) VALUES ('Sylhet Main Branch', 16);

-- Branches for Islami Bank Bangladesh Ltd. (Bank ID: 26)
INSERT INTO branch (name, bank_id) VALUES ('Local Office, Dilkusha', 26);
INSERT INTO branch (name, bank_id) VALUES ('Khatunganj Branch, Chattogram', 26);
INSERT INTO branch (name, bank_id) VALUES ('Bogura Branch', 26);

-- Branches for Janata Bank (Bank ID: 28)
INSERT INTO branch (name, bank_id) VALUES ('Local Office, Motijheel', 28);
INSERT INTO branch (name, bank_id) VALUES ('Khulna Corporate Branch', 28);

-- Branches for Sonali Bank (Bank ID: 53)
INSERT INTO branch (name, bank_id) VALUES ('Local Office, Motijheel', 53);
INSERT INTO branch (name, bank_id) VALUES ('Wari Branch', 53);
INSERT INTO branch (name, bank_id) VALUES ('Barishal Main Branch', 53);

-- Branches for The City Bank Ltd. (Bank ID: 58)
INSERT INTO branch (name, bank_id) VALUES ('City Centre Branch', 58);
INSERT INTO branch (name, bank_id) VALUES ('Dhanmondi 27 Branch', 58);

-- Branches for United Commercial Bank Ltd. (Bank ID: 61)
INSERT INTO branch (name, bank_id) VALUES ('Corporate Office, Gulshan', 61);
INSERT INTO branch (name, bank_id) VALUES ('Bijoynagar Branch', 61);


