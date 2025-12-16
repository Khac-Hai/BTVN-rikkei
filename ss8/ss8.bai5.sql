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
create or replace procedure update_employee_status(p_emp_id int,p_status text)
    language plpgsql
AS $$
    declare
        v_salary numeric(10,2);
        v_row_count int;
BEGIN
        select salary,count(*)
        into v_salary,v_row_count
        from employees
        where id=p_emp_id
        group by salary;
        if v_row_count=0 then
            raise exception 'Employee not found';
        end if;
        if v_salary <5000 then
            p_status := 'Junior';
        elsif v_salary between 5000 and 10000 then
            p_status := 'Mid-level';
        elsif v_salary >10000 then
            p_status := 'Senior';
        end if;
END;

$$;
