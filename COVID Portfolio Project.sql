SELECT *
FROM PorfolioProject..CovidDeaths2 
ORDER BY 1,2


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths2 
order BY 1,2

-- Looking as Total cases vs Total Death 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PorfolioProject..CovidDeaths2 
where Location like '%India%'
order BY 1,2

-- shows what percentage of population got covid 
SELECT Location, date, Population, total_cases, total_deaths, (total_cases/Population)*100 as PopulationInfected
FROM PorfolioProject..CovidDeaths2 
where Location like '%India%'
order BY 1,2

-- Looking at Countries Highesht Infection Rate Compared to population
Select Location, population, MAX(total_cases) as HighInfectionCount,
MAX(total_cases/Population)*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths2
Group By Location, Population
Order By PercentPopulationInfected desc

-- Showing Countries With HIGHEST Death Count per Population
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths2
where continent is not null
Group by location
Order by TotalDeathCount desc


-- Showing Quantents with Higesh death count per population
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths2
where continent is not null
Group by continent
Order by TotalDeathCount desc


--Global Number 
Select  SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Death,
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PorfolioProject..CovidDeaths2
where continent is not null
--Group By Date
Order By 1,2

--vLooking as Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over(partition by dea.Location Order by dea.Location)
from PorfolioProject..CovidDeaths2 dea
join PorfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Use CTE
with PopvsVac(continent, Location, Date, Population,new_vaccinations, rollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PorfolioProject..CovidDeaths2 dea
Join PorfolioProject..CovidVaccinations vac
   On dea.Location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac


--Creating view to store data for later visualization
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PorfolioProject..CovidDeaths2 dea
Join PorfolioProject..CovidVaccinations vac
   On dea.Location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
