select * 
from ProjectPortfolio.dbo.CovidDeaths 
order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from ProjectPortfolio.dbo.CovidDeaths 
order by 1,2

-- Total Cases vs. Total Deaths as a Percentage
select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
from ProjectPortfolio.dbo.CovidDeaths 
order by 1,2

--Total Cases vs. Total Deaths as a Percentage (United States)
select Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
from ProjectPortfolio.dbo.CovidDeaths
where location like '%states%'
order by 1,2

--Total Cases vs. Population (United States)
--Shows what percentage of population has contracted COVID-19 (United States)
select Location, date, total_cases, population, (total_cases/population) *100 as PercentPopulationInfected
from ProjectPortfolio.dbo.CovidDeaths
where location like '%states%'
order by 1,2

--Countries with Highest Infection Rate compared to overall population
select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) *100 as PercentPopulationInfected
from ProjectPortfolio.dbo.CovidDeaths
group by location, population
order by PercentPopulationInfected DESC

--Countries with Highest Death Count Per Population

select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathCount DESC

--Total Population vs. Vaccinations using CTE
with PopvsVac(continent, location, date, population, new_vaccinations,RollingPeopleVaccinated) as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3
)
Select * ,(RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temporary Table 
Create Table #PercentPopulationVaccinated

(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3
Select * ,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



--Creating a View to Store Data to Look at later visualization
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3
