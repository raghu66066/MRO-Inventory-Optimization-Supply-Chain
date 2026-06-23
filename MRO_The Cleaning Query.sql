 
    -- 1. Standard string cleaning
    SELECT
    TRIM(Location) as Location,
    TRIM(Org_Material_No) AS Org_Material_No,
    TRIM(PLANT_GROUP) AS PLANT_GROUP,
    TRIM(PLANT) AS PLANT,
    TRIM(Submitted_By) AS Submitted_By,
    TRIM(Match_Status) AS Match_Status,
    TRIM(QA_Status) AS QA_Status,
    
    -- 2. Handling blanks gracefully
    CASE WHEN TRIM(Clean_Manufacturer) = '' THEN NULL ELSE TRIM(Clean_Manufacturer) END AS Clean_Manufacturer,
    CASE WHEN TRIM(Clean_Part_No) = '' THEN NULL ELSE TRIM(Clean_Part_No) END AS Clean_Part_No,
    SUBMITTED_Date,
    TRIM(Org_Short_Desc) AS Original_Short_Description,
    UPPER(TRIM(Noun)) AS Noun, -- Standardize taxonomy to uppercase
    UPPER(TRIM(Modifier)) AS Modifier,
    TRIM(Tags) AS Tags,
    TRIM(Batch) AS Batch,
    TRIM(Cleaning_Status) AS Cleaning_Status,
    TRIM(Orig_Lang) AS Orig_Language,
    TRIM(Issue_Status) AS Issue_Status,
    TRIM(Action_level) AS Action_level
FROM MRO_data;

