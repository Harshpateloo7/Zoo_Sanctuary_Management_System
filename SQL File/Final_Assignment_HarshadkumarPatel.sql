--- 1 Donation_view” will show the details of the Donation ID, Amount, Donor ID, Donor Name, and Type of Animals-----------------
-- N01481887.Donation_view source
CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `N01481887`.`Donation_view` AS
select
    `dn`.`DonationID` AS `DonationID`,
    `dn`.`Amount` AS `Amount
`,
    `ds`.`DonorID` AS `DonorID`,
    `ds`.`DonorName` AS `DonorName`,
    `AnT`.`Type` AS `Type`
from
((`N01481887`.`Donations` `dn`
join `N01481887`.`Donor` `ds` on
((`dn`.`DonorID` = `ds`.`DonorID`)))
join `N01481887`.`AnimalType` `AnT` on
((`dn`.`AnimalTypeID` = `AnT`.`AnimalTypeID`)));

--- 2 Calling procedures by the procedures name, We will see the type of animal list data with their total donation funds by animal type--------------------------------------------------
CREATE DEFINER=`N01481887`@`%` PROCEDURE `N01481887`.`TotalDonation`
()
BEGIN
    -- DECLARE total int DEFAULT 0; 
    SELECT AnT.`Type
    ` AS `Type`  ,sum
    (amount) AS Total from N01481887.Donations d  
	JOIN N01481887.AnimalType AnT  ON
    (d.AnimalTypeId = AnT.AnimalTypeId) 
	GROUP BY
    (AnT.`Type`);

END
-----Call procedure by name TotalDonation-------------------
CALL TotalDonation
();

--- 3 The Employee Schedule table will have a before insert to trigger to ensure employees cannot work more than 40 hours a week.-----------------------------------------------------
CREATE DEFINER=`N01481887`@`%` TRIGGER HoursTrigger
BEFORE
INSERT
ON
EmployeeSchedule
FOR
EACH
ROW
BEGIN
    IF NEW.HoursWorked >40 THEN SIGNAL SQLSTATE '02000'
    SET MESSAGE_TEXT
    = 'You cannot work more then 40 hours';
END
IF;
END

--- 4 The Donor table will have after delete trigger, which will keep a record of the deleted data of the Donor into a DonorLog-----------------
CREATE DEFINER=`N01481887`@`%` TRIGGER Deleted_Donor
AFTER
DELETE 
ON Donor FOR EACH
ROW
BEGIN
    INSERT INTO N01481887.DonorLog
    values(old.DonorID, old.DonorName, old.DOB, old.Contact, old.Address);
END
