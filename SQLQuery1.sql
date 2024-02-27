--select location,date, total_cases, new_cases, total_deaths, population
--from CovidDeaths 
--order by 1,2 

-----Looking at total cases vs total deaths
---means how many cases are their and how many deaths
----shows the likelihood of dying if you contract covid in your country
select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths 
Where location like '%india%' and total_cases is not null and total_deaths is not null
order by 1,2 

----total cases vs the population
---shows what perecent of population got covid
select location,date, total_cases, Population, (total_cases/Population)*100 as DeathPercentage
from CovidDeaths 
Where total_cases is not null and Population is not null
order by 1, 2

-- looking at countries with highest infection rates compared to population 
select location, MAX(total_cases) as highestinfectioncount , Population,
MAX(total_cases/Population)*100 as PercentPopulationInfected
from CovidDeaths
Group by location,Population
Order by PercentPopulationInfected desc


-- LETS BREAK THINGS DOWN BY CONTINENT
select continent, MAX(cast(Total_deaths as int)) as TotalDeathsCount 
from CovidDeaths
where continent is not null
Group by location
Order by TotalDeathsCount desc


--showing the countries with the highest death count per population
select continent, MAX(cast(Total_deaths as int)) as TotalDDeathCount
from CovidDeaths 
where continent is not null
group by continent
order by TotalDDeathCount desc



--Showing continents with highest death count
select continent, MAX(cast(Total_deaths as int)) as TotalDDeathCount
from CovidDeaths 
where continent is not null
group by continent
order by TotalDDeathCount desc

--Global Numbers
select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int ))as total_deaths,SUM(cast(new_deaths as int ))/SUM(new_cases) *100 as DeathPercentage
from CovidDeaths 
where continent is not null
group by date
order by 1,2 

--joining tables
--looking at total populations vs vaccinations

SELECT dea.date,dea.location,dea.continent, dea.population, vac.new_vaccinations
,SUM(CONVERT(INT, vac.new_vaccinations)) OVER	(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join  CovidVaccinations vac
on 
dea.location = vac.location
and
dea.date = vac.date
where dea.continent is not null
order by 2,3

--use CTE
with PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.date,dea.location,dea.continent, dea.population, vac.new_vaccinations
,SUM(CONVERT(INT, vac.new_vaccinations)) OVER	
(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join  CovidVaccinations vac
on 
dea.location = vac.location
and
dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100 from PopvsVac

--TEMP_TABLES
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER
(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join  CovidVaccinations vac
on 
dea.location = vac.location
and
dea.date = vac.date
--where dea.continent is not null

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--creating and working on views
--creating views to store data for later visualizations

CREATE view PercentPopulationVaccinated as
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER
(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join  CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
















































































































































