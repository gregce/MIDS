--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.5
-- Started on 2015-10-14 21:45:27 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 179 (class 3079 OID 12123)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2299 (class 0 OID 0)
-- Dependencies: 179
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 173 (class 1259 OID 16555)
-- Name: effective_care; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE effective_care (
    "Provider ID" text,
    "HospitalName" text,
    "Address" text,
    "City" text,
    "State" text,
    "ZIPCode" bigint,
    "CountyName" text,
    "PhoneNumber" bigint,
    "Condition" text,
    "MeasureID" text,
    "MeasureName" text,
    "Score" text,
    "Sample" text,
    "Footnote" text,
    "MeasureStartDate" text,
    "MeasureEndDate" text
);


ALTER TABLE effective_care OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 16580)
-- Name: hosp_patientexperience; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hosp_patientexperience (
    "Provider Number" bigint,
    "HospitalName" text,
    "Address" text,
    "City" text,
    "State" text,
    "ZIPCode" text,
    "CountyName" text,
    "CommunicationwithNursesAchievementPoints" text,
    "CommunicationwithNursesImprovementPoints" text,
    "CommunicationwithNursesDimensionScore" text,
    "CommunicationwithDoctorsAchievementPoints" text,
    "CommunicationwithDoctorsImprovementPoints" text,
    "CommunicationwithDoctorsDimensionScore" text,
    "ResponsivenessofHospitalStaffAchievementPoints" text,
    "ResponsivenessofHospitalStaffImprovementPoints" text,
    "ResponsivenessofHospitalStaffDimensionScore" text,
    "PainManagementAchievementPoints" text,
    "PainManagementImprovementPoints" text,
    "PainManagementDimensionScore" text,
    "CommunicationaboutMedicinesAchievementPoints" text,
    "CommunicationaboutMedicinesImprovementPoints" text,
    "CommunicationaboutMedicinesDimensionScore" text,
    "CleanlinessandQuietnessofHospitalEnvironmentAchievementPoints" text,
    "CleanlinessandQuietnessofHospitalEnvironmentImprovementPoints" text,
    "CleanlinessandQuietnessofHospitalEnvironmentDimensionScore" text,
    "DischargeInformationAchievementPoints" text,
    "DischargeInformationImprovementPoints" text,
    "DischargeInformationDimensionScore" text,
    "OverallRatingofHospitalAchievementPoints" text,
    "OverallRatingofHospitalImprovementPoints" text,
    "OverallRatingofHospitalDimensionScore" text,
    "HCAHPSBaseScore" text,
    "HCAHPSConsistencyScore" text
);


ALTER TABLE hosp_patientexperience OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 16587)
-- Name: hosp_totalperformance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hosp_totalperformance (
    "Provider Number" bigint,
    "HospitalName" text,
    "Address" text,
    "City" text,
    "State" text,
    "ZipCode" text,
    "CountyName" text,
    "UnweightedNormalizedClinicalProcessofCareDomainScore" text,
    "WeightedClinicalProcessofCareDomainScore" text,
    "UnweightedPatientExperienceofCareDomainScore" text,
    "WeightedPatientExperienceofCareDomainScore" text,
    "UnweightedNormalizedOutcomeDomainScore" text,
    "WeightedOutcomeDomainScore" text,
    "UnweightedNormalizedEfficiencyDomainScore" text,
    "WeightedEfficiencyDomainScore" text,
    "TotalPerformanceScore" double precision
);


ALTER TABLE hosp_totalperformance OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 16548)
-- Name: hospitals; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hospitals (
    "Provider ID" text,
    "HospitalName" text,
    "Address" text,
    "City" text,
    "State" text,
    "ZIPCode" bigint,
    "CountyName" text,
    "PhoneNumber" bigint,
    "HospitalType" text,
    "HospitalOwnership" text,
    "EmergencyServices" text
);


ALTER TABLE hospitals OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 16573)
-- Name: measuredates; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE measuredates (
    "Measure Name" text,
    "MeasureID" text,
    "MeasureStartQuarter" text,
    "MeasureStartDate" text,
    "MeasureEndQuarter" text,
    "MeasureEndDate" text
);


ALTER TABLE measuredates OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 16594)
-- Name: readmissionreduction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE readmissionreduction (
    "Hospital Name" text,
    "ProviderNumber" bigint,
    "State" text,
    "MeasureName" text,
    "NumberofDischarges" text,
    "Footnote" double precision,
    "ExcessReadmissionRatio" text,
    "PredictedReadmissionRate" text,
    "ExpectedReadmissionRate" text,
    "NumberofReadmissions" text,
    "StartDate" text,
    "EndDate" text
);


ALTER TABLE readmissionreduction OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 16566)
-- Name: readmissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE readmissions (
    "Provider ID" text,
    "HospitalName" text,
    "Address" text,
    "City" text,
    "State" text,
    "ZIPCode" bigint,
    "CountyName" text,
    "PhoneNumber" bigint,
    "MeasureName" text,
    "MeasureID" text,
    "ComparedtoNational" text,
    "Denominator" text,
    "Score" text,
    "LowerEstimate" text,
    "HigherEstimate" text,
    "Footnote" text,
    "MeasureStartDate" text,
    "MeasureEndDate" text
);


ALTER TABLE readmissions OWNER TO postgres;

--
-- TOC entry 2177 (class 1259 OID 16561)
-- Name: ix_effective_care_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_effective_care_Provider ID" ON effective_care USING btree ("Provider ID");


--
-- TOC entry 2180 (class 1259 OID 16586)
-- Name: ix_hosp_patientexperience_Provider Number; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hosp_patientexperience_Provider Number" ON hosp_patientexperience USING btree ("Provider Number");


--
-- TOC entry 2181 (class 1259 OID 16593)
-- Name: ix_hosp_totalperformance_Provider Number; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hosp_totalperformance_Provider Number" ON hosp_totalperformance USING btree ("Provider Number");


--
-- TOC entry 2176 (class 1259 OID 16554)
-- Name: ix_hospitals_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hospitals_Provider ID" ON hospitals USING btree ("Provider ID");


--
-- TOC entry 2179 (class 1259 OID 16579)
-- Name: ix_measuredates_Measure Name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_measuredates_Measure Name" ON measuredates USING btree ("Measure Name");


--
-- TOC entry 2182 (class 1259 OID 16600)
-- Name: ix_readmissionreduction_Hospital Name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_readmissionreduction_Hospital Name" ON readmissionreduction USING btree ("Hospital Name");


--
-- TOC entry 2178 (class 1259 OID 16572)
-- Name: ix_readmissions_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_readmissions_Provider ID" ON readmissions USING btree ("Provider ID");


--
-- TOC entry 2298 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-10-14 21:45:27 PDT

--
-- PostgreSQL database dump complete
--

