# Group_3_final_project
## Selected topic - Precious Metal (aka Olympic Medals)

- Reason the topic was selected - 
Since the opening of the first modern Olympic Games in 1896, the international sports competition has only been canceled three times: once during World War I (1916) and twice during World War II (1940, 1944). Until this year. Because of the COVID-19 outbreak the 2020 Olympic Games have been postponed by a year. In anticipation of the Olympic games we decided to try and make a prediction for the games in the future.  

- A question we hope to answer with the data is whether the amount of medals that a country wins can be predicted by the demographics and economic conditions in that country. 

### Technology Selection

- Languages: Python, JavaScript, HTML, SQL
- Technologies: Tableau, PostgreSQL, PgAdmin
- Tools: Jupyter Notebook

### Source of data:

Below is the data that we selected for this project, along with links to the sources that it was downloaded from:

Population

The total population for countries and territories in the world as reported by the World Bank.

Source:
https://data.worldbank.org/indicator/SP.POP.TOTL?end=2019&start=1960&view=chart

GDP per capita

The GDP of countries divided by their total population, as reported by the World Bank.

Source:
https://data.worldbank.org/indicator/NY.GDP.PCAP.CD?view=chart

HDI

The Human Development Index (HDI), provided by the Humanitarian Data Exchange. The HDI ranks countries based on quality of life, as measured by lifespan, education and purchasing power-adjusted income per capita. The HDI ranges between 0 and 1, with higher values indicating higher human development.

Source:
https://data.humdata.org/dataset/human-development-index-hdi-2014/resource/ccc764d4-1e53-4370-83fa-562e860e72b5

GII

The Gender Inequality Index (GII), provided by Resource Watch. The GII is a measure used to quantify the loss of achievement within a country due to gender inequality, combining reproductive health, empowerment and labor market participation measures. Lower values indicate more gender equality. The GII ranges between 0 (high gender equality) and 1 (high inequality).
Source:
https://resourcewatch.org/data/explore/soc025-Gender-Inequality-Index?section=Discover&zoom=3&lat=0&lng=0&pitch=0&bearing=0&basemap=dark&labels=light&layers=%255B%257B%2522dataset%2522%253A%252211278cb6-b298-49a1-bf71-f1e269f40758%2522%252C%2522opacity%2522%253A1%252C%2522layer%2522%253A%25229d3ef845-93a1-47a0-b26a-c124b8a6ff2b%2522%257D%255D&page=1&sort=most-viewed&sortDirection=-1

CPI

The Corruption Perceptions Index (CPI), provided by Transparency International. The CPI defines corruption as "the misuse of public power for private benefit", and calculates a score by amalgamating a number of surveys and assessments from various organizations. The CPI ranges on a scale from 0 (highly corrupt) to 100 (very clean). 

Source:
https://www.transparency.org/en/cpi/2014/results

2012 & 2014 Olympic Medal Count

Medal totals for all countries in the 2012 Summer and 2014 Winter Olympics as shown on Wikipedia.

Sources:
https://en.wikipedia.org/wiki/2012_Summer_Olympics_medal_table 
https://en.wikipedia.org/wiki/2014_Winter_Olympics_medal_table

### Data Exploration and Data Preprocessing

The demographic/index data was selected when deciding on the theoretical basis for our model. We had decided on the specific data that we needed prior to searching for the datasets.
Upon looking into the datasets, we realized that there were several issues that made them difficult to use. To remedy this, the code within the data_cleaning.ipynb file was used to:
1. Set the country names to a common name within all of the data sources.
2. Remove the blank space character from the front of all country names in the GII dataset and at the end of all countries in the Olympic medal datasets.
3. Set the population of Eritrea to the last known value (2011).
4. Used external sources to fill in the GDP per capita for Syria and North Korea.
5. Filled in missing GII values using logic in the following order of available data: using average of 2013 and 2015 values to fill in 2014 value; using 2015 data; using 2012 data; using last available value.
6. Added the following countries/territories to the datasets where they were missing, along with most reasonable value estimates: Puerto Rico, US Virgin Islands, North Korea, Kosovo.
7. Narrowed down each dataset to the columns that we intend to use (the country name and the demographic/index value for 2014). 

### Database

To set up the database in Postgres, the following steps need to be taken:
1. Create a config.py file with the following code: db_password = 'your postgres password goes here'
2. Launch pgAdmin and create a database called OlympicsDB
3. Run the CREATE TABLE commands from database_creation.sql
4. Run the code in loading_data_into_sql.ipynb
5. Run the second set of commands from database_creation.sql

<img width="814" alt="ERD_Schemas" src="https://user-images.githubusercontent.com/67556541/101271846-9f0ad580-3754-11eb-958b-06b7a79344b9.png">

### Machine Learning Model
Initial Model: 
- To create a complete and useable dataset for the machine learning model, during preprocessing the 7 demographic/index and medal datasets were combined with SQL and any rows with null values were removed.
- The preliminary features for the model were selected based on the theory that we wanted to test: whether the number of medals that a country wins can be predicted by the demographics and economic conditions/indicators for that country. Specifically, the following features were selected: population, gdp_per_capita, human_development_index, gender_inequality_index, & corruption_perceptions_index.
- The Random Forest Regression model was selected because we needed to predict the number of medals as a total value, as opposed to one of two values with a classifier model. Like a linear regression model, a benefit of the Random Forest Regression is that it shows the relationship between the features and the target. Additionally, by combining multiple weak learners to form a strong learner, this model develops more accurate results with lower variance by averaging the predictions of the trees. A limitation of this model is that it doesn’t predict beyond the range in the training data.
- The ‘train_test_split’ was used to split the data in 75:25 ratio i.e. 75% of the data will be used for training the model and 25% will be used for testing the model.
- The performance of the Random Forest Regression model was compared to Logistic Regression and Deep Learning models.

Optimization: 
- While working to optimize the model, we discovered that using total GDP in place of GDP per capita greatly increased the predictive ability of the Random Forest Regression model.
- gdp_total was added to the model by multiplying population by gdp_per_capita; population and gdp_per_capita were dropped from the features during model training as this increased model performance.
- The complement of the gender_inequality_index was used instead of the original gender_inequality_index values (the compliment values are incremental with higher gender equality); this increased model performance.
- The predictive ability of the model, measured as R^2, increased from -0.115 to 0.492. (Note: a negative R^2 value means that our model predicted results worse than just predicting the average medal count for each country.)

<img width="1345" alt="Screen Shot 2020-12-05 at 10 45 08 PM" src="https://user-images.githubusercontent.com/67556541/101271722-71715c80-3753-11eb-846f-0c1f94ee83f2.png">

Second Model: 
- An issue that the initial model was running into was that many countries don't have medals, but the model would predict those countries winning several medals.
- A different angle was taken to predict the medal count: predicting the range of medals that a country won. A Deep Learning model was used to predict categorical outcomes.
- The medals were bucketed into 6 bins, and one-hot encoded into an array.
- The model uses 3 layers of ReLu functions and a Softmax activation function on the output to predict which of the 6 medal bins the country's medal count falls into.
- The evaluation metric for this model was accuracy; the model predicted 57.5% of medal ranges correctly. 

### Summary:

Overall, demographic data and economic indexes do not predict Olympic medals well, though they do have positive correlation.

Even thought we were not able to achive the 90% accuracy we wanted we were able to increase the accuracy from -17.4% to 57.5%.


### Dashboard and Google Slides

[google slides](https://docs.google.com/presentation/d/14y4Lvk1pmtc8OTdNtIsPLjCLNAikkeURze1wMbV6xWk/edit?usp=sharing)

[Tableau Story](https://public.tableau.com/views/PreciousMedal/PreciousMedal?:language=en&:display_count=y&publish=yes&:origin=viz_share_link)

[Precious Medals](https://k2handa.github.io/PreciousMedal.github.io/)
