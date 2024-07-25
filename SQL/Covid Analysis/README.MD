# COVID-19 Data Analysis Project Report
## Introduction
This report presents an analysis of COVID-19 data sourced from the PortfolioProject database, focusing on COVID-19 deaths and vaccinations. 

The objective is to understand the impact of the pandemic across different countries and continents by analyzing total cases, deaths, infection rates, and vaccination progress.

## Data
COVID-19 Deaths Data
The CovidDeaths table includes information on total cases, new cases, total deaths, and population for various locations globally.

COVID-19 Vaccinations Data
The CovidVaccinations table provides data on the number of new vaccinations administered over time in different locations.

## Data Analysis and Queries
## 1. Data Overview
The initial step was to explore the data by selecting all records from the CovidDeaths and CovidVaccinations tables:


SELECT * 

FROM PortfolioProject..CovidDeaths 

WHERE continent IS NOT NULL 

ORDER BY date, population;

SELECT * 

FROM PortfolioProject..CovidVaccinations 

ORDER BY 3, 4;

## 2. Filtered Deaths Data
We filtered the deaths data to focus on records where the continent is not null and ordered the results by location and date:

SELECT location, population, date, total_cases, new_cases, total_deaths

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL

ORDER BY 1, 3;

## 3. Total Deaths vs. Total Cases

To understand the fatality rate in Canada, we calculated the death percentage of total cases:

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%canada%' AND continent IS NOT NULL
ORDER BY 1, 2;

## 4. Cases vs. Population
We determined the percentage of the population infected in Canada:


SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectedPopulationPercentage

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL AND location LIKE '%canada%'

ORDER BY 1, 2;

## 5. Countries with Highest Infection Rates
We identified countries with the highest infection rates relative to their populations:


SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS InfectedPopulationPercentage

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL

GROUP BY location, population

ORDER BY InfectedPopulationPercentage ASC;

## 6. Countries with Highest Death Counts
To find the countries with the highest death counts, we aggregated the total deaths:

SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL

GROUP BY location

ORDER BY TotalDeathCount DESC;

## 7. Continents with the Highest Death Counts
We aggregated the death counts at the continent level:

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL

GROUP BY continent

ORDER BY TotalDeathCount DESC;

## 8. Global Numbers
We calculated global statistics for new cases and deaths:

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage 

FROM PortfolioProject..CovidDeaths

WHERE continent IS NOT NULL;

## 9. Total Population vs. Vaccinations
We examined the total number of vaccinations over time:

SELECT * 

FROM PortfolioProject..CovidVaccinations;

## 10. Deaths and Vaccinations Join
We joined the deaths and vaccinations tables to analyze vaccination progress alongside COVID-19 deaths:

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations

FROM PortfolioProject..CovidDeaths dea

JOIN PortfolioProject..CovidVaccinations vac

ON dea.location = vac.location AND dea.date = vac.date

WHERE dea.continent IS NOT NULL

ORDER BY 2, 3;

## 11. Rolling Vaccination Count
We calculated the rolling count of people vaccinated:

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea

JOIN PortfolioProject..CovidVaccinations vac

ON dea.location = vac.location AND dea.date = vac.date

WHERE dea.continent IS NOT NULL

ORDER BY 2, 3;


## 12. Percentage of Population Vaccinated
Using a Common Table Expression (CTE), we calculated the percentage of the population vaccinated:


WITH popvsVac (continent, Location, Date, population, new_vaccinations, RollingPeopleVaccinated) AS (

  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 

 SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
  
FROM PortfolioProject..CovidDeaths dea
 
JOIN PortfolioProject..CovidVaccinations vac
  
ON dea.location = vac.location AND dea.date = vac.date
  
WHERE dea.continent IS NOT NULL

)

SELECT *, (RollingPeopleVaccinated/population)*100

FROM popvsVac;

## 13. Temporary Table for Vaccination Percentage
We used a temporary table to store and calculate the percentage of the population vaccinated:


DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated (
 
Continent NVARCHAR(255),
 
Location NVARCHAR(255),

Date DATETIME,
 
Population NUMERIC,
 
New_vaccinations NUMERIC,
 
RollingPeopleVaccinated NUMERIC

);

INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea

JOIN PortfolioProject..CovidVaccinations vac

ON dea.location = vac.location AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated/population)*100

FROM #PercentPopulationVaccinated;

## 14. View for Visualizations
Finally, we created a view to store data for visualizations:


CREATE VIEW PercentPopulationVaccinated AS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 

SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea

JOIN PortfolioProject..CovidVaccinations vac

ON dea.location = vac.location AND dea.date = vac.date

WHERE dea.continent IS NOT NULL;

SELECT * FROM PercentPopulationVaccinated;
## Conclusion
This analysis provides a comprehensive overview of COVID-19's impact across different regions, focusing on infection and death rates, as well as vaccination progress. The SQL queries used facilitate detailed examination and comparison of data, offering valuable insights into the pandemic's progression and the effectiveness of vaccination efforts. The creation of views and temporary tables aids in structuring the data for further visualization and analysis.
