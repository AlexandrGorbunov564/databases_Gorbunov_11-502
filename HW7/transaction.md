1. BEGIN ... COMMIT

1.1. Добавление нового студента и изменение формы обучения его группы
```sql
BEGIN;
INSERT INTO student (studentId, FCs, academicGroup) VALUES (126, 'Алексей Петров', '11-502');
UPDATE academic_group SET formOfStudy = 'Очно-заочная' WHERE numberOfGroup = '11-502';
COMMIT;
```
![Результат INSERT](images/screen1.jpg)
![Результат UPDATE](images/screen2.jpg)

1.2. Добавление нового преподавателя и изменение факультета его кафедры
```sql
BEGIN;
INSERT INTO teacher (passport, FCs, departmentName, post)VALUES (123469, 'Соколов Андрей Викторович', 'Кафедра баз данных', 'Доцент');
UPDATE department SET facultyName = 'ИВМиИТ' WHERE nameOfDepartment = 'Кафедра баз данных';
COMMIT;
```
![Результат INSERT](images/screen3.jpg)
![Результат UPDATE](images/screen4.jpg)

2. BEGIN ... ROLLBACK

2.1. Добавление нового студента и изменение формы обучения его группы с ROLLBACK
```sql
BEGIN;
INSERT INTO student (studentId, FCs, academicGroup) VALUES (127, 'Александр Иванов', '11-502');
UPDATE academic_group SET formOfStudy = 'Заочная' WHERE numberOfGroup = '11-502';
ROLLBACK;
```
![Результат INSERT](images/screen5.jpg)
![Результат UPDATE](images/screen6.jpg)

2.2. Добавление нового преподавателя и изменение факультета его кафедры с ROLLBACK
```sql
BEGIN;
INSERT INTO teacher (passport, FCs, departmentName, post)VALUES (123654, 'Соколов Андрей Викторович', 'Кафедра баз данных', 'Доцент');
UPDATE department SET facultyName = 'ИВМиИТ' WHERE nameOfDepartment = 'Кафедра баз данных';
ROLLBACK;
```
![Результат INSERT](images/screen7.jpg)
![Результат UPDATE](images/screen8.jpg)

3. Транзакция с ошибкой

3.1. Поменять курс группы на недопустимый
```sql
BEGIN;
INSERT INTO student (studentId, FCs, academicGroup) VALUES (900001, 'Тестовый Студент', '11-502');
UPDATE academic_group SET course = 5 WHERE numberOfGroup = '11-502';
```
![Результат выполнения запроса](images/screen9.jpg)
![Студент не добавился, хотя INSERT выполнился до ошибки](images/screen10.jpg)

3.2. Получить названия дисциплин и формы аттестации на русском
```sql
BEGIN;
INSERT INTO discipline (disciplineName, intensity, certificationForm) VALUES ('Тестовая дисциплина', 100, 'Зачёт');
UPDATE discipline SET intensity = intensity / 0 WHERE disciplineName = 'Тестовая дисциплина';
```
![Результат выполнения запроса](images/screen11.jpg)
![Дисциплина не добавилась, хотя INSERT выполнился до ошибки](images/screen12.jpg)

4. Грязное чтение

4.1. Запустил 2 транзакцию до завершения 1 на таблице discipline
```sql
BEGIN;
UPDATE discipline SET intensity = 999 WHERE disciplineName = 'Алгебра';
```
![В консоли указано, что строка обновлена](images/screen13.jpg)

```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![Запрос читает старые данные](images/screen14.jpg)

4.2. Запустил 2 транзакцию до завершения 1 на таблице teacher
```sql
BEGIN;
UPDATE teacher SET post = 'Профессор' WHERE passport = 123456;
```
![В консоли указано, что строка обновлена](images/screen15.jpg)

```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Запрос читает старые данные](images/screen16.jpg)

5. UPDATE без COMMIT в T1 и чтение в T2

5.1. Запустил 2 транзакцию до завершения 1 на таблице teacher, теперь уровень изоляции READ COMMITTED
```sql
BEGIN;
UPDATE teacher SET post = 'Профессор' WHERE passport = 123456;
```
![В консоли указано, что строка обновлена](images/screen17.jpg)

```sql
BEGIN;
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Запрос читает старые данные](images/screen18.jpg)

5.2. Запустил 2 транзакцию до завершения 1 на таблице discipline, теперь уровень изоляции READ COMMITTED
```sql
BEGIN;
UPDATE discipline SET intensity = 999 WHERE disciplineName = 'Алгебра';
```
![В консоли указано, что строка обновлена](images/screen19.jpg)

```sql
BEGIN;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![Запрос читает старые данные](images/screen20.jpg)

6. READ COMMITTED

6.1. На таблице teacher
```sql
BEGIN;
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![До выполнения 2 транзакции](images/screen21.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
UPDATE teacher SET post = 'Профессор' WHERE passport = 123456;
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Запрос читает обновлённые данные](images/screen22.jpg)

6.2. На таблице discipline
```sql
BEGIN;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![До выполнения 2 транзакции](images/screen23.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
UPDATE discipline SET intensity = 300 WHERE disciplineName = 'Алгебра';
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![Запрос читает обновлённые данные](images/screen24.jpg)

7. T1 не видит изменений от T2, пока не завершится

7.1. На таблице discipline
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![До выполнения 2 транзакции](images/screen25.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
UPDATE discipline SET intensity = 500 WHERE disciplineName = 'Алгебра';
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
```
![Запрос всё ещё читает то же самое](images/screen25.jpg)
![После COMMIT в 1 транзакции тот же SELECT читает обновлённые данные](images/screen26.jpg)

7.2. На таблице teacher
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![До выполнения 2 транзакции](images/screen27.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
UPDATE teacher SET post = 'Старший преподаватель' WHERE passport = 123456;
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Запрос всё ещё читает то же самое](images/screen27.jpg)
![После COMMIT в 1 транзакции тот же SELECT читает обновлённые данные](images/screen28.jpg)

8. Фантомное чтение через INSERT (невозможно при REPEATABLE READ?)

8.1. На таблице teacher
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT passport, FCs, departmentName, post FROM teacher WHERE departmentName = 'Кафедра алгебры';
```
![До выполнения 2 транзакции](images/screen29.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
INSERT INTO teacher (passport, FCs, departmentName, post) VALUES (123460, 'Сидоров Алексей Петрович', 'Кафедра алгебры', 'Доцент');
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT passport, FCs, departmentName, post FROM teacher WHERE departmentName = 'Кафедра алгебры';
```
![Запрос всё ещё читает то же самое, фантомное чтение на этом кровне изоляции невозможно, в презентации ошибка](images/screen29.jpg)
![После COMMIT в 1 транзакции тот же SELECT читает обновлённые данные](images/screen30.jpg)

8.2. На таблице student
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT studentId, FCs, academicGroup FROM student WHERE academicGroup = '11-502';
```
![До выполнения 2 транзакции](images/screen31.jpg)

Это выполняется во 2 транзакции
```sql
BEGIN;
INSERT INTO student (studentId, FCs, academicGroup) VALUES (136, 'Алексей Смирнов', '11-502');
COMMIT;
```
Это снова в 1 после завершения 2 транзакции
```sql
SELECT studentId, FCs, academicGroup FROM student WHERE academicGroup = '11-502';
```
![Запрос всё ещё читает то же самое](images/screen31.jpg)
![После COMMIT в 1 транзакции тот же SELECT читает обновлённые данные](images/screen32.jpg)

9. Две транзакции вставляют одинаковые данные

9.1. На таблице teacher
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO teacher (passport, FCs, departmentName, post) VALUES (777777, 'Тестовый Преподаватель', 'Кафедра алгебры', 'Доцент');
```

То же самое выполняется во 2 транзакции
![2 транзакция ждёт завершения 1](images/screen33.jpg)
![После COMMIT в 1 транзакции 2 транзакция выдаёт ошибку](images/screen34.jpg)

9.2. На таблице student
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO student (studentId, FCs, academicGroup) VALUES (999, 'Тестовый Студент', '11-502');
```

То же самое выполняется во 2 транзакции
![2 транзакция ждёт завершения 1](images/screen33.jpg)
![После COMMIT в 1 транзакции 2 транзакция выдаёт ошибку](images/screen36.jpg)


10. could not serialize access due to concurrent update

10.1. На таблице teacher
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE teacher SET post = 'Доцент' WHERE passport = 123456;
```

Во 2 транзакции выполняется то же самое, но со значением Профессор
![2 транзакция ждёт завершения 1](images/screen33.jpg)
![После COMMIT в 1 транзакции 2 транзакция выдаёт ошибку](images/screen37.jpg)

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE teacher SET post = 'Профессор' WHERE passport = 123456;
COMMIT;
```
![После ROLLBACK можно выполнить новое изменение](images/screen38.jpg)

10.1. На таблице discipline
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
UPDATE discipline SET intensity = 300 WHERE disciplineName = 'Алгебра';
```

Во 2 транзакции выполняется то же самое, но со значением 400
![2 транзакция ждёт завершения 1](images/screen33.jpg)
![После COMMIT в 1 транзакции 2 транзакция выдаёт ошибку](images/screen39.jpg)

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT disciplineName, intensity FROM discipline WHERE disciplineName = 'Алгебра';
UPDATE discipline SET intensity = 400 WHERE disciplineName = 'Алгебра';
COMMIT;
```
![После ROLLBACK можно выполнить новое изменение](images/screen40.jpg)
11. SAVEPOINT

11.1. Изменить трудоёмкость дисциплины, создать точку сохранения, затем изменить форму аттестации. Откатиться к точке сохранения
```sql
BEGIN;
UPDATE discipline SET intensity = 150 WHERE disciplineName = 'Экономика';

SAVEPOINT sp1;

UPDATE discipline SET certificationForm = 'Экзамен' WHERE disciplineName = 'Экономика';

ROLLBACK TO SAVEPOINT sp1;

SELECT disciplineName, intensity, certificationForm FROM discipline WHERE disciplineName = 'Экономика';
COMMIT;
```
![Изменение после точки сохранения откатилось, а до точки - осталось](images/screen41.jpg)

11.2. Несколько раз изменить должность преподавателя, создавая точки сохранения. Сначала вернуться ко второй точке, затем к первой
```sql
BEGIN;
UPDATE teacher SET post = 'Доцент' WHERE passport = 123456;

SAVEPOINT sp1;

UPDATE teacher SET post = 'Профессор' WHERE passport = 123456;

SAVEPOINT sp2;

UPDATE teacher SET post = 'Заведующий кафедрой' WHERE passport = 123456;
```

Затем возвращаемся ко 2 точке
```sql
ROLLBACK TO SAVEPOINT sp2;

SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Результат выполнения запроса](images/screen42.jpg)

Теперь возвращаемся к 1
```sql
ROLLBACK TO SAVEPOINT sp1;

SELECT passport, FCs, post FROM teacher WHERE passport = 123456;
```
![Результат выполнения запроса](images/screen43.jpg)
