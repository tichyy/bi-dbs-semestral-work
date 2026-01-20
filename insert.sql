-- smazání všech záznamů z tabulek

CREATE OR REPLACE FUNCTION clean_tables() RETURNS void AS
$$
DECLARE
    l_stmt text;
BEGIN
    SELECT 'truncate ' || STRING_AGG(FORMAT('%I.%I', schemaname, tablename), ',')
    INTO l_stmt
    FROM pg_tables
    WHERE schemaname IN ('public');

    EXECUTE l_stmt || ' cascade';
END;
$$ LANGUAGE plpgsql;
SELECT clean_tables();

-- reset sekvenci

CREATE OR REPLACE FUNCTION restart_sequences() RETURNS void AS
$$
DECLARE
    i TEXT;
BEGIN
    FOR i IN (SELECT column_default FROM information_schema.columns WHERE column_default SIMILAR TO 'nextval%')
        LOOP
            EXECUTE 'ALTER SEQUENCE' || ' ' || SUBSTRING(SUBSTRING(i FROM '''[a-z_]*') FROM '[a-z_]+') || ' ' ||
                    ' RESTART 1;';
        END LOOP;
END
$$ LANGUAGE plpgsql;
SELECT restart_sequences();
-- konec resetu

-- konec mazání

INSERT INTO uzivatelsky_ucet (id_uzivatel, jmeno, prijmeni, telefonni_cislo, datum_narozeni)
VALUES (1, 'Michaela', 'Sedlak', '+420602456789', '1946-08-06'),
       (2, 'Honza', 'Jelinek', '+420777123321', '2001-07-15'),
       (3, 'Eva', 'Prochazka', '+420703456789', '1954-12-16'),
       (4, 'Petra', 'Simek', '+420605789456', '1988-06-25'),
       (5, 'Eva', 'Vesely', '+420777654321', '1967-01-09'),
       (6, 'Gabriela', 'Simek', '+420605789456', '1995-06-20'),
       (7, 'Petra', 'Sedlak', '+420602998877', '1956-08-13'),
       (8, 'Michaela', 'Vesely', '+420605123987', '1989-02-12'),
       (9, 'Gabriela', 'Dostal', '+420605123987', '2005-05-09'),
       (10, 'Lenka', 'Dostal', '+420776123789', '1963-08-05'),
       (11, 'Lenka', 'Fiala', '+420731987654', '1980-05-13'),
       (12, 'Tomáš', 'Zelenka', '+420728112233', '1993-02-09'),
       (13, 'Petra', 'Horak', '+420602345678', '1994-01-05'),
       (14, 'Honza', 'Kucera', '+420602456789', '1947-06-19'),
       (15, 'Filip', 'Bartos', '+420728112233', '1975-04-18'),
       (16, 'Ondřej', 'Zelenka', '+420605987321', '2005-06-02'),
       (17, 'Radek', 'Kral', '+420776987123', '1963-11-29'),
       (18, 'Veronika', 'Cerny', '+420728115566', '1965-08-10'),
       (19, 'Dagmar', 'Sedlak', '+420776789123', '1995-08-09'),
       (20, 'Filip', 'Kucera', '+420703654321', '1982-11-07'),
       (21, 'Zuzana', 'Pokorny', '+420731234567', '1948-03-18'),
       (22, 'Klára', 'Jancarik', '+420776987123', '1995-09-20'),
       (23, 'Petr', 'Suchy', '+420728115566', '1991-06-01'),
       (24, 'Pavel', 'Bilek', '+420703987123', '1986-11-07'),
       (25, 'Marek', 'Marek', '+420777789654', '1999-03-28'),
       (26, 'Jarmilka', 'Sediva', '123123123', '1925-01-01'),
       (27, 'Zdeněk', 'Zavadil', '607001123', '1960-02-02'),
       (28, 'Jakub', 'Nezverejnil', '607101123', '1961-02-02'),
       (29, 'Jiri', 'Oblibeny', '400213112', '1950-01-01');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('uzivatelsky_ucet', 'id_uzivatel'), 29);


INSERT INTO prodejce (id_uzivatel)
VALUES (12),
       (9),
       (15),
       (23),
       (7),
       (13),
       (24),
       (3),
       (22),
       (10),
       (26),
       (27),
       (28);

INSERT INTO kupujici (id_uzivatel)
VALUES (10),
       (14),
       (24),
       (6),
       (7),
       (3),
       (12),
       (23),
       (17),
       (20),
       (21),
       (15),
       (11),
       (22),
       (13),
       (29);

INSERT INTO kategorie (id_kategorie, nazev)
VALUES (1, 'Dámské'),
       (2, 'Pánské'),
       (3, 'Unisex'),
       (6, 'Dětské');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('kategorie', 'id_kategorie'), 6);


INSERT INTO typ_obleceni (id_typ_obleceni, nazev)
VALUES (1, 'Tričko'),
       (2, 'Sukně'),
       (4, 'Bunda'),
       (6, 'Spodní prádlo'),
       (11, 'Sako'),
       (12, 'Kraťasy'),
       (13, 'Košile'),
       (14, 'Kalhoty'),
       (16, 'Mikina'),
       (19, 'Šaty'),
       (21, 'Obuv'),
       (23, 'Kabát'),
       (25, 'Ponožky'),
       (39, 'Plavky'),
       (40, 'Svetry');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('typ_obleceni', 'id_typ_obleceni'), 40);



INSERT INTO inzerat (id_inzerat, id_uzivatel, cena, datum_vystaveni, nazev, popis)
VALUES (1, 3, 103.90, '2025-03-30', 'Módní bunda', NULL),
       (2, 24, 508.90, '2025-02-16', 'Pohodlné džíny', 'Pohodlné džíny pro volný čas, ideální na každodenní nošení.'),
       (3, 10, 1102.90, '2024-09-27', 'Stylová čepice', NULL),
       (4, 15, 157.90, '2024-09-02', 'Módní kalhoty', 'Módní kalhoty s moderním střihem, které zaručují pohodlí.'),
       (5, 12, 670.90, '2024-08-09', 'Zimní rukavice černé', 'Zimní rukavice, které vás ochrání před mrazem.'),
       (6, 9, 157.90, '2024-08-13', 'Elegantní košile', 'Elegantní košile pro formální i neformální příležitosti.'),
       (7, 7, 859.90, '2025-02-14', 'Luxusní šaty', 'Luxusní šaty vhodné pro formální příležitosti.'),
       (8, 23, 1048.90, '2024-10-27', 'Pohodlná mikina', 'Mikina s měkkým materiálem a moderním designem.'),
       (9, 22, 238.90, '2024-09-06', 'Luxusní šaty', 'Luxusní šaty vhodné pro speciální příležitosti.'),
       (10, 13, 130.90, '2024-09-25', 'Jedinečný svetr', 'Svetr s jedinečným designem, ideální na chladné večery.'),
       (11, 12, 1102.90, '2024-08-06', 'Sportovní bunda', 'Bunda vhodná pro sportovní aktivity, odolná a pohodlná.'),
       (12, 10, 292.90, '2025-02-17', 'Pohodlné džíny', 'Pohodlné džíny s moderním střihem, vhodné na každý den.'),
       (13, 15, 589.90, '2024-10-14', 'Módní kalhoty', 'Módní kalhoty pro každý den, které zaručují pohodlí a styl.'),
       (14, 13, 994.90, '2025-04-17', 'Zimní rukavice', NULL),
       (15, 7, 589.90, '2024-04-23', 'Vysoce odolné tenisky',
        'Vysoce odolné tenisky, které vydrží i náročné podmínky.'),
       (16, 24, 535.90, '2025-04-06', 'Volné tričko', 'Volné tričko pro pohodlné nošení během teplých dnů.'),
       (17, 23, 697.90, '2024-11-29', 'Stylová čepice', NULL),
       (18, 9, 886.90, '2024-06-16', 'Pevné džíny', 'Pevné džíny, které vám poskytnou komfort po celý den.'),
       (19, 22, 994.90, '2025-01-12', 'Dámské legíny černé', 'Dámské černé legíny pro pohodlné nošení.'),
       (20, 3, 373.90, '2025-03-04', 'Módní plavky', 'Módní plavky pro letní dny, které zaručují pohodlí.'),
       (21, 23, 238.90, '2025-02-23', 'Robustní boty', 'Robustní boty, které zvládnou i náročné terény.'),
       (22, 10, 211.90, '2025-02-16', 'Stylová čepice', NULL),
       (23, 13, 184.90, '2024-08-12', 'Pevné džíny', 'Džíny, které se hodí do každé situace, pohodlné a odolné.'),
       (24, 24, 589.90, '2024-04-29', 'Trendy mikina', 'Trendy mikina s moderním střihem, ideální na volný čas.'),
       (25, 15, 724.90, '2024-12-18', 'Pánské kožené boty hnědé', 'Pánské kožené boty, které vydrží mnoho let.'),
       (26, 3, 670.90, '2024-07-27', 'Lehký svetr', 'Lehký svetr pro chladnější dny, ideální na vrstvení.'),
       (27, 9, 562.90, '2025-01-11', 'Volné tričko', 'Volné tričko s pohodlným střihem a moderním designem.'),
       (28, 22, 832.90, '2024-11-07', 'Pánské košile s krátkým rukávem',
        'Pánské košile s krátkým rukávem pro teplé dny.'),
       (29, 7, 724.90, '2025-01-31', 'Pohodlná mikina', 'Pohodlná mikina pro volný čas a chladné dny.'),
       (30, 12, 1021.90, '2025-01-17', 'Jedinečný svetr', 'Černý svetr, který je ideální pro chladné dny.'),
       (31, 3, 589.90, '2024-05-12', 'Dámská sukně s květinovým vzorem',
        'Dámská sukně s krásným květinovým vzorem, ideální na léto.'),
       (32, 9, 1129.90, '2024-05-28', 'Pohodlné kalhoty',
        'Pohodlné kalhoty pro každodenní nošení, skvělé pro volný čas.'),
       (33, 22, 427.90, '2024-11-12', 'Elegantní košile', NULL),
       (34, 7, 481.90, '2024-12-05', 'Stylová bunda', 'Stylová bunda, která vás ochrání před větrem a deštěm.'),
       (35, 12, 778.90, '2024-11-03', 'Stylové tenisky', NULL),
       (36, 23, 616.90, '2024-05-31', 'Sportovní šortky', 'Sportovní šortky pro aktivní dny a volný čas.'),
       (37, 10, 319.90, '2024-12-03', 'Zimní rukavice', 'Teplé rukavice, které vás ochrání před zimou.'),
       (38, 13, 859.90, '2024-10-13', 'Letní klobouk', 'Letní klobouk na slunce, který vás ochrání před horkem.'),
       (39, 24, 670.90, '2024-11-09', 'Dámské tričko modré', 'Dámské tričko v modré barvě pro každodenní nošení.'),
       (40, 15, 346.90, '2024-07-31', 'Pánské kožené boty hnědé',
        'Kvalitní pánské kožené boty v hnědé barvě, ideální pro každodenní nošení.'),
       (41, 26, 990.00, '2025-04-20', 'Stara pracka', 'stara, ale jeste poslouzi'),
       (42, 27, 100.00, '2025-04-21', 'Panska kosile', 'pekna, bila');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('inzerat', 'id_inzerat'), 42);



INSERT INTO kus_obleceni (id_inzerat, id_kategorie, id_typ_obleceni, velikost, kondice)
VALUES (1, 2, 4, 'XL', 1),
       (2, 2, 14, '40', 6),
       (3, 3, 11, 'M', 7),
       (4, 2, 14, 'L', 6),
       (5, 3, 25, 'XS', 5),
       (6, 1, 13, 'XL', 1),
       (7, 1, 19, '40', 5),
       (8, 1, 16, 'S', 5),
       (9, 1, 19, 'L', 1),
       (10, 3, 40, 'S', 7),
       (11, 2, 4, '40', 4),
       (12, 2, 14, 'XL', 7),
       (13, 2, 14, '40', 9),
       (14, 3, 25, 'M', 3),
       (15, 2, 21, 'XL', 5),
       (16, 1, 1, 'XS', 9),
       (17, 3, 11, 'M', 7),
       (18, 2, 14, 'XXL', 5),
       (19, 1, 14, 'L', 5),
       (20, 1, 39, 'XL', 5),
       (21, 2, 21, 'S', 6),
       (22, 3, 11, 'L', 1),
       (23, 2, 14, 'M', 9),
       (24, 1, 16, 'L', 7),
       (25, 2, 21, 'S', 7),
       (26, 3, 40, 'XL', 4),
       (27, 1, 1, 'L', 9),
       (28, 2, 13, 'S', 1),
       (29, 1, 16, 'S', 7),
       (30, 3, 40, 'XL', 1),
       (31, 1, 2, 'XL', 1),
       (32, 2, 14, 'XS', 10),
       (33, 1, 13, 'XL', 5),
       (34, 2, 4, 'XL', 5),
       (35, 2, 21, 'M', 3),
       (36, 2, 12, 'XL', 7),
       (37, 3, 25, 'M', 7),
       (38, 3, 25, 'XL', 4),
       (39, 1, 1, '40', 3),
       (40, 2, 21, '38', 5),
       (42, 2, 13, 'L', 8);


INSERT INTO oblibene (id_uzivatel, id_inzerat, poznamka)
VALUES (3, 20, NULL),
       (10, 34, NULL),
       (11, 24, NULL),
       (12, 3, NULL),
       (13, 38, 'Mozna koupim'),
       (14, 37, 'Na pozdeji'),
       (17, 10, 'Libi se mi'),
       (20, 26, NULL),
       (23, 23, 'Pro rodinu'),
       (24, 18, 'wowowowow'),
       (29, 1, NULL),
       (29, 2, NULL),
       (29, 3, NULL),
       (29, 4, NULL),
       (29, 5, NULL),
       (29, 6, NULL),
       (29, 7, NULL),
       (29, 8, NULL),
       (29, 9, NULL),
       (29, 10, NULL),
       (29, 11, NULL),
       (29, 12, NULL),
       (29, 13, NULL),
       (29, 14, NULL),
       (29, 15, NULL),
       (29, 16, NULL),
       (29, 17, NULL),
       (29, 18, NULL),
       (29, 19, NULL),
       (29, 20, NULL),
       (29, 21, NULL),
       (29, 22, NULL),
       (29, 23, NULL),
       (29, 24, NULL),
       (29, 25, NULL),
       (29, 26, NULL),
       (29, 27, NULL),
       (29, 28, NULL),
       (29, 29, NULL),
       (29, 30, NULL),
       (29, 31, NULL),
       (29, 32, NULL),
       (29, 33, NULL),
       (29, 34, NULL),
       (29, 35, NULL),
       (29, 36, NULL),
       (29, 37, NULL),
       (29, 38, NULL),
       (29, 39, NULL),
       (29, 40, NULL),
       (29, 41, NULL),
       (29, 42, NULL);

INSERT INTO rezervace (id_rezervace, id_uzivatel, id_inzerat, datum_od, datum_do)
VALUES (1, 23, 3, '2024-06-04', '2024-06-04'),
       (2, 3, 19, '2024-06-22', '2024-06-30'),
       (3, 11, 22, '2024-07-30', '2025-02-15'),
       (4, 22, 31, '2024-05-04', NULL),
       (5, 6, 35, '2024-08-15', '2025-01-06'),
       (6, 21, 8, '2024-04-29', NULL),
       (7, 10, 32, '2024-07-13', '2025-03-14'),
       (8, 12, 13, '2024-07-31', '2024-11-02'),
       (9, 17, 16, '2024-06-23', NULL),
       (10, 7, 1, '2025-02-20', '2025-03-02'),
       (11, 24, 30, '2024-09-12', '2024-11-07'),
       (12, 15, 21, '2024-06-15', NULL),
       (13, 20, 18, '2024-11-14', '2025-02-06'),
       (14, 14, 11, '2024-05-20', '2025-02-17'),
       (15, 13, 6, '2024-05-15', '2024-12-13'),
       (16, 14, 9, '2024-05-18', NULL),
       (17, 23, 34, '2024-06-19', NULL),
       (18, 7, 33, '2025-01-24', '2025-03-06'),
       (19, 6, 25, '2024-09-08', NULL),
       (20, 15, 17, '2025-01-19', NULL);
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('rezervace', 'id_rezervace'), 20);


INSERT INTO stav (id_stav, nazev)
VALUES (1, 'Probíhá'),
       (3, 'Dokončena'),
       (4, 'Zrušena');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('stav', 'id_stav'), 4);


INSERT INTO stav_rezervace (id_stav, id_rezervace, popis)
VALUES (1, 1, 'Mam zajem'),
       (1, 2, NULL),
       (1, 3, NULL),
       (1, 4, NULL),
       (1, 5, 'Rezervace zahájena.'),
       (1, 6, 'Rezervace byla zahájena.'),
       (1, 7, NULL),
       (1, 8, NULL),
       (1, 9, 'Rezervace zahájena.'),
       (1, 10, NULL),
       (1, 11, 'Rezervace zahájena.'),
       (1, 12, NULL),
       (1, 13, NULL),
       (1, 14, 'Rezervace zahájena.'),
       (1, 15, NULL),
       (1, 16, 'Kupujici nabizi nizsi cenu.'),
       (1, 17, 'Rezervace zahájena.'),
       (1, 18, 'Chci se domluvit'),
       (1, 19, NULL),
       (1, 20, 'Rezervace zahájena.');

-- Ukončení rezervací
INSERT INTO stav_rezervace (id_stav, id_rezervace, popis)
VALUES (3, 1, 'Rezervace úspěšně dokončena.'),
       (4, 2, 'Rezervace byla zrušena zákazníkem.'),
       (3, 3, 'Zboží bylo předáno a rezervace uzavřena.'),
       (3, 5, 'Transakce dokončena.'),
       (4, 7, 'Zákazník rezervaci zrušil.'),
       (3, 8, 'Zákazník převzal zboží.'),
       (4, 10, 'Rezervace zamítnuta prodávajícím.'),
       (3, 11, 'Rezervace skončila předáním zboží.'),
       (3, 13, 'Zboží bylo úspěšně prodáno.'),
       (4, 14, 'Rezervace byla zrušena ze strany prodejce.'),
       (3, 15, 'Zákazník si zboží vyzvedl.'),
       (3, 18, 'Zákazník spokojeně převzal zboží.');


INSERT INTO topovani (id_topovani, id_uzivatel, id_inzerat, datum_od, datum_do)
VALUES (1, 12, 1, '2024-06-17', '2025-03-14'),
       (2, 24, 2, '2024-05-12', '2025-02-12'),
       (3, 7, 34, '2024-04-26', '2024-05-16'),
       (4, 7, 15, '2024-09-28', '2024-12-18'),
       (5, 7, 30, '2024-10-27', '2024-12-03'),
       (6, 23, 36, '2024-08-19', '2024-11-29'),
       (7, 15, 4, '2024-07-14', '2025-03-19'),
       (8, 23, 17, '2024-10-09', '2024-10-23'),
       (9, 9, 18, '2024-07-17', '2024-09-03'),
       (10, 9, 9, '2024-09-24', '2024-11-20'),
       (11, 26, 41, '2025-04-20', '2025-04-27');
SELECT SETVAL(PG_GET_SERIAL_SEQUENCE('topovani', 'id_topovani'), 11);
