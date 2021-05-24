-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Creato il: Mag 24, 2021 alle 13:09
-- Versione del server: 10.4.17-MariaDB
-- Versione PHP: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `CentroFitness`
--
CREATE DATABASE IF NOT EXISTS `CentroFitness3` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `CentroFitness3`;

DELIMITER $$
--
-- Procedure
--
DROP PROCEDURE IF EXISTS `OP1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP1` (OUT `id` INTEGER, OUT `specializzazione` VARCHAR(255), OUT `numero_corsi` INTEGER)  BEGIN
SELECT I.ID_impiegato, I.Specializzazione , count(I.ID_impiegato) as numero_insegnamenti INTO id, specializzazione, numero_corsi
FROM ISTRUTTORE I JOIN INSEGNAMENTO A on A.Istruttore=I.ID_impiegato
GROUP BY I.ID_impiegato
HAVING numero_insegnamenti >= ALL (	SELECT count(I.ID_impiegato) 
							FROM ISTRUTTORE I JOIN INSEGNAMENTO A on A.Istruttore=I.ID_impiegato
							GROUP BY I.ID_impiegato)
LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `OP1_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP1_2` (IN `ID` INTEGER, OUT `id1_2` INTEGER, OUT `specializzazione1_2` VARCHAR(255), OUT `numero_corsi1_2` INTEGER)  BEGIN
IF EXISTS (SELECT * FROM SEGRETARIO WHERE ID_impiegato = ID)
then 

SELECT I.ID_impiegato, I.Specializzazione , count(I.ID_impiegato) as numero_insegnamenti INTO id1_2, specializzazione1_2, numero_corsi1_2
FROM ISTRUTTORE I JOIN INSEGNAMENTO A on A.Istruttore=I.ID_impiegato
GROUP BY I.ID_impiegato
HAVING numero_insegnamenti >= ALL (	SELECT count(I.ID_impiegato) 
							FROM ISTRUTTORE I JOIN INSEGNAMENTO A on A.Istruttore=I.ID_impiegato
							GROUP BY I.ID_impiegato)
LIMIT 1;

END IF;
END$$

DROP PROCEDURE IF EXISTS `OP2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP2` (IN `sede` INTEGER)  BEGIN
drop temporary table if exists  tmp1;
create temporary table tmp1 (
	id_impiegato integer,
    id_sede integer,
    nome varchar(255),
    cognome varchar(255),
	codice_fiscale varchar(255)
);
INSERT INTO tmp1
SELECT Im1.ID_impiegato, S.ID_sede, Im1.nome, Im1.cognome, Im1.C_F
FROM ImpiegoImpiegato Im1 JOIN SEDE S on Im1.Sede=S.ID_sede
WHERE exists(SELECT * FROM ImpiegoImpiegato Im2 WHERE Im1.Nome=Im2.Nome and Im1.ID_impiegato<>Im2.ID_impiegato) and S.ID_sede=sede ;
END$$

DROP PROCEDURE IF EXISTS `OP2_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP2_2` (IN `ID_ingresso3` INTEGER, IN `sede_ingresso` INTEGER)  BEGIN 
IF EXISTS (SELECT * FROM SEGRETARIO WHERE ID_impiegato = ID_ingresso3)
THEN
CALL OP2(sede_ingresso);
END IF ; 
SELECT * from tmp1;
END$$

DROP PROCEDURE IF EXISTS `OP3`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP3` (IN `ID` INTEGER, IN `Nome` VARCHAR(255), IN `Prezzo` FLOAT, IN `IscrittiMax` INTEGER, IN `età` VARCHAR(255), IN `istruttore` INTEGER)  BEGIN
INSERT INTO CORSO (ID_corso,Nome_corso,Prezzo,Max_iscritti,Fascia_eta) VALUE (ID,Nome,Prezzo,IscrittiMax,età);
INSERT INTO INSEGNAMENTO(Sede,Corso,Istruttore) 
	VALUE (
		(CASE 
			WHEN iscrittiMax <= 20 THEN 
				(SELECT ID_sede
				 FROM SEDE 
				 WHERE Citta = "Roma")
			ELSE 
				(SELECT ID_sede FROM SEDE WHERE Citta= "Milano")
			END),
			(SELECT ID_corso FROM CORSO WHERE ID_corso=ID),
            istruttore);
			
END$$

DROP PROCEDURE IF EXISTS `OP3_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP3_2` (IN `id_ingresso3_2` INTEGER, IN `ID3_2` INTEGER, IN `Nome3_2` VARCHAR(255), IN `Prezzo3_2` FLOAT, IN `IscrittiMax3_2` INTEGER, IN `eta3_2` VARCHAR(255), IN `istruttore3_2` INTEGER)  BEGIN 
IF EXISTS (SELECT * FROM SEGRETARIO WHERE ID_impiegato = id_ingresso3_2)
THEN
CALL OP3(ID3_2,Nome3_2,Prezzo3_2,IscrittiMax3_2,eta3_2,istruttore3_2);
END IF; 
END$$

DROP PROCEDURE IF EXISTS `OP4`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP4` (OUT `ID` INTEGER, OUT `NomeIscritto` VARCHAR(255), OUT `CognomeIscritto` VARCHAR(255), OUT `ncorsi` INTEGER)  BEGIN
SELECT ID_iscritto, Nome, Cognome , count(*) as n_corsi into ID, NomeIscritto ,CognomeIscritto,ncorsi
FROM IscrittoCorso 
WHERE età < 18
GROUP BY ID_iscritto, Nome, Cognome
HAVING n_corsi >=ALL (SELECT  count(*) 
					  FROM IscrittoCorso
					  WHERE età < 18
					  GROUP BY ID_iscritto)
LIMIT 1; 
END$$

DROP PROCEDURE IF EXISTS `OP4_2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `OP4_2` (IN `ID` INTEGER, OUT `ID4_2` INTEGER, OUT `NomeIscritto4_2` VARCHAR(255), OUT `CognomeIscritto4_2` VARCHAR(255), OUT `ncorsi4_2` INTEGER)  BEGIN
IF EXISTS (SELECT * FROM SEGRETARIO UNION SELECT * FROM ISTRUTTORE  WHERE ID_impiegato = ID)
THEN
SELECT ID_iscritto, Nome, Cognome , count(*) as n_corsi into ID4_2, NomeIscritto4_2 ,CognomeIscritto4_2,ncorsi4_2
FROM IscrittoCorso 
WHERE età < 18
GROUP BY ID_iscritto, Nome, Cognome
HAVING n_corsi >=ALL (SELECT  count(*) 
					  FROM IscrittoCorso
					  WHERE età < 18
					  GROUP BY ID_iscritto)
LIMIT 1; 
END IF ;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `ABBONAMENTO`
--

DROP TABLE IF EXISTS `ABBONAMENTO`;
CREATE TABLE `ABBONAMENTO` (
  `Corso` int(11) NOT NULL,
  `Iscritto` int(11) NOT NULL,
  `Data_inizio` date DEFAULT NULL,
  `Data_fine` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `ABBONAMENTO`:
--   `Corso`
--       `CORSO` -> `ID_corso`
--   `Iscritto`
--       `ISCRITTO` -> `ID_iscritto`
--

--
-- Dump dei dati per la tabella `ABBONAMENTO`
--

INSERT INTO `ABBONAMENTO` (`Corso`, `Iscritto`, `Data_inizio`, `Data_fine`) VALUES
(1, 5, '2020-11-11', '2021-05-11'),
(1, 7, '2020-01-01', '2021-06-01'),
(2, 2, '2020-10-12', '2021-04-12'),
(3, 3, '2019-12-30', '2020-12-30'),
(3, 4, '2020-12-12', '2020-03-12'),
(4, 1, '2020-10-11', '2021-01-11'),
(4, 2, '2020-04-01', '2021-04-01'),
(5, 5, '2020-09-01', '2021-09-01'),
(5, 6, '2020-07-16', '2021-07-16'),
(5, 8, '2020-01-01', '2021-06-01'),
(5, 9, '2020-01-01', '2021-06-01'),
(6, 2, '2020-05-09', '2021-05-09'),
(8, 1, '2020-01-01', '2021-01-01');

-- --------------------------------------------------------

--
-- Struttura della tabella `ADETTO_PULIZIE`
--

DROP TABLE IF EXISTS `ADETTO_PULIZIE`;
CREATE TABLE `ADETTO_PULIZIE` (
  `ID_impiegato` int(11) NOT NULL,
  `Reparto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `ADETTO_PULIZIE`:
--   `ID_impiegato`
--       `IMPIEGATO` -> `ID_impiegato`
--

--
-- Dump dei dati per la tabella `ADETTO_PULIZIE`
--

INSERT INTO `ADETTO_PULIZIE` (`ID_impiegato`, `Reparto`) VALUES
(9, 'Sala1'),
(10, 'Sala2'),
(11, 'Sala3'),
(12, 'Sala4'),
(13, 'Sala5');

-- --------------------------------------------------------

--
-- Struttura della tabella `ATTREZZO`
--

DROP TABLE IF EXISTS `ATTREZZO`;
CREATE TABLE `ATTREZZO` (
  `ID_attrezzo` int(11) NOT NULL,
  `Marca` varchar(255) DEFAULT NULL,
  `Tipo` varchar(255) DEFAULT NULL,
  `Ultima_manutenzione` date DEFAULT NULL,
  `Peso_minimo` float DEFAULT NULL,
  `Peso_Massimo` float DEFAULT NULL,
  `Sala` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `ATTREZZO`:
--   `Sala`
--       `SALA` -> `ID_sala`
--

--
-- Dump dei dati per la tabella `ATTREZZO`
--

INSERT INTO `ATTREZZO` (`ID_attrezzo`, `Marca`, `Tipo`, `Ultima_manutenzione`, `Peso_minimo`, `Peso_Massimo`, `Sala`) VALUES
(1, 'TechnoGym', 'Tapis Roulant', '2020-11-12', 40, 150, 4),
(2, 'TechnoGym', 'Cyclette', '2019-11-12', 40, 180, 2),
(3, 'TechnoGym', 'Ellittica', '2020-10-12', 40, 150, 1),
(4, 'TechnoGym', 'Trampolino', '2020-06-11', 20, 100, 3),
(5, 'TechnoGym', 'Tapis Roulant', '2020-07-12', 20, 150, 5),
(6, 'TechnoGym', 'Cyclette', '2020-11-12', 20, 150, 6);

-- --------------------------------------------------------

--
-- Struttura della tabella `CORSO`
--

DROP TABLE IF EXISTS `CORSO`;
CREATE TABLE `CORSO` (
  `ID_corso` int(11) NOT NULL,
  `Nome_corso` varchar(255) DEFAULT NULL,
  `Prezzo` float DEFAULT NULL,
  `Max_iscritti` int(11) DEFAULT NULL,
  `Fascia_eta` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `CORSO`:
--

--
-- Dump dei dati per la tabella `CORSO`
--

INSERT INTO `CORSO` (`ID_corso`, `Nome_corso`, `Prezzo`, `Max_iscritti`, `Fascia_eta`) VALUES
(1, 'Aerobica', 120, 20, '16/20'),
(2, 'Funzionale', 140, 12, '20/30'),
(3, 'Zumba', 60, 25, '35/60'),
(4, 'Cardio', 150, 15, '20/30'),
(5, 'Spinning', 120, 20, '16/20'),
(6, 'Pugilato', 100, 20, '18/30'),
(7, 'Aerobica', 130, 20, '21/30'),
(8, 'Zumba', 70, 20, '18/34'),
(21, 'Nuoto Libero', 120, 30, '18/80'),
(22, 'Scuola Nuoto', 100, 20, '5/11'),
(23, 'Pallanuoto', 150, 25, '13/25'),
(24, 'Preparazione calciatori', 300, 15, '18/45');

-- --------------------------------------------------------

--
-- Struttura della tabella `DIRIGENZA`
--

DROP TABLE IF EXISTS `DIRIGENZA`;
CREATE TABLE `DIRIGENZA` (
  `Sede` int(11) NOT NULL,
  `Segretario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `DIRIGENZA`:
--   `Sede`
--       `SEDE` -> `ID_sede`
--   `Segretario`
--       `SEGRETARIO` -> `ID_impiegato`
--

--
-- Dump dei dati per la tabella `DIRIGENZA`
--

INSERT INTO `DIRIGENZA` (`Sede`, `Segretario`) VALUES
(1, 9),
(2, 10),
(3, 4),
(4, 11),
(5, 12),
(6, 13);

-- --------------------------------------------------------

--
-- Struttura della tabella `IMPIEGATO`
--

DROP TABLE IF EXISTS `IMPIEGATO`;
CREATE TABLE `IMPIEGATO` (
  `ID_impiegato` int(11) NOT NULL,
  `C_F` varchar(16) DEFAULT NULL,
  `Nome` varchar(255) DEFAULT NULL,
  `Cognome` varchar(255) DEFAULT NULL,
  `Data_nascita` date DEFAULT NULL,
  `Indirizzo` varchar(255) DEFAULT NULL,
  `Citta` varchar(255) DEFAULT NULL,
  `Posta_elettronica` varchar(255) DEFAULT NULL,
  `Telefono` varchar(255) DEFAULT NULL,
  `Pass` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `IMPIEGATO`:
--

--
-- Dump dei dati per la tabella `IMPIEGATO`
--

INSERT INTO `IMPIEGATO` (`ID_impiegato`, `C_F`, `Nome`, `Cognome`, `Data_nascita`, `Indirizzo`, `Citta`, `Posta_elettronica`, `Telefono`, `Pass`) VALUES
(1, 'RMRGRG99H41C351J', 'Giuseppe', 'Rossi', '1999-06-01', 'Via Dafnica 206', 'Acireale', 'giorgiarumorepagano@gmail.com', '3455097800', NULL),
(2, 'SPDMRR66H61C464A', 'Maria', 'Ferrari', '1966-05-15', 'Via Wagner 206', 'Roma', 'maraspadario@yahoo.com', '3485798830', NULL),
(3, 'PRRMTT99F21AGGVV', 'Andrea', 'Russo', '1999-11-02', 'Via Londa 111', 'Verona', 'mattipirri@gmail.com', '3488897800', NULL),
(4, 'RMRLSS94F1GHJ34G', 'Alessio', 'Rumore Pagano', '1994-05-06', 'Palermo', 'Palermo', 'alessio94@live.it', '3455294800', NULL),
(5, 'PRRLSS99H32C6673', 'Marco', 'Bianchi', '1999-02-11', 'Via Londa 112', 'Milano', 'alessio99@hotmail.it', '3455097456', NULL),
(6, 'RMRGSP66H41C351J', 'Francesco', 'Gallo', '1966-10-08', 'Via Sciarelle', 'Catania', 'giusepperumorepagano@yahoo.it', '3455123800', NULL),
(7, 'FRCBTT00H34C6123', 'Giovanna', 'Rossi', '2000-06-08', 'Via V Settembre', 'Catania', 'francesca00@gmail.com', '3455097800', NULL),
(8, 'RCCDTR00H41C351J', 'Francesco', 'Agnelli', '2000-12-22', 'Via San Piero Patti', 'Firenze', 'demetrio33@gamil.com', '3455677800', NULL),
(9, 'ALBBNC99H41C351J', 'Alberto', 'Bianchi', '1998-06-12', 'Via V settembre 11', 'Acireale', 'alberto@gmail.com', '3455097800', NULL),
(10, 'RSSMRR66H61C464A', 'Mara', 'Rossi', '1967-06-15', 'Via Wagner 211', 'Roma', 'mara@yahoo.com', '3485710230', NULL),
(11, 'RMNMTT97F21AGGVV', 'Mattia', 'Romano', '1997-11-02', 'Via Piemonte', 'Verona', 'mattia@gmail.com', '3488840600', NULL),
(12, 'CSTLSS94F1GHJ34G', 'Alessio', 'Costa', '1994-12-02', 'Via Palermo', 'Palermo', 'alessio@live.it', '3455456800', NULL),
(13, 'GLLLSS80H32C6673', 'Alessio', 'Gallo', '1980-02-11', 'Via Londa 112', 'Milano', 'gallo@hotmail.it', '3455097456', NULL),
(16, 'RMRGRG99H41C321J', 'Oscar', 'Luigi', '2016-07-16', 'Via Dafnica', 'Acireale', 'oscar@ciaociao.it', '1238067456', '$2y$10$UWCYAz6lsY.hajIld3niU.pFVEHFINUFIqsv2kHnRZNRqrI6q85qW'),
(17, 'RMRARG99H41C321J', 'Pippo', 'Baudo', '1900-01-15', 'Via Roma 30', 'Roma', 'pippo@mediaset.it', '093764456', '$2y$10$Ndeu97o1pFoARNiv51NwkelPjY5SrhBKheVoF1MGXP8k2aapFnjjq'),
(18, 'SPDGRG99H41C456J', 'Giorgio', 'Spadaro', '1999-12-12', 'Via Palazzolo', 'Firenze', 'giorgio99@live.it', '3786534234', '$2y$10$7qAzDjxv/iUUCYROn9OvT.v0Fsr7Eu.CUbxQVI9VMERw1zWosrc2C'),
(19, 'SLVSLV8941C367K2', 'Salvatore', 'Salvato', '2011-11-11', 'Via Pace', 'Milano', 'ss@gmail.com', '3467895345', '$2y$10$qIFNIAX3LIYN/uI5fkF8Juy6goXcDrZ7MPoEY3yHGfvnsi9OJ75.i');

-- --------------------------------------------------------

--
-- Struttura della tabella `IMPIEGO`
--

DROP TABLE IF EXISTS `IMPIEGO`;
CREATE TABLE `IMPIEGO` (
  `ID_impiego` int(11) NOT NULL,
  `Data_inizio` date DEFAULT NULL,
  `Data_fine` date DEFAULT NULL,
  `Salario` float DEFAULT NULL,
  `ID_impiegato` int(11) DEFAULT NULL,
  `Sede` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `IMPIEGO`:
--   `ID_impiegato`
--       `IMPIEGATO` -> `ID_impiegato`
--   `Sede`
--       `SEDE` -> `ID_sede`
--

--
-- Dump dei dati per la tabella `IMPIEGO`
--

INSERT INTO `IMPIEGO` (`ID_impiego`, `Data_inizio`, `Data_fine`, `Salario`, `ID_impiegato`, `Sede`) VALUES
(1, '2019-10-11', NULL, 1300, 2, 2),
(2, '2018-03-01', '2019-04-01', 1500, 4, 1),
(3, '2020-01-11', NULL, 1600, 1, 2),
(4, '2017-10-11', NULL, 1400, 3, 2),
(5, '2019-06-01', NULL, 2000, 7, 3),
(6, '2018-10-11', '2020-01-11', 1300, 8, 4),
(7, '2019-10-11', '2020-11-11', 1200, 5, 1),
(8, '2018-11-03', NULL, 1800, 6, 5),
(9, '2019-05-01', NULL, 1600, 4, 6),
(10, '2020-02-11', NULL, 1400, 8, 7),
(11, '2020-12-11', NULL, 1300, 5, 3);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `ImpiegoImpiegato`
-- (Vedi sotto per la vista effettiva)
--
DROP VIEW IF EXISTS `ImpiegoImpiegato`;
CREATE TABLE `ImpiegoImpiegato` (
`ID_impiegato` int(11)
,`Nome` varchar(255)
,`Cognome` varchar(255)
,`C_F` varchar(16)
,`Sede` int(11)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `INSEGNAMENTO`
--

DROP TABLE IF EXISTS `INSEGNAMENTO`;
CREATE TABLE `INSEGNAMENTO` (
  `Sede` int(11) NOT NULL,
  `Istruttore` int(11) NOT NULL,
  `Corso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `INSEGNAMENTO`:
--   `Sede`
--       `SEDE` -> `ID_sede`
--   `Istruttore`
--       `ISTRUTTORE` -> `ID_impiegato`
--   `Corso`
--       `CORSO` -> `ID_corso`
--

--
-- Dump dei dati per la tabella `INSEGNAMENTO`
--

INSERT INTO `INSEGNAMENTO` (`Sede`, `Istruttore`, `Corso`) VALUES
(1, 1, 21),
(1, 2, 3),
(1, 8, 5),
(2, 3, 2),
(2, 8, 7),
(3, 1, 1),
(3, 6, 6),
(3, 7, 1),
(4, 7, 24),
(5, 5, 22),
(6, 18, 23),
(7, 5, 4);

-- --------------------------------------------------------

--
-- Struttura della tabella `ISCRITTO`
--

DROP TABLE IF EXISTS `ISCRITTO`;
CREATE TABLE `ISCRITTO` (
  `ID_iscritto` int(11) NOT NULL,
  `Nome` varchar(255) DEFAULT NULL,
  `Cognome` varchar(255) DEFAULT NULL,
  `Data_nascita` date DEFAULT NULL,
  `età` int(11) DEFAULT NULL,
  `C_F` varchar(16) DEFAULT NULL,
  `Indirizzo` varchar(255) DEFAULT NULL,
  `Citta` varchar(255) DEFAULT NULL,
  `Telefono` varchar(255) DEFAULT NULL,
  `Posta_elettronica` varchar(255) DEFAULT NULL,
  `ID_tessera` int(11) DEFAULT NULL,
  `Prezzo_tessera` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `ISCRITTO`:
--

--
-- Dump dei dati per la tabella `ISCRITTO`
--

INSERT INTO `ISCRITTO` (`ID_iscritto`, `Nome`, `Cognome`, `Data_nascita`, `età`, `C_F`, `Indirizzo`, `Citta`, `Telefono`, `Posta_elettronica`, `ID_tessera`, `Prezzo_tessera`) VALUES
(1, 'Giuseppe', 'Primavera', '1999-03-13', 21, 'PRMGSP99G567ASD1', 'Via Botteghelle', 'Acireale', '3475099824', 'giuseppe.primavera@yahoo.it', 1, 5),
(2, 'Francesco', 'Rossi', '1998-11-02', 22, 'FRCRSS98G56QWSD1', 'Via Rossi', 'Catania', '3475012324', 'francesco98@yahoo.it', 2, 5),
(3, 'Leonardo', 'Bianchi', '1990-03-13', 60, 'LNRBNC60G567ASD1', 'Via Salvatore Vigo', 'Acicastello', '3475367824', 'leonardo@gmail.com', 3, 8),
(4, 'Alessandro', 'Russo', '1966-10-08', 54, 'RSSALS66G512ASD1', 'Via Sciarelle', 'Catania', '3475048024', 'russo@yahoo.it', 4, 10),
(5, 'Giudo', 'Panebianco', '2003-03-13', 17, 'GDDPNB03G545ASD1', 'Corso Italia', 'Roma', '3471479824', 'guidoo@yahoo.it', 5, 5),
(6, 'Salvatore', 'Fontana', '2002-03-13', 18, 'SLVFNT02G567ASD1', 'Corso Savoia', 'Milano', '3475014824', 'salvatore@yahoo.it', 6, 10),
(7, 'Giorgio', 'Pagano', '2002-04-13', 18, 'GRGPGN123HGFAS78', 'Corso Italia', 'Milano', '3450987564', 'giorgio02@gmail.com', 7, 8),
(8, 'Davide', 'Pennisi', '2004-04-05', 16, 'DVDPNNASD12VB90B', 'Corso Sicilia', 'Palermo', '3450987123', 'davide@outlook.com', 8, 5),
(9, 'Francesca', 'Leonardi', '2005-04-05', 15, 'FRNLNDASD123F90B', 'Via Leonardi', 'Palermo', '3410787123', 'francesca@outlook.com', 9, 10);

--
-- Trigger `ISCRITTO`
--
DROP TRIGGER IF EXISTS `aggiungi_eta`;
DELIMITER $$
CREATE TRIGGER `aggiungi_eta` BEFORE INSERT ON `ISCRITTO` FOR EACH ROW BEGIN
	SET new.età = timestampdiff(YEAR, NEW.data_nascita, CURRENT_DATE);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `IscrittoCorso`
-- (Vedi sotto per la vista effettiva)
--
DROP VIEW IF EXISTS `IscrittoCorso`;
CREATE TABLE `IscrittoCorso` (
`ID_iscritto` int(11)
,`Nome` varchar(255)
,`Cognome` varchar(255)
,`Data_nascita` date
,`età` int(11)
,`C_F` varchar(16)
,`Indirizzo` varchar(255)
,`Citta` varchar(255)
,`Telefono` varchar(255)
,`Posta_elettronica` varchar(255)
,`ID_corso` int(11)
,`Nome_corso` varchar(255)
,`Prezzo` float
,`Max_iscritti` int(11)
,`Fascia_eta` varchar(255)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `ISTRUTTORE`
--

DROP TABLE IF EXISTS `ISTRUTTORE`;
CREATE TABLE `ISTRUTTORE` (
  `ID_impiegato` int(11) NOT NULL,
  `Specializzazione` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `ISTRUTTORE`:
--   `ID_impiegato`
--       `IMPIEGATO` -> `ID_impiegato`
--

--
-- Dump dei dati per la tabella `ISTRUTTORE`
--

INSERT INTO `ISTRUTTORE` (`ID_impiegato`, `Specializzazione`) VALUES
(1, 'Aerobica'),
(2, 'Zumba'),
(3, 'Cardio'),
(5, 'Funzionale'),
(6, 'Spinning'),
(7, 'Funzionale'),
(8, 'Pugilato'),
(18, NULL);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `n_usi`
-- (Vedi sotto per la vista effettiva)
--
DROP VIEW IF EXISTS `n_usi`;
CREATE TABLE `n_usi` (
`Attrezzo` int(11)
,`Citta` varchar(255)
,`usi` bigint(21)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `SALA`
--

DROP TABLE IF EXISTS `SALA`;
CREATE TABLE `SALA` (
  `ID_sala` int(11) NOT NULL,
  `Sede` int(11) DEFAULT NULL,
  `GRANDEZZA` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `SALA`:
--   `Sede`
--       `SEDE` -> `ID_sede`
--

--
-- Dump dei dati per la tabella `SALA`
--

INSERT INTO `SALA` (`ID_sala`, `Sede`, `GRANDEZZA`) VALUES
(1, 1, 100),
(2, 1, 200),
(3, 7, 85),
(4, 2, 100),
(5, 3, 90),
(6, 6, 100),
(7, 3, 50),
(8, 4, 60),
(9, 5, 100);

-- --------------------------------------------------------

--
-- Struttura della tabella `SEDE`
--

DROP TABLE IF EXISTS `SEDE`;
CREATE TABLE `SEDE` (
  `ID_sede` int(11) NOT NULL,
  `Indirizzo` varchar(255) DEFAULT NULL,
  `Citta` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `SEDE`:
--

--
-- Dump dei dati per la tabella `SEDE`
--

INSERT INTO `SEDE` (`ID_sede`, `Indirizzo`, `Citta`) VALUES
(1, 'Via Lazzaretto', 'Acireale'),
(2, 'Via Abbruzzi', 'Catania'),
(3, 'Via Roma', 'Palermo'),
(4, 'Via Firenze', 'Roma'),
(5, 'Via Vittorio Emanuele', 'Milano'),
(6, 'Via Platani', 'Firenze'),
(7, 'Via Rossi', 'Verona');

-- --------------------------------------------------------

--
-- Struttura della tabella `SEGRETARIO`
--

DROP TABLE IF EXISTS `SEGRETARIO`;
CREATE TABLE `SEGRETARIO` (
  `ID_impiegato` int(11) NOT NULL,
  `Reparto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `SEGRETARIO`:
--   `ID_impiegato`
--       `IMPIEGATO` -> `ID_impiegato`
--

--
-- Dump dei dati per la tabella `SEGRETARIO`
--

INSERT INTO `SEGRETARIO` (`ID_impiegato`, `Reparto`) VALUES
(4, 'Call Center'),
(7, 'Call Center'),
(9, 'Informazioni'),
(10, 'Pagamenti'),
(11, 'Informazioni'),
(12, 'Pagamenti'),
(13, 'Informazionii'),
(19, NULL);

--
-- Trigger `SEGRETARIO`
--
DROP TRIGGER IF EXISTS `MaxSegretari`;
DELIMITER $$
CREATE TRIGGER `MaxSegretari` BEFORE INSERT ON `SEGRETARIO` FOR EACH ROW BEGIN 
	IF (EXISTS(select count(*) as n_segretari FROM SEGRETARIO HAVING n_segretari = 10))
    THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "ERRORE: non puoi inserire un nuovo segretario, ogni sede ne può avere al massimo 10!";
        
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `SVOLGERE`
--

DROP TABLE IF EXISTS `SVOLGERE`;
CREATE TABLE `SVOLGERE` (
  `Sala` int(11) NOT NULL,
  `Corso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `SVOLGERE`:
--   `Sala`
--       `SALA` -> `ID_sala`
--   `Corso`
--       `CORSO` -> `ID_corso`
--

--
-- Dump dei dati per la tabella `SVOLGERE`
--

INSERT INTO `SVOLGERE` (`Sala`, `Corso`) VALUES
(1, 3),
(2, 5),
(3, 4),
(4, 2),
(4, 7),
(5, 1),
(5, 6),
(6, 3),
(9, 8);

-- --------------------------------------------------------

--
-- Struttura della tabella `USUFRUIRE`
--

DROP TABLE IF EXISTS `USUFRUIRE`;
CREATE TABLE `USUFRUIRE` (
  `Corso` int(11) NOT NULL,
  `Attrezzo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELAZIONI PER TABELLA `USUFRUIRE`:
--   `Attrezzo`
--       `ATTREZZO` -> `ID_attrezzo`
--   `Corso`
--       `CORSO` -> `ID_corso`
--

--
-- Dump dei dati per la tabella `USUFRUIRE`
--

INSERT INTO `USUFRUIRE` (`Corso`, `Attrezzo`) VALUES
(1, 5),
(2, 1),
(3, 3),
(3, 6),
(4, 4),
(5, 2),
(6, 5);

-- --------------------------------------------------------

--
-- Struttura per vista `ImpiegoImpiegato`
--
DROP TABLE IF EXISTS `ImpiegoImpiegato`;

DROP VIEW IF EXISTS `ImpiegoImpiegato`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ImpiegoImpiegato`  AS SELECT `I`.`ID_impiegato` AS `ID_impiegato`, `IM`.`Nome` AS `Nome`, `IM`.`Cognome` AS `Cognome`, `IM`.`C_F` AS `C_F`, `I`.`Sede` AS `Sede` FROM (`IMPIEGO` `I` join `IMPIEGATO` `IM` on(`I`.`ID_impiegato` = `IM`.`ID_impiegato`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `IscrittoCorso`
--
DROP TABLE IF EXISTS `IscrittoCorso`;

DROP VIEW IF EXISTS `IscrittoCorso`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `IscrittoCorso`  AS SELECT `I`.`ID_iscritto` AS `ID_iscritto`, `I`.`Nome` AS `Nome`, `I`.`Cognome` AS `Cognome`, `I`.`Data_nascita` AS `Data_nascita`, `I`.`età` AS `età`, `I`.`C_F` AS `C_F`, `I`.`Indirizzo` AS `Indirizzo`, `I`.`Citta` AS `Citta`, `I`.`Telefono` AS `Telefono`, `I`.`Posta_elettronica` AS `Posta_elettronica`, `C`.`ID_corso` AS `ID_corso`, `C`.`Nome_corso` AS `Nome_corso`, `C`.`Prezzo` AS `Prezzo`, `C`.`Max_iscritti` AS `Max_iscritti`, `C`.`Fascia_eta` AS `Fascia_eta` FROM ((`CORSO` `C` join `ABBONAMENTO` `A` on(`C`.`ID_corso` = `A`.`Corso`)) join `ISCRITTO` `I` on(`I`.`ID_iscritto` = `A`.`Iscritto`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `n_usi`
--
DROP TABLE IF EXISTS `n_usi`;

DROP VIEW IF EXISTS `n_usi`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `n_usi`  AS SELECT `U`.`Attrezzo` AS `Attrezzo`, `I`.`Citta` AS `Citta`, count(`I`.`ID_iscritto`) AS `usi` FROM (`IscrittoCorso` `I` join `USUFRUIRE` `U` on(`I`.`ID_corso` = `U`.`Corso`)) GROUP BY `I`.`Citta`, `U`.`Attrezzo` ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `ABBONAMENTO`
--
ALTER TABLE `ABBONAMENTO`
  ADD PRIMARY KEY (`Corso`,`Iscritto`),
  ADD KEY `idx_corso5` (`Corso`),
  ADD KEY `idx_iscrittoo` (`Iscritto`);

--
-- Indici per le tabelle `ADETTO_PULIZIE`
--
ALTER TABLE `ADETTO_PULIZIE`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_impiegato3` (`ID_impiegato`);

--
-- Indici per le tabelle `ATTREZZO`
--
ALTER TABLE `ATTREZZO`
  ADD PRIMARY KEY (`ID_attrezzo`),
  ADD KEY `idx_sala` (`Sala`);

--
-- Indici per le tabelle `CORSO`
--
ALTER TABLE `CORSO`
  ADD PRIMARY KEY (`ID_corso`);

--
-- Indici per le tabelle `DIRIGENZA`
--
ALTER TABLE `DIRIGENZA`
  ADD PRIMARY KEY (`Sede`,`Segretario`),
  ADD KEY `idx_sede2` (`Sede`),
  ADD KEY `idx_segretario` (`Segretario`);

--
-- Indici per le tabelle `IMPIEGATO`
--
ALTER TABLE `IMPIEGATO`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD UNIQUE KEY `C_F` (`C_F`);

--
-- Indici per le tabelle `IMPIEGO`
--
ALTER TABLE `IMPIEGO`
  ADD PRIMARY KEY (`ID_impiego`),
  ADD UNIQUE KEY `ID_impiegato` (`ID_impiegato`,`Data_inizio`),
  ADD KEY `idx_impiegato` (`ID_impiegato`),
  ADD KEY `idx_sedee` (`Sede`);

--
-- Indici per le tabelle `INSEGNAMENTO`
--
ALTER TABLE `INSEGNAMENTO`
  ADD PRIMARY KEY (`Sede`,`Istruttore`,`Corso`),
  ADD KEY `idx_sede1` (`Sede`),
  ADD KEY `idx_istruttore` (`Istruttore`),
  ADD KEY `idx_corso1` (`Corso`);

--
-- Indici per le tabelle `ISCRITTO`
--
ALTER TABLE `ISCRITTO`
  ADD PRIMARY KEY (`ID_iscritto`),
  ADD UNIQUE KEY `C_F` (`C_F`,`ID_tessera`);

--
-- Indici per le tabelle `ISTRUTTORE`
--
ALTER TABLE `ISTRUTTORE`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_impiegato2` (`ID_impiegato`);

--
-- Indici per le tabelle `SALA`
--
ALTER TABLE `SALA`
  ADD PRIMARY KEY (`ID_sala`),
  ADD KEY `idx_sede` (`Sede`);

--
-- Indici per le tabelle `SEDE`
--
ALTER TABLE `SEDE`
  ADD PRIMARY KEY (`ID_sede`);

--
-- Indici per le tabelle `SEGRETARIO`
--
ALTER TABLE `SEGRETARIO`
  ADD PRIMARY KEY (`ID_impiegato`),
  ADD KEY `idx_impiegato1` (`ID_impiegato`);

--
-- Indici per le tabelle `SVOLGERE`
--
ALTER TABLE `SVOLGERE`
  ADD PRIMARY KEY (`Sala`,`Corso`),
  ADD KEY `idx_sala1` (`Sala`),
  ADD KEY `idx_corso2` (`Corso`);

--
-- Indici per le tabelle `USUFRUIRE`
--
ALTER TABLE `USUFRUIRE`
  ADD PRIMARY KEY (`Corso`,`Attrezzo`),
  ADD KEY `idx_attrezzo` (`Attrezzo`),
  ADD KEY `idx_corso3` (`Corso`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `ATTREZZO`
--
ALTER TABLE `ATTREZZO`
  MODIFY `ID_attrezzo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT per la tabella `CORSO`
--
ALTER TABLE `CORSO`
  MODIFY `ID_corso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT per la tabella `IMPIEGATO`
--
ALTER TABLE `IMPIEGATO`
  MODIFY `ID_impiegato` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT per la tabella `IMPIEGO`
--
ALTER TABLE `IMPIEGO`
  MODIFY `ID_impiego` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT per la tabella `ISCRITTO`
--
ALTER TABLE `ISCRITTO`
  MODIFY `ID_iscritto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT per la tabella `SALA`
--
ALTER TABLE `SALA`
  MODIFY `ID_sala` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT per la tabella `SEDE`
--
ALTER TABLE `SEDE`
  MODIFY `ID_sede` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `ABBONAMENTO`
--
ALTER TABLE `ABBONAMENTO`
  ADD CONSTRAINT `ABBONAMENTO_ibfk_1` FOREIGN KEY (`Corso`) REFERENCES `CORSO` (`ID_corso`),
  ADD CONSTRAINT `ABBONAMENTO_ibfk_2` FOREIGN KEY (`Iscritto`) REFERENCES `ISCRITTO` (`ID_iscritto`);

--
-- Limiti per la tabella `ADETTO_PULIZIE`
--
ALTER TABLE `ADETTO_PULIZIE`
  ADD CONSTRAINT `ADETTO_PULIZIE_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `IMPIEGATO` (`ID_impiegato`);

--
-- Limiti per la tabella `ATTREZZO`
--
ALTER TABLE `ATTREZZO`
  ADD CONSTRAINT `ATTREZZO_ibfk_1` FOREIGN KEY (`Sala`) REFERENCES `SALA` (`ID_sala`);

--
-- Limiti per la tabella `DIRIGENZA`
--
ALTER TABLE `DIRIGENZA`
  ADD CONSTRAINT `DIRIGENZA_ibfk_1` FOREIGN KEY (`Sede`) REFERENCES `SEDE` (`ID_sede`),
  ADD CONSTRAINT `DIRIGENZA_ibfk_2` FOREIGN KEY (`Segretario`) REFERENCES `SEGRETARIO` (`ID_impiegato`);

--
-- Limiti per la tabella `IMPIEGO`
--
ALTER TABLE `IMPIEGO`
  ADD CONSTRAINT `IMPIEGO_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `IMPIEGATO` (`ID_impiegato`),
  ADD CONSTRAINT `IMPIEGO_ibfk_2` FOREIGN KEY (`Sede`) REFERENCES `SEDE` (`ID_sede`);

--
-- Limiti per la tabella `INSEGNAMENTO`
--
ALTER TABLE `INSEGNAMENTO`
  ADD CONSTRAINT `INSEGNAMENTO_ibfk_1` FOREIGN KEY (`Sede`) REFERENCES `SEDE` (`ID_sede`),
  ADD CONSTRAINT `INSEGNAMENTO_ibfk_2` FOREIGN KEY (`Istruttore`) REFERENCES `ISTRUTTORE` (`ID_impiegato`),
  ADD CONSTRAINT `INSEGNAMENTO_ibfk_3` FOREIGN KEY (`Corso`) REFERENCES `CORSO` (`ID_corso`);

--
-- Limiti per la tabella `ISTRUTTORE`
--
ALTER TABLE `ISTRUTTORE`
  ADD CONSTRAINT `ISTRUTTORE_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `IMPIEGATO` (`ID_impiegato`);

--
-- Limiti per la tabella `SALA`
--
ALTER TABLE `SALA`
  ADD CONSTRAINT `SALA_ibfk_1` FOREIGN KEY (`Sede`) REFERENCES `SEDE` (`ID_sede`);

--
-- Limiti per la tabella `SEGRETARIO`
--
ALTER TABLE `SEGRETARIO`
  ADD CONSTRAINT `SEGRETARIO_ibfk_1` FOREIGN KEY (`ID_impiegato`) REFERENCES `IMPIEGATO` (`ID_impiegato`);

--
-- Limiti per la tabella `SVOLGERE`
--
ALTER TABLE `SVOLGERE`
  ADD CONSTRAINT `SVOLGERE_ibfk_1` FOREIGN KEY (`Sala`) REFERENCES `SALA` (`ID_sala`),
  ADD CONSTRAINT `SVOLGERE_ibfk_2` FOREIGN KEY (`Corso`) REFERENCES `CORSO` (`ID_corso`);

--
-- Limiti per la tabella `USUFRUIRE`
--
ALTER TABLE `USUFRUIRE`
  ADD CONSTRAINT `USUFRUIRE_ibfk_1` FOREIGN KEY (`Attrezzo`) REFERENCES `ATTREZZO` (`ID_attrezzo`),
  ADD CONSTRAINT `USUFRUIRE_ibfk_2` FOREIGN KEY (`Corso`) REFERENCES `CORSO` (`ID_corso`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
