------------------------------------------------------Create "titles" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.titles
(
    title_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT titles_pkey PRIMARY KEY (title_id)
)

------------------------------------------------------Create "salaries" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.salaries
(
    emp_no bigint NOT NULL,
    salary bigint,
    CONSTRAINT salaries_pkey PRIMARY KEY (emp_no),
    CONSTRAINT "fk_empNo_sal" FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

------------------------------------------------------Create "employees" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.employees
(
    emp_no bigint NOT NULL,
    emp_title_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    birth_date date,
    first_name character varying(255) COLLATE pg_catalog."default",
    last_name character varying(255) COLLATE pg_catalog."default",
    sex "char",
    hire_date date,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_no),
    CONSTRAINT fk_emp_title FOREIGN KEY (emp_title_id)
        REFERENCES public.titles (title_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

------------------------------------------------------Create "dept_manager" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.dept_manager
(
    dept_no character varying(255) COLLATE pg_catalog."default" NOT NULL,
    emp_no integer NOT NULL,
    CONSTRAINT dept_manager_pkey PRIMARY KEY (emp_no),
    CONSTRAINT "fk_deptNo_departments" FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "fk_empNo_employees" FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

------------------------------------------------------Create "dept_emp" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.dept_emp
(
    emp_no bigint NOT NULL,
    dept_no character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no, dept_no),
    CONSTRAINT "fk_deptNo_departments" FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "fk_empNo_employees" FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

------------------------------------------------------Create "departments" table---------------------------------------------------

CREATE TABLE IF NOT EXISTS public.departments
(
    dept_no character varying(255) COLLATE pg_catalog."default" NOT NULL,
    dept_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT departments_pkey PRIMARY KEY (dept_no)
)

------------------------------------------------------ DATA ANALYSIS ---------------------------------------------------

--  1. List the employee number, last name, first name, sex, and salary of each employee.

    SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no;

--  2. List the first name, last name, and hire date for the employees who were hired in 1986.

    SELECT first_name, last_name, hire_date
    FROM employees
    WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--  3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

    SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
    FROM dept_manager dm
    JOIN departments d ON dm.dept_no = d.dept_no
    JOIN employees e ON dm.emp_no = e.emp_no;

--  4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

    SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
    FROM dept_emp de
    JOIN employees e ON de.emp_no = e.emp_no
    JOIN departments d ON de.dept_no = d.dept_no;

--  5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

    SELECT first_name, last_name, sex
    FROM employees
    WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--  6. List each employee in the Sales department, including their employee number, last name, and first name.

    SELECT e.emp_no, e.last_name, e.first_name
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE d.dept_name = 'Sales';

--  7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

    SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
    FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    JOIN departments d ON de.dept_no = d.dept_no
    WHERE d.dept_name IN ('Sales', 'Development');

--  8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

    SELECT last_name, COUNT(*) AS frequency
    FROM employees
    GROUP BY last_name
    ORDER BY frequency DESC;
