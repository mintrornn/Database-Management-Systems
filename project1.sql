 DROP DATABASE IF EXISTS procurement;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `procurement` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `procurement`;
   
CREATE TABLE department(
  dep_name nvarchar(20) not null
);

---------------------- -- ALTER (ADD) -- ----------------------
ALTER TABLE department
  ADD dep_id nchar(9) PRIMARY KEY;

CREATE TABLE employee(
  emp_id    nchar(9)     not null unique primary key,
  emp_fname nvarchar(20) not null,
  emp_lname nvarchar(20) not null,
  emp_phone nvarchar(10) not null,
  emp_email nvarchar(20) not null,
  dep_id 	nchar(9),
  CONSTRAINT FK_EmpDep  FOREIGN KEY (dep_id)   REFERENCES department(dep_id)
);

CREATE TABLE product(
  prod_id           nchar(9)        not null  unique primary key,
  prod_name         nvarchar(20)    not null,
  prod_status       nvarchar(20)    not null,
  prod_description  nvarchar(100)
);

CREATE TABLE goods(
  prod_id  nchar(9) 	   not null,
  g_price  decimal(12,2)   not null,
  g_unit   nvarchar(20)    not null,
  CONSTRAINT FK_ProdGoods  FOREIGN KEY (prod_id)   REFERENCES product(prod_id),
  PRIMARY KEY(prod_id)
);


CREATE TABLE services(
  prod_id  		nchar(9)		not null,
  s_wage        decimal(12,2)   not null,
  s_startdate   date            not null,
  s_enddate     date            not null,
  s_hour        datetime        ,
  s_reqprops    nvarchar(100)   not null,
  CONSTRAINT FK_ProdService FOREIGN KEY (prod_id)   REFERENCES product(prod_id),
  PRIMARY KEY(prod_id)
);

CREATE TABLE supplier(
  sup_id          nchar(9)       not null unique primary key,
  sup_rep         varchar(50)    not null,
  sup_comname     nvarchar(50)   not null,
  sup_contact     nvarchar(100),
  sup_typobus     nvarchar(100)  not null,
  sup_typoprod    char(1)        not null,  
  sup_address     nvarchar(100)  not null,
  sup_description nvarchar(100)  not null,
  sup_status      char(1)        not null,  
  sup_email       nvarchar(50),
  sup_phone       nvarchar(10),
  sup_rating      int            not null,
  CONSTRAINT CHK_type     CHECK (sup_typoprod IN ('G','S')),
  CONSTRAINT CHK_status   CHECK (sup_status IN ('S','U')),
  CONSTRAINT CHK_rating   CHECK (sup_rating >= 1 AND sup_rating <= 5)
);

CREATE TABLE purchase_requisition(
  pr_id           nchar(9)       not null unique primary key,
  pr_date         date           not null,
  pr_duedate      date           not null,
  pr_shipaddress  nvarchar(100)  not null,
  pr_note         nvarchar(100),
  pr_discount     decimal(5,2),
  pr_shipcost     decimal(12,2),
  pr_tax          decimal(5,2),
  emp_id          nchar(9),
  CONSTRAINT FK_PrEmp FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
  CONSTRAINT chk_pr_tax CHECK (pr_tax >= 0.00 AND pr_tax <= 100.00)
);

CREATE TABLE purchase_requisition_detail(
  pr_id        nchar(9),
  prd_num      int            not null,
  prd_total    int            ,
  prd_budget   decimal(12, 2) not null,
  prd_quantity int            not null,
  prd_category nvarchar(20)   not null,
  prod_id      nchar(9),
  CONSTRAINT PK_Prd PRIMARY KEY(pr_id, prd_num),
  CONSTRAINT FK_PrdPr FOREIGN KEY (pr_id) REFERENCES purchase_requisition (pr_id),
  CONSTRAINT FK_PrdProd FOREIGN KEY (prod_id) REFERENCES product (prod_id),
  CONSTRAINT  CHK_quantity  CHECK (prd_quantity >= 1 AND prd_quantity <= 50)
);

CREATE TABLE purchase_order(
  po_id           nchar(9)        not null unique primary key,
  po_date         date            not null,
  po_shipaddress  nvarchar(100)   not null,
  po_note         nvarchar(100),
  po_discount     decimal(5,2), 
  po_deldate      date            not null,
  po_shipcost     decimal(12,2),
  po_tax          decimal(5,2),
  emp_id          nchar(9),
  sup_id          nchar(9),
  CONSTRAINT FK_PoEmp FOREIGN KEY (emp_id) REFERENCES employee(emp_id),
  CONSTRAINT FK_PoSup FOREIGN KEY (sup_id) REFERENCES supplier(sup_id),
  CONSTRAINT chk_po_tax CHECK (po_tax >= 0.00 AND po_tax <= 100.00),
  CONSTRAINT chk_po_discount CHECK (po_discount >= 0.00 AND po_discount <= 100.00)
);

CREATE TABLE purchase_order_detail(
  po_id           nchar(9),
  pod_num         nvarchar(20)    not null,
  pod_quantity    int             not null,
  pod_price       decimal(12,2)   not null,
  pr_id           nchar(9),
  prd_num         int,
  PRIMARY KEY(po_id, pod_num),
  CONSTRAINT  FK_PodPo FOREIGN KEY (po_id) REFERENCES purchase_order (po_id),
  CONSTRAINT  FK_PodPr FOREIGN KEY (pr_id) REFERENCES purchase_requisition (pr_id),
  CONSTRAINT  FK_PodPrd FOREIGN KEY (pr_id, prd_num) REFERENCES purchase_requisition_detail (pr_id, prd_num),
  CONSTRAINT  CHK_Pod_quantity  CHECK (pod_quantity >= 1 AND pod_quantity <= 50)
);

---------------------- -- ALTER (DROP) -- ----------------------
ALTER TABLE supplier
  DROP COLUMN sup_contact;
  
ALTER TABLE purchase_requisition_detail
  DROP COLUMN prd_total;   

------------------------- -- INSERT -- -------------------------

INSERT INTO department(dep_id, dep_name) VALUES
('111222161', 'Account'),
('111222162', 'Finance'),
('111222163', 'Sales'),
('111222164', 'Marketing'),
('111222165', 'Procurement'),
('111222166', 'Production'),
('111222167', 'Human Resources'),
('111222168', 'Quality Control'),
('111222169', 'Research and Development'),
('111222170', 'Information Technology');

INSERT INTO employee(emp_id, emp_fname, emp_lname, emp_phone, emp_email, dep_id) VALUES
('333444598', 'Ariana', 'Grande', '0912345678', 'Ariana.gra@gmail.com', '111222161'),
('333444599', 'Justin', 'Bieber', '0923456789', 'Justin.bie@gmail.com', '111222163'),
('333444601', 'Harry', 'Styles', '0945678912', 'Harry.sty@gmail.com', '111222166'),
('333444602', 'Jeremy', 'Zucker', '0956789123', 'Jeremy.zuc@gmail.com', '111222170'),
('333444603', 'Travis', 'Scott', '0967891234', 'Travis.sco@gmail.com', '111222164'),
('333444604', 'Andy', 'Williams', '0978912345', 'Andy.wil@gmail.com', '111222162'),
('333444605', 'Taylor', 'Swift', '0989123456', 'Taylor.swi@gmail.com', '111222166'),
('333444606', 'Billie', 'Eilish', '0991234567', 'Billie.eil@gmail.com', '111222169'),
('333444607', 'Selena', 'Gomez', '0902345678', 'Selena.gom@gmail.com', '111222166'),
('333444608', 'Sam', 'Smith', '0939876543', 'Sam.smi@gmail.com', '111222165'),
('333444609', 'Samina', 'Smith', '0845138264', 'Samina.smi@gmail.com', '111222163'),
('333444618', 'Somjai', 'Rakdee', '0816584588', 'Somjai.rak@gmail.com', '111222165');

INSERT INTO product(prod_id, prod_name, prod_status, prod_description) VALUES
('600000600', 'Spatular', 'S', null),
('600000601', 'Japan rice', 'U', 'Import from Japan'),
('600000603', 'Striky Thai rice', 'S', null),
('600000605', 'Mango', 'U', 'Raw'),
('600000606', 'Jack fruit', 'S', null),
('600000711', 'Beef Meat', 'S', 'A5'),
('600000722', 'Flour', 'S', 'Low glutin for cake baking'),
('600000733', 'Apple', 'U', null),
('600000755', 'Syrup', 'S', null),
('600000800', 'Cocoa', 'S', null),
('600000810', 'Chicken', 'U', 'For meat'),
('600000811', 'Prawns', 'S', NULL),
('600000812', 'Brown Sugar', 'S', 'Organic'),
('600000823', 'Wood table', 'S', null),
('600000825', 'Wood chair', 'S', null),
('600000826', 'Shelf', 'S', 'Stanley'),
('600000827', 'Microsoft license', 'S', null),
('600000834', 'Modern plate set', 'S', '12 plates per set'),
('600000836', 'Matcha Green Tea', 'U', 'Organic'),
('600000841', 'Strawberry', 'S', null),
('600000845', 'Milk', 'S', 'High fat'),
('600000850', 'Hand mixer', 'S', 'Medium size'),
('600000851', 'Industial oven', 'S', '10 years insurance'),
('600000852', 'Industial mixer', 'S', '8 years insurance'),
('610000053', 'Machine caring', 'S', 'checking main machines of central factory'),
('610000061', 'Cleaning service', 'S', 'Cleaning'),
('610000063', 'Survey and explore service', 'S', 'Do a customer survey for marketing'),
('610000065', 'Survey service', 'U', 'Do a customer survey for marketing'),
('610000103', 'Marketing consultant', 'S', 'Consulting for marketing'),
('610000114', 'Bread making expert', 'U', 'Explore new menu of bread'),
('610000134', 'Food scientist', 'S', 'checking main machine of central factory'),
('610000159', 'Business consultant', 'S', 'Consulting for business management'),
('610000168', 'IT consultant', 'U', 'Improving business by using technology'),
('610000169', 'Online Advertisement', 'U', 'Advertising on online platforms'),
('610000199', 'Delivery', 'U', 'Just for a busy day'),
('610000212', 'Mascot', 'S', 'For halloween theme');

INSERT INTO goods(prod_id, g_price, g_unit) VALUES
('600000600', '20.00', 'pieces'), 
('600000601', '200.00', 'kg'),
('600000603', '160.00', 'kg'),
('600000605', '25.00', 'kg'),
('600000606', '40.00', 'kg'),
('600000711', '990.00', 'kg'),
('600000722', '18.00', 'kg'),
('600000733', '80.00', 'kg'),
('600000755', '45.00', 'bag'),
('600000800', '21.00', 'bag'),
('600000810', '100.00', 'kg'),
('600000811', '420.00', 'kg'),
('600000812', '16.50', 'kg'),
('600000823', '1200.00', 'unit'),
('600000825', '1050.00', 'unit'),
('600000826', '980.00', 'shelf'),
('600000827', '4000.00', 'unit'),
('600000834', '790.00', 'set'),
('600000836', '470.50', 'bag'),
('600000841', '510.00', 'kg'),
('600000845', '55.50', 'gallon'),
('600000850', '2690.00', 'unit'),
('600000851', '85000.00', 'machine'),
('600000852', '67500.00', 'machine');

INSERT INTO services(prod_id, s_wage, s_startdate, s_enddate, s_hour, s_reqprops) VALUES
('610000053', '12000.00' ,'2020-02-19', '2021-02-19', '4.50', 'Having highest standards of safety'),
('610000061', '25000.00' ,'2020-10-13', '2021-10-13', '8.00', 'Ability to work cohesively as part of a team'),
('610000063', '13000.00' ,'2020-08-28', '2021-08-28', NULL, 'Excellent communication and organizational skills'),
('610000065', '15000.00' ,'2020-08-28', '2021-08-28', NULL, 'Excellent communication and organizational skills'),
('610000114', '12000.00' ,'2020-02-03', '2021-02-03', '3.50', 'Attention to quailty of ingredients and products'),
('610000134', '15000.00' ,'2020-12-07', '2021-12-07', '5.00', 'Knowledge and understanding of data science'),
('610000159', '11000.00' ,'2020-03-25', '2021-03-25', '6.00', 'Great communication and interpersonal skills'),
('610000168', '27000.00' ,'2020-01-08', '2021-01-08', NULL, 'Proficiency with database languages'),
('610000169', '18000.00' ,'2020-11-01', '2021-11-01', '8.00', 'Experience working with Facebook Advertising is a plus'),
('610000199', '30000.00' ,'2020-04-11', '2021-04-11', '12.00', 'Experience working with Facebook Advertising is a plus'),
('610000212', '10000.00' ,'2020-03-05', '2021-03-05', NULL, 'Having previous mascot experience in college');

INSERT INTO supplier(sup_id, sup_rep, sup_comname, sup_typobus, sup_typoprod, sup_address, sup_description, sup_status, sup_email, sup_phone, sup_rating) VALUES
('555666112', 'Harry Potter', 'Hogwarts Inc.', 'Fruit supplier', 'G', '123/4 Silom road Bangkok 10500', 'ALL famous Thai fruits', 'S', 'Harry.pot@email.com', '0854323231', 4),
('555666113', 'Peter Parker', 'Marvels Co.', 'Bakery Ingredient supplier', 'S', '69/42 Sai Mai road Bangkok 10220', NULL, 'S', 'Peter.par@email.com', '0942526677', 2),
('555666114', 'Angelina Jolie', 'Asus Rice Itd.', 'Rice supplier', 'G', '123/4 Dusit road Bangkok 10300', 'Thai rice or rice from overseas','S','Angelina.jol@email.com', '0849727345', 3),
('555666120', 'Elle Fanning', 'Microsoft Co.', 'Software', 'G', '52/9 Ao Luk road Krabi 81110', 'Necesary programs for business', 'S', 'Elle.fan@email.com', '0928763453', 5),
('555666123', 'Winnie Pooh As', 'The Walt Disney Farm', 'Farm', 'S', '45/6 Pua road Nan 55120', NULL, 'U', 'Winnie.poo@email.com', '0882349899', 5),
('555666213', 'Toy Story', 'Pixar Furnituring Co.',  'Furniture and decoration', 'G', '123/4 Kathu road Phuket 83120', NULL, 'S', 'Toy.sto@email.com', '0918875467', 4),
('555666214', 'Lion King', 'Zimnba Itd.', 'Food science', 'G', '5/192 Phet Kasem road Bangkok 10160', 'Checking quality', 'S', 'Lion.kin@email.com', '0987548342', 1),
('555666220', 'Lily Collins', 'Apple Tool Co.', 'Kitchen tools', 'G', '456/7 Chiang Dao road Chiang Mai 50170', NULL, 'U', 'Lily.col@email.com', '0834427783', 5),
('555666235', 'Troye Sivan', 'Soundcore Inc.', 'Advertising agency company', 'G', '34/35 Omkoi road Chiang 50310', 'Promoting goods and services', 'U', 'Troye.siv@email.com', '0968837920', 5),
('555666251', 'Hermione Granger', 'Industial Mac Inc.', 'Industial Machine for Food Factory ', 'S', '123/4 Silom road Bangkok 10500', NULL, 'S', 'Hermione.gra@email.com', '0958485243', 5);

insert into purchase_requisition(pr_id, pr_date, pr_duedate, pr_shipaddress, pr_note, pr_discount, pr_shipcost, pr_tax, emp_id) values
	('196000001', '2019-01-20', '2019-02-05', '7/19 Sathon Rd, Bkk 10120', 'For creating new menu', '5.00', '100.00', '7.00', '333444601'),
	('196000002', '2019-01-20', '2019-01-30', '1/11 Sathon Rd, Bkk 10120', null, null, '100.00', null, '333444604'),
	('196000006', '2019-02-04', '2019-03-04', 'Sanam Chan Sub-district, Mueang Nakhon Pathom District, Nakhon Pathom 73000', 'urgent!', null, '100.00', '7.00', '333444599'),
	('196000020', '2019-05-16', '2019-06-16', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, '10.00', '100.00', null, '333444607'),
	('196000150', '2019-06-29', '2019-07-15', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, '15.00', '100.00', null, '333444607'),
	('196000174', '2019-07-03', '2019-08-23', 'Central Wongsawang, Wong Sawang, Bang Sue, Bangkok 10800', 'urgent!', null, '100.00', null, '333444603'),
	('196000199', '2019-07-25', '2020-08-25', '1804, 1-3 Lat Phrao Rd, Wang Thonglang, Bangkok 10310', null, '5.00', '100.00', '5.00', '333444603'),
	('196000201', '2019-02-20', '2019-03-05', '7/19 Sathon Rd, Bkk 10120', 'For creating new menu', '5.00', '100.00', '7.00', '333444601'),
	('194400002', '2019-01-20', '2019-01-30', '1/11 Sathon Rd, Bkk 10120', null, null, '100.00', null, '333444604'),
	('194400005', '2019-05-04', '2019-07-04', 'Sanam Chan Sub-district, Mueang Nakhon Pathom District, Nakhon Pathom 73000', 'urgent!', null, '100.00', '7.00', '333444599'),
	('196700006', '2019-02-16', '2019-03-16', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, '10.00', '100.00', null, '333444607'),
	('194400011', '2019-04-29', '2019-05-15', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, '15.00', '100.00', null, '333444607'),
	('194400012', '2019-06-03', '2019-06-23', 'Central Wongsawang, Wong Sawang, Bang Sue, Bangkok 10800', 'urgent!', null, '100.00', null, '333444603'),
	('194400013', '2019-07-25', '2020-08-25', '1804, 1-3 Lat Phrao Rd, Wang Thonglang, Bangkok 10310', null, '5.00', '100.00', '5.00', '333444603'),
	('199100001', '2019-11-01', '2019-12-01', 'Nakhon Pathom Central Factory', 'Important', null, '100.00', '10.00', '333444602'),
	('203500036', '2020-08-18', '2020-08-30', '7/19 Sathon Rd, Bkk 10120', null, '12.00', '100.00', null, '333444601'),
	('206700084', '2020-09-18', '2020-10-20', 'Nakhon Pathom Central Factory', 'Important', '20.00', '100.00', null, '333444605'),
    ('206700110', '2020-03-11', '2020-04-11', '59/52 Yaowarat road Bangkok 10110', NULL, '0.00', NULL, '7.00', '333444606'),
	('206700112', '2020-04-09', '2020-05-09', '1/129 Mittraphap road Khon Kaen 40000', NULL, '10.00', '70.00', '7.00', '333444603'),
	('206700123', '2020-12-23', '2021-01-23', '999/9 Rama I road Bangkok 10330','For yearly seminar', '10.00', '20.00', NULL, '333444598'),
	('206700156', '2020-12-01', '2021-01-01', '99/21 Baromrajchonnee road Nakhon Pathom 73210',  null, NULL, '50.00', NULL, '333444606'),
	('206700723', '2020-05-26', '2020-06-26', '999/1 Super Highway road Chiang Mai 50000',  null, '10.00', NULL, '7.00', '333444601'),
	('206700724', '2020-10-04', '2020-11-04', '199/2 Rattanathibet road Nonthaburi 11140', null, NULL, '40.00', '7.00', '333444605'),
	('206700725', '2020-11-29', '2020-12-29', '1027 Phloen Chit road Bangkok 10330',  null, NULL, '15.00', NULL, '333444599'),
	('206700736', '2020-06-18', '2020-07-18', '206 Khao San road Bangkok 10200', NULL, '10.00', '20.00', '7.00', '333444607'),
	('206700740', '2020-09-12', '2020-10-12', '99/99 Chaengwattana road Nonthaburi 11120', NULL, '10.00', '40.00', NULL, '333444604'),
	('206700744', '2020-03-20', '2020-04-26', '1518 Kanjanavanich road Songkhla 90110', NULL, '0.00', '50.00', NULL, '333444604'),
    ('206700745', '2020-03-06', '2020-03-26', 'Nakhon Pathom Central Factory', NULL, '10.00', '50.00', NULL, '333444605'),
    ('206700767', '2020-05-26', '2020-06-26', 'Sanam Chan Sub-district, Mueang Nakhon Pathom District, Nakhon Pathom 73000', NULL, NULL, '0.00', NULL, '333444599'),
    ('206700774', '2020-05-26', '2020-06-16', '1518 Kanjanavanich road Songkhla 90110', NULL, '0.00', '5.00', NULL, '333444609'),
    ('206700775', '2020-11-02', '2020-11-30', '1/129 Mittraphap road Khon Kaen 40000', NULL, '20.00', '7.00', NULL, '333444609'),
    ('206700800', '2020-09-10', '2020-10-05', 'Nakhon Pathom Central Factory', NULL, '100.00', '50.00', NULL, '333444605'),
    ('206700801', '2020-09-01', '2020-10-01', '999/1 Super Highway road Chiang Mai 50000', NULL, '10.00', '7.00', NULL, '333444609'),
    ('206700802', '2020-10-10', '2020-10-30', '1/11 Sathon Rd, Bkk 10120', null, '300.00', '50.00', NULL, '333444604'),
    ('206700803', '2020-10-12', '2020-10-31', 'Nakhon Pathom Central Factory', null, '5000', '23.50', NULL, '333444605'),
    ('206700810', '2020-12-01', '2020-12-20', '1/129 Mittraphap road Khon Kaen 40000', null, '60.00', '3.00', NULL, '333444609'),
    ('206700811', '2020-12-04', '2021-01-09', '999/1 Super Highway road Chiang Mai 50000', null, '0.00', '5.00', NULL, '333444609'),
    ('206700812', '2020-12-03', '2021-01-10', 'Nakhon Pathom Central Factory', null, null, '15.00', null, '333444605');

insert into purchase_requisition_detail(pr_id, prd_num, prd_budget, prd_quantity, prd_category, prod_id) values
	('196000001', 1, '500.00', 10, 'Ingredient', '600000810'),
    ('196000001', 2, '1000.00', 4, 'Ingredient', '600000811'),
    ('196000001', 3, '5000.00', 20, 'Ingredient', '600000841'),
    ('196000001', 4, '500.00', 10, 'Ingredient', '600000845'),
    ('196000001', 5, '1000.00', 4, 'Ingredient', '600000836'),
    ('196000001', 6, '5000.00', 20, 'Ingredient', '600000812'),
    ('194400002', 1, '8000.00', 12, 'Kitchen tool', '600000834'),
    ('194400002', 2, '8000.00', 12, 'Kitchen tool', '600000850'),
    ('196700006', 1, '200000.00', 10, 'Furniture', '600000823'),
    ('196700006', 2, '200000.00', 20, 'Furniture', '600000825'),
    ('196700006', 3, '200000.00', 3, 'Furniture', '600000826'),
    ('194400011', 1, '7000.00', 15, 'Ingredient', '600000711'),
    ('194400011', 2, '3000.00', 12, 'Ingredient', '600000810'),
	('194400011', 3, '7000.00', 10, 'Ingredient', '600000811'),
    ('194400011', 4, '3000.00', 6, 'Ingredient', '600000722'),
    ('194400011', 5, '7000.00', 8, 'Ingredient', '600000755'),
    ('194400011', 6, '3000.00', 4, 'Ingredient', '600000733'),
    ('194400013', 1, '4000.00', 1, 'License', '600000827'),
	('203500036', 1, '1500.00', 3, 'Ingredient', '600000601'),
    ('203500036', 2, '2500.00', 3, 'Ingredient', '600000603'),
    ('203500036', 3, '2500.00', 30, 'Ingredient', '600000605'),
	('206700084', 1, '350000.00', 5, 'Machine', '600000851'),
    ('206700084', 2, '400000.00', 10, 'Machine', '600000852'),
    ('206700110', 1, '50000.00', 3, 'Consulting', '610000103'),
    ('206700112', 1, '10000.00', 1, 'External service', '610000061'),
    ('206700123', 1, '30000.00', 1, 'Special guest', '610000114'),
    ('206700123', 2, '300000.00', 1, 'Special guest', '610000134'),
    ('206700156', 1, '5000.00', 20, 'Ingredient', '600000812'),
    ('206700156', 2, '12000.00', 5, 'Ingredient', '600000755'),
    ('206700156', 3, '3000.00', 10, 'Ingredient', '600000800'),
    ('206700156', 4, '9000.00', 12, 'Ingredient', '600000722'),
    ('206700156', 5, '35000.00', 8, 'Ingredient', '600000836'),
    ('206700156', 6, '100000.00', 6, 'Machine', '600000850'),
    ('206700812', 1, '10000.00', 1, 'External service', '610000061');
    
    
insert into purchase_order(po_id, po_date, po_shipaddress, po_note, po_discount, po_deldate, po_shipcost, po_tax, emp_id, sup_id) values
	('305600012', '2019-01-23', '1/11 Sathon Rd, Bkk 10120', null, null, '2019-02-01', '100.00', '5.00', '333444608', '555666114'),
    ('305600013', '2019-01-24', '7/19 Sathon Rd, Bkk 10120', null, null, '2019-02-02', '100.00', '10.00', '333444608', '555666112'),
    ('305600015', '2019-01-25', '1/11 Sathon Rd, Bkk 10120', null, null, '2019-02-28', '100.00', null, '333444608', '555666220'),
    ('305600016', '2019-11-02', 'Nakhon Pathom Central Factory', null, null, '2019-12-01', '100.00', '5.00', '333444618', null),
    ('305600022', '2019-07-27', '1804, 1-3 Lat Phrao Rd, Wang Thonglang, Bangkok 10310', null, null, '2019-08-17', '100.00', '7.00', '333444608', '555666120'),
    ('305600033', '2020-09-20', 'Nakhon Pathom Central Factory', null, null, '2020-09-30', '100.00', '5.00', '333444608', '555666251'),
    ('305600044', '2020-02-18', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, null, '2020-03-10', '100.00', null, '333444608', '555666213'),
    ('305600055', '2020-03-15', '59/52 Yaowarat road Bangkok 10110', null, null, '2020-04-01', '100.00', '8.00', '333444608', null),
    ('305600066', '2020-04-10', '1/129 Mittraphap road Khon Kaen 40000', null, null, '2020-04-26', '100.00', '5.00', '333444608', '555666235'),
    ('305600077', '2020-12-02', '99/21 Baromrajchonnee road Nakhon Pathom 73210', null, null, '2020-12-23', '100.00', '12.00', '333444608', '555666220'),
    ('305600088', '2020-12-24', '999/9 Rama I road Bangkok 10330', null, null, '2021-01-08', '100.00', null, '333444608', null),
    ('305600099', '2019-04-30', 'Petchkasem Rd, Lak Song, Bang Khae, Bkk 10160', null, null, '2019-05-10', '100.00', null, '333444618', '555666113'),
    ('305600111', '2020-05-27', '999/1 Super Highway road Chiang Mai 50000', null, null, '2020-06-16', '100.00', '3.00', '333444618', '555666251'),
    ('305600112', '2020-10-04', '199/2 Rattanathibet road Nonthaburi 11140', null, null, '2020-11-04', '100.00', '3.00', '333444608', '555666214'),
    ('305600113', '2020-11-29', '1027 Phloen Chit road Bangkok 10330',  null, null, '2020-12-20', '100.00', '10.20', '333444618', '555666220'),
    ('305600124', '2020-12-02', '99/21 Baromrajchonnee road Nakhon Pathom 73210', null, null, '2020-12-23', '100.00', '5.78', '333444608', '555666123'),
    ('305600125', '2020-06-18', '206 Khao San road Bangkok 10200', null, null, '2020-07-18', '100.00', null, '333444618', '555666214'),
    ('305600133', '2020-08-20', '7/19 Sathon Rd, Bkk 10120', null, null, '2020-09-08', '100.00', null, '333444608', '555666112'),
    ('305600135', '2020-12-02', '99/21 Baromrajchonnee road Nakhon Pathom 73210', null, null, '2020-12-23', '0.00', null, '333444608', '555666113'),
    ('305600145', '2019-01-24', '7/19 Sathon Rd, Bkk 10120', null, null, '2019-02-02', '0.00', null, '333444608', '555666123'),
    ('305600156', '2020-09-12', '99/99 Chaengwattana road Nonthaburi 11120', null, null, '2020-10-12', '0.00', '7.70', '333444618', '555666113'),
    ('305600167', '2020-03-20', '1518 Kanjanavanich road Songkhla 90110', null, null, '2020-04-26', '0.00', null, '333444618', '555666112'),
    ('305600178', '2020-03-06', 'Nakhon Pathom Central Factory', null, null, '2020-03-26', '0.00', '11.00', '333444618', '555666213'),
    ('305600189', '2020-05-26', 'Sanam Chan Sub-district, Mueang Nakhon Pathom District, Nakhon Pathom 73000', null, null, '2020-06-26', '0.00', '7.90', '333444608', null),
    ('305600201', '2020-05-26', '1518 Kanjanavanich road Songkhla 90110', null, null, '2020-06-16', '0.00', '2.50', '333444618', '555666114'),
    ('305600211', '2020-11-02', '1/129 Mittraphap road Khon Kaen 40000', null, null, '2020-11-30', '0.00', '10.00', '333444608', '555666213'),
    ('305600222', '2020-09-10', 'Nakhon Pathom Central Factory', null, null, '2020-10-05', '100.00', '8.50', '333444618', null),
    ('305600234', '2020-09-01', '999/1 Super Highway road Chiang Mai 50000', null, null, '2020-10-01', '100.00', null, '333444608', '555666220'),
    ('305600235', '2020-10-10', '1/11 Sathon Rd, Bkk 10120', null, null, '2020-10-30', '100.00', null, '333444618', '555666113'),
    ('305600238', '2020-10-12', 'Nakhon Pathom Central Factory', null, null, '2020-10-31', '100.00', '6.80', '333444608', null),
    ('305600239', '2020-12-01', '1/129 Mittraphap road Khon Kaen 40000', null, null, '2020-12-20', '100.00', null, '333444608', '555666114'),
    ('305600255', '2020-12-03', 'Nakhon Pathom Central Factory', null, null, '2021-01-10', '100.00', '5.00', '333444618', null);

insert into purchase_order_detail(po_id, pod_num, pod_quantity, pod_price, pr_id, prd_num) values
('305600013', 1, 10, '500.00', '196000001', 1),
('305600013', 2, 4, '1000.00', '196000001', 2),
('305600013', 3, 20, '5000.00', '196000001', 3),
('305600013', 4, 10, '500.00', '196000001', 4),
('305600015', 1, 10, '7000.00',  '194400002', 1),
('305600015', 2, 10, '7000.00',  '194400002', 2),
('305600022', 1, 1, '3950.00', '194400013', 1),
('305600033', 1, 5, '320000.00', '206700084', 1),
('305600033', 2, 10, '400000.00', '206700084', 2),
('305600044', 1, 10, '200000.00', '196700006', 1),
('305600044', 2, 20, '200000.00', '196700006', 2),
('305600055', 1, 3, '50000.00', '206700110', 1),
('305600066', 1, 1, '10000.00', '206700112', 1),
('305600077', 1, 6, '100000.00', '206700156', 6),
('305600088', 1, 1, '30000.00', '206700123', 1),
('305600088', 2, 1, '30000.00', '206700123', 2),
('305600099', 1, 15, '6500.00', '194400011', 1),
('305600099', 2, 10, '7000.00', '194400011', 3),
('305600099', 3, 6, '2250.00', '194400011', 4),
('305600099', 4, 8, '7000.00', '194400011', 5),
('305600099', 5, 4, '3000.00', '194400011', 6),
('305600124', 1, 20, '5000.00', '206700156', 1),
('305600133', 1, 3, '1500.00', '203500036', 1),
('305600133', 2, 3, '2500.00', '203500036', 2),
('305600133', 3, 3, '2500.00', '203500036', 3),
('305600135', 1, 5, '10000.00', '206700156', 2),
('305600135', 2, 10, '2800.00', '206700156', 3),
('305600135', 3, 12, '9000.00', '206700156', 4),
('305600135', 4, 8, '30800.00', '206700156', 5),
('305600145', 1, 4, '1000.00', '196000001', 5),
('305600145', 2, 20, '4800.00', '196000001', 6);

------------------------- -- UPDATE -- -------------------------
UPDATE supplier
SET sup_address = 'Sukhumvit 53 Alley, Khlong Tan Nuea, Watthana, Bangkok 10110'
WHERE sup_id = '555666235';

------------------------- -- DELECT -- -------------------------
DELETE FROM services WHERE prod_id = '610000065';
DELETE FROM product WHERE prod_id = '610000065';

------------------------- -- SELECT -- -------------------------
-- Basic quries--
-- 1
SELECT dep_id, CONCAT(emp_fname,' ',emp_lname) AS emp_name
FROM employee
WHERE dep_id = '111222161';

-- 2
SELECT sup_id, sup_rep, sup_comname, sup_rating FROM supplier
WHERE sup_rating >= 4;

-- 3
SELECT dep_id, dep_name
FROM department
WHERE dep_name IN ('Production', 'Sales', 'Quality Control', 'Information Technology');

-- 4
SELECT sup_id, sup_typoprod, sup_comname, sup_email FROM supplier
WHERE sup_status = 'S' AND sup_description IS NOt NULL;

-- 5
SELECT dep_id, dep_name
FROM department
WHERE dep_id = '111222167' OR dep_id = '111222164';

-- 6
SELECT po_id, pod_num, pod_quantity, pod_price
FROM purchase_order_detail
ORDER BY pod_quantity ASC
LIMIT 5;

-- 7
SELECT pr_id, pr_date
FROM purchase_requisition
WHERE YEAR(pr_date) < 2020
ORDER BY pr_date DESC;

-- 8
SELECT prod_id, prod_name FROM product
WHERE prod_status = 'U';

-- 9
SELECT sup_id, sup_status, sup_rating
FROM supplier
WHERE sup_status = 'S' AND sup_rating > 3;

-- 10
SELECT po_id, pod_num, pod_quantity, pod_price 
FROM purchase_order_detail
WHERE pod_quantity < 5;

-- 11 
SELECT prd_category, COUNT(prd_quantity) AS 'all request quantity'
FROM purchase_requisition_detail
GROUP by prd_category
order by pr_id ASC;

-- 12
SELECT pr_id, pr_shipcost, pr_tax
FROM purchase_requisition
WHERE pr_note IS NULL AND pr_tax IS NOT NULL AND pr_shipcost > 40;

-- 13
SELECT pr_id, prd_num, prd_budget, prd_quantity, prd_category
FROM purchase_requisition_detail
WHERE prd_category = 'Ingredient';

-- 14
SELECT emp_id, UPPER(emp_fname), UPPER(emp_lname)
FROM employee
WHERE emp_fname LIKE 'A%';

-- 15
SELECT prod_id, prod_name
FROM product
WHERE prod_name LIKE 'M%';

-- 16 
SELECT pr_id, prd_category, prod.prod_id, LOWER(prod_name)
FROM purchase_requisition_detail prd
INNER JOIN product prod ON prd.prod_id = prod.prod_id
ORDER BY prd_category ASC;

-- 17 
SELECT pr_id, pr_shipaddress
FROM purchase_requisition
WHERE pr_shipaddress LIKE '%Bkk%';

-- Advanced queries--
-- 1 
SELECT pr.emp_id, UPPER(CONCAT(emp_fname,' ',emp_lname)) AS emp_name, dep_name, COUNT(pr.pr_id) as 'number of requirements'
FROM purchase_requisition pr
INNER JOIN employee e ON pr.emp_id = e.emp_id
INNER JOIN department d ON e.dep_id = d.dep_id
GROUP BY pr.emp_id;
-- count num of r of each emp

-- 2
SELECT prod_name AS 'name', g.prod_id AS ID, prod_description AS 'description'
FROM goods g
LEFT OUTER JOIN product prod ON g.prod_id = prod.prod_id
WHERE prod_status = 'S' AND prod_description IS NOT NULL
UNION ALL
SELECT prod_name AS 'name', s.prod_id AS ID, prod_description AS 'description'
FROM services s
LEFT OUTER JOIN product prod ON s.prod_id = prod.prod_id
WHERE prod_status = 'S' AND prod_description IS NOT NULL;

-- 3
-- find num of r each dep 
SELECT dep_name, COUNT(pr.pr_id) as 'number of requirements'
FROM purchase_requisition pr
INNER JOIN employee e ON pr.emp_id = e.emp_id
INNER JOIN department d ON e.dep_id = d.dep_id
GROUP BY d.dep_id;

-- 4
-- max q of each cator
select prd_category, pr.emp_id, d.dep_name, max(prd_quantity), prd.prod_id
from purchase_requisition_detail prd
LEFT OUTER JOIN purchase_requisition pr ON prd.pr_id = pr.pr_id
LEFT OUTER JOIN product p ON p.prod_id = prd.prod_id
LEFT OUTER JOIN employee e ON pr.emp_id = e.emp_id
LEFT OUTER JOIN department d ON e.dep_id = d.dep_id
GROUP BY prd_category;

-- 5
SELECT pr.emp_id, CONCAT(emp_fname,' ',emp_lname) AS emp_name, dep_name, prd.pr_id, prd.prd_num, prd.prd_category
FROM purchase_requisition_detail prd
INNER JOIN purchase_requisition pr ON prd.pr_id = pr.pr_id
INNER JOIN employee e ON pr.emp_id = e.emp_id
INNER JOIN department d ON e.dep_id = d.dep_id
WHERE prd.pr_id NOT IN (SELECT pod.pr_id FROM purchase_order_detail pod);

-- 6
SELECT pod.po_id, pod.pod_num, po.po_deldate, prd.prod_id, p.prod_name, po.sup_id, s.sup_comname
FROM purchase_order po
INNER JOIN purchase_order_detail pod ON pod.po_id = po.po_id
LEFT OUTER JOIN purchase_requisition_detail prd ON pod.pr_id = prd.pr_id AND pod.prd_num = prd.prd_num
LEFT OUTER JOIN product p ON prd.prod_id = p.prod_id
LEFT OUTER JOIN supplier s ON po.sup_id = s.sup_id
WHERE date(po.po_deldate) < '2019-08-01';

-- 7
SELECT pod.po_id, pod.pod_num, prod_name, prd.prod_id, pod_price, prd_budget
FROM purchase_order_detail pod
LEFT OUTER JOIN purchase_requisition_detail prd ON pod.pr_id = prd.pr_id AND pod.prd_num = prd.prd_num
LEFT OUTER JOIN product p ON prd.prod_id = p.prod_id
HAVING pod_price = prd_budget;

-- 8
SELECT prod_name, emp_id, prd_category, prd_budget
FROM purchase_requisition_detail prd1
INNER JOIN purchase_requisition pr ON prd1.pr_id = pr.pr_id
INNER JOIN product p ON prd1.prod_id = p.prod_id
WHERE prd1.prd_budget >= (SELECT AVG(prd_budget) FROM purchase_requisition_detail prd2 
						  WHERE prd1.prd_category = prd2.prd_category GROUP BY prd2.prd_category)
ORDER BY prd_category ASC;

-- 9
SELECT prd_category, MAX(prd_budget), CONCAT(emp_fname,' ',emp_lname) AS emp_name, dep_name
FROM purchase_requisition_detail prd
INNER JOIN purchase_requisition pr ON prd.pr_id = pr.pr_id
INNER JOIN employee e ON pr.emp_id = e.emp_id
INNER JOIN department d ON e.dep_id = d.dep_id
group by prd_category
ORDER BY MAX(prd_budget) DESC;

-- 10
SELECT po.sup_id, sup_address, po.po_id, pod_num, prod_id, po_shipaddress
FROM purchase_order po
INNER JOIN purchase_order_detail pod ON po.po_id = pod.po_id
INNER JOIN purchase_requisition_detail prd ON pod.pr_id = prd.pr_id AND pod.prd_num = prd.prd_num
INNER JOIN supplier s ON po.sup_id = s.sup_id
WHERE (sup_address LIKE '%Bkk%' OR sup_address LIKE '%Bangkok%') AND po_shipaddress NOT IN (SELECT po_shipaddress FROM purchase_order
																							WHERE po_shipaddress LIKE '%Bkk%' OR po_shipaddress LIKE '%Bangkok%')
ORDER BY po_id ASC;

-- 11
SELECT po.emp_id, CONCAT(emp_fname,' ',emp_lname) AS emp_name, sup_comname, po_shipcost, po_shipaddress, sup_address
FROM purchase_order po
INNER JOIN supplier s ON po.sup_id = s.sup_id
INNER JOIN employee e ON po.emp_id = e.emp_id
WHERE po_shipcost = '0.00'  AND (po_shipaddress LIKE '%Bkk%' OR po_shipaddress LIKE '%Bangkok%');

-- 12
SELECT DISTINCT po_id, s.sup_id, sup_comname, po.emp_id, dep_name
FROM purchase_order po
LEFT OUTER JOIN supplier s ON po.sup_id = s.sup_id
LEFT OUTER JOIN employee e ON po.emp_id = e.emp_id
LEFT OUTER JOIN department d ON e.dep_id = d.dep_id
WHERE po.sup_id IS NOT NULL AND po_id NOT IN (SELECT DISTINCT po_id FROM purchase_order_detail)
ORDER BY po_id ASC;

-- 13
SELECT p.prod_id, prod_name, prod_description
FROM goods g
LEFT OUTER JOIN product p ON p.prod_id = g.prod_id
LEFT OUTER JOIN services s ON p.prod_id = s.prod_id
LEFT OUTER JOIN purchase_requisition_detail prd ON p.prod_id = prd.prod_id
WHERE prd.pr_id IS NULL
UNION ALL
SELECT p.prod_id, prod_name, prod_description
FROM services s
LEFT OUTER JOIN product p ON p.prod_id = s.prod_id
LEFT OUTER JOIN purchase_requisition_detail prd ON p.prod_id = prd.prod_id
WHERE prd.pr_id IS NULL;

-- 14
SELECT pr.pr_id, pr_date, po.po_id, pod.pod_num, po_deldate
FROM purchase_requisition pr 
INNER JOIN purchase_requisition_detail prd ON pr.pr_id = prd.pr_id
INNER JOIN purchase_order_detail pod ON prd.pr_id = pod.pr_id AND prd.prd_num = pod.prd_num
INNER JOIN purchase_order po ON pod.po_id = po.po_id
WHERE year(pr.pr_date) - year(po.po_deldate) <> 0 ;

-- 15
SELECT sup_id, sup_rep, sup_comname, sup_description
FROM supplier 
WHERE sup_id NOT IN (SELECT DISTINCT s.sup_id FROM supplier s 
					LEFT OUTER JOIN purchase_order po ON s.sup_id = po.sup_id
					LEFT OUTER JOIN purchase_order_detail pod ON po.po_id = pod.po_id
					LEFT OUTER JOIN purchase_requisition_detail prd ON prd.pr_id = pod.pr_id AND prd.prd_num = pod.prd_num
					LEFT OUTER JOIN purchase_requisition pr ON prd.pr_id = pr.pr_id
					LEFT OUTER JOIN employee e ON pr.emp_id = e.emp_id
					LEFT OUTER JOIN department d ON e.dep_id = d.dep_id
					WHERE d.dep_id = '111222166');





