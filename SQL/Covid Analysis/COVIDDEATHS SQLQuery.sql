Select *
From PortfolioProject ..CovidDeaths
Where continent is not null
Order by date,population

--select *
--from PortfolioProject ..CovidVaccinations
--order by 3,4

-- DATA WE ARE WORKING WITH

Select location, population, date, total_cases, new_cases, total_deaths
From PortfolioProject ..CovidDeaths
Where continent is not null
Order by 1,3

--TOTAL DEATHS VS TOTAL CASES

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject ..CovidDeaths
where location like '%canada%'
and continent is not null
order by 1,2

--CASES VS POPULATION

Select location, date, population, total_cases, (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject ..CovidDeaths
Where continent is not null
and location like '%canada%'
order by 1,2

--Countries with highest infections vs populations
Select location, population, Max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject ..CovidDeaths
Where continent is not null
--and location like '%nigeria%'
group by location, population
order by InfectedPopulationPercentage Asc

--Countries with highest Death vs populations
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
Where continent is not null
--and location like '%nigeria%'
group by location
order by TotalDeathCount Desc

--CONTINENTS WITH THE HIGHEST DEATH COUNT VS POPULATION
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject ..CovidDeaths
Where continent is not null
group by continent
order by TotalDeathCount Desc

--GLOBAL NUMBERS
Select sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From PortfolioProject ..CovidDeaths
Where continent is not null
order by 1,2

--TOTAL POPULATION VS VACCINATIONS
select *
From PortfolioProject ..CovidVaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject ..CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE TO PERFORM CALCULATION 
with popvsVac (continent, Location, Date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from popvsVac

--using temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--create view to store data for visualisations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject ..CovidDeaths dea
join PortfolioProject ..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select *
from PercentPopulationVaccinated