/*Create and Populate Dim_Plant*/

-- Create the structure
CREATE TABLE Dim_Plant (
    Plant_SK INT IDENTITY(1,1) PRIMARY KEY,
    Location VARCHAR(10),
    Plant_Group VARCHAR(50),
    Plant_Name VARCHAR(100)
);

-- Insert unique plant records safely
INSERT INTO Dim_Plant (Location, Plant_Group, Plant_Name)
SELECT DISTINCT 
    TRIM(Location), 
    TRIM(PLANT_GROUP), 
    TRIM(PLANT)
FROM MRO_data
WHERE PLANT IS NOT NULL;


/*Create and Populate Dim_Material_Master*/

-- Create the structure
CREATE TABLE Dim_Material_Master (
    Material_SK INT IDENTITY(1,1) PRIMARY KEY,
    Org_Material_No VARCHAR(50),
    Noun VARCHAR(100),
    Modifier VARCHAR(100),
    Org_Short_Desc NVARCHAR(500),
    Orig_Lang VARCHAR(50),
    Tags VARCHAR(50)
);

-- Insert unique material records
INSERT INTO Dim_Material_Master (Org_Material_No, Noun, Modifier, Org_Short_Desc, Orig_Lang, Tags)
SELECT DISTINCT 
    TRIM(Org_Material_No), 
    UPPER(TRIM(Noun)), 
    UPPER(TRIM(Modifier)), 
    TRIM(Org_Short_Desc), 
    TRIM(Orig_Lang), 
    TRIM(Tags)
FROM MRO_data;

/*Create and Populate Dim_Submission_Audit*/

-- Create the structure
CREATE TABLE Dim_Submission_Audit (
    Submission_SK INT IDENTITY(1,1) PRIMARY KEY,
    Submitted_By VARCHAR(100),
    Submitted_Date DATE,
    Match_Status VARCHAR(50),
    QA_Status VARCHAR(50),
    Cleaning_Status VARCHAR(50),
    Issue_Status VARCHAR(50),
    Action_Level VARCHAR(50),
    Batch VARCHAR(50)
);

-- Insert unique submission and status tracking records
INSERT INTO Dim_Submission_Audit (Submitted_By, Submitted_Date, Match_Status, QA_Status, Cleaning_Status, Issue_Status, Action_Level, Batch)
SELECT DISTINCT 
    TRIM(Submitted_By), 
    SUBMITTED_Date,
    TRIM(Match_Status), 
    TRIM(QA_Status), 
    TRIM(Cleaning_Status), 
    TRIM(Issue_Status), 
    TRIM(Action_level), 
    TRIM(Batch)
FROM MRO_data;



/*Generating the Final Fact Table*/

CREATE TABLE Fact_Material_Inventory (
    Plant_SK INT,
    Material_SK INT,
    Submission_SK INT,
    Clean_Manufacturer VARCHAR(100),
    Clean_Part_No VARCHAR(100)
);

INSERT INTO Fact_Material_Inventory (Plant_SK, Material_SK, Submission_SK, Clean_Manufacturer, Clean_Part_No)
SELECT 
    p.Plant_SK,
    m.Material_SK,
    s.Submission_SK,
    CASE WHEN TRIM(r.Clean_Manufacturer) = '' THEN NULL ELSE TRIM(r.Clean_Manufacturer) END,
    CASE WHEN TRIM(r.Clean_Part_No) = '' THEN NULL ELSE TRIM(r.Clean_Part_No) END
FROM MRO_data r
JOIN Dim_Plant p 
ON TRIM(r.PLANT) = p.Plant_Name
 AND TRIM(r.Location) = p.Location
 AND TRIM(r.PLANT_GROUP) = p.Plant_Group
JOIN Dim_Material_Master m 
ON TRIM(r.Org_Material_No) = m.Org_Material_No
JOIN Dim_Submission_Audit s 
ON TRIM(r.Submitted_By) = s.Submitted_By 
    AND (r.SUBMITTED_Date) = s.Submitted_Date
    AND TRIM(r.Action_level) = s.Action_Level
    AND trim(r.Match_Status) = s.Match_Status
    AND TRIM(r.QA_Status) = s.QA_Status
    AND TRIM(r.Cleaning_Status) = s.Cleaning_Status
    AND TRIM(r.Issue_Status) = s.Issue_Status
    AND TRIM(r.Batch) = s.Batch;


/*create a clean SQL View that automatically categorizes your materials based on their lead times.*/

 CREATE VIEW Vw_Procurement_Risk_Analysis AS
SELECT 
    f.Plant_SK,
    f.Material_SK,
    f.Submission_SK,
    f.Clean_Part_No,
    m.Noun,
    p.Plant_Name,
    p.Plant_Group,
    -- Simple SQL Case statement to create risk buckets based on lead days
    CASE 
        WHEN m.Tags = 'Priority 1' AND f.Clean_Part_No IS NULL THEN 'Critical Risk'
        WHEN f.Clean_Part_No IS NULL AND m.Noun IN ('SLEEVE', 'WASHER') THEN 'High Risk'
        ELSE 'Standard Review'
    -- Note: If your staging table has a raw numeric lead time column, use that here instead!
    END AS Supply_Risk_Category
FROM Fact_Material_Inventory f
JOIN Dim_Material_Master m 
ON f.Material_SK = m.Material_SK
JOIN Dim_Plant p 
ON f.Plant_SK = p.Plant_SK;   