--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.5
-- Started on 2015-10-17 15:56:08 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 189 (class 3079 OID 12123)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2350 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


--
-- TOC entry 180 (class 1259 OID 16624)
-- Name: t_hospitals; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitals (
    "ProviderID" text,
    "HospitalName" text,
    "City" text,
    "State" text,
    "HospitalType" text,
    "HospitalOwnership" text,
    "EmergencyServices" text
);


ALTER TABLE t_hospitals OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16646)
-- Name: t_hospitalseffectivecare; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalseffectivecare (
    "ProviderID" text,
    "Condition" text,
    "MeasureID" text,
    "MeasureName" text,
    "Score" text,
    "Sample" text
);


ALTER TABLE t_hospitalseffectivecare OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 16652)
-- Name: t_hospitalseffectivecareranges; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalseffectivecareranges (
    "Condition" text,
    "MeasureName" text,
    "MeasureID" text,
    min numeric,
    max numeric,
    minmaxrange numeric
);


ALTER TABLE t_hospitalseffectivecareranges OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16670)
-- Name: t_hospitalspatientexperiencescaledscore; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalspatientexperiencescaledscore (
    "ProviderID" bigint,
    "CommunicationwithNursesDimensionScore" text,
    "CommunicationwithDoctorsDimensionScore" text,
    "ResponsivenessofHospitalStaffDimensionScore" text,
    "PainManagementDimensionScore" text,
    "CommunicationaboutMedicinesDimensionScore" text,
    "CleanlinessandQuietnessofHospitalEnvironmentDimensionScore" text,
    "DischargeInformationDimensionScore" text,
    "OverallRatingofHospitalDimensionScore" text,
    "HCAHPSBaseScore" text,
    "HCAHPSConsistencyScore" text,
    scaledscoreaverage double precision
);


ALTER TABLE t_hospitalspatientexperiencescaledscore OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 16639)
-- Name: t_hospitalsreadmissionratios; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalsreadmissionratios (
    "ProviderID" bigint,
    cntprocedures bigint,
    aggregatereadmissionratio numeric,
    aggregateexcessreadmissions integer
);


ALTER TABLE t_hospitalsreadmissionratios OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16658)
-- Name: t_hospitalsreadmissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalsreadmissions (
    "ProviderID" text,
    "MeasureName" text,
    "MeasureID" text,
    "ComparedtoNational" text,
    "Denominator" text,
    "Score" text
);


ALTER TABLE t_hospitalsreadmissions OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16664)
-- Name: t_hospitalsreadmissionsscaledscoresbycat; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalsreadmissionsscaledscoresbycat (
    "ProviderID" text,
    category text,
    count bigint,
    ss bigint,
    ratioscore double precision
);


ALTER TABLE t_hospitalsreadmissionsscaledscoresbycat OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 16632)
-- Name: t_hospitalstypecountsgranular; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_hospitalstypecountsgranular (
    cnt bigint,
    "State" text,
    "HospitalType" text,
    "HospitalOwnership" text,
    "EmergencyServices" text
);


ALTER TABLE t_hospitalstypecountsgranular OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16676)
-- Name: t_measurenames; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t_measurenames (
    "Measure Name" text,
    "MeasureID" text,
    "MeasureStartQuarter" text,
    "MeasureEndQuarter" text
);


ALTER TABLE t_measurenames OWNER TO postgres;

--
-- TOC entry 2227 (class 1259 OID 16561)
-- Name: ix_effective_care_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_effective_care_Provider ID" ON effective_care USING btree ("Provider ID");


--
-- TOC entry 2230 (class 1259 OID 16586)
-- Name: ix_hosp_patientexperience_Provider Number; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hosp_patientexperience_Provider Number" ON hosp_patientexperience USING btree ("Provider Number");


--
-- TOC entry 2233 (class 1259 OID 16623)
-- Name: ix_hosp_surveys_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hosp_surveys_Provider ID" ON hosp_surveys USING btree ("Provider ID");


--
-- TOC entry 2231 (class 1259 OID 16593)
-- Name: ix_hosp_totalperformance_Provider Number; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hosp_totalperformance_Provider Number" ON hosp_totalperformance USING btree ("Provider Number");


--
-- TOC entry 2226 (class 1259 OID 16554)
-- Name: ix_hospitals_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_hospitals_Provider ID" ON hospitals USING btree ("Provider ID");


--
-- TOC entry 2229 (class 1259 OID 16579)
-- Name: ix_measuredates_Measure Name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_measuredates_Measure Name" ON measuredates USING btree ("Measure Name");


--
-- TOC entry 2232 (class 1259 OID 16600)
-- Name: ix_readmissionreduction_Hospital Name; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_readmissionreduction_Hospital Name" ON readmissionreduction USING btree ("Hospital Name");


--
-- TOC entry 2228 (class 1259 OID 16572)
-- Name: ix_readmissions_Provider ID; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX "ix_readmissions_Provider ID" ON readmissions USING btree ("Provider ID");


--
-- TOC entry 2349 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-10-17 15:56:08 PDT

--
-- PostgreSQL database dump complete
--

