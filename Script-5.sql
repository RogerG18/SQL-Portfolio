/* 
 In the last two years, the COVID 19 Pandemic has been different to every person and country around the world. 
 Some countries reacted faster and better against this worldwide problem, and others did not act until it was a problem in the country.  
 This analysis is aimed to discover how the general situation was during an specific period of time in my country, Mexico 
*/



-- 1. Finding out the number of records in the data set 

select
	COUNT(RESULTADO) as "Number_of_Records"
from
	general_covid19_mx gcm; 
/*
As a first step, I wanted to know how many records this data set had and find out how many patients were registered during this period of time. 
In total, there is 879,608 patients including their personal information such as Age, State where they live, Health Conditions, Date of Symtoms among others
*/
 

-- 2. How many of these records are positive cases and how many are negative?
select
	(
	select
		count(RESULTADO)
	from
		general_covid19_mx gcm
	where
		RESULTADO = 1) as "Positive Cases", 
		(
	select
		count(RESULTADO)
	from
		general_covid19_mx gcm
	where
		RESULTADO = 2) as "Negative Cases";
/*
370,712 patients had a positive result for COVID 19 and 419,319 had a negative result. 
Considering that this data set has only records from the beggining of the Pandemic (7 Months), I think the positive results are actually high.
I belive this was caused by the desinformation we had at the time. People did not consider it was going to last for a long period of time and could not imagine the concecuences
of not using the masks in public places.
*/

	
-- 3. From those positive cases, how many are men and women?
select
	sd.DESCRIPCIÓN,
	count(gcm.RESULTADO) as "Count_of_Patients"
from
	general_covid19_mx gcm
join sex_data sd on
	gcm.SEXO = sd.CLAVE
where
	gcm.RESULTADO = 1
group by
	sd.DESCRIPCIÓN; 
/* 
There were 198,358 Men and 172,354 Women that tested positive during this period of time.
*/


-- 4. Month with the highest Positive Cases 
select
	distinct(MONTHNAME(`Date`)) as "Month",
	count(Confirmed) as "Number_of_Cases"
from
	confirmed_cases cc
group by
	monthname(`Date`)
order by
	Number_of_Cases desc; 
/* 
150,143 patients tested positive in June. Out of the 7 months this data set collects, this month was the one with more positive cases.  
*/


-- 5. Positive results by state in Mexico*/ 
select
	distinct(State),
	SUM(Confirmed) as "Total_Cases"
from
	confirmed_cases cc
group by
	State
order by
	Total_Cases desc; 
/* 
During this period of time, Mexico City had the highest positive results. 
This makes a lot of sence, since Mexico City is one of the most populated cities in Mexico
*/

-- 6. Type of Patients
select
	top.DESCRIPCIÓN as "Type_of_Patient",
	count(gcm.TIPO_PACIENTE) as "Count_of_Patients"
from
	general_covid19_mx gcm
join type_of_patient top on
	gcm.TIPO_PACIENTE = top.CLAVE
where
	gcm.RESULTADO = 1
group by
	gcm.TIPO_PACIENTE; 
/* 
From the 370,712 patients that tested positive, 266,481 were "Ambulatory" patients, which means that they did not necessarily had to stay in a hospital. 
104,231 were "Hospitalized" patients. These people had to stay in an hospital and needed a treatment. 
There are a number of reasons why these could have happened. I belive one of them is the fact that at an early stage of the Pandemic, there were a lot of positive 
results, therefore the hospitals did not have enough resources and room for every patient.
*/


-- 7. How many people with positive results were on Intensive Care 
select
	count(UCI) as "People on Intensive Care"
from
	general_covid19_mx gcm
where
	UCI = 1
	and RESULTADO = 1; 
/* 
8,536 patients were on Intensive Care
*/ 


-- 8. Month with more Deaths 
select
	monthname(FECHA_DEF) as "Month",
	count(FECHA_DEF) as "Number_of_Deaths"
from
	general_covid19_mx gcm
where
	FECHA_DEF != "9999-99-99"
group by
	monthname(FECHA_DEF)
order by
	Number_of_Deaths desc
limit 1
/*
June was the month with more Deaths of COVID 19
*/ 


-- 9. Average age of patients with Positive Results that Passed Away  
select
	sd.DESCRIPCIÓN ,
	round(avg(gcm.EDAD), 0) as "Average Age"
from
	general_covid19_mx as gcm
join sex_data as sd 
on
	gcm.SEXO = sd.CLAVE
where
	RESULTADO = 1
	and FECHA_DEF != "9999-99-99"
group by
	gcm.SEXO;
/* 
The Average age of people that had COVID 19 and Passed Away is 63 for Women and 61 for Men.
Some studies show that older people have a higher chance of having complications if they tested postive for COVID 19 mostly because their immune system does not work properly. 
Also, in Mexico we have a serious problem regarding chronic conditions, that is defenitely something that affects the body response against different diseases, including COVID 19 
*/ 


-- 10. People that died of COVID 19 and had some chronic condition
select
	(
	select
		count(DIABETES)
	from
		general_covid19_mx
	where
		DIABETES = 1
		and FECHA_DEF != "9999-99-99"
		and RESULTADO = 1 ) as "People with Diabetes", 
		(
	select
		count(HIPERTENSION)
	from
		general_covid19_mx
	where
		HIPERTENSION = 1
		and FECHA_DEF != "9999-99-99"
		and RESULTADO = 1) as "People with Hypertension", 
		(
	select
		count(OBESIDAD)
	from
		general_covid19_mx
	where
		OBESIDAD = 1
		and FECHA_DEF != "9999-99-99"
		and RESULTADO = 1 ) as "People with Obesity"; 
/* 
As I mentioned before, chronic conditions in Mexico are something really common, affecting the overall health of the population. 
As specified by Studies, having some sort of chronic condition like Diabetes, Hypertension or Obesity increases the risk of complications during COVID 19
leading to permanent side effects or in this case, death.
*/ 
	
	
-- 11. People with breathing conditions 
select
	(
	select
		count(TABAQUISMO)
	from
		general_covid19_mx
	where
		TABAQUISMO = 1
		and FECHA_DEF != "9999-99-99"
		and RESULTADO = 1) as "Smokers",
		(
	select
		count(ASMA)
	from
		general_covid19_mx
	where
		ASMA = 1
		and FECHA_DEF != "9999-99-99"
		and RESULTADO = 1) as "People with Asma";
/* 
Finally, having some tyoe of breathing condition is dangerous while infected by COVID 19. Therefore, people that Smoke or have Asma are part of the population
with serious difficulties
*/
