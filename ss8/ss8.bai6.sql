CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           department VARCHAR(50),
                           salary NUMERIC(10,2),
                           bonus NUMERIC(10,2) DEFAULT 0
);
INSERT INTO employees (name, department, salary) VALUES
                                                     ('Nguyen Van A', 'HR', 4000),
                                                     ('Tran Thi B', 'IT', 6000),
                                                     ('Le Van C', 'Finance', 10500),
                                                     ('Pham Thi D', 'IT', 8000),
                                                     ('Do Van E', 'HR', 12000);
create or replace procedure calculate_bonus(in p_emp_id INT,in p_percent NUMERIC,out p_bonus NUMERIC)
    language plpgsql
AS $$
    declare
        v_salary numeric(10,2);
        v_row_count int;
BEGIN
    select employees.salary
    into v_salary
        from employees
        where id = p_emp_id;
    if not FOUND then
        raise exception 'Employee not found';
    end if;
    if p_percent<= 0 then
        p_bonus:= 0;
    else
        p_percent:=v_salary*p_percent /100;
    end if;
    update employees set bonus = p_bonus
        where id = p_emp_id;
END;
$$;
