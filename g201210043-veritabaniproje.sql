--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: doktor_maasmiktar(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doktor_maasmiktar(min_maasmiktar integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare 
maasmiktar int;
begin
select count(*) into maasmiktar from doktor_maas where maaşlar>min_maasmiktar;
return maasmiktar;
end;
$$;


ALTER FUNCTION public.doktor_maasmiktar(min_maasmiktar integer) OWNER TO postgres;

--
-- Name: hastakontrol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hastakontrol("_hastaıd" integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
if (select count(*) from "public"."hasta" where hastaıd = _hastaıd)>0 then 
return 1;
else
return 0;
end if;
end;
$$;


ALTER FUNCTION public.hastakontrol("_hastaıd" integer) OWNER TO postgres;

--
-- Name: ilDegisikligi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."ilDegisikligi"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."iller" <> OLD."iller" THEN
        INSERT INTO "ilDegisikligiIzle"("ilid", "eskiil", "yeniil", "degisiklikTarihi")
        VALUES(OLD."ilid", OLD."iller", NEW."iller", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public."ilDegisikligi"() OWNER TO postgres;

--
-- Name: ilekle(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ilekle(ilid integer, iller character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin 
insert into public."il"("ilid","iller") values (ilid,iller);
End;
$$;


ALTER FUNCTION public.ilekle(ilid integer, iller character varying) OWNER TO postgres;

--
-- Name: kayitekle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kayitekle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."ilceler" = UPPER(NEW."ilceler"); 
    NEW."ilceler" = LTRIM(NEW."ilceler"); 
    IF NEW."ilid" IS NULL THEN
            RAISE EXCEPTION 'İlID alanı boş olamaz';  
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.kayitekle() OWNER TO postgres;

--
-- Name: test(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update toplamhasta set sayi=sayi+1;
return new;
end;
$$;


ALTER FUNCTION public.test() OWNER TO postgres;

--
-- Name: test2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.test2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update toplamhasta2silme set azalansayi=azalansayi-1;
return new;
end;
$$;


ALTER FUNCTION public.test2() OWNER TO postgres;

--
-- Name: toplamdoktor(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplamdoktor() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare 
doktor_count integer;
begin
select count (*)
into doktor_count
from "doktor";
return doktor_count;
end;
$$;


ALTER FUNCTION public.toplamdoktor() OWNER TO postgres;

--
-- Name: toplamhasta(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplamhasta() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare 
hasta_count integer;
begin
select count (*)
into hasta_count
from "hasta";
return hasta_count;
end;
$$;


ALTER FUNCTION public.toplamhasta() OWNER TO postgres;

--
-- Name: zamlımaaslar(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."zamlımaaslar"("maaş" double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
begin
maaş:=maaş+((maaş*20)/100);
 return maaş;
end;
$$;


ALTER FUNCTION public."zamlımaaslar"("maaş" double precision) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bolumler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bolumler (
    bolumlerid integer NOT NULL,
    bolumler character varying(35) NOT NULL,
    hastaneid integer
);


ALTER TABLE public.bolumler OWNER TO postgres;

--
-- Name: doktor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doktor (
    doktorid integer NOT NULL,
    doktorlar character varying(45) NOT NULL,
    doktormaasid integer,
    bolum integer,
    kangrubuid integer,
    ilid integer,
    ilceid integer,
    unvanid smallint
);


ALTER TABLE public.doktor OWNER TO postgres;

--
-- Name: doktor_maas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doktor_maas (
    "doktormaaşid" integer NOT NULL,
    "maaşlar" integer NOT NULL
);


ALTER TABLE public.doktor_maas OWNER TO postgres;

--
-- Name: hasta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hasta (
    "hastaıd" integer NOT NULL,
    ad character varying(50) NOT NULL,
    soyad character varying(75) NOT NULL,
    hastail integer NOT NULL,
    ilid integer,
    kangrubuid integer,
    "hastalıkid" integer,
    ilceid integer,
    tckimlikno character varying(11),
    iletisim text,
    randevuid text
);


ALTER TABLE public.hasta OWNER TO postgres;

--
-- Name: hastalık; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."hastalık" (
    "hastalıkid" integer NOT NULL,
    "Hastalıklar" character varying(75) NOT NULL,
    poliklinikid integer
);


ALTER TABLE public."hastalık" OWNER TO postgres;

--
-- Name: hastane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hastane (
    hastaneid integer NOT NULL,
    hastaneler text NOT NULL,
    "hastanetürü" character varying(25),
    ilid integer
);


ALTER TABLE public.hastane OWNER TO postgres;

--
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    ilid integer NOT NULL,
    iller character varying(38) NOT NULL
);


ALTER TABLE public.il OWNER TO postgres;

--
-- Name: ilDegisikligiIzle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ilDegisikligiIzle" (
    "kayitNo" integer NOT NULL,
    ilid integer NOT NULL,
    eskiil character varying NOT NULL,
    yeniil character varying NOT NULL,
    "degisiklikTarihi" timestamp without time zone NOT NULL
);


ALTER TABLE public."ilDegisikligiIzle" OWNER TO postgres;

--
-- Name: ilDegisikligiIzle_kayitNo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ilDegisikligiIzle_kayitNo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ilDegisikligiIzle_kayitNo_seq" OWNER TO postgres;

--
-- Name: ilDegisikligiIzle_kayitNo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ilDegisikligiIzle_kayitNo_seq" OWNED BY public."ilDegisikligiIzle"."kayitNo";


--
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    ilceid integer NOT NULL,
    ilceler character varying(37) NOT NULL,
    ilid integer
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- Name: kangrubu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kangrubu (
    kangrubuid integer NOT NULL,
    "KanGrubları" character varying(22) NOT NULL
);


ALTER TABLE public.kangrubu OWNER TO postgres;

--
-- Name: lab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab (
    "labıd" integer NOT NULL,
    "labuygulamaları" text DEFAULT '25'::text NOT NULL
);


ALTER TABLE public.lab OWNER TO postgres;

--
-- Name: muayne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muayne (
    "muayneıd" integer NOT NULL,
    muaynetipi character varying(40) NOT NULL,
    hastaid integer
);


ALTER TABLE public.muayne OWNER TO postgres;

--
-- Name: muaynesonuc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muaynesonuc (
    muaynesonucid integer NOT NULL,
    sonuclar character varying(45) NOT NULL,
    hastaid integer,
    muayneid integer
);


ALTER TABLE public.muaynesonuc OWNER TO postgres;

--
-- Name: randevular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.randevular (
    "randevularıd" integer NOT NULL,
    randevu character varying(24) NOT NULL,
    "hastaıd" integer,
    hastaneid integer
);


ALTER TABLE public.randevular OWNER TO postgres;

--
-- Name: teshis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teshis (
    "teshisıd" integer NOT NULL,
    teshisler character varying(400) NOT NULL,
    hastaid integer
);


ALTER TABLE public.teshis OWNER TO postgres;

--
-- Name: test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test (
    "testıd" integer NOT NULL,
    testler character varying(48) NOT NULL,
    muaynesonucid integer,
    "labıd" integer
);


ALTER TABLE public.test OWNER TO postgres;

--
-- Name: testsonuc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testsonuc (
    "testsonuclarııd" integer NOT NULL,
    sonuclar character varying(100) NOT NULL,
    teshisid integer,
    "labıd" integer
);


ALTER TABLE public.testsonuc OWNER TO postgres;

--
-- Name: toplamhasta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplamhasta (
    sayi integer
);


ALTER TABLE public.toplamhasta OWNER TO postgres;

--
-- Name: toplamhasta2silme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplamhasta2silme (
    azalansayi integer
);


ALTER TABLE public.toplamhasta2silme OWNER TO postgres;

--
-- Name: unvan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unvan (
    unvanid integer NOT NULL,
    unvan character varying(44) NOT NULL
);


ALTER TABLE public.unvan OWNER TO postgres;

--
-- Name: ilDegisikligiIzle kayitNo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ilDegisikligiIzle" ALTER COLUMN "kayitNo" SET DEFAULT nextval('public."ilDegisikligiIzle_kayitNo_seq"'::regclass);


--
-- Data for Name: bolumler; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bolumler VALUES
	(1001, 'Nefroloji
', 401),
	(1002, 'Kardiyoloji ', 401),
	(1003, 'Dahiliye', 401),
	(1004, 'Gastroenteroloji', 401),
	(1005, 'Nöroloji
', 401),
	(1006, 'Pskiyatri', 402),
	(1007, 'Kadın Hastalıkları', 403),
	(1008, 'Çocuk Hastalıkları', 402);


--
-- Data for Name: doktor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doktor VALUES
	(1, 'Yusuf Cihan Gedik', 102, 1001, 4, 1, 601, 11),
	(2, 'Elif Beyaz', 102, 1002, 3, 5, 605, 11),
	(3, 'İbrahim Salih GEDİK', 104, 1001, 4, 1, 601, 11);


--
-- Data for Name: doktor_maas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doktor_maas VALUES
	(101, 10500),
	(102, 8500),
	(103, 9652),
	(104, 15000),
	(1, 30000);


--
-- Data for Name: hasta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hasta VALUES
	(1, 'Ömer Faruk', 'Beyaz', 1, 1, 1, 302, 601, '23423423414', 'ömerfaruk beyaz@hotmail.com
cumhuriyet caddesi alibey sokak daire3', NULL),
	(2, 'yusuf', 'gedik', 2, 2, 2, 301, 602, '12560235474', 'cedid mah büş sok kat3', NULL),
	(3, 'Mehmet ', 'Kara', 3, 3, 4, 301, 602, '11245302415', 'ermezler caddesi eflatun sokak özyilmaz apt kat3 daire3', NULL),
	(4, 'Mücahid', 'Yildiz', 1, 1, 4, 302, 601, '42263553241', 'mücahid yildiz@hotmail.com', NULL),
	(5, 'Ayşe', 'Kaçan', 7, 7, 4, 304, 607, '48536524102', 'ayşekaçan@hotmail.com', NULL);


--
-- Data for Name: hastalık; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."hastalık" VALUES
	(301, 'Böbrek Ağrısı', 1001),
	(302, 'Kalp Ağrısı
', 1002),
	(303, 'Bağırsak Rahatsızlıgı
', 1003),
	(304, 'Mide Ağrısı
', 1004),
	(305, 'Beyin Hasarı', 1005);


--
-- Data for Name: hastane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hastane VALUES
	(401, 'Kent Hastanesi', 'Özel', 1),
	(402, 'Acıbadem Hastanesi
', 'Özel', 5),
	(403, 'Ümit Hastanesi', 'Özel', 5),
	(404, 'Evliya Çelebi Hastanesi', 'Devlet', 1);


--
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.il VALUES
	(2, 'Erzurum'),
	(3, 'Adana'),
	(4, 'İstanbul'),
	(7, 'Kars'),
	(8, 'Muş'),
	(1, 'Kütahya'),
	(5, 'Sakarya');


--
-- Data for Name: ilDegisikligiIzle; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."ilDegisikligiIzle" VALUES
	(1, 1, 'Kütahya', 'Erzincan', '2021-12-20 02:15:13.054759'),
	(2, 1, 'Erzincan', 'Kütahya', '2021-12-20 03:01:23.53435');


--
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ilce VALUES
	(601, 'Emet', 1),
	(602, 'Şenkaya', 2),
	(603, 'Pozantı', 3),
	(604, 'Fatih', 4),
	(607, 'Sarıkamış', 7),
	(608, 'HASKÖY', 8),
	(605, 'SERDIVAN', 5);


--
-- Data for Name: kangrubu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kangrubu VALUES
	(1, 'A
'),
	(2, 'B'),
	(3, 'AB'),
	(4, '0');


--
-- Data for Name: lab; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lab VALUES
	(702, 'İdrar Tahlili'),
	(703, 'Tümör belirteçleri.'),
	(704, 'Enzim testleri'),
	(701, 'Kan Testi '),
	(705, 'Genel Tarama'),
	(706, 'Bilirubin Kontrolü'),
	(707, 'O2 Kontrolü');


--
-- Data for Name: muayne; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.muayne VALUES
	(803, 'Baş-Boyun Muayenesi', 1),
	(801, 'Acil Mudahale', 2),
	(804, 'Ekstremiteler', 2),
	(802, 'Karna Müdahale', 2),
	(805, 'Göğse Magüdahale', 2);


--
-- Data for Name: muaynesonuc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.muaynesonuc VALUES
	(901, 'Böbrek Tümörü', 1, 801),
	(902, 'Karında Komplikasyonlar', 2, 802),
	(903, 'Beyin Sarsıntısı', 1, 803),
	(904, 'Kalp Spazmı', 1, 804),
	(905, '4.derce yanık', 2, 803);


--
-- Data for Name: randevular; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.randevular VALUES
	(1104, 'randevualındı', 2, 402),
	(1103, 'randevu alındı', 3, 401),
	(1102, 'Randevu Alındı', 5, 401);


--
-- Data for Name: teshis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teshis VALUES
	(1202, 'Mesane Kanseri', 2),
	(1203, 'Temiz
', 2),
	(1204, 'Nöronlar Arası Bağlantı Yoksunluğu Sonucu Vücudun His Mekanizmasınd Kalıcı Hasar', 1),
	(1201, 'Böbreklerde Taş', 3),
	(1205, 'Kalp Damarlarında Daralma', 3);


--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.test VALUES
	(1305, 'asdasd', 902, 701),
	(1301, 'Kan Testi', 901, 702),
	(1302, 'Kan Testi 
', 901, 703),
	(1303, 'İdrar Testi', 902, 704),
	(1304, 'zxzvxc', 903, 705);


--
-- Data for Name: testsonuc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.testsonuc VALUES
	(1404, 'asdf', 1204, 701),
	(1401, 'Kanda Alyuvar Azalması', 1204, 702),
	(1402, 'Beyin Tümerüne Bağlı His Yoksunluğu
', 1203, 703),
	(1403, ' Mide de tümör başlangıcı
', 1203, 701);


--
-- Data for Name: toplamhasta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.toplamhasta VALUES
	(9),
	(9);


--
-- Data for Name: toplamhasta2silme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.toplamhasta2silme VALUES
	(2),
	(NULL);


--
-- Data for Name: unvan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.unvan VALUES
	(11, 'doc'),
	(12, 'prof'),
	(13, 'pratisyen'),
	(14, 'stajyer');


--
-- Name: ilDegisikligiIzle_kayitNo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ilDegisikligiIzle_kayitNo_seq"', 2, true);


--
-- Name: bolumler  Poliklinik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bolumler
    ADD CONSTRAINT " Poliklinik_pkey" PRIMARY KEY (bolumlerid);


--
-- Name: doktor_maas Doktor_Maaş_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor_maas
    ADD CONSTRAINT "Doktor_Maaş_pkey" PRIMARY KEY ("doktormaaşid");


--
-- Name: hastalık Hastalık_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."hastalık"
    ADD CONSTRAINT "Hastalık_pkey" PRIMARY KEY ("hastalıkid");


--
-- Name: hastane Hastane_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hastane
    ADD CONSTRAINT "Hastane_pkey" PRIMARY KEY (hastaneid);


--
-- Name: kangrubu Kan Grubu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kangrubu
    ADD CONSTRAINT "Kan Grubu_pkey" PRIMARY KEY (kangrubuid);


--
-- Name: ilDegisikligiIzle PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ilDegisikligiIzle"
    ADD CONSTRAINT "PK" PRIMARY KEY ("kayitNo");


--
-- Name: doktor doktor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_pkey PRIMARY KEY (doktorid);


--
-- Name: hasta hasta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT hasta_pkey PRIMARY KEY ("hastaıd");


--
-- Name: lab lab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab
    ADD CONSTRAINT lab_pkey PRIMARY KEY ("labıd");


--
-- Name: muayne muayne_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muayne
    ADD CONSTRAINT muayne_pkey PRIMARY KEY ("muayneıd");


--
-- Name: muaynesonuc muayne_sonuc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muaynesonuc
    ADD CONSTRAINT muayne_sonuc_pkey PRIMARY KEY (muaynesonucid);


--
-- Name: randevular randevular_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT randevular_pkey PRIMARY KEY ("randevularıd");


--
-- Name: teshis teshis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teshis
    ADD CONSTRAINT teshis_pkey PRIMARY KEY ("teshisıd");


--
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY ("testıd");


--
-- Name: testsonuc test_sonuc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testsonuc
    ADD CONSTRAINT test_sonuc_pkey PRIMARY KEY ("testsonuclarııd");


--
-- Name: hasta unique_hasta_tckimlikno; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT unique_hasta_tckimlikno UNIQUE (tckimlikno);


--
-- Name: muayne unique_muayne_muayneıd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muayne
    ADD CONSTRAINT "unique_muayne_muayneıd" UNIQUE ("muayneıd");


--
-- Name: randevular unique_randevular_randevularıd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT "unique_randevular_randevularıd" UNIQUE ("randevularıd");


--
-- Name: teshis unique_teshis_teshisıd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teshis
    ADD CONSTRAINT "unique_teshis_teshisıd" UNIQUE ("teshisıd");


--
-- Name: testsonuc unique_test_sonuc_testsonuclarııd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testsonuc
    ADD CONSTRAINT "unique_test_sonuc_testsonuclarııd" UNIQUE ("testsonuclarııd");


--
-- Name: test unique_test_testıd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT "unique_test_testıd" UNIQUE ("testıd");


--
-- Name: unvan unique_unvan_unvanid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unvan
    ADD CONSTRAINT unique_unvan_unvanid PRIMARY KEY (unvanid);


--
-- Name: il İl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT "İl_pkey" PRIMARY KEY (ilid);


--
-- Name: ilce İlçe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT "İlçe_pkey" PRIMARY KEY (ilceid);


--
-- Name: fki_Hastaİl_ForeignKey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Hastaİl_ForeignKey" ON public.hasta USING btree (hastail);


--
-- Name: index_ PoliklinikID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_ PoliklinikID" ON public.doktor USING btree (bolum);


--
-- Name: index_Bulunduğu İl; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Bulunduğu İl" ON public.hastane USING btree (ilid);


--
-- Name: index_Doktormaaşid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Doktormaaşid" ON public.doktor USING btree (doktormaasid);


--
-- Name: index_HastalıkID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_HastalıkID" ON public.hasta USING btree ("hastalıkid");


--
-- Name: index_HastaneID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_HastaneID" ON public.randevular USING btree (hastaneid);


--
-- Name: index_Kan Grubu ID; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Kan Grubu ID" ON public.hasta USING btree (kangrubuid);


--
-- Name: index_Kangrubuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_Kangrubuid" ON public.doktor USING btree (kangrubuid);


--
-- Name: index_hastaid1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hastaid1 ON public.muayne USING btree (hastaid);


--
-- Name: index_hastaid2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hastaid2 ON public.muaynesonuc USING btree (hastaid);


--
-- Name: index_hastaid3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hastaid3 ON public.teshis USING btree (hastaid);


--
-- Name: index_hastaneid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_hastaneid ON public.bolumler USING btree (hastaneid);


--
-- Name: index_hastaıd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_hastaıd" ON public.randevular USING btree ("hastaıd");


--
-- Name: index_ilceid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ilceid ON public.doktor USING btree (ilceid);


--
-- Name: index_ilceid1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ilceid1 ON public.hasta USING btree (ilceid);


--
-- Name: index_iletişim; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_iletişim" ON public.hasta USING btree (iletisim);


--
-- Name: index_ilid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ilid ON public.doktor USING btree (ilid);


--
-- Name: index_ilid1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ilid1 ON public.ilce USING btree (ilid);


--
-- Name: index_ilıd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_ilıd" ON public.hasta USING btree (ilid);


--
-- Name: index_labid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_labid ON public.test USING btree ("labıd");


--
-- Name: index_labıd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_labıd" ON public.testsonuc USING btree ("labıd");


--
-- Name: index_muanetipi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_muanetipi ON public.muayne USING btree (muaynetipi);


--
-- Name: index_muayneid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_muayneid ON public.muaynesonuc USING btree (muayneid);


--
-- Name: index_muaynesonucid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_muaynesonucid ON public.test USING btree (muaynesonucid);


--
-- Name: index_poliklinikid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_poliklinikid ON public."hastalık" USING btree (poliklinikid);


--
-- Name: index_randevu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_randevu ON public.randevular USING btree (randevu);


--
-- Name: index_randevuId; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "index_randevuId" ON public.hasta USING btree (randevuid);


--
-- Name: index_teshisid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_teshisid ON public.testsonuc USING btree (teshisid);


--
-- Name: index_unvan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_unvan ON public.unvan USING btree (unvan);


--
-- Name: index_unvanno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_unvanno ON public.doktor USING btree (unvanid);


--
-- Name: il ilDegistiginde; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "ilDegistiginde" BEFORE UPDATE ON public.il FOR EACH ROW EXECUTE FUNCTION public."ilDegisikligi"();


--
-- Name: ilce ilcekontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ilcekontrol BEFORE INSERT OR UPDATE ON public.ilce FOR EACH ROW EXECUTE FUNCTION public.kayitekle();


--
-- Name: hasta test2trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER test2trigger AFTER DELETE ON public.hasta FOR EACH ROW EXECUTE FUNCTION public.test2();


--
-- Name: hasta testtrigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testtrigger AFTER INSERT ON public.hasta FOR EACH ROW EXECUTE FUNCTION public.test();


--
-- Name: doktor Doktormaaşid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT "Doktormaaşid_foreignkey" FOREIGN KEY (doktormaasid) REFERENCES public.doktor_maas("doktormaaşid") NOT VALID;


--
-- Name: muaynesonuc HastaMuaynesonuc_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muaynesonuc
    ADD CONSTRAINT "HastaMuaynesonuc_foreignkey" FOREIGN KEY (hastaid) REFERENCES public.hasta("hastaıd") NOT VALID;


--
-- Name: randevular Hasta_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT "Hasta_foreignkey" FOREIGN KEY ("hastaıd") REFERENCES public.hasta("hastaıd") NOT VALID;


--
-- Name: randevular HastaneID_foreign ; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.randevular
    ADD CONSTRAINT "HastaneID_foreign " FOREIGN KEY (hastaneid) REFERENCES public.hastane(hastaneid) NOT VALID;


--
-- Name: bolumler HastaneID_foreign ; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bolumler
    ADD CONSTRAINT "HastaneID_foreign " FOREIGN KEY (hastaneid) REFERENCES public.hastane(hastaneid) NOT VALID;


--
-- Name: hasta KanGrubuID_Foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT "KanGrubuID_Foreign" FOREIGN KEY (kangrubuid) REFERENCES public.kangrubu(kangrubuid) NOT VALID;


--
-- Name: doktor KanGrubuID_Foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT "KanGrubuID_Foreign" FOREIGN KEY (kangrubuid) REFERENCES public.kangrubu(kangrubuid) NOT VALID;


--
-- Name: doktor bolumID_foreignKey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT "bolumID_foreignKey" FOREIGN KEY (bolum) REFERENCES public.bolumler(bolumlerid) NOT VALID;


--
-- Name: doktor doktor_doktoril_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktor_doktoril_fkey FOREIGN KEY (doktorid) REFERENCES public.il(ilid) NOT VALID;


--
-- Name: doktor doktoril_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktoril_foreignkey FOREIGN KEY (ilid) REFERENCES public.il(ilid) NOT VALID;


--
-- Name: doktor doktorilce_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT doktorilce_foreignkey FOREIGN KEY (ilceid) REFERENCES public.ilce(ilceid) NOT VALID;


--
-- Name: doktor doktorunvanıd_foreinkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doktor
    ADD CONSTRAINT "doktorunvanıd_foreinkey" FOREIGN KEY (unvanid) REFERENCES public.unvan(unvanid) NOT VALID;


--
-- Name: hasta hastailceid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT hastailceid_foreignkey FOREIGN KEY (ilceid) REFERENCES public.ilce(ilceid) NOT VALID;


--
-- Name: hasta hastalık_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT "hastalık_foreignkey" FOREIGN KEY ("hastalıkid") REFERENCES public."hastalık"("hastalıkid") NOT VALID;


--
-- Name: muayne hastamuayneid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muayne
    ADD CONSTRAINT hastamuayneid_foreignkey FOREIGN KEY (hastaid) REFERENCES public.hasta("hastaıd") NOT VALID;


--
-- Name: teshis hastateshisid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teshis
    ADD CONSTRAINT hastateshisid_foreignkey FOREIGN KEY (hastaid) REFERENCES public.hasta("hastaıd") NOT VALID;


--
-- Name: hasta iLID_Foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hasta
    ADD CONSTRAINT "iLID_Foreign" FOREIGN KEY (ilid) REFERENCES public.il(ilid) NOT VALID;


--
-- Name: ilce ilid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilid_foreignkey FOREIGN KEY (ilid) REFERENCES public.il(ilid) NOT VALID;


--
-- Name: muaynesonuc muayid_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muaynesonuc
    ADD CONSTRAINT muayid_foreignkey FOREIGN KEY (muayneid) REFERENCES public.muayne("muayneıd") NOT VALID;


--
-- Name: hastalık poliklinikıd_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."hastalık"
    ADD CONSTRAINT "poliklinikıd_foreignkey" FOREIGN KEY (poliklinikid) REFERENCES public.bolumler(bolumlerid) NOT VALID;


--
-- Name: testsonuc teshistestsonuc_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testsonuc
    ADD CONSTRAINT teshistestsonuc_foreignkey FOREIGN KEY (teshisid) REFERENCES public.teshis("teshisıd") NOT VALID;


--
-- Name: test test_muaynesonucid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_muaynesonucid_fkey FOREIGN KEY (muaynesonucid) REFERENCES public.muaynesonuc(muaynesonucid) NOT VALID;


--
-- Name: test testlab_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT testlab_foreignkey FOREIGN KEY ("labıd") REFERENCES public.lab("labıd") NOT VALID;


--
-- Name: testsonuc testsonuclab_foreignkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testsonuc
    ADD CONSTRAINT testsonuclab_foreignkey FOREIGN KEY ("labıd") REFERENCES public.lab("labıd") NOT VALID;


--
-- PostgreSQL database dump complete
--

