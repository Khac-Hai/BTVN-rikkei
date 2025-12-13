create table employees(
    emp_id serial primary key ,
    emp_name varchar(100),
    job_level int,
    salary numeric
);
create or replace procedure adjust_salary (p_emp_id INT, OUT p_new_salary NUMERIC)
    language plpgsql
AS $$
DECLARE
    v_salary NUMERIC;
    v_level INT;
BEGIN
    select employees.job_level,employees.salary
    into v_level,v_salary
    from employees
    where emp_id=p_emp_id;
    if v_level=1 then
        p_new_salary:= v_salary*1.05;
    elsif v_level=2 then
        p_new_salary:= v_salary*1.1;
    elsif v_level=3 then
        p_new_salary:= v_salary*1.15;
    end if;
    update employees
    set salary=p_new_salary
    where emp_id=p_emp_id;
END;
$$;
call adjust_salary(3,null);