create schema bai6;
set search_path to bai6;

CREATE TABLE patients (
                          patient_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          phone VARCHAR(20),
                          city VARCHAR(50),
                          symptoms TEXT[]
);

CREATE TABLE doctors (
                         doctor_id SERIAL PRIMARY KEY,
                         full_name VARCHAR(100),
                         department VARCHAR(50)
);

CREATE TABLE appointments (
                              appointment_id SERIAL PRIMARY KEY,
                              patient_id INT REFERENCES patients(patient_id),
                              doctor_id INT REFERENCES doctors(doctor_id),
                              appointment_date DATE,
                              diagnosis VARCHAR(200),
                              fee NUMERIC(10,2)
);
INSERT INTO doctors (full_name, department) VALUES
                                                ('BS. Nguyễn Văn A', 'Nội tổng quát'),
                                                ('BS. Trần Thị B', 'Tim mạch'),
                                                ('BS. Lê Văn C', 'Nhi khoa'),
                                                ('BS. Phạm Thị D', 'Da liễu'),
                                                ('BS. Hoàng Văn E', 'Thần kinh');
INSERT INTO patients (full_name, phone, city, symptoms) VALUES
                                                            ('Nguyễn Thị Mai', '0901234567', 'Hà Nội', ARRAY['sốt', 'ho']),
                                                            ('Trần Văn Nam', '0912345678', 'Đà Nẵng', ARRAY['đau đầu']),
                                                            ('Lê Thị Hương', '0923456789', 'TP. Hồ Chí Minh', ARRAY['ngứa da', 'phát ban']),
                                                            ('Phạm Văn Khoa', '0934567890', 'Huế', ARRAY['đau ngực']),
                                                            ('Hoàng Thị Lan', '0945678901', 'Cần Thơ', ARRAY['mệt mỏi', 'chóng mặt']);
INSERT INTO appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
                                                                                       (1, 1, '2025-12-01', 'Cảm cúm nhẹ', 300000),
                                                                                       (1, 2, '2025-12-03', 'Kiểm tra tim mạch', 500000),
                                                                                       (2, 5, '2025-12-02', 'Đau đầu do căng thẳng', 400000),
                                                                                       (3, 4, '2025-12-04', 'Viêm da dị ứng', 350000),
                                                                                       (3, 4, '2025-12-10', 'Tái khám da liễu', 200000),
                                                                                       (4, 2, '2025-12-05', 'Đau ngực không rõ nguyên nhân', 600000),
                                                                                       (4, 1, '2025-12-07', 'Khám tổng quát', 300000),
                                                                                       (5, 3, '2025-12-06', 'Mệt mỏi do thiếu máu', 450000),
                                                                                       (5, 5, '2025-12-08', 'Chóng mặt do rối loạn tiền đình', 550000),
                                                                                       (2, 1, '2025-12-09', 'Khám tổng quát định kỳ', 300000);

create index idx_tree_phone on patients(phone);
create index idx_hash_city on patients(city);
create index idx_gin_symptoms on patients(symptoms);
CREATE EXTENSION IF NOT EXISTS btree_gist;
create index idx_gist_fee on appointments(fee);

create index idx_appointment_date on appointments(appointment_date);
cluster appointments using idx_appointment_date;
analyse appointments;

create view top3_patient as
select p.patient_id, p.full_name,
       sum(fee)
    from patients p join appointments a on p.patient_id = a.patient_id
    group by p.patient_id,p.full_name
    order by sum(fee) desc
    limit 3;

create view doctor_revenue as
select d.doctor_id, d.full_name,
       count(a.appointment_id)
    from doctors d join appointments a on d.doctor_id = a.doctor_id
    group by d.doctor_id, d.full_name
    order by count(a.appointment_id) desc ;

create view v_patient_city as
select patient_id, full_name,city
    from patients
with check option ;

update v_patient_city set city='Hồ Chí Minh'
where patient_id =1;
