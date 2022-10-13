-- COMMAND ----------
#Overview: total sales, total spent, ROI
select sum(Sales) AS total_sales,round(sum(Spent),0) AS total_spent,round((sum(Sales) / sum(Spent)),2) AS roi 
from campaign_cleaned

-- COMMAND ----------
#Conversion funnel: summary
SELECT sum(impressions) as total_impressions, sum(clicks) as total_clicks, sum(sales) as total_sales
FROM `campaign optimization`.campaign_cleaned

-- COMMAND ----------
#Campaign comparison:sales, click through rate, roi
select xyz_campaign_id,sum(impressions) AS total_impressions,sum(clicks) AS total_clicks,sum(Sales) AS total_sales,
round(((sum(clicks) / sum(impressions)) * 100),2) AS ctr_rate,round(((sum(Sales) / sum(impressions)) * 100),3) AS cr_rate,round(((sum(Sales) / sum(Spent)) * 100),1) AS roi_Rate 
from campaign_cleaned 
group by xyz_campaign_id order by roi_Rate desc

-- COMMAND ----------
#Extract top 20% roi campaigns in each category, find its age and gender distribution
select xyz_campaign_id, round(sum(gender='f')*100/ count(*),2) as female_per, round(sum(gender='m')*100/ count(*),2) as male_per, 
round(sum(age='30-34')*100/ count(*),2) as age_30_34, round(sum(age='35-39')*100/ count(*),2) as age_35_39, 
round(sum(age='40-44')*100/ count(*),2) as age_40_44, round(sum(age='45-49')*100/ count(*),2) as age_45_49
from (SELECT *, sales/spent as roi, percent_rank() over(partition by xyz_campaign_id order by sales/spent) as ranking 
FROM `campaign optimization`.campaign_cleaned) t
where ranking>=0.8
group by xyz_campaign_id