select COUNT(*) from dbo.CovidDeaths;

select COUNT(*) from dbo.CovidVaccinations;

select DISTINCT(iso_code)  from dbo.CovidDeaths1;

select * from dbo.CovidDeaths
order by location,date ;

select count(*) from dbo.CovidDeaths where continent IS NULL;--4111

select * from dbo.CovidDeaths;


select location,date,total_cases,new_cases,total_deaths,population,new_deaths
from dbo.CovidDeaths
order by location,date;

--TOTAL CASES
select SUM(new_cases) total_cases,
sum(CAST(new_deaths AS INT)) total_deaths,
ROUND((sum(CAST(new_deaths AS INT))/SUM(new_cases))*100 ,2)as percentage_of_total_deaths
from dbo.CovidDeaths
--where location like '%state%'
where continent IS NOT NULL;


---% Of people infected per day

select location,date,total_cases,new_cases,total_deaths,population,new_deaths,ROUND((total_cases/population)*100 ,2)as Percetage_of_people_infected
from dbo.CovidDeaths
--where location like '%state%'
where continent IS NOT NULL
order by location,date;


---% Of deaths per day

select location,date,total_cases,new_cases,total_deaths,population,new_deaths,ROUND((total_deaths/total_cases)*100 ,2)as Percetage_of_deaths
from dbo.CovidDeaths
--where location like '%state%'
where continent IS NOT NULL
order by location,date;


--highest infectious rate by location

select location,MAX(total_cases) as highest_casecount,MAX(population) population,ROUND(MAX(total_cases/population)*100,2) as high_infection_rate
FROM dbo.CovidDeaths
where continent IS NOT NULL
GROUP BY location
order by high_infection_rate desc;

--highest infectious rate by location,date

select location,date,MAX(total_cases) as highest_casecount,MAX(population) population,ROUND(MAX(total_cases/population)*100,2) as high_infection_rate
FROM dbo.CovidDeaths
where continent IS NOT NULL
GROUP BY location,date
order by high_infection_rate desc;


--highest death counts  by location

select location,MAX(CAST(total_deaths as INT)) as highest_deathcount 
FROM dbo.CovidDeaths
where continent IS NOT NULL
GROUP BY location
order by highest_deathcount desc;

--highest infectious rate by continent

select continent,ROUND(MAX(total_cases/population)*100,2) as high_infection_rate,MAX(total_cases) as highest_casecount
FROM dbo.CovidDeaths
where continent IS NOT NULL
GROUP BY continent
order by high_infection_rate desc;


--highest death counts  by continent

select continent,MAX(CAST(total_deaths as INT)) as highest_deathcount 
FROM dbo.CovidDeaths
where continent IS NOT NULL
GROUP BY continent
order by highest_deathcount desc;


--total  death count by continent


select CONTINENT,
SUM(new_cases) total_cases,
sum(CAST(new_deaths AS INT)) total_deaths
--ROUND((sum(CAST(new_deaths AS INT))/SUM(new_cases))*100 ,2)as percentage_of_total_deaths
from dbo.CovidDeaths
--where location like '%state%'
where continent IS NOT NULL
GROUP BY CONTINENT;

--total  death count by location
select location,
SUM(new_cases) total_cases,
sum(CAST(new_deaths AS INT)) total_deaths
--ROUND((sum(CAST(new_deaths AS INT))/SUM(new_cases))*100 ,2)as percentage_of_total_deaths
from dbo.CovidDeaths
--where location like '%state%'
where continent IS NOT NULL
GROUP BY location;

--totalcases,total death,death percentage by date
select date ,SUM(NEW_CASES) total_cases,SUM(CAST (NEW_DEATHS AS INT)) total_deaths,ROUND((SUM(CAST (NEW_DEATHS AS INT)) /SUM(NEW_CASES))*100 ,2) as total_death_percentage
FROM dbo.CovidDeaths
where continent is not null
group by date
order by date ;


---
select location,date,median_age,AGE_GROUP,total_cases,new_cases,population,total_deaths,new_deaths from dbo.CovidDeaths;

ALTER TABLE dbo.CovidDeaths
ADD  AGE_GROUP NVARCHAR(255);


UPDATE dbo.CovidDeaths
SET AGE_GROUP =
CASE WHEN MEDIAN_AGE >15 and MEDIAN_AGE<=26 THEN 'Young'
 WHEN MEDIAN_AGE >26 and MEDIAN_AGE<=38 THEN 'Middle Age'
 WHEN MEDIAN_AGE >38 and MEDIAN_AGE<=49 THEN 'Old'
ELSE NULL 
END;

--total deaths by age group

select age_group ,SUM(NEW_CASES) total_cases,SUM(CAST (NEW_DEATHS AS INT)) total_deaths,ROUND((SUM(CAST (NEW_DEATHS AS INT)) /SUM(NEW_CASES))*100 ,2) as total_death_percentage
FROM dbo.CovidDeaths
where continent is not null
group by age_group
order by age_group ;

--

select * from dbo.CovidVaccinations;

--
SELECT cd.location,cd.date,cd.total_cases,cd.new_cases,cd.total_deaths,cd.new_deaths,cv.total_vaccinations,cv.new_vaccinations,
cv.median_age,cd.age_group,cv.people_vaccinated,cv.people_fully_vaccinated
from 
 dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
on cd.location=cv.location
AND cd.date=cv.date
--AND  cv.total_vaccinations is not null
AND CD.CONTINENT IS NOT NULL
--AND cd.location like '%ndia%'
order by date;


--%of people vaccinated by location
SELECT cv.location,cv.date,cv.people_vaccinated,cd.population,ROUND((CAST (cv.people_vaccinated AS INT)/cd.population)*100,2) Percentage_of_people_vaccinated
from 
 dbo.CovidDeaths cd
JOIN dbo.CovidVaccinations cv
on cd.location=cv.location
AND cd.date=cv.date
AND cv.CONTINENT IS NOT NULL
--GROUP BY cv.location
--HAVING Percentage_of_people_vaccinated>0
AND  cv.people_vaccinated is not null
order by cv.location,cv.date;

--

select * from dbo.covidvaccinations


-- total vaccinations reported by location


select cv.location,
SUM(cast(CV.NEW_VACCINATIONS as INT))  total_vaccinations
from dbo.covidvaccinations cv
where cv.continent IS NOT NULL
group by cv.location
HAVING SUM(cast(CV.NEW_VACCINATIONS as INT)) >0
ORDER BY total_vaccinations DESC;

-- total vaccinations reported by continent

select cv.continent,
SUM(cast(CV.NEW_VACCINATIONS as INT))  total_vaccinations
from dbo.covidvaccinations cv
where cv.continent IS NOT NULL
group by cv.continent
HAVING SUM(cast(CV.NEW_VACCINATIONS as INT)) >0
ORDER BY total_vaccinations DESC;


--|% of total vaccinations by location


with cte_t as (
select 
cd.location,
--ROUND((t.total_vaccinations/CD.population)*100,2) As percentage_total_vaccination
MAX(cd.population) population
from dbo.coviddeaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.LOCATION
),
 cte_v AS
(
select cv.location,
SUM(cast(CV.NEW_VACCINATIONS as INT))  total_vaccinations
from dbo.covidvaccinations cv
where cv.continent IS NOT NULL
group by cv.location
HAVING SUM(cast(CV.NEW_VACCINATIONS as INT)) >0
)
select 
t.location,
v.total_vaccinations,
t.population,
ROUND((v.total_vaccinations/t.population)*100,2) As percentage_total_vaccination
from cte_t t
JOIN cte_v v
ON t.location=v.location
order by t.location;

--|% of total vaccinations by continents



with cte_t as (
select 
cd.continent,
--ROUND((t.total_vaccinations/CD.population)*100,2) As percentage_total_vaccination
SUM(cd.population) population
from dbo.coviddeaths cd
WHERE cd.continent IS NOT NULL
GROUP BY cd.continent
),
 cte_v AS
(
select cv.continent,
SUM(cast(CV.NEW_VACCINATIONS as INT))  total_vaccinations
from dbo.covidvaccinations cv
where cv.continent IS NOT NULL
group by cv.continent
HAVING SUM(cast(CV.NEW_VACCINATIONS as INT)) >0
)
select 
t.continent,
v.total_vaccinations,
t.population,
ROUND((v.total_vaccinations/t.population)*100,4) As percentage_total_vaccination
from cte_t t
JOIN cte_v v
ON t.continent=v.continent
order by t.continent;




ALTER TABLE dbo.covidvaccinations
ADD  AGE_GROUP NVARCHAR(255);


UPDATE dbo.covidvaccinations
SET AGE_GROUP =
CASE WHEN MEDIAN_AGE >15 and MEDIAN_AGE<=26 THEN 'Young'
 WHEN MEDIAN_AGE >26 and MEDIAN_AGE<=38 THEN 'Middle Age'
 WHEN MEDIAN_AGE >38 and MEDIAN_AGE<=49 THEN 'Old'
ELSE NULL 
END;

--COUNT of people vaccinated by age group


select 
cv.age_group,
sum(CAST(cv.new_vaccinations AS INT)) total_vaccination,
from  dbo.CovidVaccinations cv
where cv.continent IS NOT NULL
AND cv.age_group IS NOT NULL
--GROUP BY cv.age_group;

select median_age,age_group from dbo.CovidVaccinations;








