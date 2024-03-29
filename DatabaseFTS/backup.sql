USE [master]
GO
/****** Object:  Database [Blog]    Script Date: 22.03.2019 22:38:19 ******/
CREATE DATABASE [Blog]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Blog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Blog.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Blog_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Blog_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Blog] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Blog].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Blog] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Blog] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Blog] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Blog] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Blog] SET ARITHABORT OFF 
GO
ALTER DATABASE [Blog] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Blog] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Blog] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Blog] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Blog] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Blog] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Blog] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Blog] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Blog] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Blog] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Blog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Blog] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Blog] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Blog] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Blog] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Blog] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Blog] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Blog] SET RECOVERY FULL 
GO
ALTER DATABASE [Blog] SET  MULTI_USER 
GO
ALTER DATABASE [Blog] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Blog] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Blog] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Blog] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Blog] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Blog] SET QUERY_STORE = OFF
GO
USE [Blog]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Blog]
GO
/****** Object:  FullTextCatalog [ArticleCatalog]    Script Date: 22.03.2019 22:38:19 ******/
CREATE FULLTEXT CATALOG [ArticleCatalog]WITH ACCENT_SENSITIVITY = ON

GO
/****** Object:  FullTextCatalog [NewsCatalog]    Script Date: 22.03.2019 22:38:19 ******/
CREATE FULLTEXT CATALOG [NewsCatalog]WITH ACCENT_SENSITIVITY = ON

GO
/****** Object:  FullTextCatalog [RubricCatalog]    Script Date: 22.03.2019 22:38:19 ******/
CREATE FULLTEXT CATALOG [RubricCatalog]WITH ACCENT_SENSITIVITY = ON

GO
/****** Object:  Table [dbo].[Article]    Script Date: 22.03.2019 22:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Article](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FTS_Int]    Script Date: 22.03.2019 22:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FTS_Int](
	[Key] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[Query] [nvarchar](1) NOT NULL,
 CONSTRAINT [PK_FTS_Int] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 22.03.2019 22:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RubricId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Tegs] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Rubric]    Script Date: 22.03.2019 22:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rubric](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Rubric] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Article] ON 

INSERT [dbo].[Article] ([Id], [Date], [Text], [Active]) VALUES (1, CAST(N'2019-01-01T00:00:00.0000000' AS DateTime2), N'Test text', 1)
INSERT [dbo].[Article] ([Id], [Date], [Text], [Active]) VALUES (2, CAST(N'2019-02-01T00:00:00.0000000' AS DateTime2), N'article', 1)
SET IDENTITY_INSERT [dbo].[Article] OFF
SET IDENTITY_INSERT [dbo].[News] ON 

INSERT [dbo].[News] ([Id], [RubricId], [DateTime], [Text], [Tegs]) VALUES (1, 1, CAST(N'2018-01-01T00:00:00.000' AS DateTime), N'Продукты HFLabs в промышленных объемах обрабатывают данные: адреса, ФИО, реквизиты компаний и еще вагон всего. Естественно, тестировщики ежедневно с этими данными имеют дело: обновляют тест-кейсы, изучают результаты очистки. Часто заказчики дают «живую» базу, чтобы тестировщик настроил сервис под нее.

Первое, чему мы учим новых QA — сохранять данные в первозданном виде. Все по заветам: «Не навреди». В статье я расскажу, как аккуратно работать с CSV-файлами в Excel и Open Office. Советы помогут ничего не испортить, сохранить информацию после редактирования и в целом чувствовать себя увереннее.

Материал базовый, профессионалы совершенно точно заскучают.', N'Блог компании HFLabs,IT-стандарты,Информационная безопасность,Софт,Хранение данных')
INSERT [dbo].[News] ([Id], [RubricId], [DateTime], [Text], [Tegs]) VALUES (2, 1, CAST(N'2018-02-01T00:00:00.000' AS DateTime), N'Завтра в 12:00 по московскому времени будет запущена новая лаборатория тестирования на проникновение «Test lab 12», представляющая собой копию реальной корпоративной сети с присущими ей уязвимостями и ошибками конфигурации. На сайте лаборатории уже зарегистрировано 25 000 участников, среди которых ведущие специалисты в области информационной безопасности крупнейших российских и международных компаний.

Ниже представлена информация о составе новой лаборатории, примеры поиска и эксплуатации уязвимостей и материал для подготовки.', N'Блог компании Pentestit,
Информационная безопасность')
INSERT [dbo].[News] ([Id], [RubricId], [DateTime], [Text], [Tegs]) VALUES (3, 1, CAST(N'2018-03-01T00:00:00.000' AS DateTime), N'Несколько дней назад я впервые запустил калькулятор на новом телефоне и увидел такое сообщение: «Калькулятор хотел бы получить доступ к вашим контактам».', N'Блог компании RUVDS.com,
JavaScript,
Node.JS,
Информационная безопасность,
Разработка веб-сайтов')
INSERT [dbo].[News] ([Id], [RubricId], [DateTime], [Text], [Tegs]) VALUES (4, 1, CAST(N'2018-03-01T00:00:00.000' AS DateTime), N'Новое исследование, проведенное компанией Honeywell, показало, что съемные USB-носители «внезапно» представляют угрозу, описываемую как «значительную и преднамеренную», для защиты промышленных сетей управления технологическими процессами.





В отчете сообщается, что на 44% проанализированных USB-накопителей был выявлен и заблокирован по крайней мере один файл, угрожавший безопасности.', N'Блог компании Devicelock DLP,
Информационная безопасность')
SET IDENTITY_INSERT [dbo].[News] OFF
SET IDENTITY_INSERT [dbo].[Rubric] ON 

INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (1, N'Информационная безопасность')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (2, N'Научно-популярное')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (3, N'Карьера в IT-индустрии')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (4, N'Разработка игр')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (5, N'Управление персоналом')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (6, N'Программирование')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (7, N'DIY или Сделай сам')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (8, N'Разработка веб-сайтов')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (9, N'Управление проектами')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (10, N'Космонавтика')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (11, N'Игры и игровые приставки')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (12, N'Здоровье гика')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (13, N'JavaScript')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (14, N'Искусственный интеллект')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (15, N'IT-инфраструктура')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (16, N'Машинное обучение')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (17, N'Конференции')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (18, N'IT-компании')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (19, N'Будущее здесь')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (20, N'Open source')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (21, N'Законодательство в IT')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (22, N'Разработка мобильных приложений')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (23, N'Читальный зал')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (24, N'Математика')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (25, N'Гаджеты')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (26, N'История IT')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (27, N'Системное программирование')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (28, N'Высокая производительность')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (29, N'Управление разработкой')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (30, N'Лазеры')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (31, N'Транспорт будущего')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (32, N'Дизайн игр')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (33, N'Экология')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (34, N'Электроника для начинающих')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (35, N'Разработка под Android')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (36, N'Старое железо')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (37, N'Работа с 3D-графикой')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (38, N'Алгоритмы')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (39, N'Системное администрирование')
INSERT [dbo].[Rubric] ([Id], [Name]) VALUES (40, N'Физика')
SET IDENTITY_INSERT [dbo].[Rubric] OFF
/****** Object:  Index [IX_FK_NewsRubric]    Script Date: 22.03.2019 22:38:19 ******/
CREATE NONCLUSTERED INDEX [IX_FK_NewsRubric] ON [dbo].[News]
(
	[RubricId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_NewsRubric] FOREIGN KEY([RubricId])
REFERENCES [dbo].[Rubric] ([Id])
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_NewsRubric]
GO
USE [master]
GO
ALTER DATABASE [Blog] SET  READ_WRITE 
GO
