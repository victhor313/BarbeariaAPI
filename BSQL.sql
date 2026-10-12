CREATE DATABASE  IF NOT EXISTS `barbeariatechh` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `barbeariatechh`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: barbeariatechh
-- ------------------------------------------------------
-- Server version	8.0.46


--
-- Table structure for table `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos` (
  `id_agendamento` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `id_barbeiro` int NOT NULL,
  `id_servico` int NOT NULL,
  `data_agendamento` date NOT NULL,
  `hora_agendamento` time NOT NULL,
  `status_agendamento` enum('AGENDADO','CONFIRMADO','CONCLUIDO','CANCELADO') DEFAULT 'AGENDADO',
  `observacoes` text,
  `data_criacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_agendamento`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_barbeiro` (`id_barbeiro`),
  KEY `id_servico` (`id_servico`),
  CONSTRAINT `agendamentos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `agendamentos_ibfk_2` FOREIGN KEY (`id_barbeiro`) REFERENCES `barbeiros` (`id_barbeiro`),
  CONSTRAINT `agendamentos_ibfk_3` FOREIGN KEY (`id_servico`) REFERENCES `servicos` (`id_servico`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos`
--

LOCK TABLES `agendamentos` WRITE;
/*!40000 ALTER TABLE `agendamentos` DISABLE KEYS */;
INSERT INTO `agendamentos` VALUES (1,1,1,3,'2026-05-10','14:00:00','AGENDADO',NULL,'2026-05-07 22:03:36'),(2,2,2,1,'2026-05-11','16:30:00','CONFIRMADO',NULL,'2026-05-07 22:03:36');
/*!40000 ALTER TABLE `agendamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `barbeiros`
--

DROP TABLE IF EXISTS `barbeiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barbeiros` (
  `id_barbeiro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `especialidade` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `status` enum('ATIVO','INATIVO') DEFAULT 'ATIVO',
  PRIMARY KEY (`id_barbeiro`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barbeiros`
--

LOCK TABLES `barbeiros` WRITE;
/*!40000 ALTER TABLE `barbeiros` DISABLE KEYS */;
INSERT INTO `barbeiros` VALUES (1,'Marcos Barber','Degrade e Navalhado','11777777777','marcos@barbearia.com','ATIVO'),(2,'Lucas Fade','Corte Social','11666666666','lucas@barbearia.com','ATIVO');
/*!40000 ALTER TABLE `barbeiros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `data_cadastro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `telefone` (`telefone`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Victhor','11954867379','victhor313@email.com','2003-01-02','2026-05-07 22:03:36'),(2,'Carlos Souza','11888888888','carlos@email.com','1998-11-20','2026-05-07 22:03:36');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamentos`
--

DROP TABLE IF EXISTS `pagamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamentos` (
  `id_pagamento` int NOT NULL AUTO_INCREMENT,
  `id_agendamento` int NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `forma_pagamento` enum('DINHEIRO','PIX','CARTAO_CREDITO','CARTAO_DEBITO') NOT NULL,
  `status_pagamento` enum('PENDENTE','PAGO') DEFAULT 'PENDENTE',
  `data_pagamento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pagamento`),
  KEY `id_agendamento` (`id_agendamento`),
  CONSTRAINT `pagamentos_ibfk_1` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamentos`
--

LOCK TABLES `pagamentos` WRITE;
/*!40000 ALTER TABLE `pagamentos` DISABLE KEYS */;
INSERT INTO `pagamentos` VALUES (1,1,55.00,'PIX','PAGO','2026-05-07 22:03:36'),(2,2,35.00,'CARTAO_CREDITO','PENDENTE','2026-05-07 22:03:36');
/*!40000 ALTER TABLE `pagamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicos`
--

DROP TABLE IF EXISTS `servicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicos` (
  `id_servico` int NOT NULL AUTO_INCREMENT,
  `nome_servico` varchar(100) NOT NULL,
  `descricao` text,
  `preco` decimal(10,2) NOT NULL,
  `duracao_minutos` int NOT NULL,
  PRIMARY KEY (`id_servico`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicos`
--

LOCK TABLES `servicos` WRITE;
/*!40000 ALTER TABLE `servicos` DISABLE KEYS */;
INSERT INTO `servicos` VALUES (1,'Corte Masculino','Corte tradicional masculino',35.00,40),(2,'Barba','Modelagem completa da barba',25.00,30),(3,'Corte + Barba','Pacote completo',55.00,60);
/*!40000 ALTER TABLE `servicos` ENABLE KEYS */;

CREATE TABLE funcionario (
    id_funcionario        SERIAL PRIMARY KEY,
    nome                  VARCHAR(100)  NOT NULL,
    cpf                   CHAR(11)      NOT NULL UNIQUE,
    rg                    VARCHAR(20),
    data_nascimento       DATE,
    telefone              VARCHAR(20),
    email                 VARCHAR(120)  UNIQUE,
    cargo                 VARCHAR(30)   NOT NULL
                          CHECK (cargo IN ('BARBEIRO', 'RECEPCIONISTA', 'GERENTE', 'AUXILIAR')),
    comissao_percentual   NUMERIC(5,2)  NOT NULL DEFAULT 0
                          CHECK (comissao_percentual BETWEEN 0 AND 100),
    salario_base          NUMERIC(10,2) NOT NULL DEFAULT 0
                          CHECK (salario_base >= 0),
    data_admissao         DATE          NOT NULL DEFAULT CURRENT_DATE,
    data_demissao         DATE,
    ativo                 BOOLEAN       NOT NULL DEFAULT TRUE,
    criado_em             TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em         TIMESTAMP,

    CONSTRAINT chk_datas_funcionario
        CHECK (data_demissao IS NULL OR data_demissao >= data_admissao),
    CONSTRAINT chk_demissao_inativo
        CHECK (ativo = TRUE OR data_demissao IS NOT NULL)
CREATE TABLE servico (
    id_servico        SERIAL PRIMARY KEY,
    nome              VARCHAR(60)   NOT NULL UNIQUE,
    descricao         VARCHAR(255),
    duracao_minutos   INT           NOT NULL CHECK (duracao_minutos > 0),
    preco             NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
    ativo             BOOLEAN       NOT NULL DEFAULT TRUE


CREATE TABLE agendamento (
    id_agendamento    SERIAL PRIMARY KEY,
    id_cliente        INT           NOT NULL REFERENCES cliente(id_cliente),
    id_funcionario    INT           NOT NULL REFERENCES funcionario(id_funcionario),
    id_servico        INT           NOT NULL REFERENCES servico(id_servico),
    data_hora_inicio  TIMESTAMP     NOT NULL,
    data_hora_fim     TIMESTAMP     NOT NULL,
    status            VARCHAR(20)   NOT NULL DEFAULT 'AGENDADO'
                      CHECK (status IN ('AGENDADO', 'CONFIRMADO', 'EM_ATENDIMENTO',
                                        'CONCLUIDO', 'CANCELADO', 'NAO_COMPARECEU')),
    valor_cobrado     NUMERIC(10,2) NOT NULL CHECK (valor_cobrado >= 0),
    observacao        VARCHAR(255),
    criado_em         TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em     TIMESTAMP,

    CONSTRAINT chk_horario_agendamento
        CHECK (data_hora_fim > data_hora_inicio)

-- Impede que o mesmo funcionário tenha dois agendamentos ativos no mesmo horário
-- (colocar no PostgreSQL com a extensão btree_gist; ver observação abaixo)
CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE agendamento
    ADD CONSTRAINT ex_agendamento_funcionario_horario
    EXCLUDE USING gist (
        id_funcionario WITH =,
        tsrange(data_hora_inicio, data_hora_fim) WITH &&
    )
    WHERE (status NOT IN ('CANCELADO', 'NAO_COMPARECEU'));

CREATE INDEX idx_agendamento_data ON agendamento (data_hora_inicio);
CREATE INDEX idx_agendamento_funcionario ON agendamento (id_funcionario, data_hora_inicio);

UNLOCK TABLES;
);
