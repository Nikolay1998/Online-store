-- MySQL Script generated by MySQL Workbench
-- Wed May 23 00:38:17 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema bshop
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bshop` ;

-- -----------------------------------------------------
-- Schema bshop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bshop` DEFAULT CHARACTER SET utf8 ;
USE `bshop` ;

-- -----------------------------------------------------
-- Table `bshop`.`Author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Author` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Author` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `about` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bshop`.`Book_Category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Book_Category` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Book_Category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bshop`.`Book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Book` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Book` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `about` VARCHAR(200) NULL,
  `author_id` INT NULL,
  `book_category_id` INT NULL,
  `price` DECIMAL(7,2) NULL,
  `wh_amount` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_BOOK_TO_AUTHOR`
    FOREIGN KEY (`author_id`)
    REFERENCES `bshop`.`Author` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_BOOK_TO_CATEGORY`
    FOREIGN KEY (`book_category_id`)
    REFERENCES `bshop`.`Book_Category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_BOOK_TO_AUTHOR_idx` ON `bshop`.`Book` (`author_id` ASC);

CREATE INDEX `FK_BOOK_TO_CATEGORY_idx` ON `bshop`.`Book` (`book_category_id` ASC);


-- -----------------------------------------------------
-- Table `bshop`.`Client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Client` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Client` (
  `id` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `parent` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_REFERAL_LINK`
    FOREIGN KEY (`parent`)
    REFERENCES `bshop`.`Client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_REFERAL_LINK_idx` ON `bshop`.`Client` (`parent` ASC);

CREATE UNIQUE INDEX `login_UNIQUE` ON `bshop`.`Client` (`login` ASC);


-- -----------------------------------------------------
-- Table `bshop`.`Order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Order` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NULL,
  `status` ENUM('Active', 'Completed', 'Cancelled') NULL,
  `completion_date` DATETIME NULL,
  `creation_date` DATETIME NULL,
  `price` DECIMAL(7,2) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_ORDER_TO_CLIENT`
    FOREIGN KEY (`client_id`)
    REFERENCES `bshop`.`Client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_ORDER_TO_CLIENT_idx` ON `bshop`.`Order` (`client_id` ASC);


-- -----------------------------------------------------
-- Table `bshop`.`Arrival`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Arrival` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Arrival` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `unique_names` INT NULL,
  `amount` INT NULL,
  `a_date` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bshop`.`Order_Book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Order_Book` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Order_Book` (
  `order_id` INT NULL,
  `book_id` INT NULL,
  `amount` INT NULL,
  CONSTRAINT `FK_OB_TO_ORDER`
    FOREIGN KEY (`order_id`)
    REFERENCES `bshop`.`Order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_OB_TO_BOOK`
    FOREIGN KEY (`book_id`)
    REFERENCES `bshop`.`Book` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_OB_TO_ORDER_idx` ON `bshop`.`Order_Book` (`order_id` ASC);

CREATE INDEX `FK_OB_TO_BOOK_idx` ON `bshop`.`Order_Book` (`book_id` ASC);


-- -----------------------------------------------------
-- Table `bshop`.`Book_raiting`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bshop`.`Book_raiting` ;

CREATE TABLE IF NOT EXISTS `bshop`.`Book_raiting` (
  `client_id` INT NULL,
  `book_id` INT NULL,
  `rating` ENUM('1', '2', '3', '4', '5') NULL,
  CONSTRAINT `FK_BR_TO_CLIENT`
    FOREIGN KEY (`client_id`)
    REFERENCES `bshop`.`Client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_BR_TO_BOOK`
    FOREIGN KEY (`book_id`)
    REFERENCES `bshop`.`Book` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `FK_BR_TO_CLIENT_idx` ON `bshop`.`Book_raiting` (`client_id` ASC);

CREATE INDEX `FK_BR_TO_BOOK_idx` ON `bshop`.`Book_raiting` (`book_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
