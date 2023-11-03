CREATE DATABASE MOLINARO;
USE MOLINARO;
-- Molinaro Receipts
CREATE TABLE emp (
  empno decimal(4,0) NOT NULL,
  ename varchar(10) default NULL,
  job varchar(9) default NULL,
  mgr decimal(4,0) default NULL,
  hiredate date default NULL,
  sal decimal(7,2) default NULL,
  comm decimal(7,2) default NULL,
  deptno decimal(2,0) default NULL
);
--
CREATE TABLE dept (
  deptno decimal(2,0) default NULL,
  dname varchar(14) default NULL,
  loc varchar(13) default NULL
);
--
CREATE TABLE emp_bonus (
  empno decimal(4,0) NOT NULL,
  received date default null,
  TYPE DECIMAL(2,0) default NULL
  );
--
INSERT INTO emp VALUES ('7369','SMITH','CLERK','7902','1980-12-17','800.00',NULL,'20');
INSERT INTO emp VALUES ('7499','ALLEN','SALESMAN','7698','1981-02-20','1600.00','300.00','30');
INSERT INTO emp VALUES ('7521','WARD','SALESMAN','7698','1981-02-22','1250.00','500.00','30');
INSERT INTO emp VALUES ('7566','JONES','MANAGER','7839','1981-04-02','2975.00',NULL,'20');
INSERT INTO emp VALUES ('7654','MARTIN','SALESMAN','7698','1981-09-28','1250.00','1400.00','30');
INSERT INTO emp VALUES ('7698','BLAKE','MANAGER','7839','1981-05-01','2850.00',NULL,'30');
INSERT INTO emp VALUES ('7782','CLARK','MANAGER','7839','1981-06-09','2450.00',NULL,'10');
INSERT INTO emp VALUES ('7788','SCOTT','ANALYST','7566','1982-12-09','3000.00',NULL,'20');
INSERT INTO emp VALUES ('7839','KING','PRESIDENT',NULL,'1981-11-17','5000.00',NULL,'10');
INSERT INTO emp VALUES ('7844','TURNER','SALESMAN','7698','1981-09-08','1500.00','0.00','30');
INSERT INTO emp VALUES ('7876','ADAMS','CLERK','7788','1983-01-12','1100.00',NULL,'20');
INSERT INTO emp VALUES ('7900','JAMES','CLERK','7698','1981-12-03','950.00',NULL,'30');
INSERT INTO emp VALUES ('7902','FORD','ANALYST','7566','1981-12-03','3000.00',NULL,'20');
INSERT INTO emp VALUES ('7934','MILLER','CLERK','7782','1982-01-23','1300.00',NULL,'10');
-- 
INSERT INTO dept VALUES ('10','ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES ('20','RESEARCH','DALLAS');
INSERT INTO dept VALUES ('30','SALES','CHICAGO');
INSERT INTO dept VALUES ('40','OPERATIONS','BOSTON');
--
INSERT INTO emp_bonus VALUES (7934,'2005-04-17',1);
INSERT INTO emp_bonus VALUES (7934,'2005-02-15',2);
INSERT INTO emp_bonus VALUES (7839,'2005-02-15',3);
INSERT INTO emp_bonus VALUES (7782,'2005-02-15',1);
INSERT INTO emp_bonus VALUES (7369,'2005-04-14',1);
INSERT INTO emp_bonus VALUES (7900,'2005-04-14',2);
INSERT INTO emp_bonus VALUES (7788,'2005-04-14',3);
-- -------------------------------------------------------------------------------
-- ГЛ. 1. Извлечение записей 
SELECT E.*, E.JOB AS PROFESSION
FROM EMP E
WHERE DEPTNO=10
OR COMM IS NOT NULL
OR SAL<=2000 AND DEPTNO=20;
-- Конкатенация
select concat(ename, ' works as a ',job) as msg
from emp
where deptno=10;
-- Условная логика
select ename,sal,
	case when sal <= 2000 then 'UNDERPAID'
		when sal >= 4000 then 'OVERPAID'
		else 'ОК'
	end as status
from emp; 
-- ограничение объема вывода
select *
from emp limit 5;
-- рандомный вывод
select ename,job
from emp
order by rand() limit 5; 
-- заполнение null
select *, coalesce(comm,0)
from emp;
-- поиск по шаблону
select ename, job
from emp
where deptno in (10, 20)
and (ename like '%I%' or job like '%ER');
-- -------------------------------------------------------------------------------
-- ГЛ. 2. Сортировка результатов запроса
-- в порядке возрастания
select ename,job,sal 
from emp
where deptno=10
order by sal asc;
-- в порядке убывания
select ename,job,sal 
from emp
where deptno=10
order by 3 desc;
-- сортировка по нескольким столбцам
select empno,deptno,sal,ename,job
from emp
order by deptno, sal desc;
-- сортировка по подстрокам (по последним двум сиволам job)
select ename,job
from emp
order by substr(job,length(job)-1);
-- обработка null
select ename, sal, comm
from emp
order by 3;
/* ЗНАЧЕНИЯ HE-NULL СТОЛБЦА СОММ СОРТИРУЮТСЯ ПО ВОЗРАСТАНИЮ,
ВСЕ ЗНАЧЕНИЯ NULL РАЗМЕШАЮТСЯ В КОНЦЕ СПИСКА */ 
select ename,sal,comm
from (
select ename,sal,comm,
	case when comm is null then 0 else 1 end as is_null
	from emp
	) x
order by is_null desc, comm;
/* ЗНАЧЕНИЯ HE-NULL СТОЛБЦА СОММ СОРТИРУЮТСЯ ПО УБЫВАНИЮ,
ВСЕ ЗНАЧЕНИЯ NULL РАЗМЕЩАЮТСЯ В КОНЦЕ СПИСКА*/ 
select ename,sal,comm
from (
select ename,sal,comm,
	case when comm is null then 0 else 1 end as is_null
from emp
	) x
order by is_null desc,comm desc; 
-- сортировка по ключу, зависящему от данных
select ename,sal,job,comm
from emp
order by case when job = 'SALESMAN' then comm else sal end;
-- -------------------------------------------------------------------------------
-- ГЛ. 3. Работа с несколькими таблицами
-- 1. Размещение 1 набор данных под другим
-- Требуется возвратить данные нескольких таблиц, разместив одно результирующее множество над другим. 
select ename as ename_and_dname, deptno
from emp
where deptno=10
union all
	(select '----------', null)
union all
	(select dname, deptno from dept);
--
-- 2. Объединение взаимосвязанных таблиц с помощью WHERE
-- надо извлечь имена всех сотрудников отдела 1О вместе с местонахождением отдела каждого сотрудника, но эти данные хранятся в двух разных таблицах.
select e.ename, d.loc
from emp e, dept d
where e.deptno = d.deptno
and e.deptno = 10; 
-- это решение - пример операции эквиобъединения (equi-join), которая является разновидностью inner join. Операция объединения объединяет строки из двух таблиц в одну. А операция эквиобъединения объединяет строки по критерию условия объединения - например, равенства. 
-- эквивалентное решение join'ом
select e.ename, d.loc
from emp e inner join dept d
on (e.deptno = d.deptno)
where e.deptno = 10;
--
-- 3. Поиск строк с общими данными в двух таблицах
-- Требуется найти и объединить строки с одинаковыми даными в двух таблицах, но объединение необходимо выполнить по нескольким столбцам. 
create view V
as
select ename,job,sal
from emp
where job = 'CLERK';

select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e, V v
where e.ename = v.ename
and e.job=v.Job
and e.sal=v.sal;
-- 
-- 4. Извлечение из одной таблицы значений, отсутствующих в другой 
-- Требуется найти в одной таблице (назовем ее исходной) значения, которых нет в другой (которую назовем таблицей назначения). Например, в исходной таблице DEPT нужно найти отделы, которых нет в таблице назначения ЕМР. Так, таблица DEPT содержит отдел 40, которого нет в таблице ЕМР.
select deptno
from dept
where deptno not in (select deptno from emp);
-- TRUE OR NULL = TRUE, А ОПЕРАТОР IN - ЭТО РЕАЛИЗАЦИЯ OR 
-- АЛЬТЕРНАТИВНОЕ РЕШЕНИЕ
select d.deptno
from dept d
where not exists (
select 1
from emp e
where d.deptno = e.deptno);
-- -1. Исполняется подзапрос, проверяющий наличие того или иного номера отдела в таблице ЕМР. Обратите внимание на условие D.DEPTNO = Е.DEPTNO, которое сводит вместе номера отделов из обеих таблиц. 
-- -2. Если подзапрос возвращает результаты, выражение EXISTS(...) возвращает TRUE, а выражение NOT EXISTS(...) - соответственно - FALSE, и обрабатываемая внешним запросом строка отбрасывается. 
-- -3. Если подзапрос не возвращает результатов, выражение NOT EXISTS (...) возвращает TRUE, и обрабатываемая внешним запросом строка возвращается (т. к. значение ее столбца DEPT отсутствует в таблице ЕМР). 
--
-- 5. Извлечение строк из таблицы, не соответствующих строкам в другой таблице 
select d.*
from dept d left outer join emp e
on (d.deptno = e.deptno)
where e.deptno is null; 
-- Сначала выполняется внешнее объединение, из результатов которого отфильтровываются требуемые строки с разными знаениями общего столбца. Такие операции называются антиобъединением (anti-join)
-- если не отфильтровывать нуль, то результат будет следующимa
select d.*
from dept d left join emp e
on (d.deptno = e.deptno); 
-- 6. Добавление в запрос независимых объединений
-- У вас есть запрос, который возвращает желаемые результаты. Требуется модифицировать его, чтобы он возвращал дополнительную информацию, но в результате попытки выполнить такую модификацию теряются данные из первоначального результирующего множества. 
-- Например, нужно получить имена всех служащих, местонахождение их отделов и дату получения премии. Данные о премиях для этой задачи содержатся в таблице ЕМР _BONUS: 
select e.ename, d.loc, eb.received
from emp e join dept d on (e.deptno=d.deptno)
left join emp_bonus eb on (e.empno=eb.empno)
order by 2; 
-- 7. Проверка двух таблиц на идентичность
DROP VIEW V;
create view V
as
select * from emp where deptno!= 10
union all
select * from emp where ename = 'WARD';
select * from V;
--
select *
from (select e.empno,e.ename,e.job,e.mgr,e.hiredate,
	e.sal,e.comm,e.deptno, count(*) as cnt
	from emp e
	group by empno,ename,job,mgr,hiredate,sal,comm,deptno) e
where not exists
	(select null
	from (select v.empno,v.ename,v.job,v.mgr,v.hiredate,
		v.sal,v.comm,v.deptno, count(*) as cnt
		from v
		group by empno,ename,job,mgr,hiredate, sal,comm,deptno) v
	where v.empno = e.empno
	and v.ename = e.ename
	and v.job = e.job
	and coalesce(v.mgr,0) = coalesce(e.mgr,0)
	and v.hiredate = e.hiredate
	and v.deptno = e.deptno
	and v.cnt = e.cnt
	and coalesce(v.comm,0)=coalesce(e.comm,0))

union all
select *
from
	(select v.empno,v.ename,v.job,v.mgr,v.hiredate,v.sal,v.comm,v.deptno, count(*) as cnt
	from v
	group by empno,ename,job,mgr,hiredate, sal,comm,deptno) v
where not exists
	(select null
	from
		(select e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno, count(*) as cnt
		from emp e
		group by empno,ename,job,mgr,hiredate,sal,comm,deptno) e
	where v.empno = e.empno
	and v.ename = e.ename
	and v.job = e.job
	and coalesce(v.mgr,0) = coalesce(e.mgr,0)
	and v.hiredate = e.hiredate
	and v.sal = e.sal
	and v.deptno = e.deptno
	and v.cnt = e.cnt
	and coalesce(v.comm,0) = coalesce(e.comm,0));
-- -1. Находим строки в таблице ЕМР, которых нет в представлении V
-- -2. Объединяем (uNION ALL) эти строки со строками в представлении V, которых нет в таблице ЕМР. 
-- Если сравниваемые объекты идентичны, запрос не возвращает никаких строк. Если таблицы различаются, то возвращаются строки, создающие различие. Сравнение таблиц проще всего начать, сравнивая только количество строк в них, не усложняя задачу одновременным сравнением данных. 
-- 8. Выявление и устранение проблемы декартовых произведений
-- Требуется извлечь имена всех сотрудников отдела 1О вместе с местонахождением отдела каждого сотрудника
-- неверное решение
select e.ename, d.loc
from emp e, dept d
where e.deptno = 10;
-- верное решение
select e.ename, d.loc
from emp e, dept d
where e.deptno = 10
and d.deptno = e.deptno;
--  Количество строк, возвращаемых неправильным запросом, представляетсобой произведение кардинальностей (мощностей) двух таблиц в конструкции FROM.
-- В этом запросе применяется фильтр для выбора из таблицы ЕМР только сотрудников отдела 1 О, в результате чего возвращаются три строки. Но поскольку для таблицы DEPT не применяется никакого фильтра, то из нее возвращаются все четыре строки. Умножив три на четыре, мы получаем двенадцать, поэтому неправильный запрос и возвращает двенадцать строк. Как правило, избежать декартова произведения можно, применяя правило п-1, где п - количество таблиц в конструкции FROM, а п-1 - минимальное количество объединений, необходимых для исключения декартова произведения. В зависимости от того, какие столбцы таблиц являются ключевыми и по каким столбцам выполняется объединение, вполне может потребоваться более чем п-1 объединений, но при создании запросов начать лучше всего с этого их количества. 
-- 9. Выполнение объединений при использовании агрегатных функций
-- поэтому необходимо убедиться, что объединения не нарушат агрегацию. Например, нужно вычислить суммы зарплат и премий всех служащих отдела 1 О. Но некоторые служащие получили несколько премий, и объединение таблицы ЕМР с таблицей ЕМР _BONUS, содержащей данные о премиях сотрудников для этой задачи, вызывает возвращение неправильных значений агрегатной функцией suм
-- Рассмотрим теперь следующий запрос, который возвращает данные о зарплате и премиях всех служащих отдела 1 О. Размер премии определяется по таблице BONUS.TYPE. Премия типа 1 составляет 10% зарплаты служащего, типа 2 - 20% и типа 3 - 30%. 
select e.empno,e.ename,e.sal,e.deptno,
e.sal*case when eb.type = 1 then .1
	when eb.type = 2 then .2
	else .3
	end as bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10;
-- Пока что все хорошо. Но при попытке присоединить таблицу ЕМР _ BONUS, чтобы вычислить сумму премий, возникают проблемы:
select deptno, sum(sal) as total_sal,
sum(bonus) as total_bonus
from (
select e.empno,e.ename, e.sal,e.deptno,
e.sal*case when eb.type = 1 then .1
	when eb.type = 2 then .2
	ELSE .3
	end AS bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10
) x
group by deptno;
-- Тогда как сумма премий тoтAL_BONUS вычисляется правильно, сумма зарплат тoтAL_SAL- нет. Правильная сумма зарплат для отдела 10 должна быть 8750, как показывает следующий запрос: 
select sum(sal) from emp where deptno=10; 
-- Но почему сумма тoтAL_SAL вычисляется неправильно? Потому что объединение создает дубликаты строк в столбце SAL.
-- Избежать неправильных результатов вычислений, вызываемых дублированием строк при объединении таблиц с помощью агрегатных функций, можно двумя способами. Первый - просто используя в вызове агрегатной функции ключевое слово DISTINCT, обеспечивающее обработку только однозначных экземпляров каждого значения. Второй - выполняя агрегирование во вложенном запросе, прежде чем выполнять объединение. 
select deptno, sum(distinct sal) as total_sal,
sum(bonus) as total_bonus
from (
select e.empno,e.ename, e.sal,e.deptno,
e.sal*case when eb.type = 1 then .1
	when eb.type = 2 then .2
	ELSE .3
	end AS bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10
) x
group by deptno;
-- 10. Выполнение внешних объединений при использовании агрегатных функций 
-- По идее запрос для вычисления сумм всех зарплат и всех бонусов всех служащих отдела 1 О должен выглядеть следующим образом
select deptno, sum(sal) as total_sal,
sum(bonus) as total_bonus
from (
select e.empno,e.ename, e.sal,e.deptno,
e.sal*case when eb.type = 1 then .1
	when eb.type = 2 then .2
	ELSE .3
	end AS bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10
) x
group by deptno;
select e.empno,e.ename, e.sal,e.deptno,
e.sal*case when eb.type = 1 then .1
	when eb.type = 2 then .2
	ELSE .3
	end AS bonus
from emp e, emp_bonus eb
where e.empno = eb.empno
and e.deptno = 10;
-- верное решени
select distinct deptno,total_sal,total_bonus
from (
select e.empno, e.ename, 
sum(distinct e.sal) over (partition by e.deptno) as total_sal,
e.deptno,
sum(e.sal*case when eb.type is null then 0
	when eb.type 1 then .1
	when eb.type = 2 then .2
	else .3
	end) over
	(partition by deptno) as total bonus
from emp e left outer join emp_bonus eb on (e.empno = eb.empno)
where e.deptno = 10
)х; 
-- не работает??????
-- 11. Возвращение отсутствующих данных из нескольких таблиц 
-- При работе одновременно с несколькими таблицами требуется возвратить данные, отсутствующие в какой-либо из них. Чтобы возвратить строки из таблицы DEPT, для которых нет соответствующих строк в таблице ЕМР (т. е. любой отдел, в котором нет служащих), нужно выполнить внешнее объединение. Попытаемся решить эту задачу посредством следующего запроса, который возвращает из таблицы DEPT все значения DEPTNO и DNAМE вместе с именами всех служащих в каждом отделе (если отдел имеет служащих): 
select d.deptno,d.dname,e.ename
from dept d left outer join emp e
on (d.deptno=e.deptno);
-- Поскольку MySQL еще не поддерживает ru11 ouтER JOIN, для этой СУБД выполняем по отдельности правое и левое внешние объединения, соединяя их результаты оператором UNION: 
select d.deptno,d.dname,e.ename
from dept d right outer join emp e
on (d.deptno=e.deptno)
union
select d.deptno,d.dname,e.ename
from dept d left outer join emp e
on (d.deptno=e.deptno);
-- Полное внешнее объединение - это просто комбинация двух типов внешних объединений (левого и правого). Чтобы увидеть «закулисные» подробности работы полного внешнего объединения, просто выполним каждый тип внешнего объединения по отдельности, а затем объединим их результаты с помощью оператора UNION.
-- 12.  Значения NULL в вычислениях и сравнениях 
-- Значение NULL никогда не может быть равным или не равным любому значению, даже другому значению NULL. Но нам нужно выполнять операции со значениями столбца, который может содержать значения NULL, так же как и операции с действительными значениями. Например, нам нужно найти в таблице ЕМР всех служащих, для которых значение премии ( сомм) меньше, чем размер премии служащего WARD.
-- Результирующее множество также должно содержать служащих, для которых значение премии равно NULL. 
select ename,comm
from emp
where coalesce(comm,0) <(select comm
						from emp 
                        where ename='WARD' );