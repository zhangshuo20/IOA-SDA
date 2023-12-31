# IOA-SDA
Production-, Consumption-, and Income-based CO2 Emissions accounting and socioeconomic drivers analysis.

The Environmental Extended I-O (EEIO) model is used to evaluate CO2 emissions from the production-, consumption-, and income-based viewpoints. The EEIO model introduces the direct emission coefficient of each economic sector into the economic I-O model, to reflect the impacts of the final demand and I-O structure on pollutant emissions in a region. Production-based CO2 emissions indicate direct emissions from sectors, which are the satellite accounts in the EEIO model. The production-based viewpoint ties emissions to the resident sectors generating goods and services; the consumption-based viewpoint ties emissions to final demand by considering life cycle impacts throughout the supply chains; and the income-based viewpoint ties emissions to primary inputs, e.g., employee compensation, fixed assets depreciation, and taxes.

Structural Decomposition Analysis (SDA) is used to quantify the relative contribution of various driving forces to CO2 emission changes. The SDA method is usually based on IOA model, including the Leontief I-O model (demand-side SDA) and the Ghosh I-O model (supply-side SDA).

guangdong_accounting_new.m - CO2 emissions accounting from three perspectives

guangdong_SDA_new_Ghosh.m, guangdong_SDA_new_Leontief.m - income-based SDA and consumption-based SDA

guangdong_SDA_sector_aggregation.m, merge.m, randnumber2.m, sector_aggregation.m - for uncertainty analysis
