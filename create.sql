-- Remove conflicting tables
DROP TABLE IF EXISTS inzerat CASCADE;
DROP TABLE IF EXISTS kategorie CASCADE;
DROP TABLE IF EXISTS kupujici CASCADE;
DROP TABLE IF EXISTS kus_obleceni CASCADE;
DROP TABLE IF EXISTS oblibene CASCADE;
DROP TABLE IF EXISTS prodejce CASCADE;
DROP TABLE IF EXISTS rezervace CASCADE;
DROP TABLE IF EXISTS stav CASCADE;
DROP TABLE IF EXISTS stav_rezervace CASCADE;
DROP TABLE IF EXISTS topovani CASCADE;
DROP TABLE IF EXISTS typ_obleceni CASCADE;
DROP TABLE IF EXISTS uzivatelsky_ucet CASCADE;
-- End of removing

CREATE TABLE inzerat (
    id_inzerat SERIAL NOT NULL,
    id_uzivatel INTEGER NOT NULL,
    cena DOUBLE PRECISION NOT NULL,
    datum_vystaveni DATE NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    popis VARCHAR(256)
);
ALTER TABLE inzerat ADD CONSTRAINT pk_inzerat PRIMARY KEY (id_inzerat);

CREATE TABLE kategorie (
    id_kategorie SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE kategorie ADD CONSTRAINT pk_kategorie PRIMARY KEY (id_kategorie);
ALTER TABLE kategorie ADD CONSTRAINT uc_kategorie_nazev UNIQUE (nazev);

CREATE TABLE kupujici (
    id_uzivatel INTEGER NOT NULL
);
ALTER TABLE kupujici ADD CONSTRAINT pk_kupujici PRIMARY KEY (id_uzivatel);

CREATE TABLE kus_obleceni (
    id_inzerat INTEGER NOT NULL,
    id_kategorie INTEGER NOT NULL,
    id_typ_obleceni INTEGER NOT NULL,
    velikost VARCHAR(256) NOT NULL,
    kondice INTEGER NOT NULL
);
ALTER TABLE kus_obleceni ADD CONSTRAINT pk_kus_obleceni PRIMARY KEY (id_inzerat);

CREATE TABLE oblibene (
    id_uzivatel INTEGER NOT NULL,
    id_inzerat INTEGER NOT NULL,
    poznamka VARCHAR(256)
);
ALTER TABLE oblibene ADD CONSTRAINT pk_oblibene PRIMARY KEY (id_uzivatel, id_inzerat);

CREATE TABLE prodejce (
    id_uzivatel INTEGER NOT NULL
);
ALTER TABLE prodejce ADD CONSTRAINT pk_prodejce PRIMARY KEY (id_uzivatel);

CREATE TABLE rezervace (
    id_rezervace SERIAL NOT NULL,
    id_uzivatel INTEGER NOT NULL,
    id_inzerat INTEGER NOT NULL,
    datum_od DATE NOT NULL,
    datum_do DATE
);
ALTER TABLE rezervace ADD CONSTRAINT pk_rezervace PRIMARY KEY (id_rezervace);

CREATE TABLE stav (
    id_stav SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE stav ADD CONSTRAINT pk_stav PRIMARY KEY (id_stav);
ALTER TABLE stav ADD CONSTRAINT uc_stav_nazev UNIQUE (nazev);

CREATE TABLE stav_rezervace (
    id_stav INTEGER NOT NULL,
    id_rezervace INTEGER NOT NULL,
    popis VARCHAR(256)
);
ALTER TABLE stav_rezervace ADD CONSTRAINT pk_stav_rezervace PRIMARY KEY (id_stav, id_rezervace);

CREATE TABLE topovani (
    id_topovani SERIAL NOT NULL,
    id_uzivatel INTEGER NOT NULL,
    id_inzerat INTEGER NOT NULL,
    datum_od DATE NOT NULL,
    datum_do DATE NOT NULL
);
ALTER TABLE topovani ADD CONSTRAINT pk_topovani PRIMARY KEY (id_topovani);

CREATE TABLE typ_obleceni (
    id_typ_obleceni SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE typ_obleceni ADD CONSTRAINT pk_typ_obleceni PRIMARY KEY (id_typ_obleceni);
ALTER TABLE typ_obleceni ADD CONSTRAINT uc_typ_obleceni_nazev UNIQUE (nazev);

CREATE TABLE uzivatelsky_ucet (
    id_uzivatel SERIAL NOT NULL,
    jmeno VARCHAR(256) NOT NULL,
    prijmeni VARCHAR(256) NOT NULL,
    telefonni_cislo VARCHAR(256) NOT NULL,
    datum_narozeni DATE NOT NULL
);
ALTER TABLE uzivatelsky_ucet ADD CONSTRAINT pk_uzivatelsky_ucet PRIMARY KEY (id_uzivatel);

ALTER TABLE inzerat ADD CONSTRAINT fk_inzerat_prodejce FOREIGN KEY (id_uzivatel) REFERENCES prodejce (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE kupujici ADD CONSTRAINT fk_kupujici_uzivatelsky_ucet FOREIGN KEY (id_uzivatel) REFERENCES uzivatelsky_ucet (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE kus_obleceni ADD CONSTRAINT fk_kus_obleceni_inzerat FOREIGN KEY (id_inzerat) REFERENCES inzerat (id_inzerat) ON DELETE CASCADE;
ALTER TABLE kus_obleceni ADD CONSTRAINT fk_kus_obleceni_kategorie FOREIGN KEY (id_kategorie) REFERENCES kategorie (id_kategorie) ON DELETE CASCADE;
ALTER TABLE kus_obleceni ADD CONSTRAINT fk_kus_obleceni_typ_obleceni FOREIGN KEY (id_typ_obleceni) REFERENCES typ_obleceni (id_typ_obleceni) ON DELETE CASCADE;

ALTER TABLE oblibene ADD CONSTRAINT fk_oblibene_kupujici FOREIGN KEY (id_uzivatel) REFERENCES kupujici (id_uzivatel) ON DELETE CASCADE;
ALTER TABLE oblibene ADD CONSTRAINT fk_oblibene_inzerat FOREIGN KEY (id_inzerat) REFERENCES inzerat (id_inzerat) ON DELETE CASCADE;

ALTER TABLE prodejce ADD CONSTRAINT fk_prodejce_uzivatelsky_ucet FOREIGN KEY (id_uzivatel) REFERENCES uzivatelsky_ucet (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE rezervace ADD CONSTRAINT fk_rezervace_kupujici FOREIGN KEY (id_uzivatel) REFERENCES kupujici (id_uzivatel) ON DELETE CASCADE;
ALTER TABLE rezervace ADD CONSTRAINT fk_rezervace_inzerat FOREIGN KEY (id_inzerat) REFERENCES inzerat (id_inzerat) ON DELETE CASCADE;

ALTER TABLE stav_rezervace ADD CONSTRAINT fk_stav_rezervace_stav FOREIGN KEY (id_stav) REFERENCES stav (id_stav) ON DELETE CASCADE;
ALTER TABLE stav_rezervace ADD CONSTRAINT fk_stav_rezervace_rezervace FOREIGN KEY (id_rezervace) REFERENCES rezervace (id_rezervace) ON DELETE CASCADE;

ALTER TABLE topovani ADD CONSTRAINT fk_topovani_prodejce FOREIGN KEY (id_uzivatel) REFERENCES prodejce (id_uzivatel) ON DELETE CASCADE;
ALTER TABLE topovani ADD CONSTRAINT fk_topovani_inzerat FOREIGN KEY (id_inzerat) REFERENCES inzerat (id_inzerat) ON DELETE CASCADE;


-- IO5: Cena jednoho inzeratu musi byt v rozmezi 0 - 1 000 000 Kč.
ALTER TABLE inzerat ADD CONSTRAINT check_io5_cena CHECK (cena BETWEEN 0 AND 1000000);

-- IO6: Hodnoty akceptovatelne v kondici obleceni jsou 1 az 10.
ALTER TABLE kus_obleceni ADD CONSTRAINT check_io6_kondice CHECK (kondice BETWEEN 1 AND 10);

-- IO7: datum_od musi byt pred datum_do ve vsech tabulkach.
ALTER TABLE rezervace ADD CONSTRAINT check_io7_1 CHECK (datum_do IS NULL OR datum_od <= datum_do);
ALTER TABLE topovani ADD CONSTRAINT check_io7_2 CHECK (datum_od <= datum_do);
