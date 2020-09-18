-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `TBOOKMARKSENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TBOOKMARKSENG` (
  `BOOKMARKID` BIGINT NOT NULL AUTO_INCREMENT,
  `BOOKMARKURL` VARCHAR(1000) NOT NULL,
  `SHORTURL` VARCHAR(250) NOT NULL,
  `EXPIRYDATE` DATETIME NOT NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250),
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`BOOKMARKID`),
  UNIQUE INDEX `SHORTURL_UNIQUE` (`SHORTURL` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TGROUPREFDATAENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TGROUPREFDATAENG` (
  `GROUPTYPE` VARCHAR(15) NOT NULL,
  `GROUPVALUE` VARCHAR(30) NOT NULL,
  `GROUPVALUEDESC` VARCHAR(60) NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250),
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`GROUPTYPE`, `GROUPVALUE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TBOOKMARKGROUPSENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TBOOKMARKGROUPSENG` (
  `GROUPID` BIGINT NOT NULL AUTO_INCREMENT,
  `GROUPTYPE` VARCHAR(15) NOT NULL,
  `GROUPVALUE` VARCHAR(30) NOT NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250),
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`GROUPID`),
   UNIQUE INDEX `GROUPVALUE_UNIQUE` (`GROUPVALUE` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TCARDSENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TCARDSENG` (
  `CARDID` BIGINT NOT NULL AUTO_INCREMENT,
  `BOOKMARKURL` VARCHAR(1000) NOT NULL,
  `CARDTITLE` VARCHAR(45) NOT NULL,
  `CARDDESC` VARCHAR(250) NOT NULL,
  `IMAGEURL` VARCHAR(50) NOT NULL,
  `SHORTURL` VARCHAR(250) NOT NULL,
  `GROUPID` BIGINT NOT NULL,
  `PUBLISH` VARCHAR(1) NOT NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250) ,
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`CARDID`),
  UNIQUE INDEX `SHORTURL_UNIQUE` (`SHORTURL` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TGROUPADMINSENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TGROUPADMINSENG` (
  `GROUPUSERID` BIGINT NOT NULL AUTO_INCREMENT,
  `GROUPID` BIGINT NOT NULL,
  `USERID` VARCHAR(100) NOT NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250),
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`GROUPUSERID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TSTATUSESENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TSTATUSESENG` (
  `STATUSCODE` VARCHAR(1) NOT NULL,
  `STATUSVALUE` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`STATUSCODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TCARDCHANGESENG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TCARDCHANGESENG` (
  `CARDCHANGEID` BIGINT NOT NULL,
  `CARDID` BIGINT NOT NULL,
  `BOOKMARKURL` VARCHAR(1000) NOT NULL,
  `CARDTITLE` VARCHAR(45) NOT NULL,
  `CARDDESC` VARCHAR(250) NULL,
  `IMAGEURL` VARCHAR(250) NULL,
  `SHORTURL` VARCHAR(250) NULL,
  `GROUPID` BIGINT NULL,
  `STATUS` VARCHAR(1) NOT NULL,
  `OPECRE` VARCHAR(250) NOT NULL,
  `DATCRE` TIMESTAMP NOT NULL,
  `OPEMOD` VARCHAR(250) ,
  `DATMOD` TIMESTAMP NULL,
  PRIMARY KEY (`CARDCHANGEID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- ADD FOREIGN KEYS
-- -----------------------------------------------------

ALTER TABLE  `bookmark`.`tbookmarkgroupseng` 
ADD INDEX `FK_GROUPREF_GROUPDATA_idx` (`GROUPTYPE` ASC, `GROUPVALUE` ASC);

ALTER TABLE `bookmark`.`tbookmarkgroupseng` 
ADD CONSTRAINT `FK_GROUPREF_GROUPDATA`
  FOREIGN KEY (`GROUPTYPE` , `GROUPVALUE`)
  REFERENCES `bookmark`.`tgrouprefdataeng` (`GROUPTYPE` , `GROUPVALUE`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `bookmark`.`tcardseng` 
ADD INDEX `FK_GROUP_CARDS_idx` (`GROUPID` ASC);

ALTER TABLE `bookmark`.`tcardseng` 
ADD CONSTRAINT `FK_GROUP_CARDS`
  FOREIGN KEY (`GROUPID`)
  REFERENCES `bookmark`.`tbookmarkgroupseng` (`GROUPID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `bookmark`.`tgroupadminseng` 
ADD INDEX `FK_GROUP_GROUPADMIN_idx` (`GROUPID` ASC);

ALTER TABLE `bookmark`.`tgroupadminseng` 
ADD CONSTRAINT `FK_GROUP_GROUPADMIN`
  FOREIGN KEY (`GROUPID`)
  REFERENCES `bookmark`.`tbookmarkgroupseng` (`GROUPID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD INDEX `FK_CARD_CARDCHANGE_idx` (`CARDID` ASC);

ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD CONSTRAINT `FK_CARD_CARDCHANGE`
  FOREIGN KEY (`CARDID`)
  REFERENCES `bookmark`.`tcardseng` (`CARDID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD INDEX `FK_GROUP_CARDCHANGE_idx` (`GROUPID` ASC);

ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD CONSTRAINT `FK_GROUP_CARDCHANGE`
  FOREIGN KEY (`GROUPID`)
  REFERENCES `bookmark`.`tbookmarkgroupseng` (`GROUPID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD INDEX `FK_STATUS_CARDCHANGE_idx` (`STATUS` ASC);

ALTER TABLE `bookmark`.`tcardchangeseng` 
ADD CONSTRAINT `FK_STATUS_CARDCHANGE`
  FOREIGN KEY (`STATUS`)
  REFERENCES `bookmark`.`tstatuseseng` (`STATUSCODE`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- -----------------------------------------------------
-- Data for table `TSTATUSESENG`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `TSTATUSESENG` (`STATUSCODE`, `STATUSVALUE`) VALUES ('A', 'APPROVED');
INSERT INTO `TSTATUSESENG` (`STATUSCODE`, `STATUSVALUE`) VALUES ('S', 'SUBMITTED');
INSERT INTO `TSTATUSESENG` (`STATUSCODE`, `STATUSVALUE`) VALUES ('D', 'DENIED');

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('TRIBE','RCM','Referntial Client Management','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('FT','SNO','Strcture and Oraganization','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('FT','ENO','Environmental and Others','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('FT','PNA','Payment and Accounts','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('FT','KYC','Know Your Customer','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('FT','SCOW','SGCIB Client Onboarding team','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('APPLICATION','BDR','Referential System','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);

INSERT INTO `bookmark`.`tgrouprefdataeng`
(`GROUPTYPE`,`GROUPVALUE`,`GROUPVALUEDESC`,`OPECRE`,`DATCRE`,`OPEMOD`,`DATMOD`)
VALUES('APPLICATION','MAESTRO','Maestro Application','bookmark',CURRENT_TIMESTAMP,'bookmark',CURRENT_TIMESTAMP);


COMMIT;

-- DROP Tables in required order --

/*DROP TABLE TCARDCHANGESENG;
DROP TABLE TSTATUSESENG;
DROP TABLE TGROUPADMINSENG;
DROP TABLE TCARDSENG;
DROP TABLE TBOOKMARKGROUPSENG;
DROP TABLE TGROUPREFDATAENG;
DROP TABLE TBOOKMARKSENG;*/
