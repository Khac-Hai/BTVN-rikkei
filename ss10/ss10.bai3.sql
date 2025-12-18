CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name TEXT NOT NULL,
                           position TEXT NOT NULL,
                           salary NUMERIC(10, 2) NOT NULL
);

CREATE TABLE employees_log (
                               log_id SERIAL PRIMARY KEY,
                               employee_id INTEGER,
                               operation TEXT,
                               old_data JSONB,
                               new_data JSONB,
                               change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create function log_employee_changes()
returns trigger
as $$
begin
    insert into employees_log(employee_id, operation, old_data, new_data,change_time)
    values (case tg_op
           when 'insert' then new.id
           else old.id
           end,
            tg_op,to_json(old),to_json(new),current_timestamp);
    return new;
end;
$$ language plpgsql;

create trigger trg_log_insert
after insert on employees
for each row
execute function log_employee_changes();

create trigger trg_log_update
after update on employees
for each row
execute function log_employee_changes();

create trigger trg_log_delete
after delete on employees
for each row
execute function log_employee_changes();

INSERT INTO employees (name, position, salary)
VALUES ('Nguyễn Văn A', 'Kế toán', 1200.00);
UPDATE employees
SET salary = 1300.00
WHERE name = 'Nguyễn Văn A';
DELETE FROM employees
WHERE name = 'Nguyễn Văn A';
SELECT * FROM employees_log;
