CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          owner_name VARCHAR(100),
                          balance NUMERIC(12,2),
                          status VARCHAR(10) DEFAULT 'ACTIVE'
);

CREATE TABLE transactions (
                              trans_id SERIAL PRIMARY KEY,
                              from_account INT REFERENCES accounts(account_id),
                              to_account INT REFERENCES accounts(account_id),
                              amount NUMERIC(12,2),
                              status VARCHAR(20) DEFAULT 'PENDING',
                              created_at TIMESTAMP DEFAULT NOW()
);
INSERT INTO accounts (owner_name, balance, status)
VALUES
    ('Nguyen Van A', 1000.00, 'ACTIVE'),
    ('Tran Thi B', 500.00, 'ACTIVE'),
    ('Le Van C', 300.00, 'LOCKED');
INSERT INTO transactions (from_account, to_account, amount, status)
VALUES
    (1, 2, 200.00, 'COMPLETED'),
    (2, 3, 100.00, 'PENDING');

BEGIN;
SELECT * FROM accounts WHERE account_id IN (1, 2) FOR UPDATE;
DO $$
    DECLARE
        sender_status VARCHAR(10);
        receiver_status VARCHAR(10);
        sender_balance NUMERIC(12,2);
    BEGIN
        SELECT status, balance INTO sender_status, sender_balance
        FROM accounts WHERE account_id = 1;
        SELECT status INTO receiver_status
        FROM accounts WHERE account_id = 2;
        IF sender_status != 'ACTIVE' THEN
            RAISE EXCEPTION 'Tài khoản gửi không hoạt động';
        ELSIF receiver_status != 'ACTIVE' THEN
            RAISE EXCEPTION 'Tài khoản nhận không hoạt động';
        ELSIF sender_balance < 500.00 THEN
            RAISE EXCEPTION 'Không đủ tiền để chuyển';
        END IF;
    END $$;
UPDATE accounts SET balance = balance - 500.00 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500.00 WHERE account_id = 2;
INSERT INTO transactions (from_account, to_account, amount, status)
VALUES (1, 2, 500.00, 'PENDING');
UPDATE transactions
SET status = 'COMPLETED'
WHERE from_account = 1 AND to_account = 2 AND amount = 500.00
  AND created_at = (
    SELECT MAX(created_at)
    FROM transactions
    WHERE from_account = 1 AND to_account = 2 AND amount = 500.00
);
COMMIT;
UPDATE accounts SET status = 'LOCKED' WHERE account_id = 2;
SELECT * FROM accounts;
SELECT * FROM transactions;
