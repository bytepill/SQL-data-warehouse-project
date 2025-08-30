/* =====================================================================
   🚀 DATA WAREHOUSE PROJECT - BRONZE LAYER LOADING SCRIPT
   =====================================================================

   This script loads raw CRM/ERP CSV data into Bronze Layer tables
   using BULK INSERT with staging for product info.

   - The Bronze Layer stores **raw ingested data** from source systems.
   - For most tables, I directly BULK INSERT data after truncating.
   - For `crm_prd_info`, additional steps are required:
       1. Create a **staging table** (all NVARCHAR) to handle CSV load safely.
       2. BULK INSERT into staging (avoids schema mismatch errors).
       3. Apply minimal safe type casting (TRY_CAST / TRY_CONVERT) to align with schema.
       4. Insert into the final `bronze.crm_prd_info` table.
   - Truncate → Load → Insert is repeatable without duplication.
   ===================================================================== */

CREATE OR ALTER PROCEDURE bronze.load_bronze 
    @debug BIT = 0   -- Debug flag: 0 = skip validation, 1 = run validation
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================';

        /* ==========================================================
           STEP A: Load CRM Tables (cust_info, sales_details)
           ----------------------------------------------------------
           - Direct truncate + BULK INSERT.
           ========================================================== */
        PRINT '-----------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------';

        -- Customer Info    
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info'
        TRUNCATE TABLE bronze.crm_cust_info;  
    
        PRINT '>> Inserting Data Into: bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        -- Sales Details 
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details'
        TRUNCATE TABLE bronze.crm_sales_details; 
    
        PRINT '>> Inserting Data Into: bronze.crm_sales_details'
        BULK INSERT bronze.crm_sales_details     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        /* ==========================================================
           STEP B: Load ERP Tables (loc_a101, cust_az12, px_cat_g1v2)
           ----------------------------------------------------------
           - Direct truncate + BULK INSERT.
           - Similar process as CRM tables.
           ========================================================== */
        PRINT '-----------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------';

        -- ERP Location  
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101'
        TRUNCATE TABLE bronze.erp_loc_a101;    
    
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
        BULK INSERT bronze.erp_loc_a101     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        -- ERP Customer 
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12'
        TRUNCATE TABLE bronze.erp_cust_az12;    
    
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
        BULK INSERT bronze.erp_cust_az12     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        -- ERP Product Category 
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;     

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
        BULK INSERT bronze.erp_px_cat_g1v2     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);  
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        /* ==========================================================
           STEP C: Load CRM Product Info (special case with staging)
           ----------------------------------------------------------
           - Needs staging table because of inconsistent CSV data.
           - Process:
               1. Create staging table (all NVARCHAR).
               2. Bulk insert raw product CSV.
               3. Apply minimal safe type casting (TRY_CAST / TRY_CONVERT) to align with schema.
               4. Insert into final bronze.crm_prd_info.
           ========================================================== */
        SET @start_time = GETDATE();
        PRINT '>> Dropping and Creating Staging Table: bronze.crm_prd_info_stg';
        DROP TABLE IF EXISTS bronze.crm_prd_info_stg;  

        CREATE TABLE bronze.crm_prd_info_stg (         
            prd_id NVARCHAR(50),         
            prd_key NVARCHAR(50),         
            prd_nm NVARCHAR(50),         
            prd_cost NVARCHAR(50),         
            prd_line NVARCHAR(50),         
            prd_start_dt NVARCHAR(50),         
            prd_end_dt NVARCHAR(50)     
        );       

        -- Bulk insert into staging
        PRINT '>> Inserting Data Into Staging Table: bronze.crm_prd_info_stg';
        BULK INSERT bronze.crm_prd_info_stg     
        FROM 'C:\Users\arpan\OneDrive\Desktop\ARPAN\SQL\PROJECTS\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'     
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);       

        -- Truncate final target
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;       

        -- Insert Raw Typed data into final
        PRINT '>> Inserting Raw Typed Data Into: bronze.crm_prd_info';
        INSERT INTO bronze.crm_prd_info (prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)     
        SELECT TRY_CAST(prd_id AS INT),
               prd_key,
               prd_nm,
               TRY_CAST(prd_cost AS INT),
               prd_line,
               TRY_CONVERT(DATETIME, prd_start_dt, 105),
               TRY_CONVERT(DATE, prd_end_dt, 105)
        FROM bronze.crm_prd_info_stg;       

        /* ==========================================================
           STEP D: Optional Validation (debug mode only)
           ----------------------------------------------------------
           - Run only if @debug = 1.
           - Reports rows with invalid IDs, costs, or dates.
           - No corrections are applied in Bronze (issues are handled in Silver).
           ========================================================== */      
        IF @debug = 1
        BEGIN
            PRINT '>> Running Validation Queries for crm_prd_info_stg';

            -- Check invalid IDs or Costs
            SELECT prd_id, prd_cost
            FROM bronze.crm_prd_info_stg
            WHERE (TRY_CAST(prd_id AS INT) IS NULL AND prd_id IS NOT NULL)
               OR (TRY_CAST(prd_cost AS INT) IS NULL AND prd_cost IS NOT NULL);

            -- Check invalid Dates
            SELECT prd_start_dt, prd_end_dt
            FROM bronze.crm_prd_info_stg
            WHERE (TRY_CONVERT(DATETIME, prd_start_dt, 105) IS NULL AND prd_start_dt IS NOT NULL)
               OR (TRY_CONVERT(DATE, prd_end_dt, 105) IS NULL AND prd_end_dt IS NOT NULL);

        END

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' Seconds'
        PRINT '-------------------------------------------------------------------------------------------'

        /* ==========================================================
           STEP E: Final Summary
           ----------------------------------------------------------
           - Prints total time taken for Bronze Layer load.
           ========================================================== */
        SET @batch_end_time = GETDATE();
        PRINT '=================================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT ' - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time ) AS NVARCHAR) + ' Seconds';
        PRINT '================================================='
    END TRY
    BEGIN CATCH
        /* ==========================================================
           ERROR HANDLING
           ----------------------------------------------------------
           - Captures SQL error details if any step fails.
           ========================================================== */
        PRINT '=================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=================================================';
    END CATCH
END;
