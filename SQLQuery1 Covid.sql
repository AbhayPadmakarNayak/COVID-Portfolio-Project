/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Converting Data Types

*/

Select *
From PortfolioProject..CovidDeaths
Where continent is not Null
Order By 3,4

Select *
From PortfolioProject..CovidVaccinations
Order By 3,4

--Choose the data we will commence with.
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not Null
Order by 1,2

--Total Cases vs Total Deaths
--Shows likelihood of dying if you contract Covid in US

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

--Total Cases vs Total Population
--Shows what percentage of populaion got Covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null 
Order by 1,2

--Countries with Highest Infection rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectCount, MAX((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null 
group By location, population
Order by PercentPopulationInfected desc

--Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
group By location, population
Order by TotalDeathCount desc


--Break things down by Continent

--Continents with the Highest Death Count per Population

Select continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group By continent
Order by TotalDeathCount desc


 --Global Numbers

 Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, (Sum(cast(new_deaths as int))/Sum(new_cases))*100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 Where continent is not null
 order by 1,2
 

 --Total Population vs Vacination
 --Shows Percentage of Population that has recieved at least one Covid Vaccine

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
      On dea.location=vac.location
	  and dea.date=vac.date
 where dea.continent is not null
 order by 2,3

 -- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentangeOfPeopleVaccinated
From PopvsVac
















