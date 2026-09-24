CREATE TABLE university (
NameOfUniversity VARCHAR(50) PRIMARY KEY,
City VARCHAR(30)
);
INSERT INTO university (NameOfUniversity, City) VALUES ('МГУ', 'Москва');
INSERT INTO university (NameOfUniversity, City) VALUES ('КФУ', 'Казань');
INSERT INTO university (NameOfUniversity, City) VALUES ('УрФУ', 'Екатеринбург');

CREATE TABLE teacher (
Passport INT PRIMARY KEY,
FCs VARCHAR(50),
Department VARCHAR(50),
Post VARCHAR(30),
UniversityName VARCHAR(50) NOT NULL,
FOREIGN KEY (UniversityName) REFERENCES university(NameOfUniversity)
);
INSERT INTO teacher (Passport, FCs, Department, Post, UniversityName)
VALUES (123456, 'Иванов Иван Иванович', 'Кафедра программной инженерии', 'Старший преподаватель', 'КФУ');
INSERT INTO teacher (Passport, FCs, Department, Post, UniversityName)
VALUES (123457, 'Петров Леонид Георгиевич', 'Кафедра алгебры', 'Старший преподаватель', 'МГУ');
INSERT INTO teacher (Passport, FCs, Department, Post, UniversityName)
VALUES (123458, 'Смирнов Валерий Сергеевич', 'Кафедра математической статистики', 'Старший преподаватель', 'КФУ');
UPDATE teacher SET Department = 'Кафедра математического анализа' WHERE Passport = 123458;

CREATE TABLE rector (
    Passport INT PRIMARY KEY,
    FCs VARCHAR(50),
    UniversityName VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (UniversityName)
        REFERENCES university(NameOfUniversity)
);
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (111111, 'Иванов Сергей Петрович', 'КФУ');
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (222222, 'Петров Алексей Иванович', 'МГУ');
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (333333, 'Васильев Александр Сергеевич', 'УрФУ');

CREATE TABLE student (
StudentID INT PRIMARY KEY,
FCs VARCHAR(50),
Course INT CHECK (Course >= 1 AND Course <= 4),
Faculty VARCHAR(50),
UniversityName VARCHAR(50) NOT NULL,
FOREIGN KEY (UniversityName) REFERENCES university(NameOfUniversity)
);
ALTER TABLE student ADD COLUMN Speciality VARCHAR(50);
ALTER TABLE student ADD COLUMN AcademicGroup INT;
ALTER TABLE student ADD COLUMN FormOfStudy VARCHAR(50);
INSERT INTO student (StudentID, FCs, Course, Faculty, UniversityName, Speciality, AcademicGroup, FormOfStudy)
VALUES (123, 'Иван Иванов', 2, 'ИТИС', 'МГУ', 'Программная инженерия', 502, 'Очная');
INSERT INTO student (StudentID, FCs, Course, Faculty, UniversityName, Speciality, AcademicGroup, FormOfStudy)
VALUES (124, 'Олег Смирнов', 3, 'Мехмат', 'КФУ', 'Математика', 401, 'Очная');
INSERT INTO student (StudentID, FCs, Course, Faculty, UniversityName, Speciality, AcademicGroup, FormOfStudy)
VALUES (125, 'Антон Васильев', 1, 'ИВМиИТ', 'УрФУ', 'Прикладная информатика', 603, 'Заочная');
UPDATE student SET Course = 4 WHERE StudentID = 124;
UPDATE student SET Course = 2, Faculty = 'ИТИС' WHERE Speciality = 'Прикладная информатика';

CREATE TABLE discipline (
DisciplineName VARCHAR(30) PRIMARY KEY,
Intensity INT CHECK (Intensity > 0 AND Intensity <= 3000),
CertificationForm VARCHAR(20)
);
INSERT INTO discipline (DisciplineName, Intensity, CertificationForm) VALUES ('Алгебра', 256, 'Экзамен');
INSERT INTO discipline (DisciplineName, Intensity, CertificationForm) VALUES ('Экономика', 36, 'Зачёт');
INSERT INTO discipline (DisciplineName, Intensity, CertificationForm) VALUES ('Программирование', 596, 'Экзамен');

CREATE TABLE teacher_discipline (
    TeacherPassport INT,
    DisciplineName VARCHAR(30),
    PRIMARY KEY (TeacherPassport, DisciplineName),
    FOREIGN KEY (TeacherPassport) REFERENCES teacher(Passport),
	FOREIGN KEY (DisciplineName) REFERENCES discipline(DisciplineName)
);
INSERT INTO teacher_discipline (TeacherPassport, DisciplineName) VALUES (123457, 'Алгебра');
INSERT INTO teacher_discipline (TeacherPassport, DisciplineName) VALUES (123456, 'Программирование');
INSERT INTO teacher_discipline (TeacherPassport, DisciplineName) VALUES (123458, 'Алгебра');

CREATE TABLE student_discipline (
    StudentID INT,
    DisciplineName VARCHAR(30),
    PRIMARY KEY (StudentID, DisciplineName),
    FOREIGN KEY (StudentID) REFERENCES student(StudentID),
	FOREIGN KEY (DisciplineName) REFERENCES discipline(DisciplineName)
);
INSERT INTO student_discipline (StudentID, DisciplineName) VALUES (123, 'Алгебра');
INSERT INTO student_discipline (StudentID, DisciplineName) VALUES (123, 'Программирование');
INSERT INTO student_discipline (StudentID, DisciplineName) VALUES (124, 'Алгебра');
INSERT INTO student_discipline (StudentID, DisciplineName) VALUES (125, 'Программирование');