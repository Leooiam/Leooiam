SELECT 
    AVG(MAE) AS avg_MAE,
    AVG(MSE) AS avg_MSE,
    AVG(SQRT(MSE)) AS avg_RMSE
FROM (
    SELECT 
        propeerty_legal_id,
        price_with_Admin,
        price_sug_calc,
        bound_sug_price,
        price_sug_calc - price_with_Admin  AS err,
        ABS(price_sug_calc - price_with_Admin) AS MAE,
        POWER((price_sug_calc - price_with_Admin), 2) AS MSE
    FROM (   
        SELECT 
            t1.property_legal_id AS propeerty_legal_id,
            t1.price + t1.administration_price AS price_with_Admin,
            t2.sug_price_with_admin AS price_sug_calc,
            t2.bound_sug_price_with_admin AS bound_sug_price,
        FROM
            `aptuno-data.mx_production.properties` AS t1
        LEFT JOIN `aptuno-data.mx_datalake.rent_pred_historic` AS t2
            ON TRIM(t1.property_legal_id) = TRIM(t2.property_legal_id)
        WHERE t2.sug_price_with_admin IS NOT NULL)
    )