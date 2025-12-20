create table accounts(
    account_id serial primary key ,
    customer_name varchar(100),
    balance numeric(12,2)
);

create table transactions(
    trans_id serial primary key ,
    account_id int references accounts(account_id),
    amount numeric(12,2),
    trans_type varchar(20),
    created_at timestamp default now()
);
INSERT INTO accounts (customer_name, balance)
VALUES
    ('Nguyen Van A', 1000.00),
    ('Tran Thi B', 500.00),
    ('Le Van C', 200.00);
INSERT INTO transactions (account_id, amount, trans_type)
VALUES
    (1, 100.00, 'DEPOSIT'),
    (2, 50.00, 'WITHDRAW'),
    (3, 200.00, 'DEPOSIT');

BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
UPDATE accounts
SET balance = balance - 200.00
WHERE account_id = 1 AND balance >= 200.00;
DO $$
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM accounts WHERE account_id = 1 AND balance >= 0
        ) THEN
            RAISE EXCEPTION 'Không đủ tiền trong tài khoản';
        END IF;
    END $$;
INSERT INTO transactions (account_id, amount, trans_type)
VALUES (1, 200.00, 'WITHDRAW');
COMMIT;

BEGIN;
UPDATE accounts
SET balance = balance - 200.00
WHERE account_id = 1 AND balance >= 200.00;
INSERT INTO transactions (account_id, amount, trans_type)
VALUES (999, 200.00, 'WITHDRAW');
ROLLBACK;
SELECT * FROM accounts;
SELECT * FROM transactions;
