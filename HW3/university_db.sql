CREATE TABLE university (
NameOfUniversity VARCHAR(50) PRIMARY KEY,
City VARCHAR(30)
);
INSERT INTO university (NameOfUniversity, City) VALUES ('МГУ', 'Москва');
INSERT INTO university (NameOfUniversity, City) VALUES ('КФУ', 'Казань');
INSERT INTO university (NameOfUniversity, City) VALUES ('УрФУ', 'Екатеринбург');

CREATE TABLE faculty (
NameOfFaculty VARCHAR(50) PRIMARY KEY,
UniversityName VARCHAR(50) NOT NULL,
FOREIGN KEY (UniversityName) REFERENCES university(NameOfUniversity)
);
INSERT INTO faculty (NameOfFaculty, UniversityName) VALUES ('Мехмат', 'МГУ');
INSERT INTO faculty (NameOfFaculty, UniversityName) VALUES ('ИТИС', 'КФУ');
INSERT INTO faculty (NameOfFaculty, UniversityName) VALUES ('ИВМиИТ', 'КФУ');

CREATE TABLE department (
NameOfDepartment VARCHAR(50) PRIMARY KEY,
FacultyName VARCHAR(50) NOT NULL,
FOREIGN KEY (FacultyName) REFERENCES faculty(NameOfFaculty)
);
INSERT INTO department (NameOfDepartment, FacultyName) VALUES ('Кафедра программной инженерии', 'ИТИС');
INSERT INTO department (NameOfDepartment, FacultyName) VALUES ('Кафедра алгебры', 'Мехмат');
INSERT INTO department (NameOfDepartment, FacultyName) VALUES ('Кафедра прикладной информатики', 'ИВМиИТ');

CREATE TABLE speciality (
NameOfSpeciality VARCHAR(50) PRIMARY KEY,
FacultyName VARCHAR(50) NOT NULL,
FOREIGN KEY (FacultyName) REFERENCES faculty(NameOfFaculty)
);
INSERT INTO speciality (NameOfSpeciality, FacultyName) VALUES ('Программная инженерия', 'ИТИС');
INSERT INTO speciality (NameOfSpeciality, FacultyName) VALUES ('Математика', 'Мехмат');
INSERT INTO speciality (NameOfSpeciality, FacultyName) VALUES ('Прикладная информатика', 'ИВМиИТ');

CREATE TABLE academic_group (
NumberOfGroup VARCHAR(20) PRIMARY KEY,
SpecialityName VARCHAR(50) NOT NULL,
Course INT CHECK (Course >= 1 AND Course <= 4),
FOREIGN KEY (SpecialityName) REFERENCES speciality(NameOfSpeciality)
);
ALTER TABLE academic_group ADD COLUMN FormOfStudy VARCHAR(20);
INSERT INTO academic_group (NumberOfGroup, SpecialityName, Course, FormOfStudy) VALUES ('11-502', 'Программная инженерия', 2, 'Очная');
INSERT INTO academic_group (NumberOfGroup, SpecialityName, Course, FormOfStudy) VALUES ('23-А51', 'Математика', 4, 'Очная');
INSERT INTO academic_group (NumberOfGroup, SpecialityName, Course, FormOfStudy) VALUES ('10-602', 'Прикладная информатика', 2, 'Заочная');


CREATE TABLE teacher (
Passport INT PRIMARY KEY,
FCs VARCHAR(50),
DepartmentName VARCHAR(50) NOT NULL,
FOREIGN KEY (DepartmentName) REFERENCES department(NameOfDepartment)
);
ALTER TABLE teacher ADD COLUMN Post VARCHAR(30);
INSERT INTO teacher (Passport, FCs, DepartmentName, Post) VALUES (123456, 'Иванов Иван Иванович', 'Кафедра программной инженерии', 'Старший преподаватель');
INSERT INTO teacher (Passport, FCs, DepartmentName, Post) VALUES (123457, 'Петров Леонид Георгиевич', 'Кафедра алгебры', 'Старший преподаватель');
INSERT INTO teacher (Passport, FCs, DepartmentName, Post) VALUES (123458, 'Смирнов Валерий Сергеевич', 'Кафедра прикладной информатики', 'Старший преподаватель');
UPDATE teacher SET Post = 'Заведующий кафедрой' WHERE Passport = 123458;

CREATE TABLE rector (
Passport INT PRIMARY KEY,
FCs VARCHAR(50),
UniversityName VARCHAR(50) UNIQUE NOT NULL,
FOREIGN KEY (UniversityName) REFERENCES university(NameOfUniversity)
);
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (111111, 'Иванов Сергей Петрович', 'КФУ');
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (222222, 'Петров Алексей Иванович', 'МГУ');
INSERT INTO rector (Passport, FCs, UniversityName) VALUES (333333, 'Васильев Александр Сергеевич', 'УрФУ');

CREATE TABLE student (
StudentID INT PRIMARY KEY,
FCs VARCHAR(50),
AcademicGroup VARCHAR(20) NOT NULL,
FOREIGN KEY (AcademicGroup) REFERENCES academic_group(NumberOfGroup)
);
INSERT INTO student (StudentID, FCs, AcademicGroup) VALUES (123, 'Иван Иванов', '11-502');
INSERT INTO student (StudentID, FCs, AcademicGroup) VALUES (124, 'Олег Смирнов', '23-А51');
INSERT INTO student (StudentID, FCs, AcademicGroup) VALUES (125, 'Антон Васильев', '10-602');
UPDATE student SET FCs = 'Николай Сидоров' WHERE StudentID = 124;
UPDATE student SET FCs = 'Сергей Корнилов' WHERE AcademicGroup = '10-602';

CREATE TABLE discipline (
DisciplineName VARCHAR(30) PRIMARY KEY,
Intensity INT CHECK (Intensity > 0 AND Intensity <= 3000)
);
ALTER TABLE discipline ADD COLUMN CertificationForm VARCHAR(20);
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