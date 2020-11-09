-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/CqaEHv
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "SummerGames" (
    "Year" int   NOT NULL,
    "Country" varchar   NOT NULL,
    "Medal" varchar   NOT NULL,
    CONSTRAINT "pk_SummerGames" PRIMARY KEY (
        "Country"
     )
);

CREATE TABLE "WinterGames" (
    "Year" int   NOT NULL,
    "Country" varchar   NOT NULL,
    "Event" varchar   NOT NULL,
    "Medal" varchar   NOT NULL,
    CONSTRAINT "pk_WinterGames" PRIMARY KEY (
        "Country"
     )
);

CREATE TABLE "WorldPopulation" (
    "Year" int   NOT NULL,
    "Country" varchar   NOT NULL,
    "Pop_total" int   NOT NULL,
    CONSTRAINT "pk_WorldPopulation" PRIMARY KEY (
        "Pop_total"
     )
);

CREATE TABLE "GDP" (
    "Year" int   NOT NULL,
    "Country" varchar   NOT NULL,
    "GDP_total" float   NOT NULL,
    CONSTRAINT "pk_GDP" PRIMARY KEY (
        "GDP_total"
     )
);

CREATE TABLE "GenderII" (
    "Year" int   NOT NULL,
    "Country" varchar   NOT NULL,
    "GII" float   NOT NULL,
    CONSTRAINT "pk_GenderII" PRIMARY KEY (
        "GII"
     )
);

CREATE TABLE "HumanDevIndex" (
    "Country" varchar   NOT NULL,
    "HDI" float   NOT NULL,
    CONSTRAINT "pk_HumanDevIndex" PRIMARY KEY (
        "HDI"
     )
);

ALTER TABLE "WinterGames" ADD CONSTRAINT "fk_WinterGames_Country" FOREIGN KEY("Country")
REFERENCES "SummerGames" ("Country");

ALTER TABLE "WorldPopulation" ADD CONSTRAINT "fk_WorldPopulation_Country" FOREIGN KEY("Country")
REFERENCES "SummerGames" ("Country");

ALTER TABLE "GDP" ADD CONSTRAINT "fk_GDP_Country" FOREIGN KEY("Country")
REFERENCES "SummerGames" ("Country");

ALTER TABLE "GenderII" ADD CONSTRAINT "fk_GenderII_Country" FOREIGN KEY("Country")
REFERENCES "SummerGames" ("Country");

ALTER TABLE "HumanDevIndex" ADD CONSTRAINT "fk_HumanDevIndex_Country" FOREIGN KEY("Country")
REFERENCES "SummerGames" ("Country");

