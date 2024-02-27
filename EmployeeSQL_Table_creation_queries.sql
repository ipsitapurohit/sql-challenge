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

